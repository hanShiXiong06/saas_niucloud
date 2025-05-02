<?php

namespace core\upload;

use core\exception\UploadFileException;
use DateTime;
use DateTimeZone;
use Exception;
use think\facade\Cache;


/**
 * 123盘存储引擎
 */
class Ott extends BaseUpload
{

    private $position = array(
        'top-left' => 'northwest',
        'top-center' => 'north',
        'top-right' => 'northeast',
        'center-left' => 'west',
        'center' => 'center',
        'center-right' => 'east',
        'bottom-left' => 'southwest',
        'bottom-center' => 'south',
        'bottom-right' => 'southeast',
    );

    protected function initialize(array $config = [])
    {
        parent::initialize($config);
        $this->clientID = $config['clientID'] ?? '';
        $this->clientSecret = $config['clientSecret'] ?? '';
        $this->dir = $config['dir'] ?? 'onetwothree';
        $this->token = $this->getAccessToken();
    }

    /**
     * 执行上传
     * @param string $dir
     * @return true
     */
    public function upload(string $dir)
    {
        $filePath = $this->getRealPath();
        $dirId = $this->checkId();
        //进行文件创建
        $createData = $this->createFile($filePath, $this->getFullPath(), $dirId);
        if ($createData['reuse'] == true) {
            usleep(500000);
            //秒传
            return $this->setDirectLink($createData['fileID']);
        } else {
            $res = $this->http_post('upload/v1/file/list_upload_parts',
                [
                    'preuploadID' => $createData['preuploadID'],
                ]);
            if ($res == []) {
                //不需分片
                $fileId = $this->http_post('upload/v1/file/upload_complete',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ]);
                usleep(500000);
                return $this->setDirectLink($fileId);
            } else {
                //进行分片上传
                $localData = $this->chunk($filePath, $createData['sliceSize'], $createData['preuploadID'])['etagList'];
                //进行上传比对
                $cloudData = $this->http_post('upload/v1/file/list_upload_parts',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ])['parts'];
                $res = $this->http_post('upload/v1/file/upload_complete',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ]);
                if ($res['async'] == true) {
                    $completed = false;
                    while (!$completed) {
                        $res = $this->http_post('upload/v1/file/upload_async_result', [
                            'preuploadID' => $createData['preuploadID']
                        ]);
                        if ($res['completed'] === true) {
                            $completed = true;
                            return $this->setDirectLink($res['fileID']);
                        } else {
                            // 当未完成时，等待1秒后再次发起轮询
                            sleep(1);
                        }
                    }
                } else {
                    //
                    return $this->setDirectLink($res['fileID']);
                }
            }
        }
    }

    public function commonUpload($filePath, $fullPath)
    {
        $dirId = $this->checkId();
        //进行文件创建
        $createData = $this->createFile($filePath, $fullPath, $dirId);
        if ($createData['reuse'] == true) {
            //秒传
            usleep(500000);
            return $this->setDirectLink($createData['fileID']);
        } else {
            $res = $this->http_post('upload/v1/file/list_upload_parts',
                [
                    'preuploadID' => $createData['preuploadID'],
                ]);
            if ($res == []) {
                //不需分片
                $fileId = $this->http_post('upload/v1/file/upload_complete',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ]);
                usleep(500000);
                return $this->setDirectLink($fileId);
            } else {
                //进行分片上传
                $localData = $this->chunk($filePath, $createData['sliceSize'], $createData['preuploadID'])['etagList'];
                //进行上传比对
                $cloudData = $this->http_post('upload/v1/file/list_upload_parts',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ])['parts'];
                $res = $this->http_post('upload/v1/file/upload_complete',
                    [
                        'preuploadID' => $createData['preuploadID']
                    ]);
                if ($res['async'] == true) {
                    $completed = false;
                    while (!$completed) {
                        $res = $this->http_post('upload/v1/file/upload_async_result', [
                            'preuploadID' => $createData['preuploadID']
                        ]);
                        if ($res['completed'] === true) {
                            $completed = true;
                            return $this->setDirectLink($res['fileID']);
                        } else {
                            // 当未完成时，等待1秒后再次发起轮询
                            sleep(1);
                        }
                    }
                } else {
                    //
                    return $this->setDirectLink($res['fileID']);
                }
            }
        }
    }

    /**
     * base文件上云
     * @param string $base64_data
     * @param string|null $key
     * @return true
     */
    public function base64(string $base64_data, ?string $key = null)
    {

    }

    /**
     * notes: 抓取远程资源
     * @param string $url
     * @param string|null $key
     * @return true
     */
    public function fetch(string $url, ?string $key = null)
    {
        try {
            if (file_exists($key)) {
                return true; // 文件已存在，无需重复保存
            }
            $directory = dirname($key);
            if (!is_dir($directory)) {
                mkdir($directory, 0775, true);
            }
            $content = @file_get_contents($url);
            if (!empty($content)) {
                file_put_contents($key, $content);
                $this->commonUpload($key, basename($key));
                unlink($key);
                return true;
            } else {
                throw new UploadFileException(203006);
            }
        } catch (Exception $e) {
            throw new UploadFileException($e->getMessage());
        }
    }

    /**
     * 删除一个简单对象
     * @param string $file_name
     * @return true
     */
    public function delete(string $file_name)
    {
        $file_path = url_to_path($file_name);
        if (file_exists($file_path)) {
            $result = unlink($file_path);
//            throw new UploadFileException(100013);
        } else {
            $result = true;
        }
        //顺便删除相关的缩略图
        $dirname = dirname($file_name);
        $file_list = [];
        search_dir($dirname, $file_list);
        if (!empty($file_list)) {
            $file_arr = explode('/', $file_name);
            $only_file_name = end($file_arr);
            foreach ($file_list as $v) {
                if (str_contains($v, $only_file_name) && file_exists($v)) {
                    unlink($v);
                }
            }
        }
        return $result;
    }

    public function thumb($file_path, $thumb_type)
    {
        $thumb_config = config('upload.thumb.thumb_type');
        $thumb_data = [];
        foreach ($thumb_config as $k => $v) {
            if ($thumb_type == 'all' || $thumb_type == $k || (is_array($thumb_type) && in_array($k, $thumb_type))) {
                $width = $v['width'];
                $height = $v['height'];
                //拼装缩略路径
                $item_thumb = $file_path;
                $thumb_data[$k] = $item_thumb;
            }
        }

        return $thumb_data;
    }


    /**
     * 图片水印
     * @param $file_path
     * @return mixed
     * @throws Exception
     */
    public function water($file_path)
    {

    }

    /**
     * 直链
     * @return mixed
     * @throws Exception
     */
    public function setDirect()
    {
        $fileId = $this->checkDir();
        $this->http_post('api/v1/direct-link/enable', ['fileID' => $fileId]);
        return $fileId;
    }

    /**
     * 进行分片上传
     * @param $file_path
     * @param $chunk_size
     * @param $preuploadID
     * @return array[]
     */
    public function chunk($file_path, $chunk_size, $preuploadID)
    {
        clearstatcache(); // 清除文件状态缓存，确保filesize()返回最新值
        $file_size = filesize($file_path);
        $file = fopen($file_path, 'rb');
        $partNumbers = [];
        $etagList = [];
        for ($offset = 0; $offset < $file_size; $offset += $chunk_size) {
            $remaining = $file_size - $offset;
            $this_chunk_size = min($chunk_size, $remaining);
            $content = fread($file, $this_chunk_size);
            $etag = md5($content);
            $uploadUrl = $this->uploadPart($preuploadID, count($partNumbers) + 1);
            $this->http_put($uploadUrl, $content);
            $partNumbers[] = count($partNumbers) + 1;
            $etagList[] = [
                'partNumber' => count($partNumbers),
                'etag' => $etag,
                'size' => $this_chunk_size,
            ];
        }
        fclose($file);
        return ['partNumbers' => $partNumbers, 'etagList' => $etagList];
    }

    /**
     * put方法封装
     * @param string $url
     * @param string $content
     * @return void
     */
    public function http_put(string $url, string $content)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
        curl_setopt($ch, CURLOPT_POSTFIELDS, $content);
        curl_setopt($ch, CURLOPT_BINARYTRANSFER, true); // 添加此行以启用二进制传输模式
        $headers = [
            'Content-Type: application/octet-stream',
            'Content-Type: application/json',
            'Platform: ' . 'open_platform',
        ];
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_exec($ch);
        curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
    }

    /**
     * 获取上传地址
     * @param $preuploadID
     * @param $num
     * @return mixed
     * @throws Exception
     */
    public function uploadPart($preuploadID, $num)
    {
        $url = $this->http_post('upload/v1/file/get_upload_url',
            [
                'preuploadID' => $preuploadID,
                'sliceNo' => $num,
            ])['presignedURL'];
        return $url;
    }

    public function setDirectLink($fileId)
    {
        return $this->http_get('api/v1/direct-link/url',
            [
                'fileID' => $fileId
            ])['url'];
    }

    /**
     * 创建上传文件
     * @param $filePath
     * @param $filename
     * @param $dirId
     * @return mixed
     * @throws Exception
     */
    public function createFile($filePath, $filename, $dirId)
    {
        return $this->http_post('upload/v1/file/create',
            [
                'parentFileID' => $dirId,
                'filename' => $filename,
                'etag' => md5_file($filePath),
                'size' => filesize($filePath)
            ]);
    }

    /**
     * 创建目录
     * @return mixed
     * @throws Exception
     */
    public function createDir()
    {
        $res = $this->http_post('upload/v1/file/mkdir', ['name' => $this->dir, 'parentID' => 0]);
        return $res['dirID'];
    }

    /**
     * 上传文件目录验证
     * @return mixed
     * @throws Exception
     */
    public function checkDir()
    {
        $res = $this->http_get('api/v1/file/list',
            [
                'parentFileId' => 0,
                'page' => 1,
                'limit' => 100,
                'orderBy' => 'file_name',
                'orderDirection' => 'desc'
            ]);
        foreach ($res['fileList'] as $k => $v) {
            if ($v['filename'] == $this->dir && $v['type'] == 1) {
                return $v['fileID'];
            }
        }
        return $this->createDir();
    }


    public function http_get(string $api, array $query_params = [])
    {
        $ch = curl_init();
        $url = 'https://open-api.123pan.com/' . $api;
        if (!empty($query_params)) {
            $url .= '?' . http_build_query($query_params);
        }
        curl_setopt($ch, CURLOPT_URL, $url);
        $headers = [
            'Content-Type: application/json',
            'Platform: ' . 'open_platform',
            'Authorization: Bearer ' . $this->token,
        ];
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        $responseData = json_decode($response, true);
        if (isset($responseData['code']) && $responseData['code'] === 0) {
            return $responseData['data'];
        } else {
            throw new \Exception("API Error: HTTP Code {$httpCode}. Response: {$response}");
        }
    }

    /**
     * 封装post方法
     * @param string $api
     * @param array $data
     * @return mixed
     * @throws Exception
     */
    public function http_post(string $api, array $data)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://open-api.123pan.com/' . $api);
        curl_setopt($ch, CURLOPT_POST, true);
        $headers = [
            'Content-Type: application/json',
            'Platform: ' . 'open_platform',
            'Authorization: Bearer ' . $this->token,
        ];
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        $responseData = json_decode($response, true);
        if ($responseData['message'] == 'ok') {
            return $responseData['data'];
        } else {
            throw new \Exception("HTTP Code: {$httpCode}. Response: {$response}");
        }
    }

    public function checkId()
    {
        $dirId = Cache::get('123pan_dirid_' . $this->clientID.$this->dir, '');
        if ($dirId == '') {
            $dirId = $this->setDirect();
            Cache::set('123pan_dirid_' . $this->clientID.$this->dir, $dirId);
        }
        return $dirId;
    }

    /**
     * 获取token凭证
     * @return mixed
     * @throws \think\Exception
     */
    public function getAccessToken()
    {
        $access_token = Cache::get('123pan_access_token_' . $this->clientID.$this->dir, '');
        if ($access_token == '') {
            if ($this->clientID == '' || $this->clientSecret == '') throw new \think\Exception('请完成开放平台信息配置');
            $url = 'https://open-api.123pan.com/api/v1/access_token';
            $jsonData = json_encode([
                'clientID' => $this->clientID,
                'clientSecret' => $this->clientSecret,
            ]);
            $ch = curl_init();
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => $jsonData,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_HTTPHEADER => [
                    'Content-Type: application/json',
                    'Platform: ' . 'open_platform',
                ],
            ]);
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);
            $responseData = json_decode($response, true);
            if ($responseData['message'] == 'ok') {
                $datetimeObject = new DateTime($responseData['data']['expiredAt']);
                $datetimeObject->setTimezone(new DateTimeZone('Asia/Shanghai'));
                $timestamp = $datetimeObject->getTimestamp();
                $expireTime = $timestamp - time();
                Cache::set('123pan_access_token_' . $this->clientID.$this->dir, $responseData['data']['accessToken'], $expireTime);
                return $responseData['data']['accessToken'];
            } else {
                throw new \Exception("token获取失败. HTTP Code: {$httpCode}. Response: {$response}");
            }
        }
        return $access_token;
    }

}

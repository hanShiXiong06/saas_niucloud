<?php
// +----------------------------------------------------------------------
// | Niucloud-admin 企业快速开发的saas管理平台
// +----------------------------------------------------------------------
// | 官方网址：https://www.niucloud.com
// +----------------------------------------------------------------------
// | niucloud团队 版权所有 开源版本可自由商用
// +----------------------------------------------------------------------
// | Author: Niucloud Team
// +----------------------------------------------------------------------

namespace app\service\admin\site;

use app\dict\addon\AddonDict;
use app\dict\site\SiteDict;
use app\dict\sys\AppTypeDict;
use app\model\addon\Addon;
use app\model\site\Site;
use app\model\site\SiteGroup;
use app\model\sys\SysUserRole;
use app\service\admin\addon\AddonService;
use app\service\admin\auth\AuthService;
use app\service\admin\diy\DiyService;
use app\service\admin\generator\GenerateService;
use app\service\admin\sys\MenuService;
use app\service\admin\sys\RoleService;
use app\service\admin\user\UserRoleService;
use app\service\admin\user\UserService;
use app\service\core\site\CoreSiteService;
use core\base\BaseAdminService;
use core\exception\AdminException;
use core\exception\CommonException;
use Exception;
use think\db\exception\DataNotFoundException;
use think\db\exception\DbException;
use think\db\exception\ModelNotFoundException;
use think\facade\Cache;
use think\facade\Db;

/**
 * 站点服务层
 * Class Site
 * @package app\service\admin\site
 */
class SiteService extends BaseAdminService
{
    public static $cache_tag_name = 'site_cash';

    public function __construct()
    {
        parent::__construct();
        $this->model = new Site();
    }

    /**
     * 获取站点列表
     * @param array $where
     * @return array
     * @throws DbException
     */
    public function getPage(array $where = [])
    {

        $field = 'site_id, site_name, front_end_name, front_end_logo, front_end_icon, app_type, keywords, logo, icon, `desc`, status, latitude, longitude, province_id, city_id, 
        district_id, address, full_address, phone, business_hours, create_time, expire_time, group_id, app, addons, site_domain';
        $condition = [
            [ 'app_type', '<>', 'admin' ]
        ];
        $search_model = $this->model->where($condition)->withSearch([ 'create_time', 'expire_time', 'keywords', 'status', 'group_id', 'app', 'site_domain' ], $where)->with([ 'groupName' ])->field($field)->append([ 'status_name' ])->order('create_time desc');
        return $this->pageQuery($search_model, function($item) {
            $item[ 'admin' ] = ( new SysUserRole() )->where([ [ 'site_id', '=', $item[ 'site_id' ] ], [ 'is_admin', '=', 1 ] ])
                ->field('uid')
                ->with([ 'userinfo' ])
                ->find()->toArray();
        });
    }

    /**
     * 站点信息
     * @param int $site_id
     * @return array
     */
    public function getInfo(int $site_id)
    {
        $field = 'site_id, site_name, front_end_name, front_end_logo, front_end_icon, app_type, keywords, logo, icon, `desc`, status, latitude, longitude, province_id, city_id, 
        district_id, address, full_address, phone, business_hours, create_time, expire_time, group_id, app, addons, site_domain';
        $info = $this->model->where([ [ 'site_id', '=', $site_id ] ])->with([ 'groupName' ])->field($field)->append([ 'status_name' ])->findOrEmpty()->toArray();
        if (!empty($info)) {
            $site_addons = ( new CoreSiteService() )->getAddonKeysBySiteId($site_id);
            $info[ 'site_addons' ] = ( new Addon() )->where([ [ 'key', 'in', $site_addons ] ])->field('key,title,desc,icon,type')->select()->toArray();
            $info[ 'uid' ] = ( new SysUserRole() )->where([ [ 'site_id', '=', $site_id ], [ 'is_admin', '=', 1 ] ])->value('uid');
        }
        return $info;
    }

    /**
     * 添加站点(平台端添加站点，同时添加用户以及密码)
     * @param array $data
     * ['site_name' => '', 'username' => '', 'head_img' => '', 'real_name' => '', 'password' => '']
     * @return mixed
     * @throws DbException
     */
    public function add(array $data)
    {
        $site_group = ( new SiteGroup() )->where([ [ 'group_id', '=', $data[ 'group_id' ] ] ])->field('app,addon')->findOrEmpty();
        if ($site_group->isEmpty()) throw new CommonException('SITE_GROUP_NOT_EXIST');

        $data[ 'app_type' ] = 'site';
        //添加站点
        $data_site = [
            'site_name' => $data[ 'site_name' ],
            'app_type' => $data[ 'app_type' ],
            'group_id' => $data[ 'group_id' ],
            'create_time' => time(),
            'expire_time' => $data[ 'expire_time' ],
            'app' => $site_group[ 'app' ],
            'addons' => '',
            'status' => strtotime($data[ 'expire_time' ]) > time() ? SiteDict::ON : SiteDict::EXPIRE
        ];
        Db::startTrans();
        try {
            $site = $this->model->create($data_site);
            $site_id = $site->site_id;

            if ($data[ 'uid' ]) {
                ( new UserRoleService() )->add($data[ 'uid' ], [ 'role_ids' => '', 'is_admin' => 1 ], $site_id);
            } else {
                //添加用户
                $data_user = [
                    'username' => $data[ 'username' ],
                    'head_img' => $data[ 'head_img' ] ?? '',
                    'status' => $data[ 'status' ] ?? 1,
                    'real_name' => $data[ 'real_name' ] ?? '',
                    'password' => $data[ 'password' ],
                    'role_ids' => '',
                    'is_admin' => 1
                ];
                $data[ 'uid' ] = ( new UserService() )->addSiteUser($data_user, $site_id);
            }

            //添加站点成功事件
            event("AddSiteAfter", [ 'site_id' => $site_id, 'main_app' => $site_group[ 'app' ], 'site_addons' => $site_group[ 'addon' ] ]);

            // 更新微页面数据
            $diy_service = new DiyService();
            $diy_service->loadDiyData([ 'site_id' => $site_id, 'main_app' => $site_group[ 'app' ], 'tag' => 'add' ]);

            Cache::delete('user_role_list_' . $data[ 'uid' ]);

            Db::commit();
            return $site_id;
        } catch (Exception $e) {
            Db::rollback();
            throw new AdminException($e->getMessage() . $e->getFile() . $e->getLine());
        }
    }

    /**
     * 修改站点
     * @param int $site_id
     * @param array $data
     * @return bool
     */
    public function edit(int $site_id, array $data)
    {
        $site = $this->model->where([ [ 'site_id', '=', $site_id ] ])->with([ 'site_group' ])->findOrEmpty();
        if ($site->isEmpty()) throw new AdminException('SITE_NOT_EXIST');
        Db::startTrans();
        try {
            if (isset($data[ 'group_id' ]) && $site[ 'group_id' ] != $data[ 'group_id' ]) {
                $old_site_group = $site[ 'site_group' ];

                $site_group = ( new SiteGroup() )->where([ [ 'group_id', '=', $data[ 'group_id' ] ] ])->field('app,addon')->findOrEmpty();
                $data[ 'app' ] = $site_group[ 'app' ];

                if (empty($site->initalled_addon)) {
                    $site->initalled_addon = array_merge($old_site_group[ 'app' ], $old_site_group[ 'addon' ]);
                }
                //添加站点成功事件
                event("AddSiteAfter", [ 'site_id' => $site_id, 'main_app' => array_diff($site_group[ 'app' ], $site->initalled_addon), 'site_addons' => array_diff($site_group[ 'addon' ], $site->initalled_addon) ]);

                // 更新微页面数据
                $diy_service = new DiyService();
                $diy_service->loadDiyData([ 'site_id' => $site_id, 'main_app' => $site_group[ 'app' ], 'tag' => 'update' ]);

                $data[ 'initalled_addon' ] = array_values(array_unique(array_merge($site->initalled_addon, $site_group[ 'app' ], $site_group[ 'addon' ])));
            }

            if (isset($data[ 'expire_time' ]) && !empty($data[ 'expire_time' ])) {
                $data[ 'status' ] = strtotime($data[ 'expire_time' ]) > time() ? SiteDict::ON : SiteDict::EXPIRE;
            }

            if (isset($data[ 'uid' ])) {
                if ($data[ 'uid' ] > 0) {
                    ( new UserRoleService() )->editAdmin($site_id, $data[ 'uid' ]);
                } else {
                    //添加用户
                    $data_user = [
                        'username' => $data[ 'username' ],
                        'head_img' => $data[ 'head_img' ] ?? '',
                        'status' => $data[ 'status' ] ?? 1,
                        'real_name' => $data[ 'real_name' ] ?? '',
                        'password' => $data[ 'password' ],
                        'role_ids' => '',
                        'is_admin' => 1
                    ];
                    $data[ 'uid' ] = ( new UserService() )->add($data_user);
                    ( new UserRoleService() )->editAdmin($site_id, $data[ 'uid' ]);
                }
            }

            $site->save($data);

            Cache::tag(self::$cache_tag_name . $site_id)->clear();
            Cache::tag(MenuService::$cache_tag_name)->clear();
            Db::commit();
            return true;
        } catch (Exception $e) {
            Db::rollback();
            throw new AdminException($e->getMessage() . $e->getFile() . $e->getLine());
        }
    }

    /**
     * 删除站点
     * @param int $site_id
     */
    public function del(int $site_id)
    {
        Db::startTrans();
        try {
            $site = $this->model->where([ [ 'site_id', '=', $site_id ] ])->findOrEmpty()->toArray();

            // 删除站点相关数据
            $sys_models = ( new GenerateService() )->getModels([ 'addon' => 'system' ]);
            $addon_models = [];
            $addons = ( new CoreSiteService() )->getAddonKeysBySiteId($site_id);
            foreach ($addons as $addon) {
                $addon_models[] = ( new GenerateService() )->getModels([ 'addon' => $addon ]);
            }
            $models = array_merge($sys_models, ...$addon_models);

            foreach ($models as $model) {

                try {
                    $name = "\\$model";
                    $class = new $name();
                    if (in_array('site_id', $class->getTableFields())) {
                        $class::destroy(function($query) use ($site){
                            $query->where([ [ 'site_id', '=', $site[ 'site_id' ] ] ]);
                        });
//                        $class->where([ [ 'site_id', '=', $site[ 'site_id' ] ] ])->delete();
                    }
                } catch (\Exception $e) {
                }
            }

            //删除站点时同步删除该站点的所有管理员的关联信息
            $sys_userrole_model = new SysUserRole();
            $site_uids = $sys_userrole_model->where('site_id', $site_id)->field('site_id,uid')->select()->toArray();
            $del_res = $sys_userrole_model->where('site_id', $site_id)->field('site_id,uid')->delete();
            if ($del_res){
                //删除成功是清除对应的缓存
                foreach ($site_uids as $item){
                    Cache::delete('user_role_'.$item['uid'].'_'.$site_id);
                    Cache::delete('user_role_list_' .$item['uid']);
                }
            }
            Cache::tag(self::$cache_tag_name . $site_id)->clear();
            Db::commit();
            return true;
        } catch (\Exception $e) {
            Db::rollback();
            throw new CommonException($e->getMessage());
        }
    }

    /**
     * 站点数量
     * @return int
     * @throws DbException
     */
    public function getCount(array $where = [])
    {
        return $this->model->where($where)->withSearch([ 'create_time', 'group_id' ], $where)->count();
    }


    /**
     * 获取授权当前站点信息(用做缓存)
     * @return mixed
     */
    public function getSiteCache(int $site_id)
    {
        return ( new CoreSiteService() )->getSiteCache($site_id);
    }


    /**
     * 通过站点id获取菜单列表
     * @param int $site_id
     * @param $is_tree
     * @param $status
     * @param $addon   所以应用名一般不建议叫all
     * @return mixed
     * @throws DataNotFoundException
     * @throws DbException
     * @throws ModelNotFoundException
     */
    public function getMenuList(int $site_id, $is_tree, $status, $addon = 'all', int $is_button = 1)
    {
        $site_info = $this->getSiteCache($site_id);
        if (empty($site_info))
            return [];
        $app_type = $site_info[ 'app_type' ];

        if (AuthService::isSuperAdmin()) {
            $is_admin = 1;
        } else {
            $user_role_info = ( new AuthService() )->getAuthRole($this->site_id);
            if (empty($user_role_info))
                return [];
            $is_admin = $user_role_info[ 'is_admin' ];//是否是超级管理员组
        }

        if ($is_admin) {
            return ( new MenuService() )->getAllMenuList($app_type, $status, $is_tree, $is_button);
        } else {
            $user_role_ids = $user_role_info[ 'role_ids' ];
            $role_service = new RoleService();
            $menu_keys = $role_service->getMenuIdsByRoleIds($this->site_id, $user_role_ids);
            return ( new MenuService() )->getMenuListByMenuKeys($this->site_id, $menu_keys, $this->app_type, 1, is_button:$is_button);
        }
    }

    /**
     * 通过站点id获取站点菜单极限
     * @param int $site_id
     * @param $status
     * @return array|mixed|string|null
     */
    public function getMenuIdsBySiteId(int $site_id, $status)
    {
        $site_info = $this->getSiteCache($site_id);
        if (empty($site_info))
            return [];
        $app_type = $site_info[ 'app_type' ];
        if ($app_type == AppTypeDict::ADMIN) {
            return ( new MenuService() )->getAllMenuIdsByAppType($app_type, $status);
        } else {

            $addons = ( new AddonService() )->getAddonKeysBySiteId($site_id);
            return ( new MenuService() )->getMenuKeysBySystem($app_type, $addons);

        }
    }

    /**
     * 通过站点id获取菜单列表
     * @param int $site_id
     * @param $status
     * @return mixed
     */
    public function getApiList(int $site_id, $status)
    {
        $site_info = $this->getSiteCache($site_id);
        if (empty($site_info))
            return [];
        $app_type = $site_info[ 'app_type' ];
        if ($app_type == AppTypeDict::ADMIN) {
            return ( new MenuService() )->getAllApiList($app_type, $status);
        } else {
            $addons = ( new AddonService() )->getAddonKeysBySiteId($site_id);
            return ( new MenuService() )->getApiListBySystem($app_type, $addons);
        }
    }

    /**
     * 站点过期时间
     * @param int $site_id
     * @return array
     */
    public function getExpireTime(int $site_id)
    {
        $field = 'expire_time';
        return $this->model->where([ [ 'site_id', '=', $site_id ] ])->field($field)->findOrEmpty()->toArray();

    }

    /**
     * 获取站点的插件
     * @return array
     */
    public function getSiteAddons(array $where)
    {
        $site_addon = ( new CoreSiteService() )->getAddonKeysBySiteId($this->site_id);
        return ( new Addon() )->where([ [ 'type', '=', AddonDict::ADDON ], [ 'status', '=', AddonDict::ON ], [ 'key', 'in', $site_addon ] ])->withSearch([ 'title' ], $where)->append([ 'status_name' ])->field('title, icon, key, desc, status, type, support_app')->select()->toArray();
    }

    /**
     * 获取站点支持的应用插件
     * @return array
     */
    public function getAddonKeysBySiteId()
    {
        $site_addon = ( new CoreSiteService() )->getAddonKeysBySiteId($this->site_id);
        return $site_addon;
    }

    /**
     * 查询应用列表，todo 完善
     * @return array
     */
    public function getShowAppTools()
    {
        $list = [
            'addon' => [
                'title' => '运营工具',
                'list' => []
            ],
            'tool' => [
                'title' => '系统工具',
                'list' => []
            ],
//            'promotion' => [
//                'title' => '营销活动',
//                'list' => []
//            ]
        ];

        $apps = event('ShowApp');

        $keys = [];
        foreach ($apps as $v) {
            foreach ($v as $ck => $cv) {
                if (!empty($cv)) {
                    foreach ($cv as $addon_k => $addon_v) {
                        if (in_array($addon_v[ 'key' ], $keys)) {
                            continue;
                        }
                        $list[ $ck ][ 'list' ][] = $addon_v;
                        $keys[] = $addon_v[ 'key' ];
                    }
                }

            }

        }

        $site_addons = $this->getSiteAddons([]);
        if (!empty($site_addons)) {
            foreach ($site_addons as $k => $v) {
                if (!in_array($v[ 'key' ], $keys)) {
                    $list[ 'addon' ][ 'list' ][] = [
                        'title' => $v[ 'title' ],
                        'desc' => $v[ 'desc' ],
                        'icon' => $v[ 'icon' ],
                        'key' => $v[ 'key' ]
                    ];
                }
            }
        }

        return $list;
    }
}

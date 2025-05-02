<?php

use core\dict\DictLoader;

$system = [
    'default' => 'local',//默认驱动
    'drivers' => [
        //本地上传
        'local' => [],
        //七牛云
        'qiniu' => [
            'access_key' => '',
            'secret_key' => '',
            'bucket' => ''
        ],
        //阿里云
        'aliyun' => [
            'access_key' => '',
            'secret_key' => '',
            'endpoint' => '',
            'bucket' => ''
        ],
        //腾讯云
        'tencent' => [
            'access_key' => '',
            'secret_key' => '',
            'region' => '',
            'bucket' => ''
        ],
    ],
    // 默认规则
    'rules' => [
        'image' => [
            'ext' => ['jpg', 'jpeg', 'png', 'gif'],
            'mime' => ['image/jpeg', 'image/gif', 'image/png'],
            'size' => 10485760
        ],
        'video' => [
            'ext' => ['mp4'],
            'mime' => ['video/mp4'],
            'size' => 104857600
        ],
        'wechat' => [
            'ext' => ['pem', 'key'],
            'mime' => [
                'application/x-x509-ca-cert',
                'application/octet-stream',
                'application/x-iwork-keynote-sffkey'
            ],
            'size' => 2097152
        ],
        'aliyun' => [
            'ext' => ['crt'],
            'mime' => [
                'application/x-x509-ca-cert',
                'application/octet-stream'
            ],
            'size' => 2097152
        ],
        'applet' => [
            'ext' => ['zip', 'rar', 'xlsx'], // 添加了 'xlsx' 和 'csv'
            'mime' => [
                'application/zip',
                'application/vnd.rar',
                'application/x-zip-compressed',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // 添加了 xlsx 的 MIME 类型
                'text/csv' // 添加了 csv 的 MIME 类型
            ],
            'size' => 2097152 // 这是文件大小限制，当前设置为 2 MB
        ],
        
    ],
    'thumb' => [
        'thumb_type' => [
            'big' => [
                'width' => 800,
                'height' => 800,
            ],
            'mid' => [
                'width' => 400,
                'height' => 400,
            ],
            'small' => [
                'width' => 200,
                'height' => 200,
            ],
        ]


    ]
];

return (new DictLoader("Config"))->load(['data' => $system, 'name' => 'upload']);

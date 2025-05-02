/*
 Navicat Premium Data Transfer

 Source Server         : flyENV
 Source Server Type    : MySQL
 Source Server Version : 90300 (9.3.0)
 Source Host           : localhost:3306
 Source Schema         : niushop

 Target Server Type    : MySQL
 Target Server Version : 90300 (9.3.0)
 File Encoding         : 65001

 Date: 28/04/2025 23:59:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for saas_addon
-- ----------------------------
DROP TABLE IF EXISTS `saas_addon`;
CREATE TABLE `saas_addon` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(40) NOT NULL DEFAULT '' COMMENT '插件名称',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '插件图标',
  `key` varchar(20) NOT NULL DEFAULT '' COMMENT '插件标识',
  `desc` text COMMENT '插件描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态',
  `author` varchar(40) NOT NULL DEFAULT '' COMMENT '作者',
  `version` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `install_time` int NOT NULL DEFAULT '0' COMMENT '安装时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `type` varchar(255) NOT NULL DEFAULT 'app' COMMENT '插件类型app，addon',
  `support_app` varchar(255) NOT NULL DEFAULT '' COMMENT '插件支持的应用空表示通用插件',
  `is_star` tinyint NOT NULL DEFAULT '1' COMMENT '是否加星',
  `compile` varchar(2000) NOT NULL DEFAULT '' COMMENT '编译端口',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='插件表';

-- ----------------------------
-- Table structure for saas_addon_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_addon_log`;
CREATE TABLE `saas_addon_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `action` varchar(40) NOT NULL DEFAULT '' COMMENT '操作类型   install 安装 uninstall 卸载 update 更新',
  `key` varchar(20) NOT NULL DEFAULT '' COMMENT '插件标识',
  `from_version` varchar(20) NOT NULL DEFAULT '' COMMENT '升级前的版本号',
  `to_version` varchar(20) NOT NULL DEFAULT '' COMMENT '升级后的版本号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='插件日志表';

-- ----------------------------
-- Table structure for saas_aihumans_card
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_card`;
CREATE TABLE `saas_aihumans_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `card_num` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卡密',
  `is_use` int DEFAULT '0' COMMENT '是否使用',
  `point` int DEFAULT NULL COMMENT '兑换点数',
  `status` int DEFAULT NULL COMMENT '状态',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`card_num`,`is_use`,`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='卡密列表';

-- ----------------------------
-- Table structure for saas_aihumans_fenxiao
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_fenxiao`;
CREATE TABLE `saas_aihumans_fenxiao` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `status` int DEFAULT NULL COMMENT '分销商状态',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '申请表单',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `member_id` (`member_id`,`site_id`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='分销会员列表';

-- ----------------------------
-- Table structure for saas_aihumans_fenxiao_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_fenxiao_member`;
CREATE TABLE `saas_aihumans_fenxiao_member` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int DEFAULT '0' COMMENT '推荐会员id(分销)',
  `fenxiao_member_id` int DEFAULT '0' COMMENT '会员上级分销商会员id',
  `is_fenxiao` tinyint DEFAULT '0' COMMENT '是否是分销商',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分销商状态',
  `bind_time` int DEFAULT '0' COMMENT '绑定时间',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE,
  KEY `member_id` (`member_id`,`site_id`,`pid`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='分销会员列表';

-- ----------------------------
-- Table structure for saas_aihumans_fenxiao_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_fenxiao_order`;
CREATE TABLE `saas_aihumans_fenxiao_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `state` int DEFAULT NULL COMMENT '订单状态',
  `first_commission` decimal(10,2) DEFAULT NULL COMMENT '一级佣金',
  `two_commission` decimal(10,2) DEFAULT NULL COMMENT '二级佣金',
  `first_member_id` int DEFAULT NULL COMMENT '一级会员',
  `two_member_id` int DEFAULT NULL COMMENT '二级会员',
  `self_commission` decimal(10,2) DEFAULT NULL COMMENT '自购佣金',
  `is_self` int DEFAULT NULL COMMENT '是否自购',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`member_id`,`site_id`,`order_id`,`type`,`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_aihumans_help
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_help`;
CREATE TABLE `saas_aihumans_help` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `cat_id` int DEFAULT NULL COMMENT '分类',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '详情',
  `view_num` int DEFAULT NULL COMMENT '浏览量',
  `sort` int DEFAULT '0' COMMENT '排序',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='帮助中心';

-- ----------------------------
-- Table structure for saas_aihumans_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_member`;
CREATE TABLE `saas_aihumans_member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `point` int DEFAULT '0' COMMENT '点数',
  `clone_voice_num` int DEFAULT '0' COMMENT '克隆声音数量',
  `create_voice_num` int DEFAULT '0' COMMENT '合成声音数量',
  `clone_video_num` int DEFAULT '0' COMMENT '克隆分身数量',
  `create_video_num` int DEFAULT '0' COMMENT '创建会员数量',
  `chat_num` int DEFAULT '0' COMMENT 'AI对话数量',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `day_point` int DEFAULT '0' COMMENT '每天赠送算力',
  `clone_voice_pro_num` int DEFAULT '0' COMMENT '克隆声音Pro次数',
  `create_voice_pro_num` int DEFAULT '0' COMMENT '合成声音Pro分钟数',
  `clone_video_pro_num` int DEFAULT '0' COMMENT '克隆视频Pro次数',
  `create_video_pro_num` int DEFAULT '0' COMMENT '合成视频Pro分钟数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='会员列表';

-- ----------------------------
-- Table structure for saas_aihumans_member_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_member_log`;
CREATE TABLE `saas_aihumans_member_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `chang_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '变动',
  `point` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '点数',
  `num` int DEFAULT NULL COMMENT '数量',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='会员列表';

-- ----------------------------
-- Table structure for saas_aihumans_model
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_model`;
CREATE TABLE `saas_aihumans_model` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色logo',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模型名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提示词描述',
  `demo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '演示',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '调教文案',
  `sort` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '排序',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`name`,`sort`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='模型配置';

-- ----------------------------
-- Table structure for saas_aihumans_msg
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_msg`;
CREATE TABLE `saas_aihumans_msg` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `model_id` int DEFAULT NULL COMMENT '模型id',
  `msg_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '对话ID',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `is_new` int DEFAULT '0' COMMENT '新会话',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创作',
  `token` int DEFAULT NULL COMMENT '消耗token',
  `status` int DEFAULT NULL COMMENT '状态',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`model_id`,`msg_id`,`is_new`,`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='对话记录';

-- ----------------------------
-- Table structure for saas_aihumans_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_order`;
CREATE TABLE `saas_aihumans_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `order_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源',
  `order_id` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id',
  `order_money` decimal(10,2) DEFAULT NULL COMMENT '订单金额',
  `order_discount_money` decimal(10,2) DEFAULT '0.00' COMMENT '订单优惠金额',
  `order_status` int DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `point` int DEFAULT NULL COMMENT '点数',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付编号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_reason` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `is_enable_refund` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否允许退款',
  `close_time` int DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `package_id` int DEFAULT '0' COMMENT '套餐ID',
  `benefits` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '权益',
  `day` int DEFAULT '0' COMMENT '天数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`order_from`,`order_id`,`order_status`,`refund_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='订单列表';

-- ----------------------------
-- Table structure for saas_aihumans_package
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_package`;
CREATE TABLE `saas_aihumans_package` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `price` decimal(10,2) DEFAULT NULL COMMENT '价格',
  `point` int DEFAULT NULL COMMENT '点数',
  `tab` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `award` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '套餐奖励',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_time` int DEFAULT NULL COMMENT '到期时间',
  `day` int DEFAULT '0' COMMENT '有效期天数',
  `benefits` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '权益',
  `limit` int DEFAULT '0' COMMENT '限购',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`name`,`sort`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='套餐列表';

-- ----------------------------
-- Table structure for saas_aihumans_video
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_video`;
CREATE TABLE `saas_aihumans_video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `tag` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `cover` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面',
  `task_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务ID',
  `scene_task_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视频克隆ID',
  `video_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成视频链接',
  `cover_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面地址',
  `voice_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音链接',
  `voice_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音ID',
  `duration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时长',
  `cloud_video_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成云视频链接',
  `source_video_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原始视频链接',
  `callback_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回掉URL',
  `status` int DEFAULT '1' COMMENT '状态',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '合成文本',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'yiding' COMMENT '克隆平台',
  `platform_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方平台合成通道',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成类型',
  `channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成通道',
  `is_open` int DEFAULT NULL COMMENT '是否公开',
  `point` int DEFAULT NULL COMMENT '点数',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '信息',
  `is_audit` int DEFAULT NULL COMMENT '是否审核',
  `create_time` int DEFAULT NULL,
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`name`,`voice_id`,`status`,`platform`,`channel`,`is_open`,`is_audit`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='视频生成列表';

-- ----------------------------
-- Table structure for saas_aihumans_video_clone
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_video_clone`;
CREATE TABLE `saas_aihumans_video_clone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `cover` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面',
  `tag` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务ID',
  `video_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视频链接',
  `callback_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回掉URL',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` int DEFAULT '1' COMMENT '状态',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'yiding' COMMENT '克隆平台',
  `platform_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方平合成的通道',
  `channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成通道',
  `is_open` int DEFAULT NULL COMMENT '是否公开',
  `point` int DEFAULT NULL COMMENT '点数',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '信息',
  `is_audit` int DEFAULT NULL COMMENT '是否审核',
  `create_time` int DEFAULT NULL,
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`task_id`,`status`,`platform`,`channel`,`is_open`,`is_audit`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='视频克隆列表';

-- ----------------------------
-- Table structure for saas_aihumans_voice
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_voice`;
CREATE TABLE `saas_aihumans_voice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `cat_id` int DEFAULT NULL COMMENT '分类',
  `relation_video_id` int DEFAULT NULL COMMENT '关联视频ID',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `voice_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音链接',
  `duration` int DEFAULT '0' COMMENT '时长',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '文本',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'yiding' COMMENT '合成渠道',
  `platform_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方平台合成通道',
  `channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合成通道',
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务ID',
  `voice_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音ID',
  `status` int DEFAULT '1' COMMENT '状态',
  `is_audit` int DEFAULT NULL COMMENT '是否审核',
  `is_open` int DEFAULT NULL COMMENT '是否公开',
  `point` int DEFAULT NULL COMMENT '点数',
  `create_time` int DEFAULT NULL,
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`name`,`cat_id`,`relation_video_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='声音合成列表';

-- ----------------------------
-- Table structure for saas_aihumans_voice_clone
-- ----------------------------
DROP TABLE IF EXISTS `saas_aihumans_voice_clone`;
CREATE TABLE `saas_aihumans_voice_clone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `tag` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `task_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务ID',
  `voice_url` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音链接',
  `voice_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '声音ID',
  `status` int DEFAULT '1' COMMENT '状态',
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'yiding' COMMENT '克隆平台',
  `platform_channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方平台通道',
  `channel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通道',
  `is_open` int DEFAULT NULL COMMENT '是否公开',
  `point` int DEFAULT NULL COMMENT '点数',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '信息',
  `is_audit` int DEFAULT NULL COMMENT '是否审核',
  `create_time` int DEFAULT NULL,
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`name`,`task_id`,`voice_id`,`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='声音克隆列表';

-- ----------------------------
-- Table structure for saas_applet_site_version
-- ----------------------------
DROP TABLE IF EXISTS `saas_applet_site_version`;
CREATE TABLE `saas_applet_site_version` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `version_id` int NOT NULL DEFAULT '0' COMMENT '版本id',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '小程序类型',
  `action` varchar(20) NOT NULL DEFAULT '' COMMENT '操作方式 download 下载  upgrade 更新',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='站点小程序版本表';

-- ----------------------------
-- Table structure for saas_applet_version
-- ----------------------------
DROP TABLE IF EXISTS `saas_applet_version`;
CREATE TABLE `saas_applet_version` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config` varchar(255) NOT NULL DEFAULT '' COMMENT '配置信息',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '小程序类型',
  `desc` text COMMENT '插件描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态  下架  上架',
  `uid` varchar(40) NOT NULL DEFAULT '' COMMENT '发布者',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '小程序包地址',
  `version` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号',
  `version_num` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号数字(用于排序)',
  `release_version` varchar(20) NOT NULL DEFAULT '' COMMENT '发布线上版本号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `site_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='小程序版本表';

-- ----------------------------
-- Table structure for saas_blog_banner
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_banner`;
CREATE TABLE `saas_blog_banner` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT '1',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_comments
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_comments`;
CREATE TABLE `saas_blog_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tid` int DEFAULT NULL COMMENT '帖子id',
  `details` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '评论详情',
  `addtime` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间',
  `reply` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回复详情',
  `hf_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回复时间',
  `member_id` int DEFAULT NULL,
  `member_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bid` int DEFAULT '0',
  `hf_id` int DEFAULT '0',
  `status` int DEFAULT '0',
  `touid` int DEFAULT '0' COMMENT '发帖人',
  `adddate` datetime DEFAULT NULL,
  `site_id` int DEFAULT '1',
  `to_member_id` int DEFAULT NULL,
  `to_member_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_comments_like
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_comments_like`;
CREATE TABLE `saas_blog_comments_like` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `cid` int DEFAULT NULL,
  `to_member_id` int DEFAULT NULL,
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  `site_id` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_config`;
CREATE TABLE `saas_blog_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `open_fatie` int DEFAULT '1' COMMENT '发帖状态',
  `open_ping` int DEFAULT '1' COMMENT '评论状态',
  `open_fatie_shenhe` int DEFAULT '1' COMMENT '发帖需审核',
  `open_top` int DEFAULT NULL COMMENT '置顶开关',
  `top_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '置顶数据',
  `site_id` int DEFAULT NULL COMMENT '站点',
  `views_num` int DEFAULT '0' COMMENT '浏览量',
  `tie_num` int DEFAULT '0' COMMENT '发布量',
  `zan_num` int DEFAULT NULL COMMENT '点赞量',
  `mianze` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '发布免责协议',
  `show_ping_num` int DEFAULT '1',
  `show_like_num` int DEFAULT '1',
  `shuaxin_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `list_type` int DEFAULT '1',
  `open_shequn` int DEFAULT '1',
  `menu_num` int DEFAULT '5',
  `color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '#1c6ef6',
  `need_image` int DEFAULT '1',
  `author_num` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='圈子配置';

-- ----------------------------
-- Table structure for saas_blog_label
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_label`;
CREATE TABLE `saas_blog_label` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `site_id` int DEFAULT '1',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_news
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_news`;
CREATE TABLE `saas_blog_news` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '链接',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='微信社群';

-- ----------------------------
-- Table structure for saas_blog_quan
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_quan`;
CREATE TABLE `saas_blog_quan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT '1',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `banner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_shequn
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_shequn`;
CREATE TABLE `saas_blog_shequn` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `cate_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='微信社群';

-- ----------------------------
-- Table structure for saas_blog_shequncate
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_shequncate`;
CREATE TABLE `saas_blog_shequncate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='微信社群分类';

-- ----------------------------
-- Table structure for saas_blog_tie
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_tie`;
CREATE TABLE `saas_blog_tie` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `cate_id` int DEFAULT '0' COMMENT '分类',
  `cate_id2` int DEFAULT NULL COMMENT '子分类',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `imgs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '图片',
  `member_id` int DEFAULT '0' COMMENT '用户ID',
  `likenum` int DEFAULT '0' COMMENT '点赞数',
  `views` int DEFAULT '0' COMMENT '浏览量',
  `status` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '2' COMMENT '状态',
  `label_ids` varchar(501) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `labelname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `site_id` int DEFAULT '1' COMMENT '站点',
  `top_endtime` int DEFAULT '0' COMMENT '置顶到期时间',
  `top_uptime` int DEFAULT '0' COMMENT '置顶更新时间',
  `huifu_time` int DEFAULT NULL COMMENT '回复时间',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lng` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `headimg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quan_id` int DEFAULT '1',
  `shuaxin_time` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `state` (`status`) USING BTREE,
  KEY `state_2` (`status`) USING BTREE,
  KEY `user_id` (`member_id`) USING BTREE,
  KEY `user_id_2` (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1361713 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='帖子';

-- ----------------------------
-- Table structure for saas_blog_tie_cate
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_tie_cate`;
CREATE TABLE `saas_blog_tie_cate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `pid` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=160070 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_tie_follow
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_tie_follow`;
CREATE TABLE `saas_blog_tie_follow` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `to_member_id` int DEFAULT NULL,
  `addtime` int DEFAULT NULL,
  `adddate` datetime DEFAULT NULL,
  `site_id` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=570341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_tie_like
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_tie_like`;
CREATE TABLE `saas_blog_tie_like` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `tid` int DEFAULT NULL,
  `to_member_id` int DEFAULT NULL,
  `addtime` int DEFAULT NULL,
  `adddate` datetime DEFAULT NULL,
  `site_id` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1530452 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_tie_look
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_tie_look`;
CREATE TABLE `saas_blog_tie_look` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tid` int DEFAULT NULL,
  `member_id` int unsigned DEFAULT NULL,
  `headimg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `adddate` datetime DEFAULT NULL,
  `addtime` int DEFAULT NULL,
  `site_id` int DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2923225 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_blog_toporder
-- ----------------------------
DROP TABLE IF EXISTS `saas_blog_toporder`;
CREATE TABLE `saas_blog_toporder` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_from` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单来源',
  `out_trade_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付流水号',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员ip',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `order_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tie_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `daynum` int DEFAULT NULL,
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_cms_article
-- ----------------------------
DROP TABLE IF EXISTS `saas_cms_article`;
CREATE TABLE `saas_cms_article` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `site_id` int NOT NULL DEFAULT '0',
  `category_id` int NOT NULL COMMENT '文章分类',
  `title` varchar(255) NOT NULL COMMENT '文章标题',
  `intro` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `summary` varchar(255) NOT NULL DEFAULT '' COMMENT '文章摘要',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '文章图片',
  `author` varchar(255) NOT NULL DEFAULT '' COMMENT '作者',
  `content` longtext COMMENT '文章内容',
  `visit` int NOT NULL DEFAULT '0' COMMENT '实际浏览量',
  `visit_virtual` int NOT NULL DEFAULT '0' COMMENT '初始浏览量',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示:1-是.0-否',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `IDX_article_category_id` (`category_id`),
  KEY `IDX_article_create_time` (`create_time`),
  KEY `IDX_article_is_show` (`is_show`),
  KEY `IDX_ns_cms_article_sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文章表';

-- ----------------------------
-- Table structure for saas_cms_article_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_cms_article_category`;
CREATE TABLE `saas_cms_article_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '文章分类id',
  `site_id` int NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示:1-是;0-否',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`category_id`),
  KEY `create_time` (`create_time`),
  KEY `is_show` (`is_show`),
  KEY `sort` (`sort`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文章分类表';

-- ----------------------------
-- Table structure for saas_cpa_act
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_act`;
CREATE TABLE `saas_cpa_act` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '发布者',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动类型',
  `act_id` int DEFAULT NULL COMMENT 'CPA活动ID',
  `cat_id` int DEFAULT '0' COMMENT '分类ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `itemPic` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主图',
  `minMoney` decimal(10,2) DEFAULT NULL COMMENT '最低佣金',
  `maxMoney` decimal(10,2) DEFAULT NULL COMMENT '最高佣金',
  `labelText` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `settlementDesc` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '结算说明',
  `projectDesc` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '项目说明',
  `promotionDesc` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '推广教程',
  `status` int DEFAULT NULL COMMENT '状态',
  `stock` int DEFAULT NULL COMMENT '任务量',
  `simpleDescription` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '简单描述',
  `limit` int DEFAULT NULL COMMENT '限制',
  `weapp_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '小程序信息',
  `system_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '系统信息',
  `form_id` int DEFAULT NULL COMMENT '万能表单ID',
  `is_audit` int DEFAULT NULL COMMENT '审核状态',
  `start_time` int DEFAULT NULL COMMENT '开始时间',
  `end_time` int DEFAULT NULL COMMENT '结束时间',
  `extra_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '附加信息',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA活动列表';

-- ----------------------------
-- Table structure for saas_cpa_act_cat
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_act_cat`;
CREATE TABLE `saas_cpa_act_cat` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `image` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图像',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA活动分类';

-- ----------------------------
-- Table structure for saas_cpa_contact
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_contact`;
CREATE TABLE `saas_cpa_contact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员开户ID',
  `nickName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推广者',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`member_id`,`site_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA推广联系信息';

-- ----------------------------
-- Table structure for saas_cpa_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_order`;
CREATE TABLE `saas_cpa_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员',
  `sid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跟单参数',
  `actName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动名称',
  `actType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动类型',
  `parentOrderId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父订单号',
  `orderSn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '子订单号',
  `xgzUuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '西瓜猪uid',
  `orderTitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单标题',
  `orderTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '下单时间',
  `payTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付时间',
  `modifiedTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后一次更新时间',
  `payPrice` decimal(10,2) DEFAULT NULL COMMENT '支付金额',
  `xgzShareRate` decimal(10,2) DEFAULT NULL COMMENT '佣金率',
  `xgzShareFee` decimal(10,2) DEFAULT NULL COMMENT '佣金',
  `status` int DEFAULT '0' COMMENT '状态',
  `xgzSettleStatus` int DEFAULT '0' COMMENT '西瓜猪结算',
  `xgzSettleTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算时间',
  `settleTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '官方结算时间',
  `platformType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台标识',
  `sourcePlatform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源',
  `picUrl` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商品主图',
  `refundTag` int DEFAULT NULL COMMENT '维权',
  `refundMoney` decimal(10,2) DEFAULT NULL COMMENT '维权金额',
  `orderChannel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单渠道',
  `commission` decimal(10,2) DEFAULT '0.00' COMMENT '用户佣金',
  `is_js` int unsigned DEFAULT '0' COMMENT '用户结算',
  `relate_id` int DEFAULT NULL COMMENT '关联ID',
  `form_record_id` int DEFAULT NULL COMMENT '记录ID',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA订单列表';

-- ----------------------------
-- Table structure for saas_cpa_sid
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_sid`;
CREATE TABLE `saas_cpa_sid` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `sid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跟单参数',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `member_id` int DEFAULT NULL COMMENT '发布者',
  `a_id` int DEFAULT NULL COMMENT '站点活动ID',
  `cpaProjectId` int DEFAULT NULL COMMENT 'cpa活动id',
  `nickName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推广者',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `status` int DEFAULT NULL COMMENT '状态',
  `auditTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核时间',
  `failReason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '失败原因',
  `h5Url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `appId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pagePath` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `miniCode` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `promotionCopywriting` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `promotionCode` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '做单推广码',
  `promotionPoster` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `promotionUrl` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '做单链接',
  `queryDataUrl` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '查单链接',
  `systemLink` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '系统链接',
  `sid_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '查单密钥',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA开码列表';

-- ----------------------------
-- Table structure for saas_cpa_site
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpa_site`;
CREATE TABLE `saas_cpa_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `site_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '站点key',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_key`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPA站点KEY';

-- ----------------------------
-- Table structure for saas_cps_act
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_act`;
CREATE TABLE `saas_cps_act` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `type` int DEFAULT '0' COMMENT '活动类型',
  `cid` int DEFAULT NULL COMMENT '分类',
  `act_id` int DEFAULT NULL COMMENT '活动id',
  `act_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动名称',
  `desc` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图像',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `poster` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '海报',
  `commission_rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '比例',
  `introduce` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '活动介绍',
  `attribution_explain` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '归属说明',
  `settlement_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算时间',
  `start_date` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开始时间',
  `end_date` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2953 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPS活动链接';

-- ----------------------------
-- Table structure for saas_cps_act_item
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_act_item`;
CREATE TABLE `saas_cps_act_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `act_id` int NOT NULL COMMENT '活动id',
  `act_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动名称',
  `type` int DEFAULT NULL COMMENT '活动类型',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `h5` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'h5链接',
  `weapp` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '微信小程序信息',
  `aliapp` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付宝小程序信息',
  `share_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推广信息',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='活动详情';

-- ----------------------------
-- Table structure for saas_cps_act_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_act_order`;
CREATE TABLE `saas_cps_act_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跟单参数',
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单别称',
  `chanel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '渠道',
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单号',
  `pay_money` decimal(13,2) DEFAULT NULL COMMENT '支付金额',
  `rate` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算比列',
  `commission` decimal(13,2) DEFAULT NULL COMMENT '结算佣金',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `status_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态名称',
  `jl_js` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '激励结算',
  `pt_js` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '平台结算',
  `create_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建时间',
  `pay_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`name`,`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='CPS活动订单';

-- ----------------------------
-- Table structure for saas_cps_fenxiao_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_fenxiao_member`;
CREATE TABLE `saas_cps_fenxiao_member` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int DEFAULT '0' COMMENT '推荐会员id(分销)',
  `fenxiao_member_id` int DEFAULT '0' COMMENT '会员上级分销商会员id',
  `is_fenxiao` tinyint DEFAULT '0' COMMENT '是否是分销商',
  `bind_time` int DEFAULT '0' COMMENT '绑定时间',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_cps_fenxiao_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_fenxiao_order`;
CREATE TABLE `saas_cps_fenxiao_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `state` int DEFAULT NULL COMMENT '订单状态',
  `first_commission` decimal(10,2) DEFAULT NULL COMMENT '一级佣金',
  `two_commission` decimal(10,2) DEFAULT NULL COMMENT '二级佣金',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_cps_site
-- ----------------------------
DROP TABLE IF EXISTS `saas_cps_site`;
CREATE TABLE `saas_cps_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `site_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '站点key',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_key`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='站点对应跟单参数';

-- ----------------------------
-- Table structure for saas_cpsbwc_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_cpsbwc_order`;
CREATE TABLE `saas_cpsbwc_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `orderSn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '霸王餐订单号',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商城订单号',
  `userOrderSn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方订单号',
  `paidAmount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '支付金额',
  `shopOriginId` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店铺id',
  `orderTelephone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名电话',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `logo` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'logo',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地址',
  `distance` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '距离',
  `planType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动类型',
  `platform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台',
  `platformName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台名称',
  `platformLogo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '平台logo',
  `source` int DEFAULT NULL COMMENT '来源',
  `actionUrl` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '下单地址',
  `planId` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报名活动ID',
  `planTypeCh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '要求',
  `planTypeDescCh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动限制',
  `plan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '活动详情',
  `commissionType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算方式',
  `sid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跟单参数',
  `minAmount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门槛',
  `maxAmount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最大返现',
  `commission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算金额',
  `commissionRatio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '佣金比例',
  `ecommission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预估金额',
  `ecommissionRatio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '预估比率',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `createTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建时间',
  `finishedTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '完成时间',
  `xgzSettleStatus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '结算状态',
  `xgzSettleTime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭时间',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原因',
  `fanxian` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '返现',
  `is_fanxian` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否返现',
  `js_type` int DEFAULT '0' COMMENT '计算类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_diy_form
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form`;
CREATE TABLE `saas_diy_form` (
  `form_id` int NOT NULL AUTO_INCREMENT COMMENT '表单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `page_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表单名称（用于后台展示）',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表单名称（用于前台展示）',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表单类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0，关闭，1：开启）',
  `template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单数据，json格式，包含展示组件',
  `addon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所属插件标识',
  `share` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分享内容',
  `write_num` int NOT NULL DEFAULT '0' COMMENT '表单填写总数量',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注说明',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单表';

-- ----------------------------
-- Table structure for saas_diy_form_fields
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form_fields`;
CREATE TABLE `saas_diy_form_fields` (
  `field_id` int NOT NULL AUTO_INCREMENT COMMENT '字段id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `field_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段唯一标识',
  `field_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段类型',
  `field_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名称',
  `field_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段说明',
  `field_default` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '字段默认值',
  `write_num` int NOT NULL DEFAULT '0' COMMENT '字段填写总数量',
  `field_required` tinyint NOT NULL DEFAULT '0' COMMENT '字段是否必填 0:否 1:是',
  `field_hidden` tinyint NOT NULL DEFAULT '0' COMMENT '字段是否隐藏 0:否 1:是',
  `field_unique` tinyint NOT NULL DEFAULT '0' COMMENT '字段内容防重复 0:否 1:是',
  `privacy_protection` tinyint NOT NULL DEFAULT '0' COMMENT '隐私保护 0:关闭 1:开启',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单字段表';

-- ----------------------------
-- Table structure for saas_diy_form_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form_records`;
CREATE TABLE `saas_diy_form_records` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '表单填写记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '填写的表单数据',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '填写人会员id',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单填写记录表';

-- ----------------------------
-- Table structure for saas_diy_form_records_fields
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form_records_fields`;
CREATE TABLE `saas_diy_form_records_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `form_field_id` int NOT NULL DEFAULT '0' COMMENT '关联表单字段id',
  `record_id` int NOT NULL DEFAULT '0' COMMENT '关联表单填写记录id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '填写会员id',
  `field_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段唯一标识',
  `field_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段类型',
  `field_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段名称',
  `field_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段值，根据类型展示对应效果',
  `field_required` tinyint NOT NULL DEFAULT '0' COMMENT '字段是否必填 0:否 1:是',
  `field_hidden` tinyint NOT NULL DEFAULT '0' COMMENT '字段是否隐藏 0:否 1:是',
  `field_unique` tinyint NOT NULL DEFAULT '0' COMMENT '字段内容防重复 0:否 1:是',
  `privacy_protection` tinyint NOT NULL DEFAULT '0' COMMENT '隐私保护 0:关闭 1:开启',
  `update_num` int NOT NULL DEFAULT '0' COMMENT '字段修改次数',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单填写字段表';

-- ----------------------------
-- Table structure for saas_diy_form_submit_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form_submit_config`;
CREATE TABLE `saas_diy_form_submit_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `submit_after_action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '填表人提交后操作，text：文字信息，voucher：核销凭证',
  `tips_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提示内容类型，default：默认提示，diy：自定义提示',
  `tips_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '自定义提示内容',
  `time_limit_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '核销凭证有效期限制类型，no_limit：不限制，specify_time：指定固定开始结束时间，submission_time：按提交时间设置有效期',
  `time_limit_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '核销凭证时间限制规则，json格式',
  `voucher_content_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '核销凭证内容，json格式',
  `success_after_action` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '填写成功后续操作',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单提交页配置表';

-- ----------------------------
-- Table structure for saas_diy_form_write_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_form_write_config`;
CREATE TABLE `saas_diy_form_write_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '所属万能表单id',
  `write_way` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '填写方式，no_limit：不限制，scan：仅限微信扫一扫，url：仅限链接进入',
  `join_member_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all_member' COMMENT '参与会员，all_member：所有会员参与，selected_member_level：指定会员等级，selected_member_label：指定会员标签',
  `level_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '会员等级id集合',
  `label_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '会员标签id集合',
  `member_write_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '每人可填写次数，no_limit：不限制，diy：自定义',
  `member_write_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '每人可填写次数自定义规则',
  `form_write_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单可填写数量，no_limit：不限制，diy：自定义',
  `form_write_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单可填写总数自定义规则',
  `time_limit_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '填写时间限制类型，no_limit：不限制， specify_time：指定开始结束时间，open_day_time：设置每日开启时间',
  `time_limit_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '填写时间限制规则',
  `is_allow_update_content` tinyint NOT NULL DEFAULT '0' COMMENT '是否允许修改自己填写的内容，0：否，1：是',
  `write_instruction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单填写须知',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='万能表单填写配置表';

-- ----------------------------
-- Table structure for saas_diy_page
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_page`;
CREATE TABLE `saas_diy_page` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `page_title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面名称（用于后台展示）',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标题（用于前台展示）',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标识',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '页面模板',
  `template` varchar(255) NOT NULL DEFAULT '' COMMENT '模板名称',
  `mode` varchar(255) NOT NULL DEFAULT 'diy' COMMENT '页面展示模式，diy：自定义，fixed：固定',
  `value` longtext COMMENT '页面数据，json格式',
  `is_default` int NOT NULL DEFAULT '0' COMMENT '是否默认页面，1：是，0：否',
  `is_change` int NOT NULL DEFAULT '0' COMMENT '数据是否发生过变化，1：变化了，2：没有',
  `share` varchar(1000) NOT NULL DEFAULT '' COMMENT '分享内容',
  `visit_count` int NOT NULL DEFAULT '0' COMMENT '访问量',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=568 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='自定义页面';

-- ----------------------------
-- Table structure for saas_diy_route
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_route`;
CREATE TABLE `saas_diy_route` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '页面名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '页面标识',
  `page` varchar(255) NOT NULL DEFAULT '' COMMENT '页面路径',
  `share` varchar(1000) NOT NULL DEFAULT '' COMMENT '分享内容',
  `is_share` int NOT NULL DEFAULT '0' COMMENT '是否支持分享',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='自定义路由';

-- ----------------------------
-- Table structure for saas_diy_theme
-- ----------------------------
DROP TABLE IF EXISTS `saas_diy_theme`;
CREATE TABLE `saas_diy_theme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '插件类型app，addon',
  `addon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所属应用，app：系统，shop：商城、o2o：上门服务',
  `mode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模式，default：默认【跟随系统】，diy：自定义配色',
  `theme_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配色类型，default：默认，diy：自定义',
  `default_theme` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '当前色调的默认值',
  `theme` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '当前色调',
  `new_theme` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '新增颜色集合',
  `is_selected` tinyint NOT NULL DEFAULT '0' COMMENT '已选色调，0：否，1.是',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义主题配色表';

-- ----------------------------
-- Table structure for saas_fastpay_business
-- ----------------------------
DROP TABLE IF EXISTS `saas_fastpay_business`;
CREATE TABLE `saas_fastpay_business` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `admin_id` int DEFAULT NULL COMMENT '员工管理员',
  `mch_id` int DEFAULT NULL COMMENT '商户号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家名称',
  `banner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家轮播展示',
  `qrcode` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家微信',
  `friend_gift` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '加好友奖品',
  `share_gift` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '转发奖品',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家描述',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家地址',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商家详情',
  `lat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '经度',
  `lng` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '维度',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转类型',
  `finderUserName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视频号主页ID',
  `feedId` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视频ID',
  `page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方链接',
  `mini_appid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '小程序APPid',
  `mini_page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '小程序页面',
  `active_num` int DEFAULT NULL COMMENT '活动数量',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商家状态',
  `over_time` datetime DEFAULT NULL COMMENT '到期时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商户列表';

-- ----------------------------
-- Table structure for saas_fastpay_business_active
-- ----------------------------
DROP TABLE IF EXISTS `saas_fastpay_business_active`;
CREATE TABLE `saas_fastpay_business_active` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `business_id` int DEFAULT NULL COMMENT '商户ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动描述',
  `gift` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动奖品',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动主题',
  `contect` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '详情',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`business_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商户活动';

-- ----------------------------
-- Table structure for saas_fastpay_business_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_fastpay_business_member`;
CREATE TABLE `saas_fastpay_business_member` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `business_id` int DEFAULT NULL COMMENT '商户ID',
  `member_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动名称',
  `level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '等级',
  `balance` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '余额',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`business_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商户会员';

-- ----------------------------
-- Table structure for saas_fastpay_business_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_fastpay_business_order`;
CREATE TABLE `saas_fastpay_business_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` int NOT NULL COMMENT '会员id',
  `business_id` int DEFAULT NULL COMMENT '关联商户',
  `order_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单来源',
  `order_id` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  `order_discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单优惠金额',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付编号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_reason` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `is_enable_refund` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否允许退款',
  `close_time` int DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`order_from`,`order_id`,`order_status`,`refund_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='商户订单列表';

-- ----------------------------
-- Table structure for saas_fastpay_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_fastpay_order`;
CREATE TABLE `saas_fastpay_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` int NOT NULL COMMENT '会员id',
  `order_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单来源',
  `order_id` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单id',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  `order_discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单优惠金额',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付编号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_reason` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `is_enable_refund` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否允许退款',
  `close_time` int DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`order_from`,`order_id`,`order_status`,`refund_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='快速支付订单表';

-- ----------------------------
-- Table structure for saas_generate_column
-- ----------------------------
DROP TABLE IF EXISTS `saas_generate_column`;
CREATE TABLE `saas_generate_column` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `table_id` int NOT NULL DEFAULT '0' COMMENT '表id',
  `column_name` varchar(100) NOT NULL DEFAULT '' COMMENT '字段名称',
  `column_comment` varchar(300) NOT NULL DEFAULT '' COMMENT '字段描述',
  `column_type` varchar(100) NOT NULL DEFAULT '' COMMENT '字段类型',
  `is_required` tinyint DEFAULT '0' COMMENT '是否必填 0-非必填 1-必填',
  `is_pk` tinyint DEFAULT '0' COMMENT '是否为主键 0-不是 1-是',
  `is_insert` tinyint DEFAULT '0' COMMENT '是否为插入字段 0-不是 1-是',
  `is_update` tinyint DEFAULT '0' COMMENT '是否为更新字段 0-不是 1-是',
  `is_lists` tinyint DEFAULT '1' COMMENT '是否为列表字段 0-不是 1-是',
  `is_query` tinyint DEFAULT '1' COMMENT '是否为查询字段 0-不是 1-是',
  `is_search` tinyint DEFAULT '1' COMMENT '是否搜索字段',
  `query_type` varchar(100) DEFAULT '=' COMMENT '查询类型',
  `view_type` varchar(100) DEFAULT 'input' COMMENT '显示类型',
  `dict_type` varchar(255) DEFAULT '' COMMENT '字典类型',
  `addon` varchar(255) DEFAULT '' COMMENT '远程下拉关联应用',
  `model` varchar(255) DEFAULT '' COMMENT '远程下拉关联model',
  `label_key` varchar(255) DEFAULT '' COMMENT '远程下拉标题字段',
  `value_key` varchar(255) DEFAULT '' COMMENT '远程下拉value字段',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否为软删除字段 0-不是 1-是',
  `is_order` tinyint DEFAULT '0' COMMENT '是否为排序字段 0-不是 1-是',
  `validate_type` varchar(255) DEFAULT '' COMMENT '验证类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成表字段信息表';

-- ----------------------------
-- Table structure for saas_generate_table
-- ----------------------------
DROP TABLE IF EXISTS `saas_generate_table`;
CREATE TABLE `saas_generate_table` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(255) NOT NULL DEFAULT '' COMMENT '表名',
  `table_content` varchar(255) NOT NULL DEFAULT '' COMMENT '描述前缀',
  `module_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名',
  `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类名前缀',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `edit_type` int NOT NULL DEFAULT '1' COMMENT '编辑方式 1-弹框 2-新页面',
  `addon_name` varchar(255) NOT NULL DEFAULT '' COMMENT '插件名',
  `order_type` int NOT NULL DEFAULT '0' COMMENT '排序方式 0-无排序 1-正序 2-倒序',
  `parent_menu` varchar(255) NOT NULL DEFAULT '' COMMENT '上级菜单',
  `relations` text COMMENT '关联配置',
  `synchronous_number` int NOT NULL DEFAULT '0' COMMENT '同步次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成表';

-- ----------------------------
-- Table structure for saas_hk_fenxiao_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_hk_fenxiao_member`;
CREATE TABLE `saas_hk_fenxiao_member` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int DEFAULT '0' COMMENT '推荐会员id(分销)',
  `fenxiao_member_id` int DEFAULT '0' COMMENT '会员上级分销商会员id',
  `is_fenxiao` tinyint DEFAULT '0' COMMENT '是否是分销商',
  `bind_time` int DEFAULT '0' COMMENT '绑定时间',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='分销会员';

-- ----------------------------
-- Table structure for saas_hk_help
-- ----------------------------
DROP TABLE IF EXISTS `saas_hk_help`;
CREATE TABLE `saas_hk_help` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `title` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '问题名称',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '解决方案',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='号卡帮助中心';

-- ----------------------------
-- Table structure for saas_hk_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_hk_order`;
CREATE TABLE `saas_hk_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '系统用户ID',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `order_from` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id',
  `orderno` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方订单号',
  `member_id` int DEFAULT NULL COMMENT '用户id',
  `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图像',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实姓名',
  `idcard` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证号',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '城市',
  `district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '街道',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `plan_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生产号码',
  `front_image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '身份证正面',
  `back_image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '身份证背面',
  `head_image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '手持身份证',
  `logistics_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流名称',
  `logisticsno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '物流号',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '失败原因',
  `activation_cash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '激活佣金',
  `followup_cash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '后续佣金',
  `close_time` int DEFAULT NULL COMMENT '关闭时间',
  `operator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运营商名称',
  `mode_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算模式',
  `is_activation` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否激活',
  `is_first_charge` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否首充',
  `first_charge_amount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '手充金额',
  `commission_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '佣金结算状态',
  `commission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '总佣金',
  `first_commission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一级佣金',
  `two_commission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '二级佣金',
  `member_commission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员佣金',
  `is_js` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结算分销',
  `close_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `update_time` int DEFAULT '0' COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `create_time` int unsigned DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `project_id` (`mobile`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='号卡订单';

-- ----------------------------
-- Table structure for saas_hk_product
-- ----------------------------
DROP TABLE IF EXISTS `saas_hk_product`;
CREATE TABLE `saas_hk_product` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `operator` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运营商',
  `is_idcard` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '1需要身份证号码',
  `is_gztcheckidcard` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '1开启国政通校验（收费）',
  `minage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最少办理年龄',
  `maxage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最大办理年龄',
  `person_card_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '单人开卡数量',
  `person_card_checkcycle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开卡检测周期',
  `img` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品主图',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '模板一产品详情',
  `templateid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板id',
  `poster` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品海报',
  `marketing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品卖点',
  `beizhu` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '推广要求',
  `tg_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '推广详情',
  `mode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '周期',
  `photo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '身份证',
  `allow_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '允许下单省份',
  `prohibit_area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '禁止下单区域',
  `detailsimg` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '模板二详情图',
  `activation_cash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '激活佣金',
  `followup_cash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '后续佣金',
  `connected` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通话时长',
  `generalized` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通用流量',
  `directional` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '定向流量',
  `heyueqixian` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '合约期限',
  `introduce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '介绍',
  `fahuofangshi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发货方式',
  `status` int DEFAULT NULL COMMENT '状态',
  `api_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三方状态',
  `sort` int DEFAULT NULL COMMENT '排序',
  `num` int DEFAULT NULL COMMENT '领取人数',
  `original_price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原价',
  `price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '现价',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '单位',
  `tag` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1529906 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='号卡产品';

-- ----------------------------
-- Table structure for saas_hlwoauth_domain
-- ----------------------------
DROP TABLE IF EXISTS `saas_hlwoauth_domain`;
CREATE TABLE `saas_hlwoauth_domain` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `domain` varchar(255) NOT NULL COMMENT '域名',
  `auth_url` varchar(255) NOT NULL COMMENT '授权链接',
  `scope` enum('snsapi_base','snsapi_userinfo','') NOT NULL DEFAULT 'snsapi_base' COMMENT '授权方式',
  `number` int NOT NULL DEFAULT '0' COMMENT '次数',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=正常,0=禁用',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='域名授权';

-- ----------------------------
-- Table structure for saas_hsx_phone_query_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_hsx_phone_query_category`;
CREATE TABLE `saas_hsx_phone_query_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `sort` int NOT NULL,
  `is_show` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90905 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_hsx_phone_query_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_hsx_phone_query_config`;
CREATE TABLE `saas_hsx_phone_query_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `appid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '由系统分配的AppID，在个人中心中查看',
  `Secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '由系统分配的密钥，在个人中心中查看',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_hsx_phone_query_info
-- ----------------------------
DROP TABLE IF EXISTS `saas_hsx_phone_query_info`;
CREATE TABLE `saas_hsx_phone_query_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `imei` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '''''' COMMENT 'IMEI码',
  `sn` varchar(50) NOT NULL COMMENT '序列号',
  `info` text NOT NULL COMMENT '查询信息，以JSON格式存储',
  `type_id` int unsigned NOT NULL COMMENT '类型ID，关联其他表',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `member_id` int NOT NULL,
  `is_look` int NOT NULL DEFAULT '0' COMMENT '是否查看过',
  `pid` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储HSX手机查询信息的表';

-- ----------------------------
-- Table structure for saas_hsx_spdr_list
-- ----------------------------
DROP TABLE IF EXISTS `saas_hsx_spdr_list`;
CREATE TABLE `saas_hsx_spdr_list` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '名称',
  `cat_id` int DEFAULT NULL COMMENT '分类ID',
  `cat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类名称',
  `flie` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件路径',
  `num` int DEFAULT NULL COMMENT '数据条数',
  `success_num` int DEFAULT NULL COMMENT '成功数量',
  `fail_num` int DEFAULT NULL COMMENT '失败数量',
  `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=429 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='二手商品导入列表';

-- ----------------------------
-- Table structure for saas_jobs
-- ----------------------------
DROP TABLE IF EXISTS `saas_jobs`;
CREATE TABLE `saas_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL DEFAULT '',
  `payload` longtext NOT NULL,
  `attempts` tinyint unsigned NOT NULL DEFAULT '0',
  `reserve_time` int unsigned DEFAULT '0',
  `available_time` int unsigned DEFAULT '0',
  `create_time` int unsigned DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='消息队列任务表';

-- ----------------------------
-- Table structure for saas_jobs_failed
-- ----------------------------
DROP TABLE IF EXISTS `saas_jobs_failed`;
CREATE TABLE `saas_jobs_failed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `fail_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='消息队列任务失败记录表';

-- ----------------------------
-- Table structure for saas_manage_oss
-- ----------------------------
DROP TABLE IF EXISTS `saas_manage_oss`;
CREATE TABLE `saas_manage_oss` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '驱动',
  `size` double DEFAULT NULL COMMENT '总存储',
  `use_size` double NOT NULL COMMENT '已用',
  `limit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '限制上传大小',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_member`;
CREATE TABLE `saas_member` (
  `member_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `member_no` varchar(255) NOT NULL DEFAULT '' COMMENT '会员编码',
  `pid` int NOT NULL DEFAULT '0' COMMENT '推广会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '会员用户名',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '会员密码',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '会员昵称',
  `headimg` varchar(1000) NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_level` int NOT NULL DEFAULT '0' COMMENT '会员等级',
  `member_label` varchar(255) NOT NULL DEFAULT '' COMMENT '会员标签',
  `wx_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信用户openid',
  `weapp_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信小程序openid',
  `wx_unionid` varchar(255) NOT NULL DEFAULT '' COMMENT '微信unionid',
  `ali_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '支付宝账户id',
  `douyin_openid` varchar(255) NOT NULL DEFAULT '' COMMENT '抖音小程序openid',
  `register_channel` varchar(255) NOT NULL DEFAULT 'H5' COMMENT '注册来源',
  `register_type` varchar(255) NOT NULL DEFAULT '' COMMENT '注册方式',
  `login_ip` varchar(255) NOT NULL DEFAULT '' COMMENT '当前登录ip',
  `login_type` varchar(255) NOT NULL DEFAULT 'h5' COMMENT '当前登录的操作终端类型',
  `login_channel` varchar(255) NOT NULL DEFAULT '',
  `login_count` int NOT NULL DEFAULT '0' COMMENT '登录次数',
  `login_time` int NOT NULL DEFAULT '0' COMMENT '当前登录时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '注册时间',
  `last_visit_time` int NOT NULL DEFAULT '0' COMMENT '最后访问时间',
  `last_consum_time` int NOT NULL DEFAULT '0' COMMENT '最后消费时间',
  `sex` tinyint NOT NULL DEFAULT '0' COMMENT '性别 0保密 1男 2女',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '用户状态  用户状态默认为1',
  `birthday` varchar(20) NOT NULL DEFAULT '' COMMENT '出生日期',
  `point` int NOT NULL DEFAULT '0' COMMENT '可用积分',
  `point_get` int NOT NULL DEFAULT '0' COMMENT '累计获取积分',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额',
  `balance_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '累计获取余额',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '可用余额（可提现）',
  `money_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '累计获取余额（可提现）',
  `money_cash_outing` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现中余额（可提现）',
  `growth` int NOT NULL DEFAULT '0' COMMENT '成长值',
  `growth_get` int NOT NULL DEFAULT '0' COMMENT '累计获得成长值',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '当前佣金',
  `commission_get` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '佣金获取',
  `commission_cash_outing` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现中佣金',
  `last_sign_in_time` datetime DEFAULT NULL COMMENT '最后一次签到的时间',
  `first_sign_in_time` datetime DEFAULT NULL COMMENT '首次签到的时间',
  `consecutive_days` int DEFAULT '0' COMMENT '持续签到的天数',
  `is_member` tinyint NOT NULL DEFAULT '0' COMMENT '是否是会员',
  `member_time` int NOT NULL DEFAULT '0' COMMENT '成为会员时间',
  `is_del` tinyint NOT NULL DEFAULT '0' COMMENT '0正常  1已删除',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市id',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区县id',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `location` varchar(255) NOT NULL DEFAULT '' COMMENT '定位地址',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员表';

-- ----------------------------
-- Table structure for saas_member_account_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_account_log`;
CREATE TABLE `saas_member_account_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `account_type` varchar(255) NOT NULL DEFAULT 'point' COMMENT '账户类型',
  `account_data` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '账户数据',
  `account_sum` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '变动后的账户余额',
  `from_type` varchar(255) NOT NULL DEFAULT '' COMMENT '来源类型',
  `related_id` varchar(50) NOT NULL DEFAULT '' COMMENT '关联Id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=41396 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员账单表';

-- ----------------------------
-- Table structure for saas_member_address
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_address`;
CREATE TABLE `saas_member_address` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '手机',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市id',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区县id',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '地址信息',
  `address_name` varchar(255) NOT NULL DEFAULT '',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址信息',
  `lng` varchar(255) NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(255) NOT NULL DEFAULT '' COMMENT '纬度',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否是默认地址',
  PRIMARY KEY (`id`),
  KEY `IDX_member_address` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2288 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员收货地址';

-- ----------------------------
-- Table structure for saas_member_cash_out
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_cash_out`;
CREATE TABLE `saas_member_cash_out` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `cash_out_no` varchar(50) NOT NULL DEFAULT '' COMMENT '提现交易号',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `account_type` varchar(255) NOT NULL DEFAULT 'money' COMMENT '提现账户类型',
  `transfer_type` varchar(20) NOT NULL DEFAULT '0' COMMENT '转账提现类型',
  `transfer_realname` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `transfer_mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `transfer_bank` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `transfer_account` varchar(255) NOT NULL DEFAULT '' COMMENT '收款账号',
  `transfer_payee` varchar(255) NOT NULL DEFAULT '' COMMENT '转账收款方(json),主要用于对接在线的打款方式',
  `transfer_payment_code` varchar(500) NOT NULL DEFAULT '' COMMENT '收款码图片',
  `transfer_fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `transfer_status` varchar(20) NOT NULL DEFAULT '' COMMENT '转账状态',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现申请金额',
  `rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现手续费比率',
  `service_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现手续费',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '提现到账金额',
  `audit_time` int NOT NULL DEFAULT '0' COMMENT '审核时间',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态1待审核2.待转账3已转账 -1拒绝 -2 已取消',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `refuse_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '拒绝理由',
  `update_time` int NOT NULL DEFAULT '0',
  `transfer_no` varchar(50) NOT NULL DEFAULT '' COMMENT '转账单号',
  `cancel_time` int NOT NULL DEFAULT '0' COMMENT '取消时间',
  `final_transfer_type` varchar(255) NOT NULL DEFAULT '' COMMENT '转账方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员提现表';

-- ----------------------------
-- Table structure for saas_member_cash_out_account
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_cash_out_account`;
CREATE TABLE `saas_member_cash_out_account` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `account_type` varchar(255) NOT NULL DEFAULT '' COMMENT '账户类型',
  `bank_name` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `realname` varchar(255) NOT NULL DEFAULT '' COMMENT '真实名称',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `account_no` varchar(255) NOT NULL DEFAULT '' COMMENT '提现账户',
  `transfer_payment_code` varchar(255) NOT NULL DEFAULT '' COMMENT '收款码',
  PRIMARY KEY (`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员提现账户';

-- ----------------------------
-- Table structure for saas_member_infos
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_infos`;
CREATE TABLE `saas_member_infos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `member_id` int NOT NULL DEFAULT '0',
  `wx_id` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `wx_qrcode` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `delete_time` int NOT NULL DEFAULT '0',
  `update_time` int NOT NULL DEFAULT '0',
  `create_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `site_id` (`site_id`,`member_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文章表';

-- ----------------------------
-- Table structure for saas_member_label
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_label`;
CREATE TABLE `saas_member_label` (
  `label_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `label_name` varchar(50) NOT NULL DEFAULT '' COMMENT '标签名称',
  `memo` varchar(1000) NOT NULL DEFAULT '' COMMENT '备注',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`) USING BTREE,
  KEY `label_id` (`label_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员标签';

-- ----------------------------
-- Table structure for saas_member_level
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_level`;
CREATE TABLE `saas_member_level` (
  `level_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '会员等级',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `level_name` varchar(50) NOT NULL DEFAULT '' COMMENT '等级名称',
  `growth` int NOT NULL DEFAULT '0' COMMENT '所需成长值',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 0已禁用1已启用',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `level_benefits` text COMMENT '等级权益',
  `level_gifts` text COMMENT '等级礼包',
  PRIMARY KEY (`level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员等级';

-- ----------------------------
-- Table structure for saas_member_sign
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_sign`;
CREATE TABLE `saas_member_sign` (
  `sign_id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `days` int NOT NULL DEFAULT '0' COMMENT '连续签到天数',
  `day_award` varchar(255) NOT NULL DEFAULT '' COMMENT '日签奖励',
  `continue_award` varchar(255) NOT NULL DEFAULT '' COMMENT '连签奖励',
  `continue_tag` varchar(30) NOT NULL DEFAULT '' COMMENT '连签奖励标识',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '签到时间',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '签到周期开始时间',
  `is_sign` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否签到（0未签到 1已签到）',
  PRIMARY KEY (`sign_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7318 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员签到表';

-- ----------------------------
-- Table structure for saas_member_sign_in_logs
-- ----------------------------
DROP TABLE IF EXISTS `saas_member_sign_in_logs`;
CREATE TABLE `saas_member_sign_in_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `sign_in_date` datetime DEFAULT NULL COMMENT '签到日期',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '签到奖励描述',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='会员签到日志表';

-- ----------------------------
-- Table structure for saas_o2o_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_goods`;
CREATE TABLE `saas_o2o_goods` (
  `goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_cover` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品封面',
  `goods_image` text COMMENT '商品图片',
  `buy_info` text COMMENT '购买须知',
  `goods_content` text COMMENT '商品详情',
  `goods_category` varchar(255) NOT NULL DEFAULT '0' COMMENT '商品分类',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '商品状态（1.正常0下架）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量（总销量）',
  `virtually_sale` int NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `buy_type` varchar(255) NOT NULL DEFAULT '' COMMENT '购买类型 reservation-预约 buy-购买',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '售卖价格(最低,查询)',
  `after_sales` int NOT NULL DEFAULT '0' COMMENT '售后服务1-支持',
  `price_list` text COMMENT '价目表',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除',
  `member_discount` varchar(255) NOT NULL DEFAULT '' COMMENT '会员等级折扣，不参与：空，会员折扣：discount，指定会员价：fixed_price',
  `poster_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPACT COMMENT='项目表';

-- ----------------------------
-- Table structure for saas_o2o_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_goods_category`;
CREATE TABLE `saas_o2o_goods_category` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL,
  `category_name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `pid` int NOT NULL DEFAULT '0' COMMENT '分类上级',
  `level` int NOT NULL DEFAULT '0' COMMENT '层级',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '分类图片',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPACT COMMENT=' 商品分类';

-- ----------------------------
-- Table structure for saas_o2o_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_goods_sku`;
CREATE TABLE `saas_o2o_goods_sku` (
  `sku_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品sku_id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku名称',
  `sku_image` varchar(2000) NOT NULL DEFAULT '' COMMENT 'sku主图',
  `sku_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku编码',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku单价',
  `market_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '划线价',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量',
  `sku_unit` varchar(50) NOT NULL DEFAULT '' COMMENT 'sku单位名称',
  `min_buy` int NOT NULL DEFAULT '0' COMMENT '最小服务量',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认',
  `member_price` text COMMENT '会员价，json格式，指定会员价，数据结构为：{"level_1":"10.00","level_2":"10.00"}',
  PRIMARY KEY (`sku_id`) USING BTREE,
  KEY `idx_goods_sku_is_default` (`is_default`) USING BTREE,
  KEY `idx_goods_sku_price` (`price`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AVG_ROW_LENGTH=16384 ROW_FORMAT=DYNAMIC COMMENT='项目规格表';

-- ----------------------------
-- Table structure for saas_o2o_hour_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_hour_stat`;
CREATE TABLE `saas_o2o_hour_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `date` varchar(20) NOT NULL DEFAULT '' COMMENT '年月日',
  `hour` int NOT NULL DEFAULT '0' COMMENT '时',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '收款金额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '订单数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款数量',
  `item_order_num` int NOT NULL DEFAULT '0' COMMENT '报单数',
  `item_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '报单金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_o2o_member_collect
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_member_collect`;
CREATE TABLE `saas_o2o_member_collect` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `create_time` int NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '收藏类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IDX_member_collect_goods` (`goods_id`) USING BTREE,
  KEY `IDX_member_collect_member` (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_o2o_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_order`;
CREATE TABLE `saas_o2o_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `order_type` varchar(50) NOT NULL DEFAULT '' COMMENT '订单类型',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `order_status` varchar(30) NOT NULL DEFAULT '' COMMENT '订单状态',
  `refund_status` varchar(30) NOT NULL DEFAULT '' COMMENT '退款状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(30) NOT NULL DEFAULT '' COMMENT '会员ip',
  `member_message` varchar(255) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `dispatch_time` int DEFAULT NULL COMMENT '派单时间',
  `service_time` int NOT NULL DEFAULT '0' COMMENT '服务时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `finish_time` int NOT NULL DEFAULT '0' COMMENT '订单完成时间',
  `auto_close_time` int NOT NULL DEFAULT '0',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `order_name` varchar(255) NOT NULL DEFAULT '',
  `is_evaluate` int NOT NULL DEFAULT '0' COMMENT '是否评论',
  `reserve_service_time` varchar(50) NOT NULL DEFAULT '' COMMENT '客户希望服务时间',
  `technician_id` int NOT NULL DEFAULT '0' COMMENT '技师id',
  `taker_name` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人',
  `taker_mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `taker_province` int NOT NULL DEFAULT '0' COMMENT '收货省',
  `taker_city` int NOT NULL DEFAULT '0' COMMENT '收货市',
  `taker_district` int NOT NULL DEFAULT '0' COMMENT '收货区县',
  `taker_address` varchar(255) NOT NULL DEFAULT '' COMMENT '收货地址',
  `taker_full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `taker_longitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货地址经度',
  `taker_latitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货详细纬度',
  `check_code` varchar(20) NOT NULL DEFAULT '' COMMENT '上门校验码',
  `reserve_service_time_stamp` int NOT NULL DEFAULT '0' COMMENT '客户希望服务时间时间戳',
  `poster_id` int NOT NULL DEFAULT '0' COMMENT '海报id',
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_o2o_order_item
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_order_item`;
CREATE TABLE `saas_o2o_order_item` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '购买会员id',
  `item_id` int NOT NULL DEFAULT '0' COMMENT '项目id',
  `item_type` varchar(255) NOT NULL DEFAULT '' COMMENT '项目类型reservation-预约 buy-一口价 custom-自定义',
  `item_name` varchar(400) NOT NULL DEFAULT '' COMMENT '项目名称',
  `item_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '项目图片',
  `unit` varchar(255) NOT NULL DEFAULT '' COMMENT '单位',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '项目单价',
  `num` int NOT NULL DEFAULT '0' COMMENT '购买数量',
  `item_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '项目总价',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '是否退款',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款编号',
  `refund_status` varchar(255) NOT NULL DEFAULT '' COMMENT '退款状态',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '支付时间',
  `technician_id` int NOT NULL DEFAULT '0' COMMENT '技师id',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `goods_id` int NOT NULL DEFAULT '0',
  `item_images` varchar(2000) NOT NULL DEFAULT '' COMMENT '项目报单图片',
  PRIMARY KEY (`order_item_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='家政订单商品表';

-- ----------------------------
-- Table structure for saas_o2o_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_order_log`;
CREATE TABLE `saas_o2o_order_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `action` varchar(255) NOT NULL DEFAULT '' COMMENT '操作内容',
  `uid` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `nick_name` varchar(50) NOT NULL DEFAULT '' COMMENT '操作人名称',
  `order_status` varchar(50) NOT NULL DEFAULT '' COMMENT '订单状态，操作后',
  `action_way` varchar(50) NOT NULL DEFAULT '' COMMENT '操作类型 member 买家 user卖家  system系统任务',
  `order_status_name` varchar(255) NOT NULL DEFAULT '' COMMENT '订单状态名称，操作后',
  `action_time` int NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=353 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单操作记录表';

-- ----------------------------
-- Table structure for saas_o2o_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_order_refund`;
CREATE TABLE `saas_o2o_order_refund` (
  `refund_id` int NOT NULL AUTO_INCREMENT,
  `order_item_id` int NOT NULL DEFAULT '0',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `refund_no` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款单号',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总退款',
  `status` varchar(30) NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `audit_time` int NOT NULL DEFAULT '0' COMMENT '审核时间',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `refuse_reason` varchar(2000) NOT NULL DEFAULT '',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源 system 系统 member 会员',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '退款原因 ',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '申请退款',
  `remark` varchar(2000) NOT NULL DEFAULT '' COMMENT '描述',
  `voucher` varchar(2000) NOT NULL DEFAULT '' COMMENT '凭证',
  PRIMARY KEY (`refund_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='家政订单退款表';

-- ----------------------------
-- Table structure for saas_o2o_order_refund_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_order_refund_log`;
CREATE TABLE `saas_o2o_order_refund_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refund_id` int NOT NULL DEFAULT '0',
  `site_id` int NOT NULL DEFAULT '0',
  `action` varchar(2000) NOT NULL DEFAULT '0' COMMENT '操作内容',
  `action_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `uid` int NOT NULL DEFAULT '0',
  `action_way` varchar(30) NOT NULL DEFAULT '' COMMENT '操作类型 member 买家 use 卖家 system 系统',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单维权日志表';

-- ----------------------------
-- Table structure for saas_o2o_position
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_position`;
CREATE TABLE `saas_o2o_position` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='技师岗位表';

-- ----------------------------
-- Table structure for saas_o2o_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_stat`;
CREATE TABLE `saas_o2o_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `date` varchar(30) NOT NULL DEFAULT '' COMMENT '年月日',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '收款金额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '订单数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款数量',
  `item_order_num` int NOT NULL DEFAULT '0' COMMENT '报单数',
  `item_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '报单金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_o2o_technician
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_technician`;
CREATE TABLE `saas_o2o_technician` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `member_id` int NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '姓名',
  `age` int NOT NULL DEFAULT '0' COMMENT '年龄',
  `sex` tinyint NOT NULL DEFAULT '0' COMMENT '性别 0保密 1男 2女',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `working_age` varchar(50) NOT NULL DEFAULT '' COMMENT '工龄/年',
  `status` varchar(50) NOT NULL DEFAULT '' COMMENT '状态1-正常 0-休息中 -1离职',
  `label` varchar(255) NOT NULL DEFAULT '' COMMENT '标签,逗号分割',
  `position_id` int NOT NULL DEFAULT '0' COMMENT '岗位',
  `position_name` varchar(50) NOT NULL DEFAULT '0' COMMENT '岗位名称',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '订单数',
  `service_time` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '服务小时',
  `bad_evaluate` int NOT NULL DEFAULT '0' COMMENT '差评数量',
  `create_time` int NOT NULL DEFAULT '0',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `headimg` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `images` text NOT NULL,
  `desc` varchar(500) NOT NULL DEFAULT '' COMMENT '简介',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='技师表';

-- ----------------------------
-- Table structure for saas_o2o_technician_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_technician_evaluate`;
CREATE TABLE `saas_o2o_technician_evaluate` (
  `evaluate_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_item_id` int NOT NULL DEFAULT '0' COMMENT '订单项ID',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `technician_id` int NOT NULL DEFAULT '0' COMMENT '技师id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员ID',
  `member_head` varchar(255) NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_name` varchar(100) NOT NULL DEFAULT '' COMMENT '会员名称',
  `content` varchar(3000) NOT NULL COMMENT '评价内容',
  `images` varchar(3000) NOT NULL DEFAULT '' COMMENT '评价图片',
  `is_anonymous` tinyint NOT NULL DEFAULT '1' COMMENT '1匿名  2不匿名',
  `scores` tinyint NOT NULL DEFAULT '1' COMMENT '评论分数 1-5',
  `is_audit` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态 1待审 2通过 3拒绝',
  `explain_first` varchar(3000) NOT NULL DEFAULT '' COMMENT '解释内容',
  `topping` int NOT NULL DEFAULT '0' COMMENT '排序 置顶',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`evaluate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AVG_ROW_LENGTH=8192 ROW_FORMAT=DYNAMIC COMMENT='技师评价表';

-- ----------------------------
-- Table structure for saas_o2o_technician_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_o2o_technician_goods`;
CREATE TABLE `saas_o2o_technician_goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `technician_id` int NOT NULL DEFAULT '0',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '项目id',
  `create_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='技师项目表';

-- ----------------------------
-- Table structure for saas_pay
-- ----------------------------
DROP TABLE IF EXISTS `saas_pay`;
CREATE TABLE `saas_pay` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '支付会员id',
  `from_main_id` int NOT NULL DEFAULT '0' COMMENT '发起支付会员id',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '业务id',
  `trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '交易单号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '支付主体',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `reference_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '参考价格',
  `voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '支付票据',
  `status` int NOT NULL DEFAULT '0' COMMENT '支付状态（0.待支付 1. 支付中 2. 已支付 -1已取消）',
  `json` varchar(255) NOT NULL DEFAULT '' COMMENT '支付扩展用支付信息',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '支付时间',
  `cancel_time` int NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付方式',
  `mch_id` varchar(50) NOT NULL DEFAULT '' COMMENT '商户收款账号',
  `main_type` varchar(255) NOT NULL DEFAULT '',
  `channel` varchar(50) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付记录表';

-- ----------------------------
-- Table structure for saas_pay_channel
-- ----------------------------
DROP TABLE IF EXISTS `saas_pay_channel`;
CREATE TABLE `saas_pay_channel` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '1' COMMENT '站点id',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付类型',
  `channel` varchar(255) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `config` text NOT NULL COMMENT '支付配置',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `status` int NOT NULL DEFAULT '0' COMMENT '是否启用',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=481 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付渠道配置表';

-- ----------------------------
-- Table structure for saas_pay_refund
-- ----------------------------
DROP TABLE IF EXISTS `saas_pay_refund`;
CREATE TABLE `saas_pay_refund` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款单号',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '支付方式',
  `channel` varchar(50) NOT NULL DEFAULT '' COMMENT '支付渠道',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `reason` varchar(255) NOT NULL DEFAULT '' COMMENT '退款原因',
  `status` varchar(255) NOT NULL DEFAULT '0' COMMENT '支付状态（0.待退款 1. 退款中 2. 已退款 -1已关闭）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `refund_time` int NOT NULL DEFAULT '0' COMMENT '支付时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '支付凭证',
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `trade_id` varchar(50) NOT NULL DEFAULT '' COMMENT '业务关联id',
  `refund_type` varchar(255) NOT NULL DEFAULT '' COMMENT '退款方式',
  `main_type` varchar(255) NOT NULL DEFAULT '' COMMENT '操作人类型',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人',
  `pay_refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '外部支付方式的退款单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付记录表';

-- ----------------------------
-- Table structure for saas_pay_transfer
-- ----------------------------
DROP TABLE IF EXISTS `saas_pay_transfer`;
CREATE TABLE `saas_pay_transfer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `trade_type` varchar(255) NOT NULL DEFAULT '' COMMENT '业务类型',
  `transfer_no` varchar(50) NOT NULL DEFAULT '' COMMENT '转账单号',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `main_type` varchar(255) NOT NULL DEFAULT '' COMMENT '主体类型',
  `transfer_type` varchar(20) NOT NULL DEFAULT '' COMMENT '转账类型',
  `transfer_realname` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `transfer_mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号',
  `transfer_bank` varchar(255) NOT NULL DEFAULT '' COMMENT '银行名称',
  `transfer_account` varchar(255) NOT NULL DEFAULT '' COMMENT '收款账号',
  `transfer_voucher` varchar(255) NOT NULL DEFAULT '' COMMENT '凭证',
  `transfer_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '凭证说明',
  `transfer_payment_code` varchar(255) NOT NULL DEFAULT '' COMMENT '收款码图片',
  `transfer_fail_reason` varchar(2000) NOT NULL DEFAULT '' COMMENT '失败原因',
  `transfer_status` varchar(20) NOT NULL DEFAULT '' COMMENT '转账状态',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '转账金额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `update_time` int NOT NULL DEFAULT '0',
  `openid` varchar(50) NOT NULL DEFAULT '',
  `remark` varchar(255) NOT NULL DEFAULT '',
  `batch_id` varchar(500) NOT NULL DEFAULT '' COMMENT '转账批次id',
  `transfer_payee` varchar(500) NOT NULL DEFAULT '' COMMENT '在线转账数据(json)',
  `out_batch_no` varchar(500) NOT NULL DEFAULT '' COMMENT '扩展数据,主要用于记录接收到线上打款的业务数据编号',
  `package_info` varchar(1000) NOT NULL DEFAULT '' COMMENT '跳转领取页面的package信息',
  `extra` varchar(1000) NOT NULL DEFAULT '' COMMENT '扩展信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='转账表';

-- ----------------------------
-- Table structure for saas_pay_transfer_scene
-- ----------------------------
DROP TABLE IF EXISTS `saas_pay_transfer_scene`;
CREATE TABLE `saas_pay_transfer_scene` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '业务类型',
  `scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '场景',
  `infos` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账报备背景',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `perception` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '转账收款感知',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='支付转账场景表';

-- ----------------------------
-- Table structure for saas_phone_shop_active
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_active`;
CREATE TABLE `saas_phone_shop_active` (
  `active_id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `active_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `active_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '活动说明',
  `active_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动类型(店铺活动，会员活动，商品活动)',
  `active_goods_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_goods_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参与活动商品信息',
  `active_class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动类别',
  `active_class_category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动类别子分类（活动管理）',
  `relate_member` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与会员条件(默认全部)',
  `active_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '活动扩展信息数据',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `active_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `active_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='店铺营销活动表（整体活动）';

-- ----------------------------
-- Table structure for saas_phone_shop_active_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_active_goods`;
CREATE TABLE `saas_phone_shop_active_goods` (
  `active_goods_id` int NOT NULL AUTO_INCREMENT COMMENT '活动商品id',
  `active_id` int NOT NULL DEFAULT '0' COMMENT '活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int DEFAULT '0' COMMENT '商品规格id',
  `active_goods_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品活动类别',
  `active_goods_label` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动商品标签（针对活动有标签）',
  `active_goods_category` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动商品分类（针对活动有分类）',
  `active_goods_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '活动商品信息数据',
  `active_goods_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动状态',
  `active_goods_point` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品积分（展示，搜索）',
  `active_goods_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品价格（展示，搜索）',
  `active_goods_stock` int NOT NULL DEFAULT '0' COMMENT '活动商品库存（针对参与库存）',
  `active_goods_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_goods_order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_goods_member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_goods_success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='店铺营销活动';

-- ----------------------------
-- Table structure for saas_phone_shop_address
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_address`;
CREATE TABLE `saas_phone_shop_address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `contact_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '联系人',
  `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `lat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '纬度',
  `lng` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '经度',
  `is_delivery_address` int NOT NULL DEFAULT '0' COMMENT '是否是发货地址',
  `is_refund_address` int NOT NULL DEFAULT '0' COMMENT '是否是退货地址',
  `is_default_delivery` int NOT NULL DEFAULT '0' COMMENT '默认发货地址',
  `is_default_refund` int NOT NULL DEFAULT '0' COMMENT '默认收货地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商家地址库';

-- ----------------------------
-- Table structure for saas_phone_shop_cart
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_cart`;
CREATE TABLE `saas_phone_shop_cart` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `goods_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'sku id',
  `num` int unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `market_type` int unsigned NOT NULL DEFAULT '0' COMMENT '活动类型',
  `market_type_id` int unsigned NOT NULL DEFAULT '0' COMMENT '活动id',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '购物车商品状态',
  `invalid_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失效原因',
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `member_id` (`member_id`),
  KEY `sku_id` (`sku_id`),
  KEY `type` (`market_type`),
  KEY `type_id` (`market_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=232 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='购物车表';

-- ----------------------------
-- Table structure for saas_phone_shop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_coupon`;
CREATE TABLE `saas_phone_shop_coupon` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开启时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `remain_count` int NOT NULL DEFAULT '0' COMMENT '剩余数量',
  `receive_count` int NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `limit_count` int NOT NULL DEFAULT '0' COMMENT '单个会员限制领取数量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 未开启 3 已无效',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品最低多少金额可用优惠券',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '优惠券类型 1通用优惠券 2商品品类优惠券 3商品优惠券',
  `receive_type` int NOT NULL DEFAULT '0' COMMENT '领取方式',
  `valid_type` int unsigned NOT NULL DEFAULT '0' COMMENT '有效时间',
  `length` int NOT NULL DEFAULT '0' COMMENT '有效期时长(天)',
  `valid_start_time` int NOT NULL DEFAULT '0' COMMENT '有效期开始时间',
  `valid_end_time` int NOT NULL DEFAULT '0' COMMENT '有效期结束时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `receive_status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 关闭',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券表';

-- ----------------------------
-- Table structure for saas_phone_shop_coupon_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_coupon_goods`;
CREATE TABLE `saas_phone_shop_coupon_goods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券模板id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  PRIMARY KEY (`id`),
  KEY `index_category_id` (`category_id`),
  KEY `index_coupon_id` (`coupon_id`),
  KEY `index_goods_id` (`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券商品或品类关联表';

-- ----------------------------
-- Table structure for saas_phone_shop_coupon_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_coupon_member`;
CREATE TABLE `saas_phone_shop_coupon_member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '优惠券发放记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `expire_time` int unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `use_time` int unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最低使用门槛',
  `receive_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '领取方式',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  PRIMARY KEY (`id`),
  KEY `coupon_id` (`coupon_id`),
  KEY `member_id` (`member_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券会员领取记录表';

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_company
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_company`;
CREATE TABLE `saas_phone_shop_delivery_company` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司名称',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司logo',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司网站',
  `express_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司编号(用于物流跟踪)',
  `express_no_electronic_sheet` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司编号(用于电子面单)',
  `electronic_sheet_switch` tinyint NOT NULL DEFAULT '0' COMMENT '是否支持电子面单（0：不支持，1：支持）',
  `print_style` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式，json字符串',
  `exp_type` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '物流公司业务类型，json字符串',
  `create_time` int NOT NULL DEFAULT '0',
  `update_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_deliver
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_deliver`;
CREATE TABLE `saas_phone_shop_delivery_deliver` (
  `deliver_id` int NOT NULL AUTO_INCREMENT COMMENT '配送员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `deliver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送员名称',
  `deliver_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送员手机号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `modify_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  PRIMARY KEY (`deliver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配送员表';

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_electronic_sheet
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_electronic_sheet`;
CREATE TABLE `saas_phone_shop_delivery_electronic_sheet` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `express_company_id` int NOT NULL DEFAULT '0' COMMENT '物流公司id',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单客户账号（CustomerName）',
  `customer_pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单密码（CustomerPwd）',
  `send_site` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SendSite',
  `send_staff` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SendStaff',
  `month_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'MonthCode',
  `pay_type` tinyint NOT NULL DEFAULT '0' COMMENT '邮费支付方式（1：现付，2：到付，3：月结）',
  `is_notice` tinyint NOT NULL DEFAULT '0' COMMENT '快递员上门揽件（0：否，1：是）',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（1：开启，0：关闭）',
  `exp_type` int NOT NULL DEFAULT '0' COMMENT '物流公司业务类型',
  `print_style` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认（1：是，0：否）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电子面单';

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_local_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_local_delivery`;
CREATE TABLE `saas_phone_shop_delivery_local_delivery` (
  `local_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `fee_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '费用类型',
  `base_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '多少km内',
  `base_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `grad_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '每超出多少km内',
  `grad_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `weight_start` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '重量多少内不额外收费',
  `weight_unit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '每超出多少kg',
  `weight_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `delivery_type` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送类型',
  `area` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配送区域',
  `center` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发货地址中心点',
  `time_is_open` tinyint NOT NULL DEFAULT '0' COMMENT '配送时间设置 0 关闭 1 开启',
  `time_type` tinyint NOT NULL DEFAULT '0' COMMENT '时间选取类型 0 每天  1 自定义',
  `time_week` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '营业时间  周一 周二.......',
  `time_interval` int NOT NULL DEFAULT '30' COMMENT '时段设置单位分钟',
  `advance_day` int NOT NULL DEFAULT '0' COMMENT '时间选择需提前多少天',
  `most_day` int NOT NULL DEFAULT '7' COMMENT '最多可预约多少天',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '当日的起始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '当日的营业结束时间',
  `delivery_time` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送时间段',
  PRIMARY KEY (`local_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_shipping_template
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_shipping_template`;
CREATE TABLE `saas_phone_shop_delivery_shipping_template` (
  `template_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `fee_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '运费计算方式1.重量2体积3按件',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_free_shipping` smallint NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `no_delivery` smallint NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='运费模板';

-- ----------------------------
-- Table structure for saas_phone_shop_delivery_shipping_template_item
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_delivery_shipping_template_item`;
CREATE TABLE `saas_phone_shop_delivery_shipping_template_item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_id` int NOT NULL DEFAULT '0' COMMENT '模板id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市id',
  `snum` int NOT NULL DEFAULT '0' COMMENT '起步计算标准',
  `sprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '起步计算价格',
  `xnum` int NOT NULL DEFAULT '0' COMMENT '续步计算标准',
  `xprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '续步计算价格',
  `fee_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '运费计算方式',
  `fee_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运费设置区域id集',
  `fee_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运费设置区域名称集',
  `no_delivery` smallint NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  `no_delivery_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不配送的区域id集',
  `no_delivery_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不配送的区域名称集',
  `is_free_shipping` smallint NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `free_shipping_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '包邮的区域id集',
  `free_shipping_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '包邮的区域名称集',
  `free_shipping_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '满足包邮的条件',
  `free_shipping_num` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `express_template_item_city_id` (`city_id`),
  KEY `express_template_item_fee_type` (`fee_type`),
  KEY `express_template_item_template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='运费模板细节';

-- ----------------------------
-- Table structure for saas_phone_shop_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods`;
CREATE TABLE `saas_phone_shop_goods` (
  `goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `goods_no` int unsigned NOT NULL COMMENT '商品no',
  `source` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'source来源',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'real' COMMENT '商品类型',
  `sub_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '副标题',
  `goods_cover` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品封面',
  `goods_image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品图片',
  `goods_video` varchar(555) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '商品视频',
  `goods_category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品分类',
  `goods_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品介绍',
  `brand_id` int NOT NULL DEFAULT '0' COMMENT '商品品牌id',
  `memory_group_id` int NOT NULL DEFAULT '1' COMMENT '内存分组ID',
  `memory_ids` int DEFAULT NULL COMMENT '内存规格值,如64G、8+128G等',
  `memory_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内存分组',
  `label_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签组',
  `service_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品服务',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '件' COMMENT '单位',
  `stock` int NOT NULL DEFAULT '0' COMMENT '商品库存（总和）',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量',
  `virtual_sale_num` int NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '商品状态（1.正常0下架）',
  `is_proxy` tinyint NOT NULL DEFAULT '1' COMMENT '是否代理商品',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `delivery_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支持的配送方式',
  `is_free_shipping` tinyint NOT NULL DEFAULT '1' COMMENT '是否免邮',
  `fee_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '运费设置，选择模板：template，固定运费：fixed',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '固定运费',
  `delivery_template_id` int NOT NULL DEFAULT '0' COMMENT '运费模板',
  `virtual_auto_delivery` tinyint NOT NULL DEFAULT '0' COMMENT '虚拟商品是否自动发货',
  `virtual_receive_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'artificial' COMMENT '虚拟商品收货方式，auto：自动收货，artificial：买家确认收货，verify：到店核销',
  `virtual_verify_type` tinyint NOT NULL DEFAULT '0' COMMENT '虚拟商品核销有效期类型，0：不限，1：购买后几日有效，2：指定过期日期',
  `virtual_indate` int NOT NULL DEFAULT '0' COMMENT '虚拟到期时间',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商id',
  `attr_id` int NOT NULL DEFAULT '0' COMMENT '商品参数id',
  `attr_format` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品参数内容，json格式',
  `is_discount` int NOT NULL DEFAULT '0' COMMENT '是否参与限时折扣',
  `member_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'fixed_price' COMMENT '会员等级折扣，不参与：空，会员折扣：discount，指定会员价：fixed_price',
  `poster_id` int NOT NULL DEFAULT '0' COMMENT '海报id',
  `is_limit` tinyint NOT NULL DEFAULT '0' COMMENT '商品是否限购(0:否 1:是)',
  `limit_type` tinyint NOT NULL DEFAULT '1' COMMENT '限购类型，1：单次限购，2：单人限购',
  `max_buy` int NOT NULL DEFAULT '0' COMMENT '限购数',
  `min_buy` int NOT NULL DEFAULT '0' COMMENT '起购数',
  `is_gift` tinyint NOT NULL DEFAULT '0' COMMENT '商品是否赠品(0:否 1:是)',
  `access_num` int NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int NOT NULL DEFAULT '0' COMMENT '评论数量',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `goods_url` int DEFAULT NULL,
  PRIMARY KEY (`goods_id`),
  KEY `idx_goods_category` (`goods_category`),
  KEY `idx_goods_create_time` (`create_time`),
  KEY `idx_goods_delete_time` (`delete_time`),
  KEY `idx_goods_name` (`goods_name`),
  KEY `idx_goods_sort` (`sort`),
  KEY `idx_goods_status` (`status`),
  KEY `idx_goods_sub_title` (`sub_title`),
  KEY `IDX_ns_goods_goods_class` (`goods_type`)
) ENGINE=InnoDB AUTO_INCREMENT=61463 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_attr
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_attr`;
CREATE TABLE `saas_phone_shop_goods_attr` (
  `attr_id` int NOT NULL AUTO_INCREMENT COMMENT '商品参数id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `attr_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参数名称',
  `attr_value_format` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参数值，json格式',
  `sort` int NOT NULL DEFAULT '0' COMMENT '参数排序号',
  PRIMARY KEY (`attr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品参数表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_brand
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_brand`;
CREATE TABLE `saas_phone_shop_goods_brand` (
  `brand_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品牌名称',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品牌logo',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '品牌介绍',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`brand_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品品牌表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_category`;
CREATE TABLE `saas_phone_shop_goods_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '商品分类id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类图片',
  `level` int NOT NULL DEFAULT '0' COMMENT '层级',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `category_full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组装分类名称',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示（1：显示，0：不显示）',
  `memory_group` int DEFAULT '1' COMMENT '内存分组id',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1627 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品分类表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_collect
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_collect`;
CREATE TABLE `saas_phone_shop_goods_collect` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  KEY `IDX_member_collect_goods` (`goods_id`),
  KEY `IDX_member_collect_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品收藏记录表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_evaluate`;
CREATE TABLE `saas_phone_shop_goods_evaluate` (
  `evaluate_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int NOT NULL DEFAULT '0' COMMENT '订单项ID',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员ID',
  `member_head` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员名称',
  `content` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评价内容',
  `images` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评价图片',
  `is_anonymous` tinyint NOT NULL DEFAULT '1' COMMENT '1匿名  2不匿名',
  `scores` tinyint NOT NULL DEFAULT '1' COMMENT '评论分数 1-5',
  `is_audit` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态 1待审 2通过 3拒绝',
  `explain_first` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '解释内容',
  `topping` int NOT NULL DEFAULT '0' COMMENT '排序 置顶',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`evaluate_id`),
  KEY `idx_shop_goods_evaluate_create_time` (`create_time`),
  KEY `idx_shop_goods_evaluate_goods_id` (`goods_id`),
  KEY `idx_shop_goods_evaluate_is_anonymous` (`is_anonymous`),
  KEY `idx_shop_goods_evaluate_is_audit` (`is_audit`),
  KEY `idx_shop_goods_evaluate_member_id` (`member_id`),
  KEY `idx_shop_goods_evaluate_order_id` (`order_id`),
  KEY `idx_shop_goods_evaluate_scores` (`scores`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品评价表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_label
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_label`;
CREATE TABLE `saas_phone_shop_goods_label` (
  `label_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `label_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签名称',
  `group_id` int NOT NULL DEFAULT '0' COMMENT '标签分组id',
  `style_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '效果设置，diy：自定义，icon：图片',
  `color_json` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态，1：启用，0；关闭',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签说明',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品标签表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_label_group
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_label_group`;
CREATE TABLE `saas_phone_shop_goods_label_group` (
  `group_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分组名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品标签分组表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_proxy
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_proxy`;
CREATE TABLE `saas_phone_shop_goods_proxy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `goods_id` int NOT NULL COMMENT '商品ID',
  `source_site_id` int NOT NULL COMMENT '来源站点ID',
  `site_id` int NOT NULL COMMENT '代理站点ID',
  `markup_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '加价类型（1：固定金额 2：区间加价）',
  `markup_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加价值',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（0：禁用 1：启用）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_goods_site` (`goods_id`,`site_id`),
  KEY `idx_source_site` (`source_site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品代理关系表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_service
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_service`;
CREATE TABLE `saas_phone_shop_goods_service` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `service_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '服务名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品服务表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_sku`;
CREATE TABLE `saas_phone_shop_goods_sku` (
  `sku_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品sku_id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品sku名称',
  `sku_image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'sku主图',
  `sku_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品sku编码',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_spec_format` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'sku规格格式',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku单价',
  `market_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '划线价',
  `sale_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际卖价（有活动显示活动价，默认原价）',
  `cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku成本价',
  `stock` int NOT NULL DEFAULT '0' COMMENT '商品sku库存',
  `weight` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '重量（单位kg）',
  `volume` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '体积（单位立方米）',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认',
  `member_price` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '会员价，json格式，指定会员价，数据结构为：{"level_1":"10.00","level_2":"10.00"}',
  PRIMARY KEY (`sku_id`),
  KEY `idx_goods_sku_is_default` (`is_default`),
  KEY `idx_goods_sku_price` (`price`),
  KEY `idx_goods_sku_sale_price` (`sale_price`)
) ENGINE=InnoDB AUTO_INCREMENT=74427 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品规格表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_spec
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_spec`;
CREATE TABLE `saas_phone_shop_goods_spec` (
  `spec_id` int NOT NULL AUTO_INCREMENT COMMENT '规格id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `spec_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格项名称',
  `spec_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '规格值名称，多个逗号隔开',
  PRIMARY KEY (`spec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品规格项/值表';

-- ----------------------------
-- Table structure for saas_phone_shop_goods_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_goods_stat`;
CREATE TABLE `saas_phone_shop_goods_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '商品销量（下单数）',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_num` int NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int NOT NULL DEFAULT '0' COMMENT '评论数量',
  `goods_visit_member_count` int NOT NULL DEFAULT '0' COMMENT '商品访客数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品数据统计';

-- ----------------------------
-- Table structure for saas_phone_shop_invoice
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_invoice`;
CREATE TABLE `saas_phone_shop_invoice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '发票id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `trade_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'order' COMMENT '开票分类 order:订单',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '业务id',
  `header_type` tinyint NOT NULL DEFAULT '1' COMMENT '抬头类型',
  `header_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称（发票抬头）',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '发票类型',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发票内容',
  `tax_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '公司税号',
  `mobile` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开票人手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开票人邮箱',
  `telephone` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '注册电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '注册地址',
  `bank_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_card_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '银行账号',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '开票金额',
  `is_invoice` tinyint NOT NULL DEFAULT '0' COMMENT '是否开票',
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发票代码',
  `invoice_voucher` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发票凭证',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `invoice_time` int NOT NULL DEFAULT '0' COMMENT '开票时间',
  `status` int NOT NULL DEFAULT '0' COMMENT '是否生效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发票表';

-- ----------------------------
-- Table structure for saas_phone_shop_memory_group
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_memory_group`;
CREATE TABLE `saas_phone_shop_memory_group` (
  `group_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分组名称,如iPhone系列、安卓系列等',
  `memory_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内存规格id集合',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='内存规格分组表';

-- ----------------------------
-- Table structure for saas_phone_shop_memory_spec
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_memory_spec`;
CREATE TABLE `saas_phone_shop_memory_spec` (
  `spec_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '规格ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `spec_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格名称,如64G、8+128G等',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`spec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='内存规格表';

-- ----------------------------
-- Table structure for saas_phone_shop_newcomer_member_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_newcomer_member_records`;
CREATE TABLE `saas_phone_shop_newcomer_member_records` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '参与时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_join` tinyint NOT NULL DEFAULT '0' COMMENT '是否参与',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '参与订单id',
  `goods_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与商品id集合',
  `sku_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与商品规格id集合',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='新人专享会员参与记录表';

-- ----------------------------
-- Table structure for saas_phone_shop_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order`;
CREATE TABLE `saas_phone_shop_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '订单内容',
  `order_type` varchar(55) NOT NULL DEFAULT '' COMMENT '订单类型',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `status` varchar(55) NOT NULL DEFAULT '' COMMENT '订单状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'ip',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送金额',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `invoice_id` int NOT NULL DEFAULT '0' COMMENT '发票id，0表示不开发票',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `delivery_time` int NOT NULL DEFAULT '0' COMMENT '订单发货时间',
  `take_time` int NOT NULL DEFAULT '0' COMMENT '订单收货时间',
  `finish_time` int NOT NULL DEFAULT '0' COMMENT '订单完成时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '通用业务超时时间记录',
  `delivery_type` varchar(255) NOT NULL DEFAULT '' COMMENT '配送方式',
  `take_store_id` int NOT NULL DEFAULT '0' COMMENT '自提点',
  `taker_name` varchar(500) NOT NULL DEFAULT '' COMMENT '收货人',
  `taker_mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `taker_province` int NOT NULL DEFAULT '0' COMMENT '收货省',
  `taker_city` int NOT NULL DEFAULT '0' COMMENT '收货市',
  `taker_district` int NOT NULL DEFAULT '0' COMMENT '收货区县',
  `taker_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货地址',
  `taker_full_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `taker_longitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货地址经度',
  `taker_latitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货详细纬度',
  `taker_store_id` varchar(50) NOT NULL DEFAULT '' COMMENT '收货门店',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `member_remark` varchar(50) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `shop_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `close_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭原因',
  `close_type` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭来源(未支付自动关闭   手动关闭  退款关闭)',
  `refund_status` int NOT NULL DEFAULT '1' COMMENT '退款状态  1不存在退款  2 部分退款  3 全部退款',
  `has_goods_types` varchar(255) NOT NULL DEFAULT '' COMMENT '包含的商品类型 json',
  `is_evaluate` int NOT NULL DEFAULT '0' COMMENT '是否评论',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联id',
  `point` int NOT NULL DEFAULT '0' COMMENT '积分兑换',
  `activity_type` varchar(255) NOT NULL DEFAULT '' COMMENT '营销类型',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=622 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_batch_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_batch_delivery`;
CREATE TABLE `saas_phone_shop_order_batch_delivery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 进行中  已完成  已失败',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '操作类型 批量发货  批量打单 ....' COMMENT '操作类型',
  `total_num` int NOT NULL DEFAULT '0' COMMENT '总发货单数',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '成功发货单数',
  `fail_num` int NOT NULL DEFAULT '0' COMMENT '失败发货单数',
  `data` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '导入文件的路径',
  `output` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '对外输出记录',
  `fail_output` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败记录',
  `fail_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_time` int NOT NULL COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单批量发货表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_delivery`;
CREATE TABLE `saas_phone_shop_order_delivery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '包裹名称',
  `delivery_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送方式',
  `sub_delivery_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细配送方式',
  `express_company_id` int NOT NULL DEFAULT '0' COMMENT '快递公司id',
  `express_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送单号',
  `local_deliver_id` int NOT NULL DEFAULT '0' COMMENT '同城配送员',
  `status` int NOT NULL DEFAULT '0' COMMENT '配送状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单发货表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_discount
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_discount`;
CREATE TABLE `saas_phone_shop_order_discount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `discount_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '优惠类型',
  `discount_type_id` int NOT NULL DEFAULT '0' COMMENT '优惠类型id',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单优惠说明',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单优惠表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_discount_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_discount_goods`;
CREATE TABLE `saas_phone_shop_order_discount_goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_discount_id` int NOT NULL DEFAULT '0' COMMENT '订单优惠id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单项优惠表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_goods`;
CREATE TABLE `saas_phone_shop_order_goods` (
  `order_goods_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '购买会员id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品规格id',
  `sku_no` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `goods_name` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_name` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品规格名称',
  `goods_image` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `sku_image` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'sku规格图片',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `num` int NOT NULL DEFAULT '0' COMMENT '购买数量',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品总价',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `goods_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品类型',
  `delivery_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配送状态',
  `delivery_id` int NOT NULL DEFAULT '0' COMMENT '发货单号',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态',
  `order_refund_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款单号',
  `order_goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单项实付金额',
  `goods_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '虚拟商品地址',
  `original_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品原价',
  `extend` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据项扩展',
  `verify_count` int NOT NULL DEFAULT '0' COMMENT '已核销次数',
  `verify_expire_time` int NOT NULL DEFAULT '0' COMMENT '过期时间 0 为永久',
  `is_verify` int NOT NULL DEFAULT '0' COMMENT '是否需要核销',
  PRIMARY KEY (`order_goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=645 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单项表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_log`;
CREATE TABLE `saas_phone_shop_order_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `main_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '操作人类型',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int DEFAULT NULL COMMENT '订单状态',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志内容',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=316 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单日志表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_refund`;
CREATE TABLE `saas_phone_shop_order_refund` (
  `refund_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int NOT NULL DEFAULT '0' COMMENT '订单项id',
  `order_refund_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '退款单号',
  `refund_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '退款方式 ',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '退款原因 ',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '申请退款',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际退款',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `remark` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '描述' COMMENT '描述',
  `voucher` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '凭证' COMMENT '凭证',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源 system 系统 member 会员',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '操作超时时间',
  `refund_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款交易号',
  `delivery` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货配送信息',
  `saas_phone_shop_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '上架拒绝原因',
  `refund_address` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家退货地址',
  `is_refund_delivery` int NOT NULL DEFAULT '0' COMMENT '是否退运费',
  `shop_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`refund_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单退款表';

-- ----------------------------
-- Table structure for saas_phone_shop_order_refund_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_order_refund_log`;
CREATE TABLE `saas_phone_shop_order_refund_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_refund_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款编号',
  `main_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '操作人类型',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int DEFAULT NULL COMMENT '退款状态',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志内容',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单退款日志表';

-- ----------------------------
-- Table structure for saas_phone_shop_payment_info
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_payment_info`;
CREATE TABLE `saas_phone_shop_payment_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `pay_type` varchar(50) NOT NULL DEFAULT '' COMMENT '收款方式',
  `account` varchar(255) NOT NULL DEFAULT '' COMMENT '收款账号',
  `qrcode_image` varchar(255) NOT NULL DEFAULT '' COMMENT '收款码图片',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '是否默认(0-否,1-是)',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_member_id` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1452 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收款方式信息表';

-- ----------------------------
-- Table structure for saas_phone_shop_point_exchange
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_point_exchange`;
CREATE TABLE `saas_phone_shop_point_exchange` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '兑换活动主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '兑换类型（商品、优惠券、红包）',
  `names` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '兑换标题',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '副标题',
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '图片',
  `status` int NOT NULL DEFAULT '0' COMMENT '兑换状态 0 下架  1上架  -1 删除',
  `product_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '兑换产品信息',
  `point` int NOT NULL DEFAULT '0' COMMENT '兑换所需积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '兑换所需金额',
  `limit_num` int NOT NULL DEFAULT '0' COMMENT '限制数量',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '产品介绍',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `total_point_num` int DEFAULT '0' COMMENT '积分消费总额',
  `total_price_num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总支付金额',
  `total_order_num` int DEFAULT '0' COMMENT '订单笔数',
  `total_member_num` int DEFAULT '0' COMMENT '参与会员数',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存',
  `total_exchange_num` int NOT NULL DEFAULT '0' COMMENT '兑换数量',
  PRIMARY KEY (`id`,`total_price_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='积分兑换表';

-- ----------------------------
-- Table structure for saas_phone_shop_point_exchange_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_point_exchange_order`;
CREATE TABLE `saas_phone_shop_point_exchange_order` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '兑换记录id',
  `order_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `out_trade_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付流水表',
  `site_id` int NOT NULL COMMENT '站点id',
  `exchange_id` int NOT NULL DEFAULT '0' COMMENT '兑换活动id',
  `exchange_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '兑换商品名称',
  `exchange_image` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '兑换商品图片',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '兑换类型',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '消费会员id',
  `member_address_id` int NOT NULL DEFAULT '0' COMMENT '会员地址id',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `relate_order_id` int NOT NULL DEFAULT '0' COMMENT '关联订单id',
  `point` int NOT NULL DEFAULT '0' COMMENT '使用积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送余额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '兑换时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '订单删除',
  `num` int NOT NULL DEFAULT '0' COMMENT '兑换数量',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单状态',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='积分兑换订单表';

-- ----------------------------
-- Table structure for saas_phone_shop_price_recycle_device_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_price_recycle_device_log`;
CREATE TABLE `saas_phone_shop_price_recycle_device_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `device_id` int NOT NULL DEFAULT '0' COMMENT '设备ID',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `operator_id` int NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人姓名',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作类型',
  `old_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '旧状态',
  `new_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '新状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_at` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收设备日志表';

-- ----------------------------
-- Table structure for saas_phone_shop_price_recycle_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_price_recycle_order_log`;
CREATE TABLE `saas_phone_shop_price_recycle_order_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `operator_id` int NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人姓名',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作类型',
  `old_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '旧状态',
  `new_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '新状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_at` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收订单日志表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_banner
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_banner`;
CREATE TABLE `saas_phone_shop_recycle_banner` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图片',
  `create_at` int DEFAULT NULL COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `sort` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收banner表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_category`;
CREATE TABLE `saas_phone_shop_recycle_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '商品分类id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类图片',
  `level` int NOT NULL DEFAULT '0' COMMENT '层级',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `category_full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '组装分类名称',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示（1：显示，0：不显示）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机报价的图片',
  `need_vip` tinyint NOT NULL DEFAULT '0' COMMENT '是否需要VIP',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=249 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报价分类表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_category_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_category_config`;
CREATE TABLE `saas_phone_shop_recycle_category_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `is_enable` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_at` int NOT NULL COMMENT '创建时间',
  `update_at` int NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收分类配置表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_device
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_device`;
CREATE TABLE `saas_phone_shop_recycle_device` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '设备ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单ID',
  `imei` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'IMEI号码',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '设备型号',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '设备状态：1-正常，2-退回',
  `check_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '质检状态：0-未质检，1-质检中，2-已质检',
  `check_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '质检结果',
  `check_images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '质检图片 逗号 , 隔开 ',
  `initial_price` decimal(10,2) DEFAULT '0.00' COMMENT '预估价格',
  `final_price` decimal(10,2) DEFAULT '0.00' COMMENT '最终价格',
  `price_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '价格备注',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `create_at` int DEFAULT NULL COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `check_at` int DEFAULT NULL COMMENT '质检时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_imei` (`imei`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_order`;
CREATE TABLE `saas_phone_shop_recycle_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '订单编号',
  `customer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客户姓名',
  `customer_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '客户电话',
  `pay_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '打款时间',
  `pay_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付账号',
  `delivery_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'express' COMMENT '发货方式：express-快递，self-自送',
  `express_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '快递公司',
  `express_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '快递单号',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '订单状态：1-待签收，2-已签收，3-质检中，4-已质检，5-已支付，6-已完成，7-已取消',
  `total_amount` decimal(10,2) DEFAULT '0.00' COMMENT '订单总金额',
  `device_count` int NOT NULL DEFAULT '0' COMMENT '设备数量',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  `create_at` int DEFAULT NULL COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `complete_at` int DEFAULT NULL COMMENT '完成时间',
  `member_id` int NOT NULL COMMENT '用户 id',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '打款时间',
  `delete_at` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_order_no` (`order_no`),
  KEY `idx_customer_phone` (`customer_phone`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收订单主表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_order_device
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_order_device`;
CREATE TABLE `saas_phone_shop_recycle_order_device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL COMMENT '订单ID',
  `imei` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'IMEI号码',
  `model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '待识别' COMMENT '设备型号',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1-正常，2-已退回',
  `check_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '验机状态：0-未验机，1-验机中，2-验机完成',
  `check_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '验机详情',
  `initial_price` decimal(10,2) DEFAULT '0.00' COMMENT '初始报价',
  `final_price` decimal(10,2) DEFAULT '0.00' COMMENT '最终报价',
  `price_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '报价备注',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_at` int DEFAULT NULL COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `check_at` int DEFAULT NULL COMMENT '验机时间',
  `site_id` int NOT NULL COMMENT '站点 id',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回收订单设备表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_return_device
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_return_device`;
CREATE TABLE `saas_phone_shop_recycle_return_device` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '退货设备ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `return_order_id` int NOT NULL DEFAULT '0' COMMENT '退货订单ID',
  `device_id` int NOT NULL DEFAULT '0' COMMENT '设备ID',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '退货状态：0-待退货，1-退货中，2-已退货',
  `create_at` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `over_at` int DEFAULT NULL COMMENT '完成时间',
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `delete_at` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_return_order_id` (`return_order_id`),
  KEY `idx_device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='退货设备关联表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycle_return_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycle_return_order`;
CREATE TABLE `saas_phone_shop_recycle_return_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '退货订单ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '关联订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货订单号',
  `express_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货快递单号',
  `express_company` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货快递公司',
  `return_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退货地址',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '退货状态：0-待退货，1-退货中，2-已退货',
  `create_at` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_at` int DEFAULT NULL COMMENT '更新时间',
  `over_at` int DEFAULT NULL COMMENT '完成时间',
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `delete_at` int NOT NULL DEFAULT '0' COMMENT ' 删除时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT ' 备注',
  `operator_uid` int NOT NULL COMMENT '操作人',
  `operator_name` int NOT NULL COMMENT '操作人的名字',
  `member_id` int NOT NULL,
  `member_name` int NOT NULL,
  `member_mobile` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='退货订单表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycler
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycler`;
CREATE TABLE `saas_phone_shop_recycler` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `contact_name` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `contact_mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '联系电话',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省份ID',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '城市ID',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区县ID',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `area` varchar(255) NOT NULL DEFAULT '' COMMENT '地区',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `category` text COMMENT '经营品类ID，多个用逗号分隔',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（1：启用，0：禁用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='回收商信息表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycler_price_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycler_price_config`;
CREATE TABLE `saas_phone_shop_recycler_price_config` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `recycler_id` int NOT NULL DEFAULT '0' COMMENT '回收商ID',
  `price_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '加价类型（1：统一加价，2：区间加价）',
  `member_markup` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '会员加价比例',
  `non_member_markup` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '非会员加价比例',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_recycler` (`site_id`,`recycler_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='回收商价格配置表';

-- ----------------------------
-- Table structure for saas_phone_shop_recycler_price_range
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_recycler_price_range`;
CREATE TABLE `saas_phone_shop_recycler_price_range` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `config_id` int NOT NULL DEFAULT '0' COMMENT '价格配置ID',
  `min_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最小价格',
  `max_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最大价格',
  `member_markup` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加价比例',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_config_id` (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='回收商价格区间表';

-- ----------------------------
-- Table structure for saas_phone_shop_site
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_site`;
CREATE TABLE `saas_phone_shop_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL COMMENT '站点id',
  `site_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名',
  `client` tinyint NOT NULL DEFAULT '0' COMMENT '是否是回收商 默认0 , 1是',
  `category_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点分类',
  `brand_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点品牌',
  `label_group_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点标签分组',
  `label_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点的标签',
  `service_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点的服务信息',
  `price_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点的回收价格',
  `memory_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点的内存规格',
  `memory_group_status` tinyint NOT NULL DEFAULT '1' COMMENT '是否使用0站点的内存分组',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_phone_shop_site_agent
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_site_agent`;
CREATE TABLE `saas_phone_shop_site_agent` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID（代理商）',
  `agent_site_id` int NOT NULL DEFAULT '0' COMMENT '被代理的站点ID',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（1：启用，0：禁用）',
  `create_time` int NOT NULL COMMENT '创建时间',
  `update_time` int NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商户代理关系表';

-- ----------------------------
-- Table structure for saas_phone_shop_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_stat`;
CREATE TABLE `saas_phone_shop_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '订单总数',
  `sale_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售总额',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_sum` int NOT NULL DEFAULT '0' COMMENT '访问数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=408 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for saas_phone_shop_store
-- ----------------------------
DROP TABLE IF EXISTS `saas_phone_shop_store`;
CREATE TABLE `saas_phone_shop_store` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `store_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '门店名称',
  `store_desc` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '简介',
  `store_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '门店logo',
  `store_mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '县（区）',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '完整地址',
  `longitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '纬度',
  `trade_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '营业时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自提门店表';

-- ----------------------------
-- Table structure for saas_qfnotice_addon
-- ----------------------------
DROP TABLE IF EXISTS `saas_qfnotice_addon`;
CREATE TABLE `saas_qfnotice_addon` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图像',
  `is_main` int DEFAULT '1' COMMENT '使用框架',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'wechat' COMMENT '类型',
  `send_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'one' COMMENT '发送类型',
  `level_id` int DEFAULT NULL COMMENT '会员等级ID',
  `config_id` int DEFAULT NULL COMMENT '对应渠道参数',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置值',
  `sms_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '短信发送内容',
  `template_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板ID',
  `is_go_url` int DEFAULT '1' COMMENT '跳转链接',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转url值',
  `page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转小程序页面',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `email_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '邮件内容',
  `email_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `email_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `category_id` int DEFAULT NULL COMMENT '应用分类',
  `status` int DEFAULT '1' COMMENT '状态',
  `cat_id` int DEFAULT NULL COMMENT '发送分类',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='群发应用';

-- ----------------------------
-- Table structure for saas_qfnotice_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_qfnotice_category`;
CREATE TABLE `saas_qfnotice_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `create_time` int DEFAULT NULL COMMENT '创建实际',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='应用分类';

-- ----------------------------
-- Table structure for saas_qfnotice_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_qfnotice_log`;
CREATE TABLE `saas_qfnotice_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `addon_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `wx_openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'openid',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'wechat' COMMENT '类型',
  `log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '发送日志',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3414 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='发送日志';

-- ----------------------------
-- Table structure for saas_qfnotice_user
-- ----------------------------
DROP TABLE IF EXISTS `saas_qfnotice_user`;
CREATE TABLE `saas_qfnotice_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `cat_id` int DEFAULT NULL COMMENT '分类ID',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '昵称',
  `headimg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头像',
  `config_id` int(11) unsigned zerofill DEFAULT '00000000000' COMMENT '配置ID',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'openid',
  `unionid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'unionid',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `num` int DEFAULT NULL COMMENT '发送次数',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40958 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户列表';

-- ----------------------------
-- Table structure for saas_qfnotice_user_cat
-- ----------------------------
DROP TABLE IF EXISTS `saas_qfnotice_user_cat`;
CREATE TABLE `saas_qfnotice_user_cat` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `create_time` int DEFAULT NULL COMMENT '创建实际',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户分类';

-- ----------------------------
-- Table structure for saas_recharge
-- ----------------------------
DROP TABLE IF EXISTS `saas_recharge`;
CREATE TABLE `saas_recharge` (
  `recharge_id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `recharge_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '套餐名称',
  `face_value` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '面值',
  `buy_price` decimal(10,2) NOT NULL COMMENT '价格',
  `point` int NOT NULL DEFAULT '0' COMMENT '赠送积分',
  `growth` int NOT NULL DEFAULT '0' COMMENT '赠送成长值',
  `gift_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '赠品json',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '发放数量',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0关闭 1开启）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`recharge_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='会员充值套餐';

-- ----------------------------
-- Table structure for saas_recharge_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_recharge_order`;
CREATE TABLE `saas_recharge_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `order_type` varchar(50) NOT NULL DEFAULT '' COMMENT '订单类型',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态',
  `refund_status` int NOT NULL DEFAULT '0' COMMENT '退款状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) NOT NULL DEFAULT '' COMMENT '会员ip',
  `member_message` varchar(50) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `order_item_money` decimal(10,2) NOT NULL COMMENT '订单项目金额',
  `order_discount_money` decimal(10,2) NOT NULL COMMENT '订单优惠金额',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `is_delete` int NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '通用业务超时时间记录',
  `invoice_id` int NOT NULL DEFAULT '0' COMMENT '发票id，0表示不开发票',
  `close_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭原因',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1346 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_recharge_order_item
-- ----------------------------
DROP TABLE IF EXISTS `saas_recharge_order_item`;
CREATE TABLE `saas_recharge_order_item` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '购买会员id',
  `item_id` int NOT NULL DEFAULT '0' COMMENT '项目id',
  `item_type` varchar(255) NOT NULL DEFAULT '' COMMENT '项目类型',
  `item_name` varchar(400) NOT NULL DEFAULT '' COMMENT '项目名称',
  `item_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '项目图片',
  `price` decimal(10,2) NOT NULL COMMENT '项目单价',
  `num` decimal(10,3) NOT NULL COMMENT '购买数量',
  `item_money` decimal(10,2) NOT NULL COMMENT '项目总价',
  `is_refund` int NOT NULL DEFAULT '0' COMMENT '是否退款',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款编号',
  `refund_status` int NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`order_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=360 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单商品表';

-- ----------------------------
-- Table structure for saas_recharge_order_item_refund
-- ----------------------------
DROP TABLE IF EXISTS `saas_recharge_order_item_refund`;
CREATE TABLE `saas_recharge_order_item_refund` (
  `refund_id` int NOT NULL AUTO_INCREMENT,
  `order_item_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_no` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `refund_no` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款单号',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `num` decimal(10,3) NOT NULL COMMENT '退货数量',
  `money` decimal(10,2) NOT NULL COMMENT '总退款',
  `status` int NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `audit_time` int NOT NULL DEFAULT '0' COMMENT '审核时间',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `item_type` varchar(255) NOT NULL DEFAULT '' COMMENT '项目类型',
  PRIMARY KEY (`refund_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单退款表';

-- ----------------------------
-- Table structure for saas_recharge_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_recharge_order_log`;
CREATE TABLE `saas_recharge_order_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `action` varchar(255) NOT NULL DEFAULT '' COMMENT '操作内容',
  `uid` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `nick_name` varchar(50) NOT NULL DEFAULT '' COMMENT '操作人名称',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态，操作后',
  `action_way` bigint NOT NULL DEFAULT '2' COMMENT '操作类型1买家2卖家 3 系统任务',
  `order_status_name` varchar(255) NOT NULL DEFAULT '' COMMENT '订单状态名称，操作后',
  `action_time` int NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单操作记录表';

-- ----------------------------
-- Table structure for saas_running_building
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_building`;
CREATE TABLE `saas_running_building` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `school_id` int NOT NULL COMMENT '学校ID',
  `name` varchar(100) NOT NULL COMMENT '楼栋名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `level` int NOT NULL DEFAULT '0' COMMENT '等级',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收货楼栋表';

-- ----------------------------
-- Table structure for saas_running_express_site
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_express_site`;
CREATE TABLE `saas_running_express_site` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `school_id` int NOT NULL COMMENT '学校ID',
  `name` varchar(100) NOT NULL COMMENT '站点名称',
  `address` varchar(255) NOT NULL COMMENT '站点地址',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='快递站点表';

-- ----------------------------
-- Table structure for saas_running_help_center
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_help_center`;
CREATE TABLE `saas_running_help_center` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `title` varchar(100) NOT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='帮助中心表';

-- ----------------------------
-- Table structure for saas_running_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_order`;
CREATE TABLE `saas_running_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `school_id` int NOT NULL COMMENT '所属学校ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单编号',
  `member_id` int NOT NULL COMMENT '下单会员ID',
  `rider_id` int DEFAULT NULL COMMENT '接单跑腿员ID',
  `type` tinyint(1) NOT NULL COMMENT '订单类型：1=快递代取，2=代购，3=租借',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态：0=待接单，1=已接单，2=配送中，3=已完成，4=已取消',
  `amount` decimal(10,2) NOT NULL COMMENT '订单金额',
  `num` int NOT NULL COMMENT '数量',
  `delivery_fee` decimal(10,2) NOT NULL COMMENT '配送费',
  `commission_rate` decimal(5,2) NOT NULL COMMENT '抽成比例',
  `commission_amount` decimal(10,2) NOT NULL COMMENT '抽成金额',
  `pickup_address` varchar(255) NOT NULL COMMENT '取件地址',
  `pickup_mobile` varchar(255) NOT NULL COMMENT '取件联系电话',
  `pickup_name` varchar(255) NOT NULL COMMENT '取件联系人',
  `delivery_address` varchar(255) NOT NULL COMMENT '送达地址',
  `contact_name` varchar(50) NOT NULL COMMENT '联系人姓名',
  `contact_mobile` varchar(11) NOT NULL COMMENT '联系人电话',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_settlement` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否结算',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `settlement_time` datetime DEFAULT NULL COMMENT '结算时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_running_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_order_log`;
CREATE TABLE `saas_running_order_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `status` tinyint(1) NOT NULL COMMENT '订单状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `operator` varchar(50) NOT NULL COMMENT '操作人',
  `operator_id` int NOT NULL COMMENT '操作人ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单日志表';

-- ----------------------------
-- Table structure for saas_running_order_product
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_order_product`;
CREATE TABLE `saas_running_order_product` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL COMMENT '站点ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `product_id` int NOT NULL COMMENT '产品ID',
  `num` int NOT NULL COMMENT '数量',
  `name` varchar(50) NOT NULL COMMENT '商品名',
  `express_name` varchar(50) NOT NULL COMMENT '网点名',
  `code` varchar(50) NOT NULL COMMENT '取货码',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单商品表';

-- ----------------------------
-- Table structure for saas_running_product
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_product`;
CREATE TABLE `saas_running_product` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `school_id` int NOT NULL COMMENT '学校ID',
  `category_id` int NOT NULL COMMENT '分类ID',
  `name` varchar(100) NOT NULL COMMENT '产品名称',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `image` varchar(255) NOT NULL COMMENT '图片',
  `desc` varchar(110) NOT NULL COMMENT '描述',
  `sales` int NOT NULL DEFAULT '0' COMMENT '销量',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品表';

-- ----------------------------
-- Table structure for saas_running_rider
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_rider`;
CREATE TABLE `saas_running_rider` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `school_id` int NOT NULL COMMENT '所属学校ID',
  `member_id` int NOT NULL COMMENT '会员ID',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `id_card` varchar(18) NOT NULL COMMENT '身份证号',
  `mobile` varchar(11) NOT NULL COMMENT '手机号',
  `avatar` varchar(255) NOT NULL COMMENT '头像',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0=待审核，1=正常，2=禁用',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '账户余额',
  `total_income` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总收入',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='跑腿员表';

-- ----------------------------
-- Table structure for saas_running_school
-- ----------------------------
DROP TABLE IF EXISTS `saas_running_school`;
CREATE TABLE `saas_running_school` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `name` varchar(100) NOT NULL COMMENT '学校名称',
  `address` varchar(255) NOT NULL COMMENT '学校地址',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学校信息表';

-- ----------------------------
-- Table structure for saas_seafoxpay_fenzhang_set
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_fenzhang_set`;
CREATE TABLE `saas_seafoxpay_fenzhang_set` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点',
  `merchant_id` int DEFAULT NULL COMMENT '商户id',
  `open` int DEFAULT NULL COMMENT '开启分账',
  `fenlist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '分账设置',
  `adddate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_seafoxpay_maidan_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_maidan_order`;
CREATE TABLE `saas_seafoxpay_maidan_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT '0' COMMENT '站点id',
  `merchant_id` int DEFAULT NULL COMMENT '商户id',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '订单编号',
  `order_from` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '订单来源',
  `order_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '订单类型',
  `out_trade_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '支付流水号',
  `order_status` int DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `member_id` int DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '会员ip',
  `member_message` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '会员留言信息',
  `order_item_money` decimal(10,2) DEFAULT '0.00' COMMENT '订单项目金额',
  `order_discount_money` decimal(10,2) DEFAULT '0.00' COMMENT '订单优惠金额',
  `order_money` decimal(10,2) DEFAULT '0.00' COMMENT '订单金额',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  `pay_time` int DEFAULT '0' COMMENT '订单支付时间',
  `close_time` int DEFAULT '0' COMMENT '订单关闭时间',
  `is_delete` int DEFAULT '0' COMMENT '是否删除(针对后台)',
  `is_enable_refund` int DEFAULT '0' COMMENT '是否允许退款',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '商家留言',
  `invoice_id` int DEFAULT '0' COMMENT '发票id，0表示不开发票',
  `close_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '关闭原因',
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_seafoxpay_merchant
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_merchant`;
CREATE TABLE `saas_seafoxpay_merchant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名称',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户LOGO',
  `mch_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商户号',
  `addtime` int NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='海狐聚合支付商户';

-- ----------------------------
-- Table structure for saas_seafoxpay_merchant_cash_register
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_merchant_cash_register`;
CREATE TABLE `saas_seafoxpay_merchant_cash_register` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sid` int NOT NULL DEFAULT '0' COMMENT '门店id',
  `mch_id` varchar(32) NOT NULL DEFAULT '' COMMENT '商户号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='海狐聚合支付商户号配置';

-- ----------------------------
-- Table structure for saas_seafoxpay_merchant_comingpart
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_merchant_comingpart`;
CREATE TABLE `saas_seafoxpay_merchant_comingpart` (
  `helpmestore_id` int NOT NULL AUTO_INCREMENT,
  `sid` int NOT NULL DEFAULT '0' COMMENT '商户id',
  `firstClassMerchantNo` varchar(16) NOT NULL COMMENT '平台商商编',
  `merchantNo` varchar(100) DEFAULT NULL COMMENT '子商户编号',
  `orderNo` varchar(50) NOT NULL DEFAULT 'member' COMMENT '商户订单号',
  `signName` varchar(150) NOT NULL COMMENT '子商户签约名',
  `showName` varchar(100) NOT NULL COMMENT '展示名',
  `webSite` varchar(150) DEFAULT NULL COMMENT '网站网址',
  `accessUrl` varchar(150) DEFAULT NULL COMMENT '接入地址',
  `merchantType` varchar(20) NOT NULL COMMENT '子商户类型',
  `legalPerson` varchar(20) NOT NULL COMMENT '法人名字',
  `legalPersonID` varchar(30) NOT NULL COMMENT '法人身份证号',
  `orgNum` varchar(30) NOT NULL COMMENT '组织机构代码',
  `businessLicense` varchar(30) NOT NULL COMMENT '营业执照号',
  `province` varchar(15) DEFAULT NULL COMMENT '子商户所在省份',
  `city` varchar(15) DEFAULT NULL COMMENT '子商户所在城市',
  `regionCode` varbinary(8) NOT NULL COMMENT '区县编码',
  `address` varchar(150) NOT NULL COMMENT '通讯地址',
  `linkman` varchar(15) NOT NULL COMMENT '联系人',
  `linkPhone` varchar(20) NOT NULL COMMENT '联系电话',
  `email` varchar(50) NOT NULL COMMENT '联系邮箱',
  `bindMobile` varchar(25) DEFAULT NULL COMMENT '绑定手机',
  `servicePhone` varchar(20) DEFAULT NULL COMMENT '客服联系电话',
  `bankCode` varchar(13) NOT NULL COMMENT '结算卡联行号',
  `accountName` varchar(50) NOT NULL COMMENT '开户名',
  `accountNo` varchar(30) NOT NULL COMMENT '开户账',
  `settleBankType` varchar(20) NOT NULL COMMENT '结算卡类型',
  `settlementPeriod` varchar(20) NOT NULL COMMENT '结算类型',
  `settlementMode` varchar(20) NOT NULL COMMENT '结算方式',
  `settlementRemark` varchar(20) DEFAULT NULL COMMENT '结算备注',
  `merchantCategory` varchar(35) NOT NULL COMMENT '经营类别',
  `industryTypeCode` varchar(10) DEFAULT NULL COMMENT '行业类型编码',
  `authorizationFlag` varchar(10) NOT NULL COMMENT '授权使用平台商秘钥',
  `unionPayQrCode` varchar(100) DEFAULT NULL COMMENT '银联二维码',
  `needPosFunction` float(10,0) NOT NULL DEFAULT '0' COMMENT '是否需要开通 POS 功能',
  `settleMode` varchar(60) NOT NULL COMMENT '结算模式',
  `idType` varchar(20) NOT NULL COMMENT '法人证件类型',
  `agreeProtocol` float(10,0) NOT NULL DEFAULT '0' COMMENT '是否同意协议',
  `weixin_feilv` decimal(10,5) DEFAULT NULL COMMENT '微信费率',
  `alipay_feilv` decimal(10,5) DEFAULT NULL COMMENT '支付宝费率',
  PRIMARY KEY (`helpmestore_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='海狐聚合支付商户进件信息';

-- ----------------------------
-- Table structure for saas_seafoxpay_setting
-- ----------------------------
DROP TABLE IF EXISTS `saas_seafoxpay_setting`;
CREATE TABLE `saas_seafoxpay_setting` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `firstClassMerchantNo` varchar(255) NOT NULL DEFAULT '' COMMENT '商户编号',
  `public_encryption` varchar(255) NOT NULL DEFAULT '' COMMENT '公共产品的加密key',
  `public_autograph` varchar(255) NOT NULL DEFAULT '' COMMENT '公共产品的签名key',
  `scancode_encryption` varchar(255) NOT NULL DEFAULT '' COMMENT '扫码产品的加密key',
  `scancode_autograph` varchar(255) NOT NULL DEFAULT '' COMMENT '扫码产品的签名key',
  `merchant_privateKey` varchar(255) NOT NULL DEFAULT '' COMMENT '商户私钥',
  `merchant_cannelName` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道名',
  `receiptAppIds` varchar(255) NOT NULL DEFAULT '' COMMENT '小程序APPID',
  `app_product_wechat_qrcode` varchar(255) NOT NULL DEFAULT '' COMMENT 'app报备微信图片',
  `app_product_alipay_qrcode` varchar(255) NOT NULL DEFAULT '' COMMENT 'app报备支付宝图片',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='海狐聚合支付插件配置';

-- ----------------------------
-- Table structure for saas_shop_active
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_active`;
CREATE TABLE `saas_shop_active` (
  `active_id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `active_name` varchar(255) NOT NULL DEFAULT '' COMMENT '活动名称',
  `active_desc` text COMMENT '活动说明',
  `active_type` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类型(店铺活动，会员活动，商品活动)',
  `active_goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_goods_info` text COMMENT '参与活动商品信息',
  `active_class` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别',
  `active_class_category` varchar(255) NOT NULL DEFAULT '' COMMENT '活动类别子分类（活动管理）',
  `relate_member` varchar(1000) NOT NULL DEFAULT '' COMMENT '参与会员条件(默认全部)',
  `active_value` text COMMENT '活动扩展信息数据',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `active_status` varchar(50) NOT NULL DEFAULT '' COMMENT '活动状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `active_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店铺营销活动表（整体活动）';

-- ----------------------------
-- Table structure for saas_shop_active_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_active_goods`;
CREATE TABLE `saas_shop_active_goods` (
  `active_goods_id` int NOT NULL AUTO_INCREMENT COMMENT '活动商品id',
  `active_id` int NOT NULL DEFAULT '0' COMMENT '活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int DEFAULT '0' COMMENT '商品规格id',
  `active_goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类型（单品，独立商品，店铺整体商品）',
  `active_class` varchar(255) NOT NULL DEFAULT '' COMMENT '商品活动类别',
  `active_goods_label` varchar(1000) NOT NULL DEFAULT '' COMMENT '活动商品标签（针对活动有标签）',
  `active_goods_category` varchar(1000) NOT NULL DEFAULT '' COMMENT '活动商品分类（针对活动有分类）',
  `active_goods_value` text COMMENT '活动商品信息数据',
  `active_goods_status` varchar(50) NOT NULL DEFAULT '' COMMENT '活动状态',
  `active_goods_point` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品积分（展示，搜索）',
  `active_goods_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品价格（展示，搜索）',
  `active_goods_stock` int NOT NULL DEFAULT '0' COMMENT '活动商品库存（针对参与库存）',
  `active_goods_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `active_goods_order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `active_goods_member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `active_goods_success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`active_goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店铺营销活动';

-- ----------------------------
-- Table structure for saas_shop_address
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_address`;
CREATE TABLE `saas_shop_address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `contact_name` varchar(255) NOT NULL DEFAULT '' COMMENT '联系人',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '地址',
  `lat` varchar(50) NOT NULL DEFAULT '' COMMENT '纬度',
  `lng` varchar(50) NOT NULL DEFAULT '' COMMENT '经度',
  `is_delivery_address` int NOT NULL DEFAULT '0' COMMENT '是否是发货地址',
  `is_refund_address` int NOT NULL DEFAULT '0' COMMENT '是否是退货地址',
  `is_default_delivery` int NOT NULL DEFAULT '0' COMMENT '默认发货地址',
  `is_default_refund` int NOT NULL DEFAULT '0' COMMENT '默认收货地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家地址库';

-- ----------------------------
-- Table structure for saas_shop_cart
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_cart`;
CREATE TABLE `saas_shop_cart` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员ID',
  `goods_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `sku_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'sku id',
  `num` int unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `market_type` int unsigned NOT NULL DEFAULT '0' COMMENT '活动类型',
  `market_type_id` int unsigned NOT NULL DEFAULT '0' COMMENT '活动id',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '购物车商品状态',
  `invalid_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '失效原因',
  PRIMARY KEY (`id`),
  KEY `goods_id` (`goods_id`),
  KEY `member_id` (`member_id`),
  KEY `sku_id` (`sku_id`),
  KEY `type` (`market_type`),
  KEY `type_id` (`market_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';

-- ----------------------------
-- Table structure for saas_shop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_coupon`;
CREATE TABLE `saas_shop_coupon` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开启时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `remain_count` int NOT NULL DEFAULT '0' COMMENT '剩余数量',
  `receive_count` int NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `give_count` int NOT NULL DEFAULT '0' COMMENT '已发放数量',
  `limit_count` int NOT NULL DEFAULT '0' COMMENT '单个会员限制领取数量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 未开启 3 已无效',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品最低多少金额可用优惠券',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '优惠券类型 1通用优惠券 2商品品类优惠券 3商品优惠券',
  `receive_type` int NOT NULL DEFAULT '0' COMMENT '领取方式',
  `valid_type` int unsigned NOT NULL DEFAULT '0' COMMENT '有效时间',
  `length` int NOT NULL DEFAULT '0' COMMENT '有效期时长(天)',
  `valid_start_time` int NOT NULL DEFAULT '0' COMMENT '有效期开始时间',
  `valid_end_time` int NOT NULL DEFAULT '0' COMMENT '有效期结束时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `receive_status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 关闭',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `title` (`title`(191))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券表';

-- ----------------------------
-- Table structure for saas_shop_coupon_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_coupon_goods`;
CREATE TABLE `saas_shop_coupon_goods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券模板id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  PRIMARY KEY (`id`),
  KEY `index_category_id` (`category_id`),
  KEY `index_coupon_id` (`coupon_id`),
  KEY `index_goods_id` (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券商品或品类关联表';

-- ----------------------------
-- Table structure for saas_shop_coupon_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_coupon_member`;
CREATE TABLE `saas_shop_coupon_member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '优惠券发放记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `expire_time` int unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `use_time` int unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '优惠券类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最低使用门槛',
  `receive_type` varchar(255) NOT NULL DEFAULT '' COMMENT '领取方式',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  PRIMARY KEY (`id`),
  KEY `coupon_id` (`coupon_id`),
  KEY `member_id` (`member_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券会员领取记录表';

-- ----------------------------
-- Table structure for saas_shop_coupon_send_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_coupon_send_records`;
CREATE TABLE `saas_shop_coupon_send_records` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL COMMENT '站点id',
  `coupon_id` int unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `send_num` int NOT NULL COMMENT '每位会员发放数量',
  `range_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '发券范围',
  `range_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '范围对应参数',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '发放成功数',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态 wait-待发送 process-发送中 finish-结束',
  `member_num` int NOT NULL DEFAULT '0' COMMENT '发放会员数',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '发放结束时间',
  `admin_uid` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `admin_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人名称',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优惠券发券记录表';

-- ----------------------------
-- Table structure for saas_shop_delivery_company
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_company`;
CREATE TABLE `saas_shop_delivery_company` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司名称',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司logo',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司网站',
  `express_no` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司编号(用于物流跟踪)',
  `express_no_electronic_sheet` varchar(255) NOT NULL DEFAULT '' COMMENT '物流公司编号(用于电子面单)',
  `electronic_sheet_switch` tinyint NOT NULL DEFAULT '0' COMMENT '是否支持电子面单（0：不支持，1：支持）',
  `print_style` varchar(2000) NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式，json字符串',
  `exp_type` varchar(2000) NOT NULL DEFAULT '' COMMENT '物流公司业务类型，json字符串',
  `create_time` int NOT NULL DEFAULT '0',
  `update_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for saas_shop_delivery_deliver
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_deliver`;
CREATE TABLE `saas_shop_delivery_deliver` (
  `deliver_id` int NOT NULL AUTO_INCREMENT COMMENT '配送员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `deliver_name` varchar(255) NOT NULL DEFAULT '' COMMENT '配送员名称',
  `deliver_mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '配送员手机号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `modify_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `store_id` int NOT NULL DEFAULT '0' COMMENT '门店id',
  PRIMARY KEY (`deliver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='配送员表';

-- ----------------------------
-- Table structure for saas_shop_delivery_electronic_sheet
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_electronic_sheet`;
CREATE TABLE `saas_shop_delivery_electronic_sheet` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `express_company_id` int NOT NULL DEFAULT '0' COMMENT '物流公司id',
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单客户账号（CustomerName）',
  `customer_pwd` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单密码（CustomerPwd）',
  `send_site` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SendSite',
  `send_staff` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'SendStaff',
  `month_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'MonthCode',
  `pay_type` tinyint NOT NULL DEFAULT '0' COMMENT '邮费支付方式（1：现付，2：到付，3：月结）',
  `is_notice` tinyint NOT NULL DEFAULT '0' COMMENT '快递员上门揽件（0：否，1：是）',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（1：开启，0：关闭）',
  `exp_type` int NOT NULL DEFAULT '0' COMMENT '物流公司业务类型',
  `print_style` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '电子面单打印模板样式',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认（1：是，0：否）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电子面单';

-- ----------------------------
-- Table structure for saas_shop_delivery_local_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_local_delivery`;
CREATE TABLE `saas_shop_delivery_local_delivery` (
  `local_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `fee_type` varchar(30) NOT NULL DEFAULT '' COMMENT '费用类型',
  `base_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '多少km内',
  `base_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `grad_dist` decimal(10,1) NOT NULL DEFAULT '0.0' COMMENT '每超出多少km内',
  `grad_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费用',
  `weight_start` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '重量多少内不额外收费',
  `weight_unit` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '每超出多少kg',
  `weight_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `delivery_type` varchar(2000) NOT NULL DEFAULT '' COMMENT '配送类型',
  `area` longtext NOT NULL COMMENT '配送区域',
  `center` varchar(255) NOT NULL DEFAULT '' COMMENT '发货地址中心点',
  `time_is_open` tinyint NOT NULL DEFAULT '0' COMMENT '配送时间设置 0 关闭 1 开启',
  `time_type` tinyint NOT NULL DEFAULT '0' COMMENT '时间选取类型 0 每天  1 自定义',
  `time_week` varchar(255) NOT NULL DEFAULT '' COMMENT '营业时间  周一 周二.......',
  `time_interval` int NOT NULL DEFAULT '30' COMMENT '时段设置单位分钟',
  `advance_day` int NOT NULL DEFAULT '0' COMMENT '时间选择需提前多少天',
  `most_day` int NOT NULL DEFAULT '7' COMMENT '最多可预约多少天',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '当日的起始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '当日的营业结束时间',
  `delivery_time` varchar(2000) NOT NULL DEFAULT '' COMMENT '配送时间段',
  PRIMARY KEY (`local_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for saas_shop_delivery_shipping_template
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_shipping_template`;
CREATE TABLE `saas_shop_delivery_shipping_template` (
  `template_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_name` varchar(50) NOT NULL DEFAULT '' COMMENT '模板名称',
  `fee_type` varchar(20) NOT NULL DEFAULT '' COMMENT '运费计算方式1.重量2体积3按件',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `is_free_shipping` smallint NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `no_delivery` smallint NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='运费模板';

-- ----------------------------
-- Table structure for saas_shop_delivery_shipping_template_item
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_delivery_shipping_template_item`;
CREATE TABLE `saas_shop_delivery_shipping_template_item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_id` int NOT NULL DEFAULT '0' COMMENT '模板id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市id',
  `snum` int NOT NULL DEFAULT '0' COMMENT '起步计算标准',
  `sprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '起步计算价格',
  `xnum` int NOT NULL DEFAULT '0' COMMENT '续步计算标准',
  `xprice` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '续步计算价格',
  `fee_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '运费计算方式',
  `fee_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运费设置区域id集',
  `fee_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运费设置区域名称集',
  `no_delivery` smallint NOT NULL DEFAULT '0' COMMENT '是否指定该区域不配送',
  `no_delivery_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不配送的区域id集',
  `no_delivery_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不配送的区域名称集',
  `is_free_shipping` smallint NOT NULL DEFAULT '0' COMMENT '该区域是否包邮',
  `free_shipping_area_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '包邮的区域id集',
  `free_shipping_area_names` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '包邮的区域名称集',
  `free_shipping_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '满足包邮的条件',
  `free_shipping_num` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `express_template_item_city_id` (`city_id`),
  KEY `express_template_item_fee_type` (`fee_type`),
  KEY `express_template_item_template_id` (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='运费模板细节';

-- ----------------------------
-- Table structure for saas_shop_discount
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_discount`;
CREATE TABLE `saas_shop_discount` (
  `discount_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动名称',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动说明',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '活动状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  PRIMARY KEY (`discount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='限时折扣表';

-- ----------------------------
-- Table structure for saas_shop_discount_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_discount_goods`;
CREATE TABLE `saas_shop_discount_goods` (
  `discount_goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '活动商品id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `discount_id` int NOT NULL DEFAULT '0' COMMENT '活动id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品规格id',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品状态',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '折扣类型',
  `rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '折扣',
  `reduce_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '减钱',
  `discount_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动商品价格（展示，搜索）',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '活动成功参与会员数',
  `is_enabled` int NOT NULL DEFAULT '1' COMMENT '是否参与活动',
  PRIMARY KEY (`discount_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='限时折扣商品表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao`;
CREATE TABLE `saas_shop_fenxiao` (
  `fenxiao_id` int NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `fenxiao_no` varchar(255) NOT NULL DEFAULT '' COMMENT '分销商编号',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员ID',
  `level_id` int NOT NULL DEFAULT '0' COMMENT '分销商等级id',
  `parent` int NOT NULL DEFAULT '0' COMMENT '上级ID',
  `fenxiao_order_num` int NOT NULL DEFAULT '0' COMMENT '一级分销订单总数',
  `fenxiao_total_order` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '一级分销订单总额',
  `fenxiao_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分销佣金总额',
  `agent_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理佣金',
  `team_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队分红',
  `task_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '任务奖励',
  `sale_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售奖励',
  `child_num` int NOT NULL DEFAULT '0' COMMENT '一级下线人数',
  `child_fenxiao_num` int NOT NULL DEFAULT '0' COMMENT '一级下线分销商',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态（0待审核 1正常 -1已冻结 -2已拒绝）',
  `is_agent` int NOT NULL DEFAULT '0' COMMENT '是否是代理商',
  `agent_level` int NOT NULL DEFAULT '0' COMMENT '代理商等级',
  `agent_status` int NOT NULL DEFAULT '1' COMMENT '代理商状态 1正常  2冻结',
  `agent_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理商加盟费',
  `agent_time` int NOT NULL DEFAULT '0' COMMENT '代理商时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `lock_time` int NOT NULL DEFAULT '0' COMMENT '冻结时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`fenxiao_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销商表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_agent_level
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_agent_level`;
CREATE TABLE `saas_shop_fenxiao_agent_level` (
  `level_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '代理等级名称',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理等级费用',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理等级折扣',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代理等级表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_apply
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_apply`;
CREATE TABLE `saas_shop_fenxiao_apply` (
  `apply_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '申请id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '申请状态1申请中2已通过-1审核拒绝',
  `refuse_reason` varchar(3000) NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `audit_time` int NOT NULL DEFAULT '0' COMMENT '审核通过时间',
  PRIMARY KEY (`apply_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for saas_shop_fenxiao_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_goods`;
CREATE TABLE `saas_shop_fenxiao_goods` (
  `fenxiao_goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `is_fenxiao` tinyint NOT NULL DEFAULT '1' COMMENT '是否参与分享（1=是，0=否）',
  `fenxiao_type` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '佣金设置类型',
  `fenxiao_rule` text COMMENT '单独设置规则信息',
  PRIMARY KEY (`fenxiao_goods_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销商品表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_goods_rule
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_goods_rule`;
CREATE TABLE `saas_shop_fenxiao_goods_rule` (
  `goods_rule_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品sku_id',
  `level_id` int NOT NULL DEFAULT '0' COMMENT '分销等级id',
  `level_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分销等级名称',
  `one_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '一级佣金比例',
  `two_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '二级佣金比例',
  `one_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '一级佣金金额',
  `two_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '二级佣金金额',
  `calculate_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '计算金额',
  PRIMARY KEY (`goods_rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分销商品分佣规则表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_level
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_level`;
CREATE TABLE `saas_shop_fenxiao_level` (
  `level_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分销等级Id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `level_num` int NOT NULL DEFAULT '0' COMMENT '等级权重',
  `level_name` varchar(30) NOT NULL DEFAULT '' COMMENT '等级名称',
  `one_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '一级佣金比例',
  `two_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '二级佣金比例',
  `team_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队分红佣金比率',
  `team_flat_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队平级奖励',
  `upgrade_type` tinyint NOT NULL DEFAULT '0' COMMENT '升级方式（0满足任意条件  1满足全部条件）',
  `fenxiao_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分销佣金',
  `fenxiao_order_num` int NOT NULL DEFAULT '0' COMMENT '分销订单总数',
  `fenxiao_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分销订单总额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '自购订单总数',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '自购订单总额',
  `child_num` int NOT NULL DEFAULT '0' COMMENT '下线人数',
  `child_fenxiao_num` int NOT NULL DEFAULT '0' COMMENT '下线分销商人数',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态（0关闭 1启用）',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认等级1=是，0=否',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`level_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销等级配置表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_member`;
CREATE TABLE `saas_shop_fenxiao_member` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '推荐会员id(分销)',
  `fenxiao_member_id` int NOT NULL DEFAULT '0' COMMENT '会员上级分销商会员id',
  `is_fenxiao` tinyint NOT NULL DEFAULT '0' COMMENT '是否是分销商',
  `bind_time` int NOT NULL DEFAULT '0' COMMENT '绑定时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for saas_shop_fenxiao_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_order`;
CREATE TABLE `saas_shop_fenxiao_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分销订单Id',
  `order_id` int unsigned NOT NULL DEFAULT '0' COMMENT '订单ID',
  `order_no` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总佣金',
  `commission_fenxiao` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分销佣金',
  `commission_team` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队分红',
  `commission_agent` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '区域代理',
  `fenxiao_member_id1` int NOT NULL DEFAULT '0' COMMENT '分销商会员id1',
  `fenxiao_member_id2` int NOT NULL DEFAULT '0' COMMENT '分销商会员id2',
  `team_members` varchar(3000) NOT NULL DEFAULT '' COMMENT '团队分红会员ids',
  `agent_members` varchar(3000) NOT NULL DEFAULT '' COMMENT '区域代理会员ids',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `is_settlement` int NOT NULL DEFAULT '0' COMMENT '是否已结算',
  `settlement_time` int NOT NULL DEFAULT '0' COMMENT '结算时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销订单表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_order_goods`;
CREATE TABLE `saas_shop_fenxiao_order_goods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `order_goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `order_goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额（分销计算）',
  `calculate_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '计算方式1按照比率2固定金额',
  `commission_type` varchar(10) NOT NULL DEFAULT 'fenxiao' COMMENT '佣金类型',
  `commission_level` tinyint(1) NOT NULL DEFAULT '1' COMMENT '佣金层级',
  `commission_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '佣金百分比',
  `fenxiao_member_id` int NOT NULL DEFAULT '0' COMMENT '获取佣金的分销商会员id',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '获得的佣金',
  `is_refund` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否退款',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `is_settlement` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否结算',
  `order_original_goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品原价总额',
  `agent_discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理商折扣',
  `team_flat_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队平级比率',
  `settlement_time` int NOT NULL DEFAULT '0' COMMENT '结算时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销订单项表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_sale_period
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_sale_period`;
CREATE TABLE `saas_shop_fenxiao_sale_period` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `period_type` varchar(50) NOT NULL DEFAULT '' COMMENT '销售奖励类型   月度  季度  年度',
  `sale_start_time` int NOT NULL DEFAULT '0' COMMENT '结算开始日期',
  `sale_end_time` int NOT NULL DEFAULT '0' COMMENT '结算结束日期',
  `total_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总销售额',
  `total_reward_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '结算总奖励',
  `send_reward_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '已发放金额',
  `is_settlement` int NOT NULL DEFAULT '0' COMMENT '是否已结算',
  `settlement_time` int NOT NULL DEFAULT '0' COMMENT '结算日期',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建日期',
  `is_send` int NOT NULL DEFAULT '0' COMMENT '是否发放',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '发放时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='销售奖励周期表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_sale_period_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_sale_period_member`;
CREATE TABLE `saas_shop_fenxiao_sale_period_member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `period_id` int NOT NULL DEFAULT '0' COMMENT '所属周期id',
  `period_type` varchar(50) NOT NULL DEFAULT '' COMMENT '销售奖励类型   月度  季度  年度',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `sale_start_time` int NOT NULL DEFAULT '0' COMMENT '结算开始日期',
  `sale_end_time` int NOT NULL DEFAULT '0' COMMENT '结算结束日期',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总销售额',
  `reward_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '结算总奖励',
  `is_settlement` int NOT NULL DEFAULT '0' COMMENT '是否已发放',
  `settlement_time` int NOT NULL DEFAULT '0' COMMENT '结算日期',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建日期',
  `is_send` int NOT NULL DEFAULT '0' COMMENT '是否已经发放',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '发放',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员销售奖励周期表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_stat`;
CREATE TABLE `saas_shop_fenxiao_stat` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `year` int NOT NULL DEFAULT '0' COMMENT '年',
  `month` int NOT NULL DEFAULT '0' COMMENT '月',
  `day` int NOT NULL DEFAULT '0' COMMENT '日',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售金额',
  `order_num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售量',
  `child_num` int NOT NULL DEFAULT '0' COMMENT '推广会员数量',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `refund_num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款数量',
  `team_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队销售额',
  `team_order_num` int NOT NULL DEFAULT '0' COMMENT '团队销售量',
  `team_refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队退款金额',
  `team_refund_num` int NOT NULL DEFAULT '0' COMMENT '团队退款数量',
  `commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总佣金',
  `fenxiao_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分销佣金',
  `agent_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '代理商佣金',
  `team_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队佣金',
  `task_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '任务奖励',
  `sale_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售奖励',
  `child_fenxiao_num` int NOT NULL DEFAULT '0' COMMENT '推广分销商数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `IDX_shop_fenxiao_stat_day` (`day`) USING BTREE,
  KEY `IDX_shop_fenxiao_stat_month` (`month`) USING BTREE,
  KEY `IDX_shop_fenxiao_stat_site_id` (`site_id`) USING BTREE,
  KEY `IDX_shop_fenxiao_stat_year` (`year`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销统计表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_task
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_task`;
CREATE TABLE `saas_shop_fenxiao_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` int NOT NULL DEFAULT '1' COMMENT '任务类型  1 循环任务  2 阶梯任务',
  `time_type` varchar(255) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '任务名称',
  `cover` varchar(500) NOT NULL DEFAULT '' COMMENT '任务图片',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '任务开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '任务结束时间',
  `rules` text COMMENT '任务规则 销售额、推广人数、团队订单数    数量  可参与的分销等级',
  `status` int NOT NULL DEFAULT '0' COMMENT '任务状态 1未开始  2进行中  3已结束',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '任务说明',
  `send_time_type` varchar(255) NOT NULL DEFAULT '' COMMENT '奖励发放时间类型',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '奖励发放时间  1 任务完成后  2 活动结束后',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `level_type` varchar(255) NOT NULL DEFAULT '' COMMENT '等级条件',
  `level` varchar(255) NOT NULL DEFAULT '' COMMENT '包含等级',
  `times` int NOT NULL DEFAULT '0' COMMENT '次数',
  `count` int NOT NULL DEFAULT '0' COMMENT '任务数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销任务奖励';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_task_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_task_member`;
CREATE TABLE `saas_shop_fenxiao_task_member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `task_id` int NOT NULL DEFAULT '0' COMMENT '任务id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '团队销售额',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '销售量',
  `child_num` int NOT NULL DEFAULT '0' COMMENT '推广人数',
  `total_reward_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '任务总奖励佣金',
  `is_complete` int NOT NULL DEFAULT '0' COMMENT '是否已完成',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `complete_num` int NOT NULL DEFAULT '0' COMMENT '完成次数',
  `send_num` int NOT NULL DEFAULT '0' COMMENT '已发放数量',
  `progress` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '进度',
  `next_index` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '下一个指标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务进度表';

-- ----------------------------
-- Table structure for saas_shop_fenxiao_task_member_reward
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_fenxiao_task_member_reward`;
CREATE TABLE `saas_shop_fenxiao_task_member_reward` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `task_id` int NOT NULL DEFAULT '0' COMMENT '任务id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `from_id` int NOT NULL DEFAULT '0' COMMENT '会员任务参与id',
  `step` int NOT NULL DEFAULT '0' COMMENT '第几阶或第几次循环',
  `reward_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '任务总奖励佣金',
  `is_complete` int NOT NULL DEFAULT '0' COMMENT '是否已完成',
  `complete_time` int NOT NULL DEFAULT '0' COMMENT '完成时间',
  `is_send` int NOT NULL DEFAULT '0' COMMENT '是否发放',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '发放时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `send_timer` int NOT NULL DEFAULT '0' COMMENT '预计发放时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员任务奖励表';

-- ----------------------------
-- Table structure for saas_shop_giftcard
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard`;
CREATE TABLE `saas_shop_giftcard` (
  `giftcard_id` int NOT NULL AUTO_INCREMENT COMMENT '礼品卡活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡类型，virtual：电子卡，real：实体卡',
  `card_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡名称',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡分类',
  `cover` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '礼品卡封面图，多个逗号隔开',
  `material_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡封面id，多个逗号隔开',
  `card_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '礼品卡价格',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '礼品卡状态，1：上架，0：下架',
  `is_give` tinyint NOT NULL DEFAULT '1' COMMENT '是否允许转赠，0：不允许，1：允许',
  `receive_validity_time` int NOT NULL DEFAULT '0' COMMENT '领取有效期（小时，范围：1~24）',
  `blessing_json` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '祝福语，多个逗号隔开',
  `card_right_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡权益类型，balance：储值余额，goods：商品',
  `balance_json` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '储值余额面值，多个逗号隔开',
  `delivery_way` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提货方式，all：全部提货，batch：分批提货',
  `card_goods_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡权益商品类型，all：全部，diy：指定商品数量',
  `card_goods_count` int NOT NULL COMMENT '权益商品数量',
  `validity_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '有效期类型，forever：永久有效，day：购买后x天有效，date：指定过期日期',
  `validity_day` int NOT NULL DEFAULT '0' COMMENT '有效天数',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效时间',
  `card_key_way` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡密内容，0-9：数字，a-z：小写英文字母，,A-Z：大写英文字母，多个逗号隔开',
  `card_key_length` int NOT NULL DEFAULT '0' COMMENT '卡密位数',
  `card_no_length` int NOT NULL DEFAULT '0' COMMENT '卡号位数',
  `card_prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡号前缀',
  `card_suffix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡号后缀',
  `instruction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '使用须知',
  `card_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '礼品卡详情',
  `poster_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡海报id',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `make_card_count` int NOT NULL DEFAULT '0' COMMENT '制卡数量',
  `sale_count` int NOT NULL DEFAULT '0' COMMENT '礼品卡销量，获取数量',
  `activate_count` int NOT NULL DEFAULT '0' COMMENT '实体卡激活数量',
  `use_count` int NOT NULL DEFAULT '0' COMMENT '使用量',
  `invalid_count` int NOT NULL DEFAULT '0' COMMENT '作废数量',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`giftcard_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡活动表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_card
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_card`;
CREATE TABLE `saas_shop_giftcard_card` (
  `card_id` int NOT NULL AUTO_INCREMENT COMMENT '卡id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `giftcard_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `card_make_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡制卡关联id',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡来源，generate：生成，order：购买，give：别人赠送',
  `card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡编号',
  `card_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡密',
  `card_cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡封面',
  `balance` int NOT NULL DEFAULT '0' COMMENT '储值金额',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡状态',
  `member_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '会员id',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `total_num` int NOT NULL DEFAULT '0' COMMENT '使用总数量',
  `use_num` int NOT NULL DEFAULT '0' COMMENT '已使用次数',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `use_time` int NOT NULL DEFAULT '0' COMMENT '使用时间',
  `activate_time` int NOT NULL DEFAULT '0' COMMENT '激活时间',
  `invalid_time` int NOT NULL DEFAULT '0' COMMENT '失效时间',
  `card_bag_id` int NOT NULL DEFAULT '0' COMMENT '卡包id',
  PRIMARY KEY (`card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡获取表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_card_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_card_goods`;
CREATE TABLE `saas_shop_giftcard_card_goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `giftcard_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '储值金额',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品规格id',
  `goods_name` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格名称',
  `sku_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `sku_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品编码',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品销售价',
  `total_num` int NOT NULL DEFAULT '0' COMMENT '总数量',
  `use_num` int NOT NULL DEFAULT '0' COMMENT '已提货数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡获取权益表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_category`;
CREATE TABLE `saas_shop_giftcard_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '分类名称',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态（0，关闭，1：开启）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡分类表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_give
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_give`;
CREATE TABLE `saas_shop_giftcard_give` (
  `give_id` int NOT NULL AUTO_INCREMENT COMMENT '赠予id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `blessing` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '祝福语',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `give_num` int NOT NULL DEFAULT '1' COMMENT '本次赠送数量',
  `limit_num` int NOT NULL DEFAULT '0' COMMENT '限制每个会员的领取数量',
  `card_bag_id` int NOT NULL DEFAULT '0' COMMENT '卡包id',
  PRIMARY KEY (`give_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡赠予记录表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_goods`;
CREATE TABLE `saas_shop_giftcard_goods` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '关联商品规格id',
  `num` int NOT NULL DEFAULT '0' COMMENT '关联商品数量（实体卡商品数量）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡关联商品表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_log`;
CREATE TABLE `saas_shop_giftcard_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作类型',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人名称',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡操作日志表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_make
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_make`;
CREATE TABLE `saas_shop_giftcard_make` (
  `make_id` int NOT NULL AUTO_INCREMENT COMMENT '制卡记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `card_right_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡权益类型，balance：储值余额，goods：商品',
  `balance_json` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '储值余额面值，多个逗号隔开',
  `make_card_way` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '制卡方式 auto：在线制卡，import：导入',
  `import_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '导入文件路径',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态，wait：未开始，proceed：进行中，finish：完成，fail：失败',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '总数量',
  `success_count` int NOT NULL DEFAULT '0' COMMENT '成功数量',
  `fail_count` int NOT NULL DEFAULT '0' COMMENT '失败数量',
  `fail_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '输出文件路径',
  `fail_output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '失败记录',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`make_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡实体制作表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_material
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_material`;
CREATE TABLE `saas_shop_giftcard_material` (
  `material_id` int NOT NULL AUTO_INCREMENT COMMENT '素材id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `group_id` int NOT NULL DEFAULT '0' COMMENT '素材分组id',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片地址',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`material_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡素材表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_material_group
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_material_group`;
CREATE TABLE `saas_shop_giftcard_material_group` (
  `group_id` int NOT NULL AUTO_INCREMENT COMMENT '素材分组id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分组名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡素材分组表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_member_card_bag
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_member_card_bag`;
CREATE TABLE `saas_shop_giftcard_member_card_bag` (
  `card_bag_id` int NOT NULL AUTO_INCREMENT COMMENT '卡包id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `to_use_count` int NOT NULL DEFAULT '0' COMMENT '待使用数量',
  `can_use_count` int NOT NULL DEFAULT '0' COMMENT '可使用数量',
  `used_count` int NOT NULL DEFAULT '0' COMMENT '已使用数量',
  `invalid_count` int NOT NULL DEFAULT '0' COMMENT '已失效数量',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '总数量',
  `card_right_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡权益类型，balance：储值余额，goods：商品',
  `balance` int NOT NULL DEFAULT '0' COMMENT '储值金额',
  `delivery_way` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提货方式，all：全部提货，batch：分批提货',
  `card_goods_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '礼品卡权益商品类型，all：全部，diy：指定商品数量',
  `validity_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '有效期类型，forever：永久有效，day：购买后x天有效，date：指定过期日期',
  `is_give` tinyint NOT NULL DEFAULT '1' COMMENT '是否允许转赠，0：不允许，1：允许',
  `card_cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卡封面',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`card_bag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡会员卡包表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_member_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_member_records`;
CREATE TABLE `saas_shop_giftcard_member_records` (
  `member_card_id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `from_member_id` int NOT NULL DEFAULT '0' COMMENT '来源会员id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '领取会员id',
  `to_member_id` int NOT NULL DEFAULT '0' COMMENT '赠予会员id',
  `give_id` int NOT NULL DEFAULT '0' COMMENT '赠予id',
  `is_give` int NOT NULL DEFAULT '0' COMMENT '是否已被转赠',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源，order：购买，give：别人赠送',
  `get_time` int NOT NULL DEFAULT '0' COMMENT '获取时间',
  `give_time` int NOT NULL DEFAULT '0' COMMENT '赠予时间',
  PRIMARY KEY (`member_card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡会员领取记录表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_order`;
CREATE TABLE `saas_shop_giftcard_order` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '订单内容',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `status` varchar(55) NOT NULL DEFAULT '' COMMENT '订单状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `balance` int NOT NULL DEFAULT '0' COMMENT '储值金额',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡id',
  `card_right_type` varchar(50) NOT NULL DEFAULT '' COMMENT '礼品卡权益类型，balance：储值余额，goods：商品',
  `card_cover` varchar(500) NOT NULL DEFAULT '' COMMENT '礼品卡封面',
  `material_id` int NOT NULL DEFAULT '0' COMMENT '素材id',
  `card_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '礼品卡储值价格',
  `num` int NOT NULL DEFAULT '0' COMMENT '购买数量',
  `delivery_way` varchar(50) NOT NULL DEFAULT '' COMMENT '提货方式，all：全部提货，batch：分批提货',
  `card_goods_type` varchar(50) NOT NULL DEFAULT '' COMMENT '礼品卡权益商品类型，all：全部，diy：指定商品数量',
  `card_goods_count` int NOT NULL DEFAULT '0' COMMENT '权益商品数量',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效时间',
  `is_give` int NOT NULL DEFAULT '0' COMMENT '是否允许转赠',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单合计金额',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `member_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `shop_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '下单时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '支付时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `close_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭原因',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '订单超时时间记录',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='礼品卡订单表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_use_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_use_records`;
CREATE TABLE `saas_shop_giftcard_use_records` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `giftcard_id` int NOT NULL DEFAULT '0' COMMENT '礼品卡活动id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `member_card_id` int NOT NULL DEFAULT '0' COMMENT '会员领取卡id',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡使用记录表';

-- ----------------------------
-- Table structure for saas_shop_giftcard_use_records_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_giftcard_use_records_goods`;
CREATE TABLE `saas_shop_giftcard_use_records_goods` (
  `record_goods_id` int NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `records_id` int NOT NULL DEFAULT '0' COMMENT '使用记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `card_id` int NOT NULL DEFAULT '0' COMMENT '卡id',
  `card_goods_id` int NOT NULL DEFAULT '0' COMMENT '关联礼品卡项权益id',
  `balance` int NOT NULL DEFAULT '0' COMMENT '储值余额',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品skuid',
  `goods_name` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '规格名称',
  `sku_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `sku_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品编码',
  `use_num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='礼品卡使用记录权益表';

-- ----------------------------
-- Table structure for saas_shop_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods`;
CREATE TABLE `saas_shop_goods` (
  `goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `goods_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'real' COMMENT '商品类型',
  `sub_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '副标题',
  `goods_cover` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品封面',
  `goods_image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品图片',
  `goods_video` varchar(555) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '商品视频',
  `goods_category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品分类',
  `goods_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品介绍',
  `brand_id` int NOT NULL DEFAULT '0' COMMENT '商品品牌id',
  `label_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签组',
  `service_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品服务',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '件' COMMENT '单位',
  `stock` int NOT NULL DEFAULT '0' COMMENT '商品库存（总和）',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量',
  `virtual_sale_num` int NOT NULL DEFAULT '0' COMMENT '虚拟销量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '商品状态（1.正常0下架）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `delivery_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支持的配送方式',
  `is_free_shipping` tinyint NOT NULL DEFAULT '1' COMMENT '是否免邮',
  `fee_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '运费设置，选择模板：template，固定运费：fixed',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '固定运费',
  `delivery_template_id` int NOT NULL DEFAULT '0' COMMENT '运费模板',
  `goods_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '虚拟商品的地址',
  `virtual_auto_delivery` tinyint NOT NULL DEFAULT '0' COMMENT '虚拟商品是否自动发货',
  `virtual_receive_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'artificial' COMMENT '虚拟商品收货方式，auto：自动收货，artificial：买家确认收货，verify：到店核销',
  `virtual_verify_type` tinyint NOT NULL DEFAULT '0' COMMENT '虚拟商品核销有效期类型，0：不限，1：购买后几日有效，2：指定过期日期',
  `virtual_indate` int NOT NULL DEFAULT '0' COMMENT '虚拟到期时间',
  `supplier_id` int NOT NULL DEFAULT '0' COMMENT '供应商id',
  `attr_id` int NOT NULL DEFAULT '0' COMMENT '商品参数id',
  `attr_format` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品参数内容，json格式',
  `is_discount` int NOT NULL DEFAULT '0' COMMENT '是否参与限时折扣',
  `member_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '会员等级折扣，不参与：空，会员折扣：discount，指定会员价：fixed_price',
  `poster_id` int NOT NULL DEFAULT '0' COMMENT '海报id',
  `form_id` int NOT NULL DEFAULT '0' COMMENT '万能表单id',
  `is_limit` tinyint NOT NULL DEFAULT '0' COMMENT '商品是否限购(0:否 1:是)',
  `limit_type` tinyint NOT NULL DEFAULT '1' COMMENT '限购类型，1：单次限购，2：单人限购',
  `max_buy` int NOT NULL DEFAULT '0' COMMENT '限购数',
  `min_buy` int NOT NULL DEFAULT '0' COMMENT '起购数',
  `is_gift` tinyint NOT NULL DEFAULT '0' COMMENT '商品是否赠品(0:否 1:是)',
  `access_num` int NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int NOT NULL DEFAULT '0' COMMENT '评论数量',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`goods_id`),
  KEY `idx_goods_category` (`goods_category`(191)),
  KEY `idx_goods_create_time` (`create_time`),
  KEY `idx_goods_delete_time` (`delete_time`),
  KEY `idx_goods_name` (`goods_name`(191)),
  KEY `idx_goods_sort` (`sort`),
  KEY `idx_goods_status` (`status`),
  KEY `idx_goods_sub_title` (`sub_title`(191)),
  KEY `IDX_ns_goods_goods_class` (`goods_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品表';

-- ----------------------------
-- Table structure for saas_shop_goods_attr
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_attr`;
CREATE TABLE `saas_shop_goods_attr` (
  `attr_id` int NOT NULL AUTO_INCREMENT COMMENT '商品参数id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `attr_name` varchar(255) NOT NULL DEFAULT '' COMMENT '参数名称',
  `attr_value_format` text COMMENT '参数值，json格式',
  `sort` int NOT NULL DEFAULT '0' COMMENT '参数排序号',
  PRIMARY KEY (`attr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品参数表';

-- ----------------------------
-- Table structure for saas_shop_goods_brand
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_brand`;
CREATE TABLE `saas_shop_goods_brand` (
  `brand_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品牌名称',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '品牌logo',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '品牌介绍',
  `color_json` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`brand_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品品牌表';

-- ----------------------------
-- Table structure for saas_shop_goods_browse
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_browse`;
CREATE TABLE `saas_shop_goods_browse` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '浏览人',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT 'sku_id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `browse_time` int NOT NULL DEFAULT '0' COMMENT '浏览时间',
  `goods_cover` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `goods_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品浏览历史';

-- ----------------------------
-- Table structure for saas_shop_goods_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_category`;
CREATE TABLE `saas_shop_goods_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '商品分类id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '分类图片',
  `level` int NOT NULL DEFAULT '0' COMMENT '层级',
  `pid` int NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `category_full_name` varchar(255) NOT NULL DEFAULT '' COMMENT '组装分类名称',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示（1：显示，0：不显示）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1448 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';

-- ----------------------------
-- Table structure for saas_shop_goods_collect
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_collect`;
CREATE TABLE `saas_shop_goods_collect` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  KEY `IDX_member_collect_goods` (`goods_id`),
  KEY `IDX_member_collect_member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品收藏记录表';

-- ----------------------------
-- Table structure for saas_shop_goods_evaluate
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_evaluate`;
CREATE TABLE `saas_shop_goods_evaluate` (
  `evaluate_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int NOT NULL DEFAULT '0' COMMENT '订单项ID',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品ID',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员ID',
  `member_head` varchar(255) NOT NULL DEFAULT '' COMMENT '会员头像',
  `member_name` varchar(100) NOT NULL DEFAULT '' COMMENT '会员名称',
  `content` varchar(3000) NOT NULL DEFAULT '' COMMENT '评价内容',
  `images` varchar(3000) NOT NULL DEFAULT '' COMMENT '评价图片',
  `is_anonymous` tinyint NOT NULL DEFAULT '1' COMMENT '1匿名  2不匿名',
  `scores` tinyint NOT NULL DEFAULT '1' COMMENT '评论分数 1-5',
  `is_audit` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态 1待审 2通过 3拒绝',
  `explain_first` varchar(3000) NOT NULL DEFAULT '' COMMENT '解释内容',
  `topping` int NOT NULL DEFAULT '0' COMMENT '排序 置顶',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '评论时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`evaluate_id`),
  KEY `idx_shop_goods_evaluate_create_time` (`create_time`),
  KEY `idx_shop_goods_evaluate_goods_id` (`goods_id`),
  KEY `idx_shop_goods_evaluate_is_anonymous` (`is_anonymous`),
  KEY `idx_shop_goods_evaluate_is_audit` (`is_audit`),
  KEY `idx_shop_goods_evaluate_member_id` (`member_id`),
  KEY `idx_shop_goods_evaluate_order_id` (`order_id`),
  KEY `idx_shop_goods_evaluate_scores` (`scores`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品评价表';

-- ----------------------------
-- Table structure for saas_shop_goods_label
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_label`;
CREATE TABLE `saas_shop_goods_label` (
  `label_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `label_name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `group_id` int NOT NULL DEFAULT '0' COMMENT '标签分组id',
  `style_type` varchar(255) NOT NULL DEFAULT '' COMMENT '效果设置，diy：自定义，icon：图片',
  `color_json` varchar(255) NOT NULL DEFAULT '' COMMENT '自定义颜色（文字、背景、边框），json格式',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态，1：启用，0；关闭',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '标签说明',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`label_id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品标签表';

-- ----------------------------
-- Table structure for saas_shop_goods_label_group
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_label_group`;
CREATE TABLE `saas_shop_goods_label_group` (
  `group_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `group_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分组名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品标签分组表';

-- ----------------------------
-- Table structure for saas_shop_goods_rank
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_rank`;
CREATE TABLE `saas_shop_goods_rank` (
  `rank_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '榜单名称',
  `rank_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '排行周期 day=天，week=周，month=月, quarter=季度',
  `goods_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源类型 goods=指定商品，category=指定分类，brand=指定品牌, label=指定标签',
  `rule_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '排序规则 sale=按照销量，collect=按收藏数，evaluate=按评价数, access=按照浏览量',
  `goods_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品信息',
  `category_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品分类id',
  `brand_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '商品品牌id',
  `label_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品标签id，多个逗号隔开',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` int NOT NULL DEFAULT '1' COMMENT '显示状态（0不显示 1显示）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品排行榜';

-- ----------------------------
-- Table structure for saas_shop_goods_service
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_service`;
CREATE TABLE `saas_shop_goods_service` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `service_name` varchar(255) NOT NULL DEFAULT '' COMMENT '服务名称',
  `image` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品服务表';

-- ----------------------------
-- Table structure for saas_shop_goods_sku
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_sku`;
CREATE TABLE `saas_shop_goods_sku` (
  `sku_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '商品sku_id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `sku_name` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku名称',
  `sku_image` varchar(2000) NOT NULL DEFAULT '' COMMENT 'sku主图',
  `sku_no` varchar(255) NOT NULL DEFAULT '' COMMENT '商品sku编码',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_spec_format` text COMMENT 'sku规格格式',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku单价',
  `market_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '划线价',
  `sale_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际卖价（有活动显示活动价，默认原价）',
  `cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'sku成本价',
  `stock` int NOT NULL DEFAULT '0' COMMENT '商品sku库存',
  `weight` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '重量（单位kg）',
  `volume` decimal(10,3) NOT NULL DEFAULT '0.000' COMMENT '体积（单位立方米）',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '销量',
  `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认',
  `member_price` text COMMENT '会员价，json格式，指定会员价，数据结构为：{"level_1":"10.00","level_2":"10.00"}',
  PRIMARY KEY (`sku_id`),
  KEY `idx_goods_sku_is_default` (`is_default`),
  KEY `idx_goods_sku_price` (`price`),
  KEY `idx_goods_sku_sale_price` (`sale_price`)
) ENGINE=InnoDB AUTO_INCREMENT=3779 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品规格表';

-- ----------------------------
-- Table structure for saas_shop_goods_spec
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_spec`;
CREATE TABLE `saas_shop_goods_spec` (
  `spec_id` int NOT NULL AUTO_INCREMENT COMMENT '规格id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '关联商品id',
  `spec_name` varchar(255) NOT NULL DEFAULT '' COMMENT '规格项名称',
  `spec_values` text COMMENT '规格值名称，多个逗号隔开',
  PRIMARY KEY (`spec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品规格项/值表';

-- ----------------------------
-- Table structure for saas_shop_goods_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_goods_stat`;
CREATE TABLE `saas_shop_goods_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `cart_num` int NOT NULL DEFAULT '0' COMMENT '加入购物车数量',
  `sale_num` int NOT NULL DEFAULT '0' COMMENT '商品销量（下单数）',
  `pay_num` int NOT NULL DEFAULT '0' COMMENT '支付件数',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付总金额',
  `refund_num` int NOT NULL DEFAULT '0' COMMENT '退款件数',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_num` int NOT NULL DEFAULT '0' COMMENT '访问次数（浏览量）',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数量',
  `evaluate_num` int NOT NULL DEFAULT '0' COMMENT '评论数量',
  `goods_visit_member_count` int NOT NULL DEFAULT '0' COMMENT '商品访客数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5227 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='商品数据统计';

-- ----------------------------
-- Table structure for saas_shop_invoice
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_invoice`;
CREATE TABLE `saas_shop_invoice` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `trade_type` varchar(10) NOT NULL DEFAULT 'order' COMMENT '开票分类 order:订单',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '业务id',
  `header_type` tinyint NOT NULL DEFAULT '1' COMMENT '抬头类型',
  `header_name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称（发票抬头）',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '发票类型',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '发票内容',
  `tax_number` varchar(50) NOT NULL DEFAULT '' COMMENT '公司税号',
  `mobile` varchar(30) NOT NULL DEFAULT '' COMMENT '开票人手机号',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '开票人邮箱',
  `telephone` varchar(30) NOT NULL DEFAULT '' COMMENT '注册电话',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '注册地址',
  `bank_name` varchar(50) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_card_number` varchar(50) NOT NULL DEFAULT '' COMMENT '银行账号',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '开票金额',
  `is_invoice` tinyint NOT NULL DEFAULT '0' COMMENT '是否开票',
  `invoice_number` varchar(50) NOT NULL DEFAULT '' COMMENT '发票代码',
  `invoice_voucher` varchar(1000) NOT NULL DEFAULT '' COMMENT '发票凭证',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '申请时间',
  `invoice_time` int NOT NULL DEFAULT '0' COMMENT '开票时间',
  `status` int NOT NULL DEFAULT '0' COMMENT '是否生效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='发票表';

-- ----------------------------
-- Table structure for saas_shop_manjian
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_manjian`;
CREATE TABLE `saas_shop_manjian` (
  `manjian_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '满减活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `manjian_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `condition_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'over_n_yuan' COMMENT '条件类型 over_n_yuan:满N元  over_n_piece:满N件',
  `goods_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all_goods' COMMENT '参与商品 all_goods:全部商品参与  selected_goods:指定商品 selected_goods_not:指定商品不参与 ',
  `join_member_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all_member' COMMENT '参与会员 all_member:所有会员参与  selected_member_level:指定会员等级  selected_member_label:指定会员标签 ',
  `rule_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ladder' COMMENT '优惠规格 ladder:阶梯优惠  cycle:循环优惠',
  `rule_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '优惠规则json',
  `goods_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '商品id集',
  `level_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '会员等级id集',
  `label_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '会员标签id集',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态（0未开始1进行中2已结束-1已关闭）',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '开始时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '结束时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `total_order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计金额',
  `total_order_num` int NOT NULL DEFAULT '0' COMMENT '活动累计订单数',
  `total_member_num` int NOT NULL DEFAULT '0' COMMENT '活动参与会员数',
  `total_point` int NOT NULL DEFAULT '0' COMMENT '活动累计赠送积分',
  `total_balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '活动累计赠送余额',
  `total_coupon_num` int NOT NULL DEFAULT '0' COMMENT '活动累计赠送优惠券数',
  `total_goods_num` int NOT NULL DEFAULT '0' COMMENT '活动累计赠送商品数',
  PRIMARY KEY (`manjian_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='满减活动表';

-- ----------------------------
-- Table structure for saas_shop_manjian_give_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_manjian_give_records`;
CREATE TABLE `saas_shop_manjian_give_records` (
  `record_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '赠送记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `manjian_id` int NOT NULL DEFAULT '0' COMMENT '满减送活动id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `level` int NOT NULL DEFAULT '0' COMMENT '优惠层级',
  `point` int NOT NULL DEFAULT '0' COMMENT '赠送积分数量',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送余额',
  `coupon_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '赠送优惠券',
  `goods_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '赠送商品',
  `sku_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '满足条件的商品规格id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='满减送记录表';

-- ----------------------------
-- Table structure for saas_shop_manjian_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_manjian_goods`;
CREATE TABLE `saas_shop_manjian_goods` (
  `manjian_goods_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '满减商品活动id',
  `manjian_id` int NOT NULL DEFAULT '0' COMMENT '满减活动id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '规格id',
  `goods_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'all_goods' COMMENT '参与商品 all_goods:全部商品参与  selected_goods:指定商品 selected_goods_not:指定商品不参与 ',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0未开始1进行中2已结束-1已关闭）',
  PRIMARY KEY (`manjian_goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='满减商品表';

-- ----------------------------
-- Table structure for saas_shop_newcomer_member_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_newcomer_member_records`;
CREATE TABLE `saas_shop_newcomer_member_records` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `validity_time` int NOT NULL DEFAULT '0' COMMENT '有效期',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '参与时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `is_join` tinyint NOT NULL DEFAULT '0' COMMENT '是否参与',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '参与订单id',
  `goods_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与商品id集合',
  `sku_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '参与商品规格id集合',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='新人专享会员参与记录表';

-- ----------------------------
-- Table structure for saas_shop_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order`;
CREATE TABLE `saas_shop_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_no` varchar(50) NOT NULL DEFAULT '' COMMENT '订单编号',
  `body` varchar(1000) NOT NULL DEFAULT '' COMMENT '订单内容',
  `order_type` varchar(55) NOT NULL DEFAULT '' COMMENT '订单类型',
  `order_from` varchar(55) NOT NULL DEFAULT '' COMMENT '订单来源',
  `out_trade_no` varchar(50) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `status` varchar(55) NOT NULL DEFAULT '' COMMENT '订单状态',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `ip` varchar(20) NOT NULL DEFAULT '' COMMENT 'ip',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品金额',
  `delivery_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送金额',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `invoice_id` int NOT NULL DEFAULT '0' COMMENT '发票id，0表示不开发票',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '订单支付时间',
  `delivery_time` int NOT NULL DEFAULT '0' COMMENT '订单发货时间/自提订单自提时间',
  `buyer_ask_delivery_time` varchar(255) NOT NULL DEFAULT '' COMMENT '购买人要求的配送/发货/自提时间（文本）',
  `take_time` int NOT NULL DEFAULT '0' COMMENT '订单收货时间',
  `finish_time` int NOT NULL DEFAULT '0' COMMENT '订单完成时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '订单关闭时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '是否删除(针对后台)',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '通用业务超时时间记录',
  `delivery_type` varchar(255) NOT NULL DEFAULT '' COMMENT '配送方式',
  `take_store_id` int NOT NULL DEFAULT '0' COMMENT '自提点',
  `taker_name` varchar(500) NOT NULL DEFAULT '' COMMENT '收货人',
  `taker_mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '收货人手机号',
  `taker_province` int NOT NULL DEFAULT '0' COMMENT '收货省',
  `taker_city` int NOT NULL DEFAULT '0' COMMENT '收货市',
  `taker_district` int NOT NULL DEFAULT '0' COMMENT '收货区县',
  `taker_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货地址',
  `taker_full_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '收货详细地址',
  `taker_longitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货地址经度',
  `taker_latitude` varchar(50) NOT NULL DEFAULT '' COMMENT '收货详细纬度',
  `taker_store_id` varchar(50) NOT NULL DEFAULT '' COMMENT '收货门店',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `member_remark` varchar(50) NOT NULL DEFAULT '' COMMENT '会员留言信息',
  `shop_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '商家留言',
  `close_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭原因',
  `close_type` varchar(255) NOT NULL DEFAULT '' COMMENT '关闭来源(未支付自动关闭   手动关闭  退款关闭)',
  `refund_status` int NOT NULL DEFAULT '1' COMMENT '退款状态  1不存在退款  2 部分退款  3 全部退款',
  `has_goods_types` varchar(255) NOT NULL DEFAULT '' COMMENT '包含的商品类型 json',
  `is_evaluate` int NOT NULL DEFAULT '0' COMMENT '是否评论',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联id',
  `point` int NOT NULL DEFAULT '0' COMMENT '积分兑换',
  `activity_type` varchar(255) NOT NULL DEFAULT '' COMMENT '营销类型',
  `form_record_id` int NOT NULL DEFAULT '0' COMMENT '万能表单记录id',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- ----------------------------
-- Table structure for saas_shop_order_batch_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_batch_delivery`;
CREATE TABLE `saas_shop_order_batch_delivery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 进行中  已完成  已失败',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作类型 批量发货  批量打单 ....',
  `total_num` int NOT NULL DEFAULT '0' COMMENT '总发货单数',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '成功发货单数',
  `fail_num` int NOT NULL DEFAULT '0' COMMENT '失败发货单数',
  `data` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '导入文件的路径',
  `output` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '对外输出记录',
  `fail_output` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败记录',
  `fail_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单批量发货表';

-- ----------------------------
-- Table structure for saas_shop_order_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_delivery`;
CREATE TABLE `saas_shop_order_delivery` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '包裹名称',
  `delivery_type` varchar(50) NOT NULL DEFAULT '' COMMENT '配送方式',
  `sub_delivery_type` varchar(50) NOT NULL DEFAULT '' COMMENT '详细配送方式',
  `express_company_id` int NOT NULL DEFAULT '0' COMMENT '快递公司id',
  `express_number` varchar(50) NOT NULL DEFAULT '' COMMENT '配送单号',
  `local_deliver_id` int NOT NULL DEFAULT '0' COMMENT '同城配送员',
  `status` int NOT NULL DEFAULT '0' COMMENT '配送状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `remark` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单发货表';

-- ----------------------------
-- Table structure for saas_shop_order_discount
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_discount`;
CREATE TABLE `saas_shop_order_discount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `discount_type` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠类型',
  `discount_type_id` int NOT NULL DEFAULT '0' COMMENT '优惠类型id',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '订单优惠说明',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单优惠表';

-- ----------------------------
-- Table structure for saas_shop_order_discount_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_discount_goods`;
CREATE TABLE `saas_shop_order_discount_goods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_discount_id` int NOT NULL DEFAULT '0' COMMENT '订单优惠id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` varchar(255) NOT NULL DEFAULT '' COMMENT '参与的订单商品项',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '类型 discount 优惠，gift 赠送',
  `num` int NOT NULL DEFAULT '0' COMMENT '使用数量',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单项优惠表';

-- ----------------------------
-- Table structure for saas_shop_order_goods
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_goods`;
CREATE TABLE `saas_shop_order_goods` (
  `order_goods_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '购买会员id',
  `goods_id` int NOT NULL DEFAULT '0' COMMENT '商品id',
  `sku_id` int NOT NULL DEFAULT '0' COMMENT '商品规格id',
  `sku_no` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `goods_name` varchar(400) NOT NULL DEFAULT '' COMMENT '商品名称',
  `sku_name` varchar(400) NOT NULL DEFAULT '' COMMENT '商品规格名称',
  `goods_image` varchar(2000) NOT NULL DEFAULT '' COMMENT '商品图片',
  `sku_image` varchar(1000) NOT NULL COMMENT 'sku规格图片',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `num` int NOT NULL DEFAULT '0' COMMENT '购买数量',
  `goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品总价',
  `is_enable_refund` int NOT NULL DEFAULT '0' COMMENT '是否允许退款',
  `goods_type` varchar(255) NOT NULL DEFAULT '' COMMENT '商品类型',
  `delivery_status` varchar(255) NOT NULL DEFAULT '' COMMENT '配送状态',
  `delivery_id` int NOT NULL DEFAULT '0' COMMENT '发货单号',
  `discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态',
  `order_refund_no` varchar(50) NOT NULL DEFAULT '' COMMENT '退款单号',
  `order_goods_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单项实付金额',
  `goods_url` varchar(255) DEFAULT NULL COMMENT '虚拟商品地址',
  `original_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品原价',
  `extend` varchar(1000) NOT NULL DEFAULT '' COMMENT '数据项扩展',
  `verify_count` int NOT NULL DEFAULT '0' COMMENT '已核销次数',
  `verify_expire_time` int NOT NULL DEFAULT '0' COMMENT '过期时间 0 为永久',
  `is_verify` int NOT NULL DEFAULT '0' COMMENT '是否需要核销',
  `saas_shop_active_refund` tinyint NOT NULL DEFAULT '0' COMMENT '商家主动退款（0否  1是）',
  `saas_shop_active_refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商家主动退款金额',
  `is_gift` tinyint NOT NULL DEFAULT '0' COMMENT '是否是赠品（0否  1是）',
  `form_record_id` int NOT NULL DEFAULT '0' COMMENT '万能表单记录id',
  PRIMARY KEY (`order_goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=847 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单项表';

-- ----------------------------
-- Table structure for saas_shop_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_log`;
CREATE TABLE `saas_shop_order_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `main_type` varchar(255) NOT NULL DEFAULT '操作人类型',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int DEFAULT NULL COMMENT '订单状态',
  `type` varchar(255) NOT NULL DEFAULT '',
  `content` varchar(255) DEFAULT NULL COMMENT '日志内容',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3579 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单日志表';

-- ----------------------------
-- Table structure for saas_shop_order_refund
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_refund`;
CREATE TABLE `saas_shop_order_refund` (
  `refund_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` int NOT NULL DEFAULT '0' COMMENT '订单id',
  `order_goods_id` int NOT NULL DEFAULT '0' COMMENT '订单项id',
  `order_refund_no` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款单号',
  `refund_type` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款方式 ',
  `reason` varchar(255) NOT NULL DEFAULT '0' COMMENT '退款原因 ',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `apply_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '申请退款',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实际退款',
  `status` varchar(30) NOT NULL DEFAULT '0' COMMENT '退款状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `transfer_time` int NOT NULL DEFAULT '0' COMMENT '转账时间',
  `remark` varchar(2000) NOT NULL DEFAULT '描述' COMMENT '描述',
  `voucher` varchar(2000) NOT NULL DEFAULT '凭证' COMMENT '凭证',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源 system 系统 member 会员',
  `timeout` int NOT NULL DEFAULT '0' COMMENT '操作超时时间',
  `refund_no` varchar(255) NOT NULL DEFAULT '' COMMENT '退款交易号',
  `delivery` varchar(3000) NOT NULL DEFAULT '' COMMENT '退货配送信息',
  `shop_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '上架拒绝原因',
  `refund_address` varchar(1000) NOT NULL DEFAULT '' COMMENT '商家退货地址',
  `is_refund_delivery` int NOT NULL DEFAULT '0' COMMENT '是否退运费',
  PRIMARY KEY (`refund_id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单退款表';

-- ----------------------------
-- Table structure for saas_shop_order_refund_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_order_refund_log`;
CREATE TABLE `saas_shop_order_refund_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `order_refund_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '退款编号',
  `main_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '操作人类型',
  `main_id` int NOT NULL DEFAULT '0' COMMENT '操作人id',
  `status` int DEFAULT NULL COMMENT '退款状态',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志内容',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=290 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='订单退款日志表';

-- ----------------------------
-- Table structure for saas_shop_point_exchange
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_point_exchange`;
CREATE TABLE `saas_shop_point_exchange` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '兑换活动主键id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换类型（商品、优惠券、红包）',
  `names` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换标题',
  `title` varchar(255) NOT NULL COMMENT '副标题',
  `image` text COMMENT '图片',
  `status` int NOT NULL DEFAULT '0' COMMENT '兑换状态 0 下架  1上架  -1 删除',
  `product_detail` text COMMENT '兑换产品信息',
  `point` int NOT NULL DEFAULT '0' COMMENT '兑换所需积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '兑换所需金额',
  `limit_num` int NOT NULL DEFAULT '0' COMMENT '限制数量',
  `content` text COMMENT '产品介绍',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `total_point_num` int DEFAULT '0' COMMENT '积分消费总额',
  `total_price_num` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总支付金额',
  `total_order_num` int DEFAULT '0' COMMENT '订单笔数',
  `total_member_num` int DEFAULT '0' COMMENT '参与会员数',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存',
  `total_exchange_num` int NOT NULL DEFAULT '0' COMMENT '兑换数量',
  PRIMARY KEY (`id`,`total_price_num`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分兑换表';

-- ----------------------------
-- Table structure for saas_shop_point_exchange_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_point_exchange_order`;
CREATE TABLE `saas_shop_point_exchange_order` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '兑换记录id',
  `order_no` varchar(255) NOT NULL DEFAULT '' COMMENT '订单编号',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '支付流水表',
  `site_id` int NOT NULL COMMENT '站点id',
  `exchange_id` int NOT NULL DEFAULT '0' COMMENT '兑换活动id',
  `exchange_name` varchar(255) NOT NULL DEFAULT '' COMMENT '兑换商品名称',
  `exchange_image` varchar(600) NOT NULL DEFAULT '' COMMENT '兑换商品图片	',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '兑换类型',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '消费会员id',
  `member_address_id` int NOT NULL DEFAULT '0' COMMENT '会员地址id',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `relate_order_id` int NOT NULL DEFAULT '0' COMMENT '关联订单id',
  `point` int NOT NULL DEFAULT '0' COMMENT '使用积分',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赠送余额',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `pay_time` int NOT NULL DEFAULT '0' COMMENT '兑换时间',
  `close_time` int NOT NULL DEFAULT '0' COMMENT '关闭时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '订单删除',
  `num` int NOT NULL DEFAULT '0' COMMENT '兑换数量',
  `status` varchar(50) NOT NULL DEFAULT '' COMMENT '订单状态',
  `order_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分兑换订单表';

-- ----------------------------
-- Table structure for saas_shop_stat
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_stat`;
CREATE TABLE `saas_shop_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `date` varchar(255) NOT NULL DEFAULT '' COMMENT '日期',
  `date_time` int NOT NULL DEFAULT '0' COMMENT '时间戳',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '订单总数',
  `sale_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '销售总额',
  `refund_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '退款总额',
  `access_sum` int NOT NULL DEFAULT '0' COMMENT '访问数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=549 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for saas_shop_store
-- ----------------------------
DROP TABLE IF EXISTS `saas_shop_store`;
CREATE TABLE `saas_shop_store` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `store_name` varchar(255) NOT NULL DEFAULT '' COMMENT '门店名称',
  `store_desc` varchar(3000) NOT NULL DEFAULT '' COMMENT '简介',
  `store_logo` varchar(255) NOT NULL DEFAULT '' COMMENT '门店logo',
  `store_mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '手机号',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省id',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '县（区）',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `longitude` varchar(255) NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(255) NOT NULL DEFAULT '' COMMENT '纬度',
  `trade_time` varchar(255) NOT NULL DEFAULT '' COMMENT '营业时间(文本展示使用)',
  `time_week` text COMMENT '自定义的营业时间["0","1","2","3","4","5","6"]周日-周六',
  `trade_time_json` text COMMENT '营业时间',
  `time_interval` int NOT NULL DEFAULT '0' COMMENT '时段设置（分钟）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自提门店表';

-- ----------------------------
-- Table structure for saas_site
-- ----------------------------
DROP TABLE IF EXISTS `saas_site`;
CREATE TABLE `saas_site` (
  `site_id` int NOT NULL AUTO_INCREMENT,
  `site_name` varchar(50) NOT NULL DEFAULT '' COMMENT '站点名称',
  `group_id` int NOT NULL DEFAULT '0' COMMENT '分组ID(0:不限制)',
  `keywords` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字',
  `app_type` varchar(50) NOT NULL DEFAULT 'admin' COMMENT '站点类型',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT '站点logo',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '简介',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 1-正常 0-体验期 2-已到期',
  `latitude` varchar(255) NOT NULL DEFAULT '' COMMENT '纬度',
  `longitude` varchar(255) NOT NULL DEFAULT '' COMMENT '经度',
  `province_id` int NOT NULL DEFAULT '0' COMMENT '省',
  `city_id` int NOT NULL DEFAULT '0' COMMENT '市',
  `district_id` int NOT NULL DEFAULT '0' COMMENT '区',
  `address` varchar(255) NOT NULL DEFAULT '' COMMENT '详细地址',
  `full_address` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `phone` varchar(255) NOT NULL DEFAULT '' COMMENT '客服电话',
  `business_hours` varchar(255) NOT NULL DEFAULT '' COMMENT '营业时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `expire_time` bigint NOT NULL DEFAULT '0' COMMENT '到期时间（如果是0 无限期）',
  `front_end_name` varchar(50) NOT NULL DEFAULT '' COMMENT '前台名称',
  `front_end_logo` varchar(255) NOT NULL DEFAULT '' COMMENT '前台logo（长方形）',
  `front_end_icon` varchar(255) NOT NULL DEFAULT '' COMMENT '前台icon（正方形）',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '网站图标',
  `member_no` varchar(255) NOT NULL DEFAULT '0' COMMENT '最大会员码值',
  `app` text NOT NULL COMMENT '站点主应用',
  `addons` text NOT NULL COMMENT '站点包含的插件',
  `initalled_addon` text COMMENT '站点已执行初始化方法的插件',
  `site_domain` varchar(255) NOT NULL DEFAULT '' COMMENT '站点域名',
  PRIMARY KEY (`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100032 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='站点表';

-- ----------------------------
-- Table structure for saas_site_account_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_site_account_log`;
CREATE TABLE `saas_site_account_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `type` varchar(255) NOT NULL DEFAULT 'pay' COMMENT '账单类型pay,refund,transfer',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '交易金额',
  `trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '对应类型交易单号',
  `create_time` varchar(255) NOT NULL DEFAULT '0' COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1799 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='站点账单记录';

-- ----------------------------
-- Table structure for saas_site_group
-- ----------------------------
DROP TABLE IF EXISTS `saas_site_group`;
CREATE TABLE `saas_site_group` (
  `group_id` int NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `group_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分组名称',
  `group_desc` text COMMENT '分组介绍',
  `app` text NOT NULL COMMENT '应用',
  `addon` text NOT NULL COMMENT '插件',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='店铺分组（分组权限）';

-- ----------------------------
-- Table structure for saas_sow_community_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_category`;
CREATE TABLE `saas_sow_community_category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '分类名称',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态（0，关闭，1：开启）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区分类表';

-- ----------------------------
-- Table structure for saas_sow_community_comment
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_comment`;
CREATE TABLE `saas_sow_community_comment` (
  `comment_id` int NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `content_id` int NOT NULL DEFAULT '0' COMMENT '内容id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '评论会员id',
  `reply_member_id` int NOT NULL DEFAULT '0' COMMENT '回复会员id',
  `parent_comment_id` int NOT NULL DEFAULT '0' COMMENT '父评论id',
  `comment_content` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评论内容',
  `comment_image` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '评价图片',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0：无需审核，1：待审核，2：审核通过，-1：审核拒绝）',
  `like_num` int NOT NULL DEFAULT '0' COMMENT '获赞数',
  `reply_num` int NOT NULL DEFAULT '0' COMMENT '回复数',
  `level` tinyint NOT NULL DEFAULT '0' COMMENT '评论层级（0评论，1一级回复，2二级回复）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区评论表';

-- ----------------------------
-- Table structure for saas_sow_community_comment_like
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_comment_like`;
CREATE TABLE `saas_sow_community_comment_like` (
  `comment_like_id` int NOT NULL AUTO_INCREMENT COMMENT '社区评论点赞id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `comment_id` int NOT NULL DEFAULT '0' COMMENT '评论id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`comment_like_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区评论点赞记录表';

-- ----------------------------
-- Table structure for saas_sow_community_content
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_content`;
CREATE TABLE `saas_sow_community_content` (
  `content_id` int NOT NULL AUTO_INCREMENT COMMENT '内容id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '发布会员id',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `topic_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '话题id集合',
  `content_type` tinyint NOT NULL DEFAULT '1' COMMENT '内容类型（1：图文，2：短视频）',
  `content_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容标题',
  `content_image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容图片',
  `content_video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容视频',
  `content_cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '内容封面',
  `content_cover_width` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面图片宽度',
  `content_cover_height` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面图片高度',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容正文',
  `treasure_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '宝贝id集合',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0：无需审核，1：待审核，2：审核通过，-1：审核拒绝，-2：强制下架）',
  `refuse_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '拒绝原因',
  `is_recommend` tinyint NOT NULL DEFAULT '1' COMMENT '是否推荐（0：否，1：是）',
  `lat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '纬度',
  `lng` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '经度',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '位置',
  `like_num` int NOT NULL DEFAULT '0' COMMENT '获赞数',
  `comment_num` int NOT NULL DEFAULT '0' COMMENT '评论数',
  `share_num` int NOT NULL DEFAULT '0' COMMENT '分享数',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数',
  `view_num` int NOT NULL DEFAULT '0' COMMENT '浏览量',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区内容表';

-- ----------------------------
-- Table structure for saas_sow_community_content_collect
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_content_collect`;
CREATE TABLE `saas_sow_community_content_collect` (
  `collect_id` int NOT NULL AUTO_INCREMENT COMMENT '社区内容收藏id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `content_id` int NOT NULL DEFAULT '0' COMMENT '内容id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`collect_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区内容收藏记录表';

-- ----------------------------
-- Table structure for saas_sow_community_content_like
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_content_like`;
CREATE TABLE `saas_sow_community_content_like` (
  `content_like_id` int NOT NULL AUTO_INCREMENT COMMENT '社区内容点赞id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `content_id` int NOT NULL DEFAULT '0' COMMENT '内容id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`content_like_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区内容点赞记录表';

-- ----------------------------
-- Table structure for saas_sow_community_follow
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_follow`;
CREATE TABLE `saas_sow_community_follow` (
  `follow_id` int NOT NULL AUTO_INCREMENT COMMENT '关注id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `follow_member_id` int NOT NULL DEFAULT '0' COMMENT '关注会员id',
  `is_follow` tinyint NOT NULL DEFAULT '0' COMMENT '是否关注（0：未关注，1：已关注）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`follow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区用户关注关系表';

-- ----------------------------
-- Table structure for saas_sow_community_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_member`;
CREATE TABLE `saas_sow_community_member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `follow_num` int NOT NULL DEFAULT '0' COMMENT '关注数',
  `fans_num` int NOT NULL DEFAULT '0' COMMENT '粉丝数',
  `like_num` int NOT NULL DEFAULT '0' COMMENT '获赞数',
  `collect_num` int NOT NULL DEFAULT '0' COMMENT '收藏数',
  `content_num` int NOT NULL DEFAULT '0' COMMENT '内容数',
  `intro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '个人简介',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区用户信息表';

-- ----------------------------
-- Table structure for saas_sow_community_member_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_member_records`;
CREATE TABLE `saas_sow_community_member_records` (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `topic_id` int NOT NULL DEFAULT '0' COMMENT '话题id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区用户偏好记录表';

-- ----------------------------
-- Table structure for saas_sow_community_sensitive
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_sensitive`;
CREATE TABLE `saas_sow_community_sensitive` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `config_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '配置项关键字',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '敏感词',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区敏感词表';

-- ----------------------------
-- Table structure for saas_sow_community_topic
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_topic`;
CREATE TABLE `saas_sow_community_topic` (
  `topic_id` int NOT NULL AUTO_INCREMENT COMMENT '话题id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `category_id` int NOT NULL DEFAULT '0' COMMENT '分类id',
  `topic_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '话题名称',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态（0：禁用，1：启用）',
  `is_recommend` tinyint NOT NULL DEFAULT '1' COMMENT '是否推荐（0：否，1：是）',
  `content_num` int NOT NULL DEFAULT '0' COMMENT '相关内容数',
  `member_num` int NOT NULL DEFAULT '0' COMMENT '相关作者数',
  `view_num` int NOT NULL DEFAULT '0' COMMENT '话题内容浏览量',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区话题表';

-- ----------------------------
-- Table structure for saas_sow_community_treasure
-- ----------------------------
DROP TABLE IF EXISTS `saas_sow_community_treasure`;
CREATE TABLE `saas_sow_community_treasure` (
  `treasure_id` int NOT NULL AUTO_INCREMENT COMMENT '宝贝id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `treasure_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '宝贝名称',
  `treasure_sub_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '宝贝副标题',
  `treasure_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '宝贝图片',
  `treasure_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '宝贝价格',
  `treasure_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '宝贝跳转链接',
  `relate_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  `relate_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联业务类型',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `is_join` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否参与',
  PRIMARY KEY (`treasure_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='种草社区宝贝库表';

-- ----------------------------
-- Table structure for saas_spdr_list
-- ----------------------------
DROP TABLE IF EXISTS `saas_spdr_list`;
CREATE TABLE `saas_spdr_list` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '名称',
  `cat_id` int DEFAULT NULL COMMENT '分类ID',
  `cat_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '分类名称',
  `flie` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '文件路径',
  `num` int DEFAULT NULL COMMENT '数据条数',
  `success_num` int DEFAULT NULL COMMENT '成功数量',
  `fail_num` int DEFAULT NULL COMMENT '失败数量',
  `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='商品导入列表';

-- ----------------------------
-- Table structure for saas_sseafoxpay_merchant
-- ----------------------------
DROP TABLE IF EXISTS `saas_sseafoxpay_merchant`;
CREATE TABLE `saas_sseafoxpay_merchant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户名称',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商户LOGO',
  `mch_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '商户号',
  `addtime` int NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='海狐聚合支付商户';

-- ----------------------------
-- Table structure for saas_stat_hour
-- ----------------------------
DROP TABLE IF EXISTS `saas_stat_hour`;
CREATE TABLE `saas_stat_hour` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '插件',
  `field` varchar(255) NOT NULL DEFAULT '' COMMENT '统计字段',
  `field_total` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总计',
  `year` int NOT NULL DEFAULT '0' COMMENT '年',
  `month` int NOT NULL DEFAULT '0' COMMENT '月',
  `day` int NOT NULL DEFAULT '0' COMMENT '天',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '当日开始时间戳',
  `last_time` int NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `hour_0` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_1` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_2` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_3` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_4` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_5` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_6` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_7` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_8` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_9` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_10` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_11` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_12` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_13` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_14` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_15` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_16` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_17` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_18` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_19` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_20` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_21` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_22` decimal(10,2) NOT NULL DEFAULT '0.00',
  `hour_23` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='小时统计表';

-- ----------------------------
-- Table structure for saas_sys_agreement
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_agreement`;
CREATE TABLE `saas_sys_agreement` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `agreement_key` varchar(255) NOT NULL DEFAULT '' COMMENT '协议关键字',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '协议标题',
  `content` text COMMENT '协议内容',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='协议表';

-- ----------------------------
-- Table structure for saas_sys_area
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_area`;
CREATE TABLE `saas_sys_area` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '名称',
  `shortname` varchar(30) NOT NULL DEFAULT '' COMMENT '简称',
  `longitude` varchar(30) NOT NULL DEFAULT '' COMMENT '经度',
  `latitude` varchar(30) NOT NULL DEFAULT '' COMMENT '纬度',
  `level` smallint NOT NULL DEFAULT '0' COMMENT '级别',
  `sort` mediumint NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态1有效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=460400502 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='地址表';

-- ----------------------------
-- Table structure for saas_sys_attachment
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_attachment`;
CREATE TABLE `saas_sys_attachment` (
  `att_id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '附件名称',
  `real_name` varchar(255) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '完整地址',
  `dir` varchar(200) NOT NULL DEFAULT '' COMMENT '附件路径',
  `att_size` char(30) NOT NULL DEFAULT '' COMMENT '附件大小',
  `att_type` char(30) NOT NULL DEFAULT '' COMMENT '附件类型image,video',
  `storage_type` varchar(20) NOT NULL DEFAULT '' COMMENT '图片上传类型 local本地  aliyun  阿里云oss  qiniu  七牛 ....',
  `cate_id` int NOT NULL DEFAULT '0' COMMENT '相关分类',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '上传时间',
  `update_time` int NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '网络地址',
  PRIMARY KEY (`att_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28528 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='附件管理表';

-- ----------------------------
-- Table structure for saas_sys_attachment_category
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_attachment_category`;
CREATE TABLE `saas_sys_attachment_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int NOT NULL DEFAULT '0' COMMENT '父级ID',
  `type` varchar(50) NOT NULL DEFAULT '' COMMENT '文件管理类型（image,video）',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '分类名称',
  `enname` varchar(50) NOT NULL DEFAULT '' COMMENT '分类目录',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='附件分类表';

-- ----------------------------
-- Table structure for saas_sys_backup_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_backup_records`;
CREATE TABLE `saas_sys_backup_records` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备份版本号',
  `backup_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备份标识',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备份内容',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态',
  `fail_reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '失败原因',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `complete_time` int NOT NULL DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='备份记录表';

-- ----------------------------
-- Table structure for saas_sys_config
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_config`;
CREATE TABLE `saas_sys_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `config_key` varchar(255) NOT NULL DEFAULT '' COMMENT '配置项关键字',
  `value` text COMMENT '配置值json',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 0不启用',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=314 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统配置表';

-- ----------------------------
-- Table structure for saas_sys_cron_task
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_cron_task`;
CREATE TABLE `saas_sys_cron_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `status` int NOT NULL DEFAULT '1' COMMENT '任务状态',
  `count` int NOT NULL DEFAULT '0' COMMENT '执行次数',
  `title` char(50) NOT NULL DEFAULT '' COMMENT '任务名称',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '任务模式  cron  定时任务  crond 周期任务',
  `crond_type` char(200) NOT NULL DEFAULT '' COMMENT '任务周期',
  `crond_length` int NOT NULL DEFAULT '0' COMMENT '任务周期',
  `task` varchar(500) NOT NULL DEFAULT '' COMMENT '任务命令',
  `data` longtext COMMENT '附加参数',
  `status_desc` varchar(1000) NOT NULL DEFAULT '' COMMENT '上次执行结果',
  `last_time` int NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `next_time` int NOT NULL DEFAULT '0' COMMENT '下次执行时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT=' 系统任务';

-- ----------------------------
-- Table structure for saas_sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_dict`;
CREATE TABLE `saas_sys_dict` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '字典名称',
  `key` varchar(100) NOT NULL DEFAULT '' COMMENT '字典关键词',
  `dictionary` text NOT NULL COMMENT '字典数据',
  `memo` varchar(255) NOT NULL DEFAULT '',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='数据字典表';

-- ----------------------------
-- Table structure for saas_sys_export
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_export`;
CREATE TABLE `saas_sys_export` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `export_key` varchar(255) NOT NULL DEFAULT '' COMMENT '主题关键字',
  `export_num` int NOT NULL DEFAULT '0' COMMENT '导出数据数量',
  `file_path` varchar(255) NOT NULL DEFAULT '' COMMENT '文件存储路径',
  `file_size` varchar(255) NOT NULL DEFAULT '' COMMENT '文件大小',
  `export_status` tinyint NOT NULL DEFAULT '0' COMMENT '导出状态',
  `fail_reason` varchar(255) NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '导出时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='导出报表';

-- ----------------------------
-- Table structure for saas_sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_menu`;
CREATE TABLE `saas_sys_menu` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `app_type` varchar(255) NOT NULL DEFAULT 'admin' COMMENT '应用类型',
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT '菜单名称',
  `menu_short_name` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单短标题',
  `menu_key` varchar(255) NOT NULL DEFAULT '' COMMENT '菜单标识（菜单输入，接口自动生成）',
  `parent_key` varchar(255) NOT NULL DEFAULT '' COMMENT '父级key',
  `menu_type` tinyint NOT NULL DEFAULT '1' COMMENT '菜单类型 0目录 1菜单 2按钮',
  `icon` varchar(500) NOT NULL DEFAULT '' COMMENT '图标 菜单有效',
  `api_url` varchar(100) NOT NULL DEFAULT '' COMMENT 'api接口地址',
  `router_path` varchar(128) NOT NULL DEFAULT '' COMMENT '菜单路由地址 前端使用',
  `view_path` varchar(255) NOT NULL DEFAULT '' COMMENT '菜单文件地址',
  `methods` varchar(10) NOT NULL DEFAULT '' COMMENT '提交方式POST GET PUT DELETE',
  `sort` int NOT NULL DEFAULT '1' COMMENT '排序',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '正常，禁用（禁用后不允许访问）',
  `is_show` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示',
  `create_time` int NOT NULL DEFAULT '0',
  `delete_time` int NOT NULL DEFAULT '0',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `source` varchar(255) NOT NULL DEFAULT 'system' COMMENT '菜单来源   system 系统文件  create 新建菜单  generator 代码生成器',
  `menu_attr` varchar(50) NOT NULL DEFAULT '' COMMENT '菜单属性 common 公共 system 系统',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=185825 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='菜单表';

-- ----------------------------
-- Table structure for saas_sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_notice`;
CREATE TABLE `saas_sys_notice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点ID',
  `key` varchar(50) NOT NULL DEFAULT '' COMMENT '标识',
  `sms_content` text COMMENT '短信配置参数',
  `is_wechat` tinyint NOT NULL DEFAULT '0' COMMENT '公众号模板消息（0：关闭，1：开启）',
  `is_weapp` tinyint NOT NULL DEFAULT '0' COMMENT '小程序订阅消息（0：关闭，1：开启）',
  `is_sms` tinyint NOT NULL DEFAULT '0' COMMENT '发送短信（0：关闭，1：开启）',
  `wechat_template_id` varchar(255) NOT NULL DEFAULT '' COMMENT '微信模版消息id',
  `weapp_template_id` varchar(255) NOT NULL DEFAULT '' COMMENT '微信小程序订阅消息id',
  `sms_id` varchar(255) NOT NULL DEFAULT '' COMMENT '短信id（对应短信配置）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `wechat_first` varchar(255) NOT NULL DEFAULT '' COMMENT '微信头部',
  `wechat_remark` varchar(255) NOT NULL DEFAULT '' COMMENT '微信说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='通知模型';

-- ----------------------------
-- Table structure for saas_sys_notice_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_notice_log`;
CREATE TABLE `saas_sys_notice_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '通知记录ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `key` varchar(255) DEFAULT '' COMMENT '消息key',
  `notice_type` varchar(50) DEFAULT 'sms' COMMENT '消息类型（sms,wechat.weapp）',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '通知的用户id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '消息的会员id',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '接收人用户昵称或姓名',
  `receiver` varchar(255) NOT NULL DEFAULT '' COMMENT '接收人（对应手机号，openid）',
  `content` text COMMENT '消息数据',
  `is_click` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '点击次数',
  `is_visit` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '访问次数',
  `visit_time` int NOT NULL DEFAULT '0' COMMENT '访问时间',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '消息时间',
  `result` varchar(1000) NOT NULL DEFAULT '' COMMENT '结果',
  `params` text,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11522 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='通知记录表';

-- ----------------------------
-- Table structure for saas_sys_notice_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_notice_sms_log`;
CREATE TABLE `saas_sys_notice_sms_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0',
  `mobile` varchar(11) NOT NULL DEFAULT '' COMMENT '手机号码',
  `sms_type` varchar(32) NOT NULL DEFAULT '' COMMENT '发送关键字（注册、找回密码）',
  `key` varchar(32) NOT NULL DEFAULT '' COMMENT '发送关键字（注册、找回密码）',
  `template_id` varchar(50) NOT NULL DEFAULT '',
  `content` text NOT NULL COMMENT '发送内容',
  `params` text NOT NULL COMMENT '数据参数',
  `status` varchar(32) NOT NULL DEFAULT 'sending' COMMENT '发送状态：sending-发送中；success-发送成功；fail-发送失败',
  `result` text COMMENT '短信结果',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `send_time` int NOT NULL DEFAULT '0' COMMENT '发送时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6699 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='短信发送表';

-- ----------------------------
-- Table structure for saas_sys_poster
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_poster`;
CREATE TABLE `saas_sys_poster` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '海报名称',
  `type` varchar(255) NOT NULL DEFAULT '' COMMENT '海报类型',
  `channel` varchar(255) NOT NULL DEFAULT '' COMMENT '海报支持渠道',
  `value` text COMMENT '配置值json',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 2不启用',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `is_default` int NOT NULL DEFAULT '0' COMMENT '是否默认海报，1：是，0：否',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AVG_ROW_LENGTH=8192 COMMENT='海报表';

-- ----------------------------
-- Table structure for saas_sys_printer
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_printer`;
CREATE TABLE `saas_sys_printer` (
  `printer_id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `printer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '打印机名称',
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '设备品牌（易联云，365，飞鹅）',
  `printer_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '打印机编号',
  `printer_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '打印机秘钥',
  `open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开发者id',
  `apikey` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '开发者密钥',
  `template_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '小票打印模板类型，多个逗号隔开',
  `trigger` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '触发打印时机',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '打印模板数据，json格式',
  `print_width` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '58mm' COMMENT '纸张宽度',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态（0，关闭，1：开启）',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`printer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='小票打印机';

-- ----------------------------
-- Table structure for saas_sys_printer_template
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_printer_template`;
CREATE TABLE `saas_sys_printer_template` (
  `template_id` int unsigned NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `template_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `template_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模板类型',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '模板数据，json格式',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='小票打印模板';

-- ----------------------------
-- Table structure for saas_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_role`;
CREATE TABLE `saas_sys_role` (
  `role_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `role_name` varchar(255) NOT NULL DEFAULT '' COMMENT '角色名称',
  `rules` text COMMENT '角色权限(menus_id)',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '最后修改时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色表';

-- ----------------------------
-- Table structure for saas_sys_schedule
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_schedule`;
CREATE TABLE `saas_sys_schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT '0',
  `addon` varchar(255) NOT NULL DEFAULT '' COMMENT '所属插件',
  `key` varchar(255) NOT NULL DEFAULT '' COMMENT '计划任务模板key',
  `status` int NOT NULL DEFAULT '1' COMMENT '任务状态 是否启用',
  `time` varchar(500) NOT NULL DEFAULT '' COMMENT '任务周期  json结构',
  `count` int NOT NULL DEFAULT '0' COMMENT '执行次数',
  `last_time` int NOT NULL DEFAULT '0' COMMENT '最后执行时间',
  `next_time` int NOT NULL DEFAULT '0' COMMENT '下次执行时间',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统任务';

-- ----------------------------
-- Table structure for saas_sys_schedule_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_schedule_log`;
CREATE TABLE `saas_sys_schedule_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '执行记录id',
  `schedule_id` int NOT NULL DEFAULT '0' COMMENT '任务id',
  `addon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所属插件',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '计划任务模板key',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '计划任务名称',
  `execute_time` int NOT NULL COMMENT '执行时间',
  `execute_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '日志信息',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '执行状态',
  `class` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `job` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='计划任务执行记录';

-- ----------------------------
-- Table structure for saas_sys_upgrade_records
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_upgrade_records`;
CREATE TABLE `saas_sys_upgrade_records` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `upgrade_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '升级标识',
  `app_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '插件标识',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '升级名称',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '升级内容',
  `prev_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '前一版本',
  `current_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '当前版本',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态',
  `fail_reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '失败原因',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `complete_time` int NOT NULL DEFAULT '0' COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='升级记录表';

-- ----------------------------
-- Table structure for saas_sys_user
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_user`;
CREATE TABLE `saas_sys_user` (
  `uid` smallint unsigned NOT NULL AUTO_INCREMENT COMMENT '系统用户ID',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '用户账号',
  `head_img` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '' COMMENT '用户密码',
  `real_name` varchar(16) NOT NULL DEFAULT '' COMMENT '实际姓名',
  `last_ip` varchar(50) NOT NULL DEFAULT '' COMMENT '最后一次登录ip',
  `last_time` int unsigned NOT NULL DEFAULT '0' COMMENT '最后一次登录时间',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `login_count` int unsigned NOT NULL DEFAULT '0' COMMENT '登录次数',
  `status` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '后台管理员状态 1有效0无效',
  `is_del` tinyint unsigned NOT NULL DEFAULT '0',
  `delete_time` tinyint NOT NULL DEFAULT '0' COMMENT '删除时间',
  `update_time` int NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`uid`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='后台管理员表';

-- ----------------------------
-- Table structure for saas_sys_user_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_user_log`;
CREATE TABLE `saas_sys_user_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '管理员操作记录ID',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT '登录IP',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `uid` int unsigned NOT NULL DEFAULT '0' COMMENT '管理员id',
  `username` varchar(64) NOT NULL DEFAULT '' COMMENT '管理员姓名',
  `url` varchar(128) NOT NULL DEFAULT '' COMMENT '链接',
  `params` longtext COMMENT '参数',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '请求方式',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='管理员操作记录表';

-- ----------------------------
-- Table structure for saas_sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `saas_sys_user_role`;
CREATE TABLE `saas_sys_user_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int NOT NULL DEFAULT '0' COMMENT '用户id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `role_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '角色id',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `is_admin` int NOT NULL DEFAULT '0' COMMENT '是否是超级管理员',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态',
  `delete_time` int NOT NULL DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户权限表';

-- ----------------------------
-- Table structure for saas_tkjhkd_brand
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_brand`;
CREATE TABLE `saas_tkjhkd_brand` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `delivery_type` varchar(255) DEFAULT NULL COMMENT '类型',
  `name` varchar(255) DEFAULT NULL COMMENT '名称',
  `logo` varchar(255) DEFAULT NULL COMMENT 'logo',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 0不启用',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '修改时间',
  `addon` varchar(255) DEFAULT NULL COMMENT '所属插件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成表字段信息表';

-- ----------------------------
-- Table structure for saas_tkjhkd_coupon
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_coupon`;
CREATE TABLE `saas_tkjhkd_coupon` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `start_time` int NOT NULL DEFAULT '0' COMMENT '活动开启时间',
  `end_time` int NOT NULL DEFAULT '0' COMMENT '活动结束时间',
  `remain_count` int NOT NULL DEFAULT '0' COMMENT '剩余数量',
  `receive_count` int NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `limit_count` int NOT NULL DEFAULT '0' COMMENT '单个会员限制领取数量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 未开启 3 已无效',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '添加时间',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '商品最低多少金额可用优惠券',
  `type` tinyint NOT NULL DEFAULT '0' COMMENT '优惠券类型 1通用优惠券 2商品品类优惠券 3商品优惠券',
  `receive_type` int NOT NULL DEFAULT '0' COMMENT '领取方式',
  `valid_type` int unsigned NOT NULL DEFAULT '0' COMMENT '有效时间',
  `length` int NOT NULL DEFAULT '0' COMMENT '有效期时长(天)',
  `valid_start_time` int NOT NULL DEFAULT '0' COMMENT '有效期开始时间',
  `valid_end_time` int NOT NULL DEFAULT '0' COMMENT '有效期结束时间',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `receive_status` tinyint NOT NULL DEFAULT '1' COMMENT ' 状态 1 正常 2 关闭',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券表';

-- ----------------------------
-- Table structure for saas_tkjhkd_coupon_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_coupon_member`;
CREATE TABLE `saas_tkjhkd_coupon_member` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '优惠券发放记录id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `coupon_id` int NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `member_id` int NOT NULL DEFAULT '0' COMMENT '会员id',
  `create_time` int unsigned NOT NULL DEFAULT '0' COMMENT '领取时间',
  `expire_time` int unsigned NOT NULL DEFAULT '0' COMMENT '过期时间',
  `use_time` int unsigned NOT NULL DEFAULT '0' COMMENT '使用时间',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '优惠券类型',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '面值',
  `min_condition_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '最低使用门槛',
  `receive_type` varchar(255) NOT NULL DEFAULT '' COMMENT '领取方式',
  `trade_id` int NOT NULL DEFAULT '0' COMMENT '关联业务id',
  PRIMARY KEY (`id`),
  KEY `coupon_id` (`coupon_id`),
  KEY `member_id` (`member_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=328 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券会员领取记录表';

-- ----------------------------
-- Table structure for saas_tkjhkd_fenxiao_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_fenxiao_member`;
CREATE TABLE `saas_tkjhkd_fenxiao_member` (
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `pid` int DEFAULT '0' COMMENT '推荐会员id(分销)',
  `fenxiao_member_id` int DEFAULT '0' COMMENT '会员上级分销商会员id',
  `is_fenxiao` tinyint DEFAULT '0' COMMENT '是否是分销商',
  `bind_time` int DEFAULT '0' COMMENT '绑定时间',
  `create_time` int DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_tkjhkd_fenxiao_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_fenxiao_order`;
CREATE TABLE `saas_tkjhkd_fenxiao_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `order_id` varchar(60) DEFAULT NULL COMMENT '会员id',
  `type` varchar(255) DEFAULT NULL COMMENT '类型',
  `state` int DEFAULT NULL COMMENT '订单状态',
  `first_commission` decimal(10,2) DEFAULT NULL COMMENT '一级佣金',
  `two_commission` decimal(10,2) DEFAULT NULL COMMENT '二级佣金',
  `status` varchar(255) DEFAULT NULL COMMENT '状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=734 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_tkjhkd_help
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_help`;
CREATE TABLE `saas_tkjhkd_help` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `title` varchar(60) DEFAULT NULL COMMENT '问题名称',
  `content` varchar(255) DEFAULT NULL COMMENT '解决方案',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_tkjhkd_notice
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_notice`;
CREATE TABLE `saas_tkjhkd_notice` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `title` varchar(88) DEFAULT NULL COMMENT '标题',
  `image` varchar(255) DEFAULT NULL COMMENT '封面',
  `content` longtext COMMENT '内容',
  `status` int NOT NULL DEFAULT '1' COMMENT '是否启用 1启用 0不启用',
  `create_time` int NOT NULL COMMENT '创建时间',
  `update_time` int NOT NULL COMMENT '修改时间',
  `addon` varchar(88) NOT NULL COMMENT '所属插件',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成表字段信息表';

-- ----------------------------
-- Table structure for saas_tkjhkd_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order`;
CREATE TABLE `saas_tkjhkd_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `member_id` int NOT NULL COMMENT '会员id',
  `order_from` varchar(50) NOT NULL COMMENT '订单来源',
  `order_id` varchar(24) NOT NULL COMMENT '订单id',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  `order_discount_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单优惠金额',
  `pay_money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `is_send` int DEFAULT '0' COMMENT '是否发单1已发单0未发单',
  `is_pick` int DEFAULT '0' COMMENT '是否揽收 1揽收 0未揽收',
  `order_status` int NOT NULL DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `out_trade_no` varchar(32) DEFAULT NULL COMMENT '支付编号',
  `mer_remark` varchar(255) DEFAULT NULL COMMENT '商户备注',
  `remark` varchar(255) DEFAULT NULL COMMENT '订单备注',
  `pay_time` varchar(100) DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_reason` varchar(80) DEFAULT NULL COMMENT '关闭原因',
  `is_enable_refund` varchar(2) DEFAULT NULL COMMENT '是否允许退款',
  `close_time` varchar(110) DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `send_log` varchar(255) DEFAULT NULL COMMENT '发单记录',
  `task_brand` varchar(255) DEFAULT NULL COMMENT '发单渠道',
  `task_type` varchar(255) DEFAULT NULL COMMENT '发单类型',
  `coupon_value` longtext COMMENT '优惠券信息',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`order_from`,`order_id`,`is_send`,`order_status`,`refund_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1644 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单列表';

-- ----------------------------
-- Table structure for saas_tkjhkd_order_add
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order_add`;
CREATE TABLE `saas_tkjhkd_order_add` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `order_id` varchar(44) NOT NULL COMMENT '订单id',
  `order_no` varchar(44) DEFAULT NULL COMMENT '订单no',
  `order_money` decimal(10,2) NOT NULL COMMENT '订单金额',
  `order_status` int DEFAULT '0' COMMENT '订单状态',
  `out_trade_no` varchar(32) DEFAULT NULL COMMENT '支付编号',
  `pay_time` varchar(110) DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_time` varchar(110) DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` varchar(110) DEFAULT '0' COMMENT '删除时间',
  `notice_num` int DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`order_id`,`order_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单列表';

-- ----------------------------
-- Table structure for saas_tkjhkd_order_delivery
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order_delivery`;
CREATE TABLE `saas_tkjhkd_order_delivery` (
  `order_id` varchar(44) NOT NULL DEFAULT '订单id',
  `task_id` varchar(44) NOT NULL DEFAULT '任务id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `order_no` varchar(48) DEFAULT NULL COMMENT '易达订单号',
  `start_address` longtext,
  `end_address` longtext,
  `goods` varchar(60) DEFAULT NULL COMMENT '物品',
  `long` double NOT NULL COMMENT '长',
  `width` double NOT NULL COMMENT '宽',
  `height` double NOT NULL COMMENT '高',
  `weight` double NOT NULL COMMENT '重量',
  `package_count` int DEFAULT NULL COMMENT '包裹数',
  `delivery_id` varchar(40) DEFAULT NULL COMMENT '运送单号',
  `delivery_status` int DEFAULT '1' COMMENT '订单状态',
  `delivery_type` varchar(60) NOT NULL COMMENT '快递公司',
  `bj_price` varchar(10) DEFAULT NULL COMMENT '保价金额',
  `customer_type` varchar(16) NOT NULL COMMENT '寄件通道',
  `delivery_business` varchar(60) NOT NULL COMMENT '产品类型',
  `online_pay` varchar(5) DEFAULT NULL COMMENT '是否在线支付YNALL',
  `start_time` varchar(40) DEFAULT NULL COMMENT '预约开始时间',
  `end_time` varchar(40) DEFAULT NULL COMMENT '预约结束时间',
  `order_status_desc` varchar(60) DEFAULT NULL COMMENT '订单状态描述',
  `order_status` varchar(5) DEFAULT '1' COMMENT '订单状态快递信息状态',
  `courier_context` varchar(500) DEFAULT NULL COMMENT '揽收信息',
  `pay_method` varchar(4) DEFAULT NULL COMMENT '支付方式',
  `remark` varchar(255) DEFAULT NULL COMMENT '订单备注',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` varchar(255) DEFAULT NULL COMMENT '删除时间',
  `channel_id` varchar(255) DEFAULT NULL,
  `price_rule` longtext,
  `original_rule` longtext,
  `platform` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`order_id`(15)) USING BTREE,
  KEY `order_id` (`order_id`,`member_id`,`order_no`,`delivery_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单快递信息表';

-- ----------------------------
-- Table structure for saas_tkjhkd_order_delivery_real
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order_delivery_real`;
CREATE TABLE `saas_tkjhkd_order_delivery_real` (
  `order_id` varchar(44) NOT NULL,
  `weight` double DEFAULT NULL COMMENT '重量',
  `fee_weight` double DEFAULT NULL COMMENT '计费重量',
  `volume` double DEFAULT NULL COMMENT '体积',
  `package_count` int DEFAULT NULL COMMENT '包裹数量',
  `fee_blockList` varchar(1000) DEFAULT NULL COMMENT '费用明细',
  `total_fee` double DEFAULT NULL COMMENT '总费用',
  `pay_fee` double DEFAULT NULL COMMENT '支付费用',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单快递信息表';

-- ----------------------------
-- Table structure for saas_tkjhkd_order_discount
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order_discount`;
CREATE TABLE `saas_tkjhkd_order_discount` (
  `order_id` int NOT NULL,
  `discount_type` varchar(255) DEFAULT NULL COMMENT '优惠类型',
  `money` double DEFAULT NULL COMMENT '优惠金额',
  `coupon_id` int DEFAULT NULL COMMENT '优惠券id',
  `card_id` int DEFAULT NULL COMMENT '会员卡id',
  PRIMARY KEY (`order_id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_tkjhkd_order_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_order_log`;
CREATE TABLE `saas_tkjhkd_order_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL,
  `order_id` varchar(40) NOT NULL COMMENT '订单id',
  `action` varchar(255) NOT NULL COMMENT '操作',
  `main_type` varchar(255) DEFAULT NULL COMMENT '操作身份',
  `main_id` int DEFAULT NULL COMMENT '身份id',
  `nick_name` varchar(255) DEFAULT NULL COMMENT '昵称',
  `order_status` varchar(255) DEFAULT NULL COMMENT '订单状态',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`order_id`,`main_type`(191),`order_status`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8037 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for saas_tkjhkd_shop_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkjhkd_shop_order`;
CREATE TABLE `saas_tkjhkd_shop_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int NOT NULL COMMENT '站点id',
  `order_no` varchar(24) NOT NULL COMMENT '商城订单号',
  `delivery_id` varchar(25) DEFAULT NULL COMMENT '快递单号',
  `yida_order_no` varchar(25) DEFAULT NULL COMMENT '易达订单号',
  `order_status_name` varchar(255) DEFAULT NULL COMMENT '订单状态',
  `is_pick` int DEFAULT NULL COMMENT '是否揽收',
  `is_send` int DEFAULT '0' COMMENT '是否发单1已发单0未发单',
  `real_price` decimal(10,2) DEFAULT NULL COMMENT '实际运费',
  `close_time` int DEFAULT NULL COMMENT '订单关闭时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`order_no`,`is_send`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商城发单';

-- ----------------------------
-- Table structure for saas_tkpartner_card
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_card`;
CREATE TABLE `saas_tkpartner_card` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '关联会员',
  `type` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `card_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '卡密',
  `is_use` int DEFAULT NULL COMMENT '是否使用',
  `status` int DEFAULT NULL COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `level_id` int DEFAULT NULL COMMENT '店主等级',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='卡密列表';

-- ----------------------------
-- Table structure for saas_tkpartner_card_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_card_log`;
CREATE TABLE `saas_tkpartner_card_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `card_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店名',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店主列表';

-- ----------------------------
-- Table structure for saas_tkpartner_commission_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_commission_order`;
CREATE TABLE `saas_tkpartner_commission_order` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `site_id` int NOT NULL DEFAULT '0' COMMENT '站点id',
  `member_id` int unsigned NOT NULL DEFAULT '0' COMMENT '会员id',
  `order_id` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `commission` decimal(10,2) DEFAULT NULL COMMENT '店主分润',
  `profit` decimal(10,2) NOT NULL COMMENT '平台利润',
  `order_money` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单金额',
  `pid` int DEFAULT '0' COMMENT '店主会员ID',
  `status` int DEFAULT '0' COMMENT '状态',
  `is_js` int DEFAULT '0' COMMENT '结算状态',
  `create_time` int NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `m_commission` decimal(10,2) DEFAULT '0.00' COMMENT '会员佣金',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`member_id`,`site_id`,`order_id`,`type`,`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='订单结算';

-- ----------------------------
-- Table structure for saas_tkpartner_help
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_help`;
CREATE TABLE `saas_tkpartner_help` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `cat_id` int DEFAULT NULL COMMENT '分类',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '详情',
  `view_num` int DEFAULT NULL COMMENT '浏览量',
  `sort` int DEFAULT '0' COMMENT '排序',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='帮助中心';

-- ----------------------------
-- Table structure for saas_tkpartner_help_cat
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_help_cat`;
CREATE TABLE `saas_tkpartner_help_cat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `sort` int DEFAULT '0' COMMENT '排序',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='帮助分类';

-- ----------------------------
-- Table structure for saas_tkpartner_level
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_level`;
CREATE TABLE `saas_tkpartner_level` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '等级名称',
  `icon` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '等级图标',
  `rate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '利润分佣比',
  `card` int DEFAULT NULL COMMENT '生成卡密数',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '详情',
  `price` decimal(10,2) DEFAULT NULL COMMENT '价格',
  `condition` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '升级条件',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店主级别列表';

-- ----------------------------
-- Table structure for saas_tkpartner_member
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_member`;
CREATE TABLE `saas_tkpartner_member` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `pid` int DEFAULT NULL COMMENT '店主ID',
  `is_partner` int DEFAULT '0' COMMENT '是否店主',
  `expire_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '到期时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='会员列表';

-- ----------------------------
-- Table structure for saas_tkpartner_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_order`;
CREATE TABLE `saas_tkpartner_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `order_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源',
  `order_id` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id',
  `order_money` decimal(10,2) DEFAULT NULL COMMENT '订单金额',
  `order_discount_money` decimal(10,2) DEFAULT '0.00' COMMENT '订单优惠金额',
  `order_status` int DEFAULT '0' COMMENT '订单状态',
  `refund_status` int DEFAULT '0' COMMENT '退款状态',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `level_id` int DEFAULT NULL COMMENT '等级id',
  `pid` int DEFAULT '0' COMMENT '上级店主',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `out_trade_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付编号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单备注',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `close_reason` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `is_enable_refund` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否允许退款',
  `close_time` int DEFAULT NULL COMMENT '订单关闭时间',
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '会员ip',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`,`order_from`,`order_id`,`order_status`,`refund_status`,`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店主开通订单';

-- ----------------------------
-- Table structure for saas_tkpartner_partner
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_partner`;
CREATE TABLE `saas_tkpartner_partner` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `member_id` int DEFAULT NULL COMMENT '会员id',
  `level_id` int DEFAULT NULL COMMENT '等级',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '密码',
  `weapp_openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '小程序openid',
  `wechat_openid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '公众号openid',
  `union_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '统一账户',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '店名',
  `logo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'logo',
  `banner` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '招牌',
  `pid` int DEFAULT NULL COMMENT '上级店长',
  `card` int DEFAULT NULL COMMENT '生成卡密数',
  `status` int DEFAULT NULL COMMENT '状态',
  `share_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邀请码',
  `expire_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '到期时间',
  `login_time` int DEFAULT NULL COMMENT '上次登录时间',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '上次登录ip',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `is_open_commission` int DEFAULT '0' COMMENT '是否开启佣金',
  `rate` decimal(10,2) DEFAULT '0.00' COMMENT '佣金比例',
  `contact_qrcode` varchar(800) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '联系二维码',
  `phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '联系电话',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`,`member_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='店主列表';

-- ----------------------------
-- Table structure for saas_tkpartner_qrcode
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkpartner_qrcode`;
CREATE TABLE `saas_tkpartner_qrcode` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `level_id` int DEFAULT NULL COMMENT '等级',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `code` varchar(255) DEFAULT NULL COMMENT '码值',
  `weapp_qrcode` varchar(500) DEFAULT NULL COMMENT '微信小程序二维码',
  `h5_qrcode` varchar(500) DEFAULT NULL COMMENT '网页链接',
  `page` varchar(500) DEFAULT NULL COMMENT '跳转页面',
  `expire_time` varchar(255) DEFAULT NULL COMMENT '到期时间',
  `is_bind` int DEFAULT NULL COMMENT '是否绑定',
  `is_export` int DEFAULT NULL COMMENT '是否导出',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`,`site_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=684 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='空码列表';

-- ----------------------------
-- Table structure for saas_tkvip_order
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkvip_order`;
CREATE TABLE `saas_tkvip_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '系统用户ID',
  `site_id` int DEFAULT NULL COMMENT '站点id',
  `member_id` int DEFAULT NULL COMMENT '用户id',
  `order_from` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单来源',
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '订单id',
  `body` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容',
  `sku_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'sku信息',
  `level_id` int DEFAULT NULL COMMENT '会员等级',
  `sku_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'SKUID',
  `day` int DEFAULT NULL COMMENT '天数',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `out_trade_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '支付单号',
  `order_money` decimal(10,2) DEFAULT NULL COMMENT '订单金额',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `close_time` int DEFAULT NULL COMMENT '关闭时间',
  `close_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关闭原因',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `refund_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '退款状态',
  `create_time` int unsigned DEFAULT '0' COMMENT '添加时间',
  `update_time` int DEFAULT '0' COMMENT '更新时间',
  `delete_time` int DEFAULT '0' COMMENT '删除时间',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `over_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '到期时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='VIP订单';

-- ----------------------------
-- Table structure for saas_tkvip_real
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkvip_real`;
CREATE TABLE `saas_tkvip_real` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '实名',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `card_num` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证',
  `card_img_back` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证背面',
  `card_img_front` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '身份证正面',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '性别',
  `birthday` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '生日',
  `field` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '字段',
  `status` int DEFAULT NULL COMMENT '认证状态',
  `over_time` int DEFAULT NULL COMMENT '到期时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='实名列表';

-- ----------------------------
-- Table structure for saas_tkvip_vip
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkvip_vip`;
CREATE TABLE `saas_tkvip_vip` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '流水id',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `level_id` int DEFAULT NULL COMMENT '等级ID',
  `over_time` int DEFAULT NULL COMMENT '结束时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4209 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='会员VIP管理';

-- ----------------------------
-- Table structure for saas_tkvip_vip_log
-- ----------------------------
DROP TABLE IF EXISTS `saas_tkvip_vip_log`;
CREATE TABLE `saas_tkvip_vip_log` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '流水id',
  `site_id` int DEFAULT NULL COMMENT '站点ID',
  `member_id` int DEFAULT NULL COMMENT '会员ID',
  `level_id` int DEFAULT NULL COMMENT '等级ID',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `body` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容',
  `over_time` int DEFAULT NULL COMMENT '结束时间',
  `update_time` int DEFAULT NULL COMMENT '更新时间',
  `create_time` int DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=571 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='会员日志';

SET FOREIGN_KEY_CHECKS = 1;

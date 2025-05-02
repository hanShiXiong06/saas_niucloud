CREATE TABLE IF NOT EXISTS `{{prefix}}addon`  (
`id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
`title` varchar(40) NOT NULL COMMENT '插件名称',
`icon` varchar(255) NOT NULL COMMENT '插件图标',
`key` varchar(20) NOT NULL COMMENT '插件标识',
`desc` text COMMENT '插件描述',
`status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
`author` varchar(40) NOT NULL COMMENT '作者',
`version` varchar(20) NOT NULL COMMENT '版本号',
`create_time` int(11) NOT NULL COMMENT '创建时间',
`install_time` int(11) NOT NULL COMMENT '安装时间',
`update_time` int(11) NOT NULL COMMENT '更新时间',
`cover` varchar(255) NOT NULL COMMENT '封面',
`type` varchar(255) NOT NULL DEFAULT 'app' COMMENT '插件类型app，addon',
`support_app` varchar(255) NOT NULL COMMENT '插件支持的应用空表示通用插件',
`is_star` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否加星',
`compile` varchar(2000) NOT NULL COMMENT '编译端口',
PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 220 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成表字段信息表' ROW_FORMAT = Dynamic;
INSERT INTO `{{prefix}}addon` VALUES ('1','智能对话','addon/ai_chat/icon.png','ai_chat','智能对话AI助理插件','1','','0.1.6','1716599718','1716599718','1718618098','','addon','tk_ai','1','');
INSERT INTO `{{prefix}}addon` VALUES ('2','AI音乐','addon/ai_music/icon.png','ai_music','','1','','0.0.1','1716599749','1716599749','1716599749','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('3','商城系统','addon/shop/icon.png','shop','实物虚拟商品，订单，物流同城配送，门店自提','1','','1.2.1','1716599809','1716599809','1718613885','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('4','分销','addon/shop_fenxiao/icon.png','shop_fenxiao','商城分销插件','1','','1.1.3','1716600128','1716600128','1716600128','','addon','shop','1','');
INSERT INTO `{{prefix}}addon` VALUES ('6','聚合快递','addon/tk_jhkd/icon.png','tk_jhkd','全网快递一件比价','1','TK','1.2.9','1716600481','1716600481','1718617951','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('7','一号通','addon/tk_yht/icon.png','tk_yht','一号通API接口接入','1','','1.2.3','1716600626','1716600626','1718617986','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('8','AI助理','addon/tk_ai/icon.png','tk_ai','多驱动多场景智能对话，多类驱动字典集成','1','','0.3.1','1716726467','1716726467','1716726467','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('9','CPS联盟','addon/tk_cps/icon.png','tk_cps','实时100多种活动转链，后台活动细节展示，支持小程序、H5、半屏小程序等推广打开','1','','1.5.2','1716726801','1716726801','1718618034','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('10','TK工具','addon/tk_devtool/icon.png','tk_devtool','便捷工具打包','1','','1.0.1','1716858006','1716858006','1716858006','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('11','业务管理','addon/tk_business/icon.png','tk_business','','1','','0.0.1','1716890952','1716890952','1716890952','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('12','旅游系统','addon/tourism/icon.png','tourism','旅游系统','1','','1.1.0','1716891838','1716891838','1716891838','','app','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('13','业务代理插件','addon/business_agent/icon.png','business_agent','业务管理代理插件','1','','0.0.1','1716941842','1716941842','1716941842','','addon','tk_business','1','');
INSERT INTO `{{prefix}}addon` VALUES ('14','附加属性--旅游系统插件','addon/tourism_sku/icon.png','tourism_sku','','1','','1.0.0','1717081754','1717081754','1717081754','','addon','tourism','1','');
INSERT INTO `{{prefix}}addon` VALUES ('15','123云盘存储','addon/tk_pan/icon.png','tk_pan','123云盘存储空间','1','','0.0.4','1717285252','1717285252','1717285252','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('16','日历插件','addon/tk_day/icon.png','tk_day','','1','','0.0.3','1717287049','1717287049','1718618137','','addon','shop','1','');
INSERT INTO `{{prefix}}addon` VALUES ('17','出票通知插件','addon/tourism_tick/icon.png','tourism_tick','','1','','0.0.4','1718683980','1718683980','1718683980','','addon','tourism','1','');
INSERT INTO `{{prefix}}addon` VALUES ('18','助通三方短信','addon/zt_sms/icon.png','zt_sms','','1','','0.0.2','1718698509','1718698509','1718698509','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('19','千二支付申请插件','addon/business_pay/icon.png','business_pay','','1','','0.0.1','1718702680','1718702680','1718702680','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('20','商品导入导出','addon/spdr/icon.png','spdr','','1','','0.0.1','1718947987','1718947987','1718947987','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('21','消息通知','addon/tk_notice/icon.png','tk_notice','','1','','0.0.1','1719246673','1719246673','1719246673','','addon','','1','');
INSERT INTO `{{prefix}}addon` VALUES ('22','card','addon/card/icon.png','card','','1','','0.0.1','1720260719','1720260719','1720260719','','app','','1','');

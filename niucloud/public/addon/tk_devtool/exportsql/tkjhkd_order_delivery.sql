CREATE TABLE IF NOT EXISTS `{{prefix}}tkjhkd_order_delivery`  (
`order_id` varchar(44) NOT NULL DEFAULT '订单id' COMMENT '',
`task_id` varchar(44) NOT NULL DEFAULT '任务id' COMMENT '',
`member_id` int COMMENT '会员id',
`order_no` varchar(48) COMMENT '易达订单号',
`start_address` varchar(500) NOT NULL COMMENT '开始地址',
`end_address` varchar(500) NOT NULL COMMENT '结束地址',
`goods` varchar(60) COMMENT '物品',
`long` double NOT NULL COMMENT '长',
`width` double NOT NULL COMMENT '宽',
`height` double NOT NULL COMMENT '高',
`weight` double NOT NULL COMMENT '重量',
`package_count` int COMMENT '包裹数',
`delivery_id` varchar(40) COMMENT '运送单号',
`delivery_status` int DEFAULT '1' COMMENT '订单状态',
`delivery_type` varchar(60) NOT NULL COMMENT '快递公司',
`bj_price` varchar(10) COMMENT '保价金额',
`customer_type` varchar(16) NOT NULL COMMENT '寄件通道',
`delivery_business` varchar(60) NOT NULL COMMENT '产品类型',
`online_pay` varchar(5) COMMENT '是否在线支付YNALL',
`start_time` varchar(40) COMMENT '预约开始时间',
`end_time` varchar(40) COMMENT '预约结束时间',
`order_status_desc` varchar(60) COMMENT '订单状态描述',
`order_status` varchar(5) DEFAULT '1' COMMENT '订单状态快递信息状态',
`courier_context` varchar(500) COMMENT '揽收信息',
`pay_method` varchar(4) COMMENT '支付方式',
`remark` varchar(255) COMMENT '订单备注',
`create_time` int COMMENT '创建时间',
`update_time` int COMMENT '更新时间',
`delete_time` int COMMENT '删除时间',
`channel_id` varchar(255) COMMENT '渠道id',
PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 220 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成表字段信息表' ROW_FORMAT = Dynamic;
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432534265552896','任务id','1','CN240507130627812173','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":1,\"member_id\":1,\"site_id\":100000,\"name\":\"TK\",\"mobile\":\"13545454545\",\"province_id\":530000,\"city_id\":530100,\"district_id\":530102,\"address\":\"\\u4e91\\u5357\\u7701-\\u6606\\u660e\\u5e02-\\u4e94\\u534e\\u533a\",\"address_name\":\"\",\"full_address\":\"\\u94c2\\u91d1\\u5927\\u9053\\u7684\\u6d4b\\u8bd5\\u5730\\u5740\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','普货','10','10','10','1','1','JT3073714090142','1','CAINIAO','','kd','CAINIAO_BK','Y',NULL,NULL,NULL,'1',NULL,'10','','1715058385','1715058388',NULL,'10252');
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432535065210880','任务id','1',NULL,'{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":1,\"member_id\":1,\"site_id\":100000,\"name\":\"TK\",\"mobile\":\"13545454545\",\"province_id\":530000,\"city_id\":530100,\"district_id\":530102,\"address\":\"\\u4e91\\u5357\\u7701-\\u6606\\u660e\\u5e02-\\u4e94\\u534e\\u533a\",\"address_name\":\"\",\"full_address\":\"\\u94c2\\u91d1\\u5927\\u9053\\u7684\\u6d4b\\u8bd5\\u5730\\u5740\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','零食特产','10','10','10','1','1',NULL,'1','CAINIAO','','kd','CAINIAO_BK','Y',NULL,NULL,NULL,'1',NULL,'10','','1715058581','1715058581',NULL,'10252');
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432536687624192','任务id','1',NULL,'{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','美妆用品','10','10','10','1','1',NULL,'1','CAINIAO','','kd','CAINIAO_BK','Y',NULL,NULL,NULL,'1',NULL,'10','','1715058977','1715058977',NULL,'10252');
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432538409050112','任务id','1',NULL,'{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','普货','10','10','10','1','1',NULL,'1','EMS','','kd','EMS_TKZD','Y',NULL,NULL,NULL,'1',NULL,'10','','1715059397','1715059397',NULL,'10247');
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432586232446976','任务id','1','YYST294655902808175722','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','普货','10','10','10','1','1','772026888000195','1','申通','','kd','4','Y',NULL,NULL,NULL,'1',NULL,'10','','1715071073','1715071163',NULL,'1663388839974146048');
INSERT INTO `{{prefix}}tkjhkd_order_delivery` VALUES ('20240507432603196354560','任务id','1','XD202405071746594234','{\"id\":1,\"member_id\":1,\"site_id\":100000,\"name\":\"TK\",\"mobile\":\"13545454545\",\"province_id\":530000,\"city_id\":530100,\"district_id\":530102,\"address\":\"\\u4e91\\u5357\\u7701-\\u6606\\u660e\\u5e02-\\u4e94\\u534e\\u533a\",\"address_name\":\"\",\"full_address\":\"\\u94c2\\u91d1\\u5927\\u9053\\u7684\\u6d4b\\u8bd5\\u5730\\u5740\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','{\"id\":2,\"member_id\":1,\"site_id\":100000,\"name\":\"dool\",\"mobile\":\"13545454545\",\"province_id\":510000,\"city_id\":511600,\"district_id\":511623,\"address\":\"\\u56db\\u5ddd\\u7701-\\u5e7f\\u5b89\\u5e02-\\u90bb\\u6c34\\u53bf\",\"address_name\":\"\",\"full_address\":\"dd\",\"lng\":\"\",\"lat\":\"\",\"is_default\":0,\"type\":\"address\"}','普货','10','10','10','1','1','73522963662521','1','中通','','kd','中通','Y',NULL,NULL,NULL,'1',NULL,'10','','1715075214','1715075219',NULL,'XinDa2370186954');

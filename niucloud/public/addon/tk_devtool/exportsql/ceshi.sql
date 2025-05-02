CREATE TABLE IF NOT EXISTS `{{prefix}}ceshi`  (
`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '',
`name` varchar(13) COMMENT '默认描述',
PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 220 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成表字段信息表' ROW_FORMAT = Dynamic;

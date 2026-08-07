CREATE TABLE `routes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `obj_type` tinyint(3) unsigned NOT NULL COMMENT '0=ship,1=fleet',
  `obj_id` int(10) unsigned NOT NULL,
  `seq` smallint(5) unsigned NOT NULL,
  `dest_type` tinyint(3) unsigned NOT NULL COMMENT '7=star,8=coords',
  `dest_id` int(10) unsigned NOT NULL DEFAULT '0',
  `arg1` int(11) DEFAULT NULL,
  `arg2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_obj_seq` (`obj_type`,`obj_id`,`seq`),
  KEY `by_obj` (`obj_type`,`obj_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

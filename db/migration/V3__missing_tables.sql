-- Tables referenced by www_new PHP but missing from 2012 dump
SET NAMES utf8;

CREATE TABLE IF NOT EXISTS `aliance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` longtext NOT NULL,
  `book_id` int(10) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `multiply` int(10) unsigned NOT NULL DEFAULT '1',
  `own` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_name` (`name`),
  KEY `by_own` (`own`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `aliance_in` (
  `aliance` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`aliance`, `user_id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `market` (
  `object_id` int(10) unsigned NOT NULL,
  `buy_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `sell_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `avg_price` float(12,2) NOT NULL DEFAULT '0.00',
  `day_buy` int(10) unsigned NOT NULL DEFAULT '0',
  `day_sell` int(10) unsigned NOT NULL DEFAULT '0',
  `min_count` int(10) unsigned NOT NULL DEFAULT '100',
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `market_events` (
  `user_id` int(10) unsigned NOT NULL,
  `summ` float(12,2) NOT NULL DEFAULT '0.00',
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `tituls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_object` (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `medals_type` (
  `object_id` int(10) unsigned NOT NULL,
  `book_id` int(10) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `img` varchar(64) NOT NULL DEFAULT '',
  `status` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users_medal` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `user_desc` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `planets_maps` (
  `id` int(10) unsigned NOT NULL,
  `top` longtext NOT NULL,
  `mdl` longtext NOT NULL,
  `btm` longtext NOT NULL,
  `fnd` longtext NOT NULL,
  `bld` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `orbits_map` (
  `id` int(10) unsigned NOT NULL,
  `lin` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `planets_active` (
  `id` int(10) unsigned NOT NULL,
  `last_pos` varchar(45) DEFAULT NULL,
  `last_orb` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ships_war` LIKE `ships`;

CREATE TABLE IF NOT EXISTS `war_places` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place` varchar(64) NOT NULL,
  `fleet_id` int(10) unsigned NOT NULL DEFAULT '0',
  `date_start` datetime DEFAULT NULL,
  `sent` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_place` (`place`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `war_test` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `u2u_quests` (
  `event_id` int(11) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `to_user` int(10) unsigned NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `summ` float(12,2) NOT NULL DEFAULT '0.00',
  `currency` int(11) NOT NULL DEFAULT '0',
  `time_long` int(11) NOT NULL DEFAULT '0',
  `visibility` int(11) NOT NULL DEFAULT '0',
  `public_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_start` datetime DEFAULT NULL,
  `arg0` varchar(128) DEFAULT NULL,
  `arg1` varchar(128) DEFAULT NULL,
  `arg2` varchar(128) DEFAULT NULL,
  `arg3` varchar(128) DEFAULT NULL,
  `arg4` varchar(128) DEFAULT NULL,
  `arg5` varchar(128) DEFAULT NULL,
  `arg6` varchar(128) DEFAULT NULL,
  `arg7` varchar(128) DEFAULT NULL,
  `arg8` varchar(128) DEFAULT NULL,
  `arg9` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `u2u_types` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `titul` int(10) unsigned NOT NULL DEFAULT '0',
  `type0` int(11) NOT NULL DEFAULT '0',
  `type1` int(11) NOT NULL DEFAULT '0',
  `type2` int(11) NOT NULL DEFAULT '0',
  `type3` int(11) NOT NULL DEFAULT '0',
  `type4` int(11) NOT NULL DEFAULT '0',
  `type5` int(11) NOT NULL DEFAULT '0',
  `type6` int(11) NOT NULL DEFAULT '0',
  `type7` int(11) NOT NULL DEFAULT '0',
  `type8` int(11) NOT NULL DEFAULT '0',
  `type9` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users_report` (
  `user_id` int(10) unsigned NOT NULL,
  `msg_date` datetime NOT NULL,
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `message` longtext NOT NULL,
  KEY `by_user_date` (`user_id`, `msg_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `promo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `interval` int(10) unsigned NOT NULL DEFAULT '60',
  PRIMARY KEY (`id`),
  KEY `by_time` (`time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `warequest` (
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `quest_id` int(11) NOT NULL,
  KEY `by_quest` (`quest_id`),
  KEY `by_place` (`place_id`, `place_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `messages` (
  `hash` varchar(64) NOT NULL,
  `ru` longtext NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `halloffame` (
  `user_id` int(10) unsigned NOT NULL,
  `login` varchar(45) NOT NULL,
  `top_a` bigint(16) NOT NULL DEFAULT '0',
  `top_p` bigint(16) NOT NULL DEFAULT '0',
  `top_m` bigint(16) NOT NULL DEFAULT '0',
  `top_f` bigint(16) NOT NULL DEFAULT '0',
  `top_t` bigint(16) NOT NULL DEFAULT '0',
  `top_q` bigint(16) NOT NULL DEFAULT '0',
  `top_r` bigint(16) NOT NULL DEFAULT '0',
  `top_s` bigint(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hot_way` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `id_from` int(10) unsigned NOT NULL,
  `from_arg1` int(11) DEFAULT NULL,
  `from_arg2` int(11) DEFAULT NULL,
  `id_to` int(10) unsigned NOT NULL,
  `to_arg1` int(11) DEFAULT NULL,
  `to_arg2` int(11) DEFAULT NULL,
  `event_time` datetime NOT NULL,
  `len` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_user` (`user_id`),
  KEY `by_time` (`event_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `trash` (
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `arg1` int(11) DEFAULT NULL,
  `arg2` int(11) DEFAULT NULL,
  `lost_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `by_place_object` (`place_type`, `place_id`, `object_id`, `arg1`, `arg2`),
  KEY `by_lost_date` (`lost_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `drones` (
  `ship_id` int(10) unsigned NOT NULL,
  `from_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ship_id`),
  KEY `by_from` (`from_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `chat_ignore` (
  `user_id` int(10) unsigned NOT NULL,
  `ignore_user` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`, `ignore_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `academy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `book_id` int(10) unsigned NOT NULL DEFAULT '0',
  `multiply` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `academy_build` (
  `build_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`build_id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `bot_analyze` (
  `user_id` int(10) unsigned NOT NULL,
  `clone_id` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`, `clone_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `full_log` (
  `uid` int(10) unsigned NOT NULL,
  `line` longtext NOT NULL,
  `log_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `by_uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hyper_hint` (
  `user_id` int(10) unsigned NOT NULL,
  `aliance` int(10) unsigned NOT NULL DEFAULT '0',
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `text` longtext NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  KEY `by_user` (`user_id`),
  KEY `by_coords` (`x`, `y`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `interupt_msg` (
  `type` int(10) unsigned NOT NULL,
  `ship_id` int(10) unsigned NOT NULL,
  `message` longtext NOT NULL,
  KEY `by_ship` (`type`, `ship_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `pilot_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ship_id` int(10) unsigned NOT NULL,
  `isfleet` int(10) unsigned NOT NULL DEFAULT '0',
  `programm` longtext NOT NULL,
  `step` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `status` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `by_status_time` (`status`, `event_time`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `city_ads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `ca_prx` varchar(64) NOT NULL DEFAULT '',
  `ca_click_id` varchar(64) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  `log_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `by_log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

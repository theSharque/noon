-- Noon V1: structure
SET NAMES utf8;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `2pay_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `command` varchar(10) NOT NULL DEFAULT 'error',
  `full_output` varchar(1024) DEFAULT NULL,
  `2pay_id` varchar(100) NOT NULL DEFAULT 'no_id',
  `full_input` varchar(2048) NOT NULL DEFAULT 'empty',
  PRIMARY KEY (`id`),
  KEY `2pay_id` (`2pay_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `2pay_pays` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `2pay_id` varchar(100) NOT NULL,
  `output` varchar(1024) NOT NULL DEFAULT 'error',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `2pay_id` (`2pay_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `aliance` (
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

CREATE TABLE `aliance_in` (
  `aliance` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`aliance`,`user_id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `antibot` (
  `user_id` int(10) unsigned NOT NULL,
  `coord` int(10) unsigned NOT NULL DEFAULT '0',
  `last` int(10) unsigned NOT NULL,
  `up` int(10) unsigned NOT NULL,
  PRIMARY KEY (`coord`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `bay_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(10) unsigned NOT NULL,
  `log_text` longtext NOT NULL,
  `conf` int(11) NOT NULL DEFAULT '0',
  `summ` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `log_time` (`log_time`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `books` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(500) NOT NULL,
  `price` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned DEFAULT NULL,
  `parent_level` int(10) unsigned DEFAULT NULL,
  `teach_time` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `books_teach` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `book_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bt_index` (`user_id`,`end_time`),
  UNIQUE KEY `by_book_user` (`book_id`,`user_id`),
  KEY `by_time` (`end_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `bot_analyze` (
  `user_id` int(10) unsigned NOT NULL,
  `clone_id` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`,`clone_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `bot_in` (
  `word` varchar(16) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT '0',
  `out_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`word`,`out_id`),
  KEY `by_out_id` (`out_id`),
  KEY `weight` (`weight`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `bot_out` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` varchar(1400) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_type` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '0-orbit, 1-planet',
  `desc` varchar(450) NOT NULL,
  `energy` int(10) NOT NULL,
  `warehouse` int(10) unsigned NOT NULL,
  `map_char` varchar(1) NOT NULL,
  `req_id` int(10) unsigned DEFAULT NULL,
  `native` int(10) unsigned NOT NULL DEFAULT '0',
  `shield` int(10) unsigned NOT NULL DEFAULT '0',
  `atack` int(10) unsigned NOT NULL DEFAULT '0',
  `w_type` int(10) unsigned NOT NULL DEFAULT '0',
  `pic` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_char` (`map_char`),
  UNIQUE KEY `by_id_warehouse` (`id`,`warehouse`),
  UNIQUE KEY `by_id_energy` (`id`,`energy`),
  UNIQUE KEY `by_id_shield` (`id`,`shield`),
  UNIQUE KEY `by_id_atack` (`id`,`atack`),
  KEY `native` (`native`),
  KEY `by_shield` (`shield`),
  KEY `by_atack` (`atack`),
  KEY `by_place_type` (`place_type`),
  KEY `by_place_type_id` (`place_type`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `chat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `to_user` int(10) unsigned DEFAULT NULL,
  `msgtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `text` varchar(1400) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `from_to` (`to_user`,`user_id`),
  KEY `by_msgtime` (`msgtime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `chat_ignore` (
  `user_id` int(10) unsigned NOT NULL,
  `ignore_user` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`ignore_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `city_ads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `ca_prx` varchar(64) NOT NULL DEFAULT '',
  `ca_click_id` varchar(64) NOT NULL DEFAULT '',
  `data` longtext NOT NULL,
  `log_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `by_log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(24) NOT NULL,
  `function` varchar(24) NOT NULL,
  `laststart` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `period` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `laststart` (`laststart`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `defence` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `place_and_type` (`place_id`,`place_type`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `drones` (
  `ship_id` int(10) unsigned NOT NULL,
  `from_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ship_id`),
  KEY `by_from` (`from_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `enciclopedia` (
  `object_id` int(11) NOT NULL AUTO_INCREMENT,
  `desc` longtext NOT NULL,
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `fleets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cargo` int(10) unsigned NOT NULL,
  `w_power` int(10) unsigned NOT NULL,
  `w_count` int(10) unsigned NOT NULL,
  `agrav` int(10) unsigned NOT NULL,
  `planet` int(10) unsigned NOT NULL,
  `hyper` int(10) unsigned NOT NULL,
  `mass` int(10) unsigned NOT NULL,
  `shield` int(11) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `arg1` int(10) DEFAULT NULL,
  `arg2` int(10) DEFAULT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship, 3-station, 5-in fly, 7-system point, 8-galaxy point',
  `name` varchar(45) NOT NULL,
  `group` varchar(32) NOT NULL,
  `planet_cnt` int(10) unsigned NOT NULL,
  `hyper_cnt` int(10) unsigned NOT NULL,
  `radar` int(1) unsigned NOT NULL DEFAULT '0',
  `remote` int(1) unsigned NOT NULL DEFAULT '0',
  `inwar` int(10) unsigned NOT NULL DEFAULT '0',
  `guard` int(10) unsigned NOT NULL DEFAULT '0',
  `interupt` int(1) unsigned NOT NULL DEFAULT '0',
  `cloak` int(10) unsigned NOT NULL DEFAULT '0',
  `abordage` int(10) unsigned NOT NULL DEFAULT '1',
  `corsar` int(10) unsigned NOT NULL DEFAULT '0',
  `harvest` int(10) unsigned NOT NULL DEFAULT '0',
  `hot` int(10) unsigned NOT NULL DEFAULT '0',
  `titul` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_user` (`user_id`),
  KEY `by_inwar` (`inwar`),
  KEY `by_radar` (`radar`),
  KEY `by_places` (`place_type`,`place_id`),
  KEY `by_guard` (`guard`),
  KEY `by_interupt` (`interupt`),
  KEY `by_cloack` (`cloak`),
  KEY `group` (`user_id`,`group`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `foe` (
  `user_id` int(10) unsigned NOT NULL,
  `foe_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`foe_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `friend` (
  `user_id` int(10) unsigned NOT NULL,
  `friend_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`friend_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `full_log` (
  `uid` int(10) unsigned NOT NULL,
  `line` longtext NOT NULL,
  `log_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `by_uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `halloffame` (
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

CREATE TABLE `hints` (
  `tid` varchar(250) NOT NULL,
  `text` mediumtext NOT NULL,
  UNIQUE KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `history_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `credits` float(12,2) NOT NULL,
  `credits_all` float(12,2) NOT NULL DEFAULT '0.00',
  `confederates` int(11) NOT NULL,
  `confederates_all` int(11) NOT NULL DEFAULT '0',
  `users` int(11) NOT NULL,
  `users_all` int(11) NOT NULL DEFAULT '0',
  `online` int(11) NOT NULL DEFAULT '0',
  `stars` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `hot_way` (
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

CREATE TABLE `hyper_hint` (
  `user_id` int(10) unsigned NOT NULL,
  `aliance` int(10) unsigned NOT NULL DEFAULT '0',
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `text` longtext NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  KEY `by_user` (`user_id`),
  KEY `by_aliance` (`aliance`),
  KEY `by_coords` (`x`,`y`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `implants` (
  `object_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  PRIMARY KEY (`object_id`),
  KEY `book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `info_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(10) unsigned NOT NULL,
  `title` longtext NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `interupt_msg` (
  `type` int(10) unsigned NOT NULL,
  `ship_id` int(10) unsigned NOT NULL,
  `message` longtext NOT NULL,
  KEY `by_ship` (`type`,`ship_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `market` (
  `object_id` int(10) unsigned NOT NULL,
  `buy_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `sell_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `avg_price` float(12,2) NOT NULL DEFAULT '0.00',
  `day_buy` int(10) unsigned NOT NULL DEFAULT '0',
  `day_sell` int(10) unsigned NOT NULL DEFAULT '0',
  `min_count` int(10) unsigned NOT NULL DEFAULT '100',
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `market_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `summ` float(12,2) NOT NULL DEFAULT '0.00',
  `bay_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `by_user` (`user_id`),
  KEY `by_bay_date` (`bay_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `medals_type` (
  `object_id` int(10) unsigned NOT NULL,
  `book_id` int(10) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `img` varchar(64) NOT NULL DEFAULT '',
  `status` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `messages` (
  `hash` varchar(64) NOT NULL,
  `ru` longtext NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `missile_types` (
  `object_id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL,
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `power` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`),
  KEY `type` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `min_cnt` int(10) unsigned NOT NULL,
  `mass` int(10) unsigned NOT NULL,
  `class` int(10) unsigned NOT NULL,
  `price` float(12,2) NOT NULL DEFAULT '0.00',
  `premium` float(12,2) NOT NULL,
  `cprice` int(11) NOT NULL DEFAULT '0',
  `weight` int(10) unsigned NOT NULL,
  `make_time` int(10) unsigned NOT NULL DEFAULT '0',
  `myprice` float(11,2) NOT NULL DEFAULT '0.00',
  `minprice` float(12,2) NOT NULL DEFAULT '0.00',
  `soldable` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_weight` (`weight`),
  KEY `classification` (`class`),
  KEY `by_name` (`name`),
  KEY `by_class_name` (`class`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `objects_sub` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fuse` (`object_id`,`res_id`),
  KEY `by_res` (`res_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orbit_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `timer` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_planet_coord` (`planet_id`,`x`),
  KEY `by_time` (`event_time`),
  KEY `event4group` (`event_type`,`x`),
  KEY `by_user_time` (`user_id`,`event_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orbits_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL DEFAULT '1',
  `shield` int(10) unsigned NOT NULL DEFAULT '0',
  `last_id` int(10) unsigned NOT NULL DEFAULT '0',
  `last_cyc` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_planet_x` (`planet_id`,`x`),
  KEY `by_object` (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orbits_make` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `cycle` int(10) NOT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orbits_map` (
  `id` int(10) unsigned NOT NULL,
  `lin` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `orbits_mines` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `cycle` int(10) NOT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `pay_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(10) unsigned NOT NULL,
  `mess` longtext NOT NULL,
  `trade_id` int(10) unsigned DEFAULT NULL,
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `log_time` (`log_time`,`user_id`),
  KEY `by_trade_id` (`trade_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `pilot_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ship_id` int(10) unsigned NOT NULL,
  `isfleet` int(10) unsigned NOT NULL DEFAULT '0',
  `programm` longtext NOT NULL,
  `step` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `status` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `by_status_time` (`status`,`event_time`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `place_name` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planet_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` int(10) NOT NULL,
  `y` int(10) NOT NULL,
  `planet_id` int(10) NOT NULL,
  `object_id` int(10) NOT NULL,
  `event_time` datetime NOT NULL,
  `event_type` int(10) unsigned NOT NULL COMMENT '1-build, 2-mine, 3-dispence, 4-upgrade, 5-make, 6-lab',
  `timer` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_planet_coord` (`planet_id`,`x`,`y`),
  KEY `by_time` (`event_time`),
  KEY `event4group` (`event_type`,`x`,`y`),
  KEY `by_coord` (`x`,`y`),
  KEY `by_user_time` (`user_id`,`event_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planet_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `planet_user` int(11) DEFAULT NULL,
  `orbit_user` int(11) DEFAULT NULL,
  `planet_time` datetime NOT NULL,
  `orbit_time` datetime NOT NULL,
  `last_pos` varchar(45) DEFAULT NULL,
  `last_orb` int(10) unsigned DEFAULT NULL,
  `star_id` int(10) unsigned NOT NULL,
  `planet_pos` int(10) unsigned NOT NULL,
  `rad` int(10) unsigned NOT NULL,
  `orb` int(10) unsigned NOT NULL,
  `cycles` int(11) NOT NULL DEFAULT '-1',
  `last_build` int(10) unsigned NOT NULL DEFAULT '0',
  `occuped` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_user` (`user_id`),
  KEY `by_star` (`star_id`),
  KEY `by_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_active` (
  `id` int(10) unsigned NOT NULL,
  `last_pos` varchar(45) DEFAULT NULL,
  `last_orb` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL DEFAULT '1',
  `shield` int(10) unsigned NOT NULL DEFAULT '0',
  `last_id` int(11) NOT NULL DEFAULT '0',
  `last_cyc` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_x_y` (`planet_id`,`x`,`y`),
  KEY `by_planets_objects` (`planet_id`,`object_id`),
  KEY `for_upgrade` (`planet_id`,`level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_disp` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_make` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `cycle` int(10) NOT NULL DEFAULT '1',
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_maps` (
  `id` int(10) unsigned NOT NULL,
  `top` longtext NOT NULL,
  `mdl` longtext NOT NULL,
  `btm` longtext NOT NULL,
  `fnd` longtext NOT NULL,
  `bld` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `planets_mines` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `cycle` int(10) NOT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `promo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `interval` int(10) unsigned NOT NULL DEFAULT '60',
  PRIMARY KEY (`id`),
  KEY `by_time` (`time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `quest_types` (
  `type` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `desc` longtext NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `cnt` int(11) NOT NULL DEFAULT '1',
  `arg0` varchar(256) NOT NULL DEFAULT 'null',
  `arg1` varchar(256) NOT NULL DEFAULT 'null',
  `arg2` varchar(256) NOT NULL DEFAULT 'null',
  `arg3` varchar(256) NOT NULL DEFAULT 'null',
  `arg4` varchar(256) NOT NULL DEFAULT 'null',
  `arg5` varchar(256) NOT NULL DEFAULT 'null',
  `arg6` varchar(256) NOT NULL DEFAULT 'null',
  `arg7` varchar(256) NOT NULL DEFAULT 'null',
  `arg8` varchar(256) NOT NULL DEFAULT 'null',
  `arg9` varchar(256) NOT NULL DEFAULT 'null',
  `gen_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `research` (
  `from_object` int(10) unsigned NOT NULL,
  `to_object` int(10) unsigned NOT NULL,
  PRIMARY KEY (`from_object`),
  UNIQUE KEY `to_object` (`to_object`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `robots` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `usedtime` int(10) unsigned NOT NULL DEFAULT '0',
  `status` int(10) unsigned NOT NULL DEFAULT '0',
  `build_id` int(10) unsigned DEFAULT '0',
  `build_type` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_time` (`usedtime`),
  KEY `status` (`status`),
  KEY `by_user` (`user_id`,`status`),
  KEY `build_type` (`build_id`,`build_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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

CREATE TABLE `ship_types` (
  `object_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `conserv_id` int(10) unsigned NOT NULL,
  `tactik` int(10) unsigned NOT NULL DEFAULT '0',
  `agrav` int(10) unsigned NOT NULL DEFAULT '0',
  `planet` int(10) unsigned NOT NULL DEFAULT '0',
  `hyper` int(10) unsigned NOT NULL DEFAULT '0',
  `shield` int(11) NOT NULL DEFAULT '0',
  `cargo` int(10) unsigned NOT NULL DEFAULT '0',
  `w_power` int(10) unsigned NOT NULL DEFAULT '0',
  `w_count` int(10) unsigned NOT NULL DEFAULT '0',
  `w_sum` int(10) unsigned NOT NULL DEFAULT '0',
  `w_type` int(11) NOT NULL DEFAULT '0',
  `code` varchar(8) NOT NULL,
  `planet_cnt` int(10) unsigned NOT NULL,
  `hyper_cnt` int(10) unsigned NOT NULL,
  `radar` int(1) unsigned NOT NULL DEFAULT '0',
  `remote` int(1) unsigned NOT NULL DEFAULT '0',
  `interupt` int(1) unsigned NOT NULL DEFAULT '0',
  `cloak` int(10) unsigned NOT NULL DEFAULT '0',
  `missile` int(10) unsigned NOT NULL DEFAULT '0',
  `dock` int(11) NOT NULL DEFAULT '0',
  `corsar` int(10) unsigned NOT NULL DEFAULT '0',
  `pic` varchar(64) NOT NULL DEFAULT '',
  `harvest` int(10) unsigned NOT NULL DEFAULT '0',
  `hot` int(10) unsigned NOT NULL DEFAULT '0',
  `titul` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`object_id`),
  UNIQUE KEY `conserv_id` (`conserv_id`),
  KEY `by_engines` (`hyper`,`planet`),
  KEY `by_radar` (`radar`),
  KEY `by_remote` (`remote`),
  KEY `by_cloack` (`cloak`),
  KEY `by_missile` (`missile`),
  KEY `dock` (`dock`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ships` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship, 3-station, 5-in fly, 7-system point, 8-galaxy point',
  `user_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `group` varchar(32) NOT NULL,
  `arg1` int(10) DEFAULT NULL,
  `arg2` int(10) DEFAULT NULL,
  `fleet_id` int(10) unsigned DEFAULT NULL,
  `shield` int(10) NOT NULL DEFAULT '0',
  `inwar` int(10) unsigned NOT NULL DEFAULT '0',
  `guard` int(10) unsigned NOT NULL DEFAULT '0',
  `interupt` int(1) unsigned NOT NULL DEFAULT '0',
  `abordage` int(10) unsigned NOT NULL DEFAULT '1',
  `fire` tinyint(1) NOT NULL DEFAULT '0',
  `new` tinyint(1) NOT NULL DEFAULT '0',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_fleet` (`fleet_id`),
  KEY `by_user` (`user_id`),
  KEY `by_inwar` (`inwar`),
  KEY `by_guard` (`guard`),
  KEY `by_object` (`object_id`),
  KEY `interup` (`interupt`),
  KEY `by_place_coords` (`place_type`,`place_id`,`arg1`,`arg2`),
  KEY `by_place_user` (`place_id`,`user_id`,`place_type`),
  KEY `group` (`user_id`,`group`),
  KEY `by_place` (`place_id`,`place_type`),
  KEY `order_id` (`fleet_id`,`order_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ships_war` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship, 3-station, 5-in fly, 7-system point, 8-galaxy point',
  `user_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `group` varchar(32) NOT NULL,
  `arg1` int(10) DEFAULT NULL,
  `arg2` int(10) DEFAULT NULL,
  `fleet_id` int(10) unsigned DEFAULT NULL,
  `shield` int(10) NOT NULL DEFAULT '0',
  `inwar` int(10) unsigned NOT NULL DEFAULT '0',
  `guard` int(10) unsigned NOT NULL DEFAULT '0',
  `interupt` int(1) unsigned NOT NULL DEFAULT '0',
  `abordage` int(10) unsigned NOT NULL DEFAULT '1',
  `fire` tinyint(1) NOT NULL DEFAULT '0',
  `new` tinyint(1) NOT NULL DEFAULT '0',
  `order_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `by_fleet` (`fleet_id`),
  KEY `by_user` (`user_id`),
  KEY `by_inwar` (`inwar`),
  KEY `by_guard` (`guard`),
  KEY `by_object` (`object_id`),
  KEY `interup` (`interupt`),
  KEY `by_place_coords` (`place_type`,`place_id`,`arg1`,`arg2`),
  KEY `by_place_user` (`place_id`,`user_id`,`place_type`),
  KEY `group` (`user_id`,`group`),
  KEY `by_place` (`place_id`,`place_type`),
  KEY `order_id` (`fleet_id`,`order_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sintez` (
  `res_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY (`res_id`),
  KEY `by_object` (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `space_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` int(10) unsigned NOT NULL COMMENT '0/100-land ship/fleet,1/101-flyout ship/fleet, 2/102-fly point ship/fleet, 3/103-fly planet ship/fleet, 4/104-fly star ship/fleet, 5/105-fly galaxy ship/fleet, 6-spy planet ship, 7-hyper gate',
  `ship_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `timer` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `arg1` int(10) DEFAULT NULL,
  `arg2` int(10) DEFAULT NULL,
  `from_arg1` int(11) DEFAULT NULL,
  `from_arg2` int(11) DEFAULT NULL,
  `from_type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_ship_type` (`ship_id`,`event_type`),
  KEY `by_time` (`event_time`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `star_pos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_x` (`x`),
  KEY `by_y` (`y`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `stars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `x` int(10) NOT NULL,
  `y` int(10) NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `bg` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_name` (`name`),
  KEY `by_x` (`x`),
  KEY `by_y` (`y`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `tituls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_object` (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `trade_in` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ob_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  `price` float(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_object` (`object_id`),
  KEY `by_ob` (`ob_id`),
  KEY `by_ob_object` (`ob_id`,`object_id`),
  KEY `by_count` (`object_cnt`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `trade_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bayer_id` int(11) unsigned NOT NULL,
  `seller_id` int(11) unsigned NOT NULL,
  `object_id` int(11) unsigned NOT NULL,
  `object_cnt` int(11) unsigned NOT NULL,
  `trade_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `log_sum` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `trade_out` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ob_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  `price` float(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_object` (`object_id`),
  KEY `by_ob` (`ob_id`),
  KEY `by_ob_object` (`ob_id`,`object_id`),
  KEY `by_count` (`object_cnt`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `trash` (
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `arg1` int(11) DEFAULT NULL,
  `arg2` int(11) DEFAULT NULL,
  `lost_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `by_place_object` (`place_type`,`place_id`,`object_id`,`arg1`,`arg2`),
  KEY `by_lost_date` (`lost_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `tutorials` (
  `level` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `premium` int(10) unsigned NOT NULL DEFAULT '0',
  `tutorial` longtext NOT NULL,
  PRIMARY KEY (`level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `u2u_quests` (
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

CREATE TABLE `u2u_types` (
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

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL DEFAULT '1',
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `err_login` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `admin` int(10) NOT NULL DEFAULT '0',
  `email` varchar(150) NOT NULL,
  `ssid` varchar(200) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `level` int(10) unsigned NOT NULL DEFAULT '2',
  `lastlevel` int(10) unsigned NOT NULL DEFAULT '0',
  `tutorial_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `place_id` int(10) unsigned NOT NULL COMMENT 'Object ID where user is',
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship, 3-station, 4-star, 5-in fly, 7-system point, 8-galaxy point',
  `money` float(12,2) NOT NULL DEFAULT '0.00',
  `credits` bigint(16) NOT NULL DEFAULT '0',
  `die_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `insur` int(10) unsigned NOT NULL DEFAULT '0',
  `last_ip` varchar(120) DEFAULT NULL,
  `volume_sound` int(11) NOT NULL DEFAULT '50',
  `volume_music` int(11) NOT NULL DEFAULT '0',
  `register_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `decline_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fid` varchar(16) NOT NULL DEFAULT '0',
  `ref_link` varchar(255) NOT NULL DEFAULT 'none',
  `ent_link` varchar(512) NOT NULL DEFAULT 'none',
  `meta_in` varchar(64) DEFAULT NULL,
  `relid` varchar(64) DEFAULT NULL,
  `repid` varchar(64) DEFAULT NULL,
  `rebid` varchar(64) DEFAULT NULL,
  `ca_prx` int(11) NOT NULL DEFAULT '0',
  `ca_ref` varchar(255) NOT NULL DEFAULT '',
  `ca_aip` varchar(255) NOT NULL DEFAULT '',
  `ca_click_id` varchar(255) NOT NULL DEFAULT '',
  `so_source` varchar(255) NOT NULL DEFAULT '',
  `so_tid` varchar(255) NOT NULL DEFAULT '',
  `wasd_id` varchar(64) NOT NULL DEFAULT '',
  `full_log` tinyint(1) NOT NULL DEFAULT '0',
  `titul` int(10) unsigned NOT NULL DEFAULT '0',
  `block` int(11) NOT NULL DEFAULT '0',
  `block_date` datetime DEFAULT NULL,
  `donate` float(12,2) NOT NULL DEFAULT '0.00',
  `aliance` int(10) unsigned NOT NULL DEFAULT '0',
  `mute` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `show_planet` int(11) NOT NULL DEFAULT '1',
  `gid` varchar(255) NOT NULL DEFAULT '',
  `vk_id` varchar(32) DEFAULT NULL,
  `ord` int(10) unsigned NOT NULL DEFAULT '0',
  `pirate_status` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_login_pass` (`login`,`password`),
  UNIQUE KEY `by_login` (`login`),
  KEY `by_ssid` (`ssid`),
  KEY `tutorial_time` (`tutorial_time`),
  KEY `parent_id` (`parent_id`),
  KEY `by_status` (`status`),
  KEY `by_aliance` (`aliance`),
  KEY `by_vk_id` (`vk_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_active` (
  `id` int(10) unsigned NOT NULL,
  `lastlogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `char_status` bigint(16) NOT NULL DEFAULT '0',
  `char_war` bigint(16) NOT NULL DEFAULT '0',
  `char_level` bigint(16) NOT NULL DEFAULT '0',
  `abandon` bigint(16) NOT NULL DEFAULT '0',
  `pirate` bigint(16) NOT NULL DEFAULT '0',
  `mine` bigint(16) NOT NULL DEFAULT '0',
  `quest` bigint(16) NOT NULL DEFAULT '0',
  `trade` bigint(16) NOT NULL DEFAULT '0',
  `ships` bigint(16) NOT NULL DEFAULT '0',
  `die_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `lastlogin` (`lastlogin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_books` (
  `user_id` int(10) unsigned NOT NULL,
  `book_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_imp` (
  `user_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`object_id`),
  KEY `book_id` (`user_id`,`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_medal` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `user_desc` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `readed` int(1) unsigned NOT NULL DEFAULT '0',
  `msg_date` datetime NOT NULL,
  `type` int(10) unsigned NOT NULL DEFAULT '1',
  `to_user` int(10) unsigned NOT NULL,
  `from_user` int(10) unsigned NOT NULL,
  `hash` varchar(64) NOT NULL DEFAULT '',
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_user_id` (`to_user`,`id`),
  KEY `by_date` (`msg_date`),
  KEY `by_from_date` (`from_user`,`msg_date`),
  KEY `by_user_hash` (`to_user`,`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_msg_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `type` int(11) NOT NULL,
  `chat` tinyint(1) DEFAULT NULL,
  `mail` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_user_type` (`user_id`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_premium` (
  `user_id` int(10) unsigned NOT NULL,
  `premium` float(12,2) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_quests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL,
  `arg0` varchar(128) DEFAULT NULL,
  `arg1` varchar(64) DEFAULT NULL,
  `arg2` varchar(64) DEFAULT NULL,
  `arg3` varchar(64) DEFAULT NULL,
  `arg4` varchar(64) DEFAULT NULL,
  `arg5` varchar(64) DEFAULT NULL,
  `arg6` varchar(128) DEFAULT NULL,
  `arg7` varchar(128) DEFAULT NULL,
  `arg8` varchar(128) DEFAULT NULL,
  `arg9` varchar(128) DEFAULT NULL,
  `gen_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_type_id` (`type`,`id`),
  KEY `by_type` (`type`),
  KEY `by_status` (`status`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `users_report` (
  `user_id` int(10) unsigned NOT NULL,
  `msg_date` datetime NOT NULL,
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  `message` longtext NOT NULL,
  KEY `by_user_date` (`user_id`,`msg_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `variables` (
  `name` varchar(32) NOT NULL,
  `val` bigint(64) NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `war_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fire_time` datetime NOT NULL,
  `move_id` int(10) unsigned NOT NULL DEFAULT '0',
  `a_user_id` int(10) unsigned NOT NULL,
  `a_corsar` int(10) unsigned NOT NULL DEFAULT '0',
  `a_strateg` int(10) unsigned NOT NULL DEFAULT '0',
  `a_tactic` int(10) unsigned NOT NULL DEFAULT '0',
  `a_object_id` int(10) unsigned NOT NULL,
  `a_type` int(10) unsigned NOT NULL COMMENT '0-ship, 1-fleet',
  `a_last_id` int(10) NOT NULL DEFAULT '0',
  `d_user_id` int(10) unsigned NOT NULL,
  `d_corsar` int(10) unsigned NOT NULL DEFAULT '0',
  `d_strateg` int(10) unsigned NOT NULL DEFAULT '0',
  `d_tactic` int(10) unsigned NOT NULL DEFAULT '0',
  `d_object_id` int(10) unsigned NOT NULL,
  `d_type` int(10) unsigned NOT NULL COMMENT '0-ship, 1-fleet, 2-planet, 3-orbit',
  `d_last_id` int(10) NOT NULL DEFAULT '0',
  `a_stat` longtext,
  `d_stat` longtext,
  `a_premium` float(12,2) NOT NULL DEFAULT '0.00',
  `d_premium` float(12,2) NOT NULL DEFAULT '0.00',
  `place_hash` int(10) unsigned NOT NULL DEFAULT '0',
  `place_step` int(10) unsigned NOT NULL DEFAULT '0',
  `a_step` int(11) NOT NULL DEFAULT '0',
  `d_step` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fire_time` (`fire_time`),
  KEY `by_a` (`a_type`,`a_object_id`),
  KEY `by_d` (`d_type`,`d_object_id`),
  KEY `by_hash_step` (`place_hash`,`place_step`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `war_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `war_id` int(10) unsigned NOT NULL,
  `msg_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `msg_time` (`msg_time`),
  KEY `by_war` (`war_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `war_online` (
  `war_id` int(10) unsigned NOT NULL,
  `move_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_object_id` int(10) unsigned NOT NULL,
  `a_type` int(10) unsigned NOT NULL,
  `d_object_id` int(10) unsigned NOT NULL,
  `d_type` int(10) unsigned NOT NULL,
  `w_type` int(10) unsigned NOT NULL COMMENT '0-laser, 1-plasma, 2-mazer, 3-rocket',
  `defeat` int(11) NOT NULL,
  `place_hash` int(10) unsigned NOT NULL DEFAULT '0',
  `side` int(10) unsigned NOT NULL DEFAULT '0',
  `power` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`war_id`,`move_id`),
  KEY `place_hash_move` (`place_hash`,`move_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `war_places` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place` varchar(64) NOT NULL,
  `fleet_id` int(10) unsigned NOT NULL DEFAULT '0',
  `date_start` datetime DEFAULT NULL,
  `sent` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_place` (`place`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `war_test` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `warehouse` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship',
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `by_place_object` (`place_id`,`object_id`,`place_type`),
  KEY `by_object_id` (`object_id`),
  KEY `by_count` (`object_cnt`),
  KEY `i_rev_place` (`place_id`,`place_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `warequest` (
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL DEFAULT '0',
  `quest_id` int(11) NOT NULL,
  KEY `by_quest` (`quest_id`),
  KEY `by_place` (`place_id`,`place_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

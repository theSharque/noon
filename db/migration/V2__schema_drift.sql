-- Schema drift: columns used by www_new PHP but absent in 2012 dump
SET NAMES utf8;

ALTER TABLE `users`
  ADD COLUMN `ref_link` varchar(255) NOT NULL DEFAULT 'none',
  ADD COLUMN `ent_link` varchar(512) NOT NULL DEFAULT 'none',
  ADD COLUMN `meta_in` varchar(64) DEFAULT NULL,
  ADD COLUMN `relid` varchar(64) DEFAULT NULL,
  ADD COLUMN `repid` varchar(64) DEFAULT NULL,
  ADD COLUMN `rebid` varchar(64) DEFAULT NULL,
  ADD COLUMN `ca_prx` int(11) NOT NULL DEFAULT '0',
  ADD COLUMN `ca_ref` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `ca_aip` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `ca_click_id` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `so_source` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `so_tid` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `wasd_id` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN `full_log` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `titul` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `block` int(11) NOT NULL DEFAULT '0',
  ADD COLUMN `block_date` datetime DEFAULT NULL,
  ADD COLUMN `donate` float(12,2) NOT NULL DEFAULT '0.00',
  ADD COLUMN `aliance` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `mute` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  ADD COLUMN `show_planet` int(11) NOT NULL DEFAULT '1',
  ADD COLUMN `gid` varchar(255) NOT NULL DEFAULT '',
  ADD COLUMN `vk_id` varchar(32) DEFAULT NULL,
  ADD COLUMN `ord` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `pirate_status` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `users_active`
  ADD COLUMN `abandon` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `pirate` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `mine` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `quest` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `trade` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `ships` bigint(16) NOT NULL DEFAULT '0',
  ADD COLUMN `die_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00';

ALTER TABLE `history_log`
  ADD COLUMN `credits_all` float(12,2) NOT NULL DEFAULT '0.00' AFTER `credits`,
  ADD COLUMN `confederates_all` int(11) NOT NULL DEFAULT '0' AFTER `confederates`,
  ADD COLUMN `users_all` int(11) NOT NULL DEFAULT '0' AFTER `users`,
  ADD COLUMN `online` int(11) NOT NULL DEFAULT '0' AFTER `users_all`;

ALTER TABLE `users_messages`
  ADD COLUMN `hash` varchar(64) NOT NULL DEFAULT '' AFTER `from_user`;

ALTER TABLE `objects`
  ADD COLUMN `minprice` float(12,2) NOT NULL DEFAULT '0.00' AFTER `myprice`,
  ADD COLUMN `soldable` tinyint(1) NOT NULL DEFAULT '0';

ALTER TABLE `buildings`
  ADD COLUMN `pic` varchar(64) NOT NULL DEFAULT '';

ALTER TABLE `ship_types`
  ADD COLUMN `w_sum` int(10) unsigned NOT NULL DEFAULT '0' AFTER `w_count`,
  ADD COLUMN `pic` varchar(64) NOT NULL DEFAULT '',
  ADD COLUMN `harvest` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `hot` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `titul` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `ships`
  ADD COLUMN `fire` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `new` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `order_id` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `fleets`
  ADD COLUMN `corsar` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `harvest` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `hot` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `titul` int(10) unsigned NOT NULL DEFAULT '0';

ALTER TABLE `pay_log`
  ADD COLUMN `trade_id` int(10) unsigned DEFAULT NULL,
  ADD COLUMN `type` int(10) unsigned NOT NULL DEFAULT '0',
  ADD KEY `by_trade_id` (`trade_id`);

ALTER TABLE `quest_types`
  ADD COLUMN `gen_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00';

ALTER TABLE `users_quests`
  ADD COLUMN `gen_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00';

ALTER TABLE `planets`
  ADD COLUMN `occuped` int(11) NOT NULL DEFAULT '0';

ALTER TABLE `war_events`
  ADD COLUMN `place_hash` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `place_step` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `a_step` int(11) NOT NULL DEFAULT '0',
  ADD COLUMN `d_step` int(11) NOT NULL DEFAULT '0',
  ADD KEY `place_hash` (`place_hash`);

ALTER TABLE `war_online`
  ADD COLUMN `place_hash` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `side` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `power` int(10) unsigned NOT NULL DEFAULT '0',
  ADD KEY `place_hash_move` (`place_hash`, `move_id`);

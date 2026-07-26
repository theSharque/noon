ALTER TABLE `ships_war`
  ADD COLUMN `fire` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `new` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `order_id` int(10) unsigned NOT NULL DEFAULT '0';

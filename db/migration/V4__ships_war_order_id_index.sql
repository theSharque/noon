-- Combat target selection (victim_fleet) historically used FORCE INDEX (order_id).
-- Index was missing from recreated ships/ships_war → MySQL 1176 → empty victim → «нет цели».

ALTER TABLE `ships` ADD KEY `order_id` (`fleet_id`, `order_id`, `user_id`);
ALTER TABLE `ships_war` ADD KEY `order_id` (`fleet_id`, `order_id`, `user_id`);

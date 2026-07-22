-- buildings.place_type expected by current PHP (planet=1, orbit=0).
-- Old backup schema lacked this column; code filters JOIN/WHERE by place_type.

ALTER TABLE `buildings`
  ADD COLUMN `place_type` int(10) unsigned NOT NULL DEFAULT 1 COMMENT '0-orbit, 1-planet' AFTER `id`,
  ADD KEY `by_place_type` (`place_type`),
  ADD KEY `by_place_type_id` (`place_type`, `id`);

UPDATE `buildings` SET `place_type` = 0 WHERE `id` >= 3000;
UPDATE `buildings` SET `place_type` = 1 WHERE `id` < 3000;

ALTER TABLE `users` MODIFY `volume_music` int(11) NOT NULL DEFAULT 0;

UPDATE `users` SET `volume_music` = 0 WHERE `id` IN (16, 17);

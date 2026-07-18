SET NAMES utf8;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

INSERT INTO `tituls` (`id`, `name`, `object_id`) VALUES (22, 'Архитектор', 22)
  ON DUPLICATE KEY UPDATE `name` = 'Архитектор', `object_id` = 22;

UPDATE `users` SET `titul` = 22 WHERE `id` = 16 AND `login` = 'sharque';

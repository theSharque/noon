-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.1.35-community


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema noon
--

CREATE DATABASE IF NOT EXISTS noon;
USE noon;

--
-- Definition of table `books`
--

DROP TABLE IF EXISTS `books`;
CREATE TABLE `books` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` varchar(500) NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `parent_level` int(10) unsigned DEFAULT NULL,
  `teach_time` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 PACK_KEYS=1 CHECKSUM=1 ROW_FORMAT=COMPRESSED;

--
-- Dumping data for table `books`
--

/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` (`id`,`name`,`description`,`parent_id`,`parent_level`,`teach_time`) VALUES 
 (1,'Математика','Основы алгебры и геометрии, знания помогают в торговле, навигации и необходимы для понимания основ программирования.',NULL,NULL,0),
 (2,'Физика','Проведение простых экспериментов, основы физических процессов. Знания позволяют изучить металлургию, а так же открывают путь к сложному оружию. Понимание физики процессов позволит строить более совершенные реакторы, вырабатывать больше енергии.',NULL,NULL,2),
 (3,'Металургия','Переплавка метала, обработка металла. Знание позволяет эффективнее и быстрее добывать сырье. Полученные навыки дают приемущиство для разработки крупных месторождений.',2,3,4),
 (4,'Навигация','Управление космическим кораблем, настройка навигационного компьютера',1,3,45),
 (5,'Гипернавигация','Управление космическим кораблем в гиперпространстве, прокладка оптимального маршрута',4,5,3),
 (6,'Шахтерство','Разработка месторождений на метеоритах, метрвых планетах, добыча газов с планет гигантов',3,3,3),
 (7,'Программирование','Переобучение компьютера, возможность установки имплантантов',1,5,3),
 (8,'Лазерное оружие','Владение лазерным оружием',2,4,3),
 (9,'Плазменное оружие','Владение плазменным оружием',2,4,3),
 (10,'Ракетное оружие','Владение ракетным оружием',2,4,3);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;


--
-- Definition of table `books_teach`
--

DROP TABLE IF EXISTS `books_teach`;
CREATE TABLE `books_teach` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `book_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bt_index` (`user_id`,`end_time`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `books_teach`
--

/*!40000 ALTER TABLE `books_teach` DISABLE KEYS */;
INSERT INTO `books_teach` (`id`,`book_id`,`user_id`,`end_time`) VALUES 
 (75,4,2,'2009-07-31 07:28:27');
/*!40000 ALTER TABLE `books_teach` ENABLE KEYS */;


--
-- Definition of table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `desc` varchar(450) NOT NULL,
  `build_time` int(10) unsigned NOT NULL,
  `energy` int(10) NOT NULL,
  `warehouse` int(10) unsigned NOT NULL,
  `map_char` varchar(1) NOT NULL,
  `req_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings`
--

/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` (`id`,`desc`,`build_time`,`energy`,`warehouse`,`map_char`,`req_id`) VALUES 
 (23,'Позволяет добывать ресурсы с поверхности планеты. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">1000</font>',1,-10,1000,'K',34),
 (24,'Переплавляет ископаемые, и ненужные устройства в ресурсы. Качество переплавки зависит от уровня структуры.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-15</font><br>	Склад					<font color=\"#00FF00\">1000</font>',2,-15,1000,'P',34),
 (25,'Позволяет исследовать агрегаты, устройства, природные процессы, продуктом деятельности является чертеж агрегата необходимый для изготовления. Уровень постройки определяет время исследования и количество исследуемых объектов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-35</font><br>	Склад					<font color=\"#00FF00\">500</font>',3,-35,500,'L',39),
 (26,'Изначальная структура в которой вы спустились на планету. Обладает возможностью полностью регенирировать игрока и восстанавливать память.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',0,50,5000,'C',NULL),
 (33,'Позволяет изготавливать вещи при наличии чертежа и ресурсов. Количество циклов производства зависит от уровня структуры. Для постоянной работы можно воспользоваться автономными роботами.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',1,-50,5000,'F',24),
 (34,'Вырабатывает электроэнергию необходимую всем постройкам на планете, без энергии не функционирует ни одна постройка. Количество вырабатываемой энергии зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">100</font>',1,100,0,'E',NULL),
 (36,'Позволяет добывать ресурсы с среднего слоя планеты. Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника.  Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-30</font><br>	Склад					<font color=\"#00FF00\">1000</font>',2,-30,1000,'M',34),
 (37,'Позволяет добывать ресурсы с глубинного слоя планеты.  Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-60</font><br>	Склад					<font color=\"#00FF00\">1000</font>',4,-60,1000,'O',34),
 (38,'Позволяет хранить больше товара на планете. Количество хранимых товаров зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">50000</font>',5,-10,50000,'S',24),
 (39,'Позволяет изготавливать сложные устройства, собираемые из нескольких модулей.',7,-70,5000,'R',33);
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;


--
-- Definition of table `classes`
--

DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `classes`
--

/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` (`id`,`name`,`code`) VALUES 
 (1,'ресурс','res'),
 (2,'продукт','prod'),
 (3,'недвижимость','prop'),
 (4,'движимость','unit'),
 (5,'ископаемые','mine');
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;


--
-- Definition of table `objects`
--

DROP TABLE IF EXISTS `objects`;
CREATE TABLE `objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `min_cnt` int(10) unsigned NOT NULL,
  `mass` int(10) unsigned NOT NULL,
  `class` int(10) unsigned NOT NULL,
  `price` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_weight` (`weight`),
  KEY `classification` (`class`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects`
--

/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
INSERT INTO `objects` (`id`,`name`,`min_cnt`,`mass`,`class`,`price`,`weight`) VALUES 
 (1,'Железо',1,1,1,0,0),
 (2,'Кобальт',1,1,1,0,0),
 (3,'Алюминий',1,1,1,0,0),
 (4,'Кварц',1,1,1,0,0),
 (5,'Мышьяк',1,1,1,0,0),
 (6,'Уран',1,1,1,0,0),
 (7,'Сера',1,1,1,0,0),
 (8,'Дерево',1,1,1,0,0),
 (9,'Вода',100,1,5,0,0),
 (10,'Никель',1,1,1,0,0),
 (11,'Медь',1,1,1,0,0),
 (12,'Золото',1,1,1,0,0),
 (13,'Титан',1,1,1,0,0),
 (14,'Железная руда',100,1,5,0,0),
 (15,'Песок',100,1,5,0,0),
 (16,'Кобальтовая руда',100,1,5,0,0),
 (17,'Урановая руда',100,1,5,0,0),
 (18,'Алюминивая руда',100,1,5,0,0),
 (19,'Медная руда',100,1,5,0,0),
 (20,'Железный метеорит',100,1,5,0,0),
 (21,'Золотая руда',1000,1,5,0,0),
 (22,'Титановая руда',100,1,5,0,0),
 (23,'Карьер',1,100000,3,0,90),
 (24,'Переплавка',1,100000,3,0,50),
 (25,'Лаборатория',1,100000,3,0,30),
 (26,'Капсула',1,100000,0,0,0),
 (27,'Шатл',1,1,4,0,0),
 (28,'корпус шатла',1,1,2,0,0),
 (29,'двигатель',1,1,2,0,0),
 (30,'кабина',1,1,2,0,0),
 (31,'реактор',1,1,2,0,0),
 (32,'чертеж шатла',1,0,6,0,0),
 (33,'Завод',1,100000,3,0,40),
 (34,'Электростанция',1,100000,3,0,100),
 (35,'Кремний',1,1,1,0,0),
 (36,'Шахта',1,100000,3,0,80),
 (37,'Буровая',1,100000,3,0,70),
 (38,'Склад',1,100000,3,0,60),
 (39,'Сборочный цех',1,100000,3,0,10);
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;


--
-- Definition of table `objects_prod`
--

DROP TABLE IF EXISTS `objects_prod`;
CREATE TABLE `objects_prod` (
  `idobject` int(10) unsigned NOT NULL,
  `energy` int(10) NOT NULL,
  `hull` int(10) unsigned NOT NULL,
  `shield` int(10) unsigned NOT NULL,
  `mass` int(10) NOT NULL,
  PRIMARY KEY (`idobject`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects_prod`
--

/*!40000 ALTER TABLE `objects_prod` DISABLE KEYS */;
INSERT INTO `objects_prod` (`idobject`,`energy`,`hull`,`shield`,`mass`) VALUES 
 (31,100,10,0,75),
 (29,-70,10,0,25),
 (30,-10,50,0,50),
 (28,-10,100,0,-300),
 (32,0,0,0,0);
/*!40000 ALTER TABLE `objects_prod` ENABLE KEYS */;


--
-- Definition of table `objects_sub`
--

DROP TABLE IF EXISTS `objects_sub`;
CREATE TABLE `objects_sub` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idobjects` int(10) unsigned NOT NULL,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects_sub`
--

/*!40000 ALTER TABLE `objects_sub` DISABLE KEYS */;
INSERT INTO `objects_sub` (`id`,`idobjects`,`res_id`,`res_cnt`) VALUES 
 (1,14,1,60),
 (2,14,7,10),
 (3,15,4,50),
 (4,16,2,36),
 (5,16,7,19),
 (6,16,5,45),
 (7,17,6,2),
 (8,18,3,25),
 (9,19,10,3),
 (10,19,11,25),
 (11,20,1,70),
 (12,20,10,17),
 (13,21,12,15),
 (14,22,13,17),
 (15,23,1,50),
 (16,23,35,10),
 (17,24,1,50),
 (18,24,35,30),
 (19,25,1,120),
 (20,25,35,120),
 (21,33,1,150),
 (22,33,35,80),
 (23,33,11,80),
 (24,34,1,110),
 (25,34,35,40),
 (26,34,11,30),
 (27,36,1,100),
 (28,36,35,25),
 (29,37,1,250),
 (30,37,35,35),
 (31,38,1,500),
 (32,38,35,500),
 (33,39,1,750),
 (34,39,35,400),
 (35,39,2,25),
 (36,39,11,150);
/*!40000 ALTER TABLE `objects_sub` ENABLE KEYS */;


--
-- Definition of table `planet_events`
--

DROP TABLE IF EXISTS `planet_events`;
CREATE TABLE `planet_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` int(10) NOT NULL,
  `y` int(10) NOT NULL,
  `planet_id` int(10) NOT NULL,
  `object_id` int(10) NOT NULL,
  `event_time` datetime NOT NULL,
  `event_type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `planet_x_y` (`planet_id`,`x`,`y`),
  KEY `by_planet` (`planet_id`),
  KEY `timers` (`event_time`,`event_type`),
  KEY `planet_timers` (`planet_id`,`event_time`,`event_type`)
) ENGINE=MyISAM AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planet_events`
--

/*!40000 ALTER TABLE `planet_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `planet_events` ENABLE KEYS */;


--
-- Definition of table `planet_types`
--

DROP TABLE IF EXISTS `planet_types`;
CREATE TABLE `planet_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planet_types`
--

/*!40000 ALTER TABLE `planet_types` DISABLE KEYS */;
INSERT INTO `planet_types` (`id`,`name`) VALUES 
 (1,'Земного типа'),
 (2,'Пустынного типа'),
 (3,'Мертвая планета'),
 (4,'Газовый гигант'),
 (5,'Каменного типа'),
 (6,'Планета океан'),
 (7,'Болотистая планета'),
 (8,'Ледяная планета'),
 (9,'Парниковые тропики');
/*!40000 ALTER TABLE `planet_types` ENABLE KEYS */;


--
-- Definition of table `planets`
--

DROP TABLE IF EXISTS `planets`;
CREATE TABLE `planets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets`
--

/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` (`id`,`type`,`name`,`user_id`) VALUES 
 (1,1,'Проверка земли',2);
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;


--
-- Definition of table `planets_buildings`
--

DROP TABLE IF EXISTS `planets_buildings`;
CREATE TABLE `planets_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `by_objects` (`object_id`),
  KEY `by_planet` (`planet_id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_buildings`
--

/*!40000 ALTER TABLE `planets_buildings` DISABLE KEYS */;
INSERT INTO `planets_buildings` (`id`,`object_id`,`planet_id`,`x`,`y`) VALUES 
 (1,26,1,3,2),
 (32,34,1,4,1),
 (33,23,1,5,1),
 (34,34,1,2,2),
 (35,34,1,2,3),
 (36,34,1,3,3),
 (37,36,1,6,1),
 (38,24,1,4,2),
 (39,37,1,3,1),
 (40,33,1,4,4),
 (41,33,1,5,2),
 (42,34,1,6,3),
 (43,23,1,7,3),
 (44,34,1,6,2),
 (45,33,1,4,3),
 (46,38,1,7,2),
 (47,37,1,5,3),
 (48,23,1,7,4),
 (49,34,1,8,2),
 (50,36,1,8,1),
 (51,39,1,7,1),
 (52,33,1,3,4),
 (53,38,1,5,4),
 (54,25,1,6,4),
 (55,23,1,7,0),
 (56,34,1,8,0),
 (57,39,1,6,0),
 (58,34,1,3,0),
 (59,34,1,4,0),
 (60,34,1,8,3);
/*!40000 ALTER TABLE `planets_buildings` ENABLE KEYS */;


--
-- Definition of table `planets_mines`
--

DROP TABLE IF EXISTS `planets_mines`;
CREATE TABLE `planets_mines` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `cycle` int(10) unsigned NOT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_mines`
--

/*!40000 ALTER TABLE `planets_mines` DISABLE KEYS */;
/*!40000 ALTER TABLE `planets_mines` ENABLE KEYS */;


--
-- Definition of table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `email` varchar(150) NOT NULL,
  `ssid` varchar(200) NOT NULL,
  `lastlogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` decimal(10,0) NOT NULL DEFAULT '1',
  `place_id` int(10) unsigned NOT NULL COMMENT 'Object ID where user is',
  `place_type` int(10) unsigned NOT NULL COMMENT '0-space, 1-planet, 2-ship, 3-station',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Users table';

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`login`,`password`,`firstname`,`lastname`,`email`,`ssid`,`lastlogin`,`status`,`place_id`,`place_type`) VALUES 
 (1,'root','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','root@localhost','1','2009-07-18 00:14:01','1',1,1),
 (2,'admin','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','admin@localhost','3rtrkv51u63lld7m9lu111doj6','2009-08-01 23:17:01','1',1,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;


--
-- Definition of table `users_books`
--

DROP TABLE IF EXISTS `users_books`;
CREATE TABLE `users_books` (
  `user_id` int(10) unsigned NOT NULL,
  `book_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_books`
--

/*!40000 ALTER TABLE `users_books` DISABLE KEYS */;
INSERT INTO `users_books` (`user_id`,`book_id`,`level`) VALUES 
 (2,1,21),
 (2,2,3),
 (1,1,2),
 (1,4,4),
 (2,3,2),
 (2,7,3),
 (2,4,2);
/*!40000 ALTER TABLE `users_books` ENABLE KEYS */;


--
-- Definition of table `users_chr`
--

DROP TABLE IF EXISTS `users_chr`;
CREATE TABLE `users_chr` (
  `user_id` int(10) unsigned NOT NULL,
  `exp` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  `iq` int(10) unsigned NOT NULL,
  `cred` int(11) NOT NULL,
  `auth` int(11) NOT NULL,
  `strong` int(10) unsigned NOT NULL,
  `speed` int(10) unsigned NOT NULL,
  `agility` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_chr`
--

/*!40000 ALTER TABLE `users_chr` DISABLE KEYS */;
INSERT INTO `users_chr` (`user_id`,`exp`,`level`,`iq`,`cred`,`auth`,`strong`,`speed`,`agility`) VALUES 
 (2,10,1,10,10000,100,10,10,10);
/*!40000 ALTER TABLE `users_chr` ENABLE KEYS */;


--
-- Definition of table `users_messages`
--

DROP TABLE IF EXISTS `users_messages`;
CREATE TABLE `users_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `msg_date` datetime NOT NULL,
  `to_user` int(10) unsigned NOT NULL,
  `from_user` int(10) unsigned NOT NULL,
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_messages`
--

/*!40000 ALTER TABLE `users_messages` DISABLE KEYS */;
INSERT INTO `users_messages` (`id`,`msg_date`,`to_user`,`from_user`,`text`) VALUES 
 (1,'2009-06-30 00:01:20',2,1,'Проверка отправки очень длинных сообщений для пользователя, что бы посмотреть, как это сообщение будет отображаться на экране и влезет ли это все в интерфейс'),
 (2,'2009-06-30 00:01:15',2,1,'Короткое сообщение');
/*!40000 ALTER TABLE `users_messages` ENABLE KEYS */;


--
-- Definition of table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_places` (`place_id`,`place_type`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `warehouse`
--

/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` (`id`,`place_id`,`place_type`,`object_id`,`object_cnt`) VALUES 
 (1,1,1,1,810),
 (2,1,1,35,725),
 (3,1,1,11,3790),
 (4,1,1,14,242),
 (5,1,1,15,20),
 (6,1,1,28,5),
 (7,1,1,29,1),
 (8,1,1,32,1),
 (9,1,1,2,150),
 (10,1,1,3,300),
 (11,1,1,9,120);
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

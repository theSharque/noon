-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.51b-community-nt


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
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(80) NOT NULL,
  `description` varchar(500) NOT NULL,
  `parent_id` int(10) unsigned default NULL,
  `parent_level` int(10) unsigned default NULL,
  `teach_time` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 PACK_KEYS=1 CHECKSUM=1 ROW_FORMAT=COMPRESSED;

--
-- Dumping data for table `books`
--

/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` (`id`,`name`,`description`,`parent_id`,`parent_level`,`teach_time`) VALUES 
 (1,'Геология','Позволяет изготавливать геологические приборы. Необходим 3 уровень Геологии, для изучения Шахтерства',NULL,NULL,60),
 (4,'Скорочтение','Сокращает время изучения других наук',NULL,NULL,240),
 (3,'Металургия','Сокращает время переплавки ископаемых и различных объектов. Необходим 3 уровень Металургии для изучения Креативности',2,3,120),
 (5,'Строительство','Сокращает время постройки объектов',NULL,NULL,120),
 (6,'Креативность','Сокращает время производства различных деталей',3,1,240),
 (2,'Шахтерство','Сокращает время добычи ресурсов. Необходим 3 уровень Шатерства для изучения Металургии',1,3,900);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;


--
-- Definition of table `books_teach`
--

DROP TABLE IF EXISTS `books_teach`;
CREATE TABLE `books_teach` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `book_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `bt_index` (`user_id`,`end_time`)
) ENGINE=MyISAM AUTO_INCREMENT=150 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `books_teach`
--

/*!40000 ALTER TABLE `books_teach` DISABLE KEYS */;
INSERT INTO `books_teach` (`id`,`book_id`,`user_id`,`end_time`) VALUES 
 (149,1,2,'2009-09-11 16:06:55');
/*!40000 ALTER TABLE `books_teach` ENABLE KEYS */;


--
-- Definition of table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `desc` varchar(450) NOT NULL,
  `energy` int(10) NOT NULL,
  `warehouse` int(10) unsigned NOT NULL,
  `map_char` varchar(1) NOT NULL,
  `req_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2001 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings`
--

/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` (`id`,`desc`,`energy`,`warehouse`,`map_char`,`req_id`) VALUES 
 (23,'Позволяет добывать ресурсы с поверхности планеты. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-10,1000,'K',24),
 (24,'Переплавляет ископаемые, и ненужные устройства в ресурсы. Качество переплавки зависит от уровня структуры.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-15</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-15,1000,'P',34),
 (25,'Позволяет исследовать агрегаты, устройства, природные процессы, продуктом деятельности является чертеж агрегата необходимый для изготовления. Уровень постройки определяет время исследования и количество исследуемых объектов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-35</font><br>	Склад					<font color=\"#00FF00\">500</font>',-35,500,'L',39),
 (26,'Изначальная структура в которой вы спустились на планету. Обладает возможностью полностью регенирировать игрока и восстанавливать память.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',50,5000,'C',NULL),
 (33,'Позволяет изготавливать вещи при наличии чертежа и ресурсов. Количество циклов производства зависит от уровня структуры. Для постоянной работы можно воспользоваться автономными роботами.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',-50,5000,'F',24),
 (34,'Вырабатывает электроэнергию необходимую всем постройкам на планете, без энергии не функционирует ни одна постройка. Количество вырабатываемой энергии зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				',100,0,'E',NULL),
 (36,'Позволяет добывать ресурсы с среднего слоя планеты. Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника.  Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-30</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-30,1000,'M',24),
 (37,'Позволяет добывать ресурсы с глубинного слоя планеты.  Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-60</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-60,1000,'O',24),
 (38,'Позволяет хранить больше товара на планете. Количество хранимых товаров зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					',-10,50000,'S',24),
 (39,'Позволяет изготавливать сложные устройства, собираемые из нескольких модулей.',-70,5000,'R',33),
 (2000,'Исследовать почву',0,0,'0',33);
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;


--
-- Definition of table `classes`
--

DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  `min_cnt` int(10) unsigned NOT NULL,
  `mass` int(10) unsigned NOT NULL,
  `class` int(10) unsigned NOT NULL,
  `price` int(10) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  `make_time` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `by_weight` (`weight`),
  KEY `classification` (`class`)
) ENGINE=MyISAM AUTO_INCREMENT=7002 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects`
--

/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
INSERT INTO `objects` (`id`,`name`,`min_cnt`,`mass`,`class`,`price`,`weight`,`make_time`) VALUES 
 (23,'Карьер',1,100000,3,0,90,60),
 (24,'Нанодиспенсер',1,100000,3,0,50,120),
 (25,'Лаборатория',1,100000,3,0,30,180),
 (26,'Капсула',1,100000,0,0,0,0),
 (4001,'Малый шатл',1,2505,4,0,0,1200),
 (2003,'Антиграв. двигатель',1,375,2,0,0,150),
 (7001,'Макет малого шатла',1,0,7,0,0,1200),
 (33,'Завод',1,100000,3,0,40,60),
 (34,'Электростанция',1,100000,3,0,100,60),
 (36,'Шахта',1,100000,3,0,80,120),
 (37,'Буровая',1,100000,3,0,70,240),
 (38,'Склад',1,100000,3,0,60,300),
 (39,'Сборочный цех',1,100000,3,0,10,420),
 (1049,'Цирконий',1,1,1,0,0,0),
 (1048,'Цинк',1,1,1,0,0,0),
 (1047,'Иттрий',1,1,1,0,0,0),
 (1046,'Вольфрам',1,1,1,0,0,0),
 (1045,'Ванадий',1,1,1,0,0,0),
 (1044,'Уран',1,1,1,0,0,0),
 (1043,'Титан',1,1,1,0,0,0),
 (1042,'Торий',1,1,1,0,0,0),
 (1041,'Теллур',1,1,1,0,0,0),
 (1040,'Стронций',1,1,1,0,0,0),
 (1039,'Олово',1,1,1,0,0,0),
 (1038,'Самарий',1,1,1,0,0,0),
 (1037,'Кремний',1,1,1,0,0,0),
 (1036,'Селен',1,1,1,0,0,0),
 (1035,'Сурьма',1,1,1,0,0,0),
 (1034,'Сера',1,1,1,0,0,0),
 (1033,'Рубидий',1,1,1,0,0,0),
 (1032,'Свинец',1,1,1,0,0,0),
 (1031,'Фосфор',1,1,1,0,0,0),
 (1030,'Кислород',1,1,1,0,0,0),
 (1029,'Никель',1,1,1,0,0,0),
 (1028,'Неодим',1,1,1,0,0,0),
 (1027,'Натрий',1,1,1,0,0,0),
 (1026,'Азот',1,1,1,0,0,0),
 (1025,'Молибден',1,1,1,0,0,0),
 (1024,'Марганец',1,1,1,0,0,0),
 (1023,'Магний',1,1,1,0,0,0),
 (1022,'Литий',1,1,1,0,0,0),
 (1021,'Калий',1,1,1,0,0,0),
 (1020,'Ртуть',1,1,1,0,0,0),
 (1019,'Водород',1,1,1,0,0,0),
 (1018,'Германий',1,1,1,0,0,0),
 (1017,'Гадолиний',1,1,1,0,0,0),
 (1016,'Железо',1,1,1,0,0,0),
 (1015,'Фтор',1,1,1,0,0,0),
 (1014,'Дейтерий',1,1,1,0,0,0),
 (1013,'Медь',1,1,1,0,0,0),
 (1012,'Хром',1,1,1,0,0,0),
 (1011,'Кобальт',1,1,1,0,0,0),
 (1010,'Хлор',1,1,1,0,0,0),
 (1009,'Цезий',1,1,1,0,0,0),
 (1008,'Кальций',1,1,1,0,0,0),
 (1007,'Углерод',1,1,1,0,0,0),
 (1006,'Висмут',1,1,1,0,0,0),
 (1005,'Бериллий',1,1,1,0,0,0),
 (1004,'Бор',1,1,1,0,0,0),
 (1003,'Золото',1,1,1,0,0,0),
 (1002,'Мышьяк',1,1,1,0,0,0),
 (1001,'Аллюминий',1,1,1,0,0,0),
 (1000,'Серебро',1,1,1,0,0,0),
 (5000,'Азурит',100,1,5,0,0,300),
 (5001,'Алабандин',100,1,5,0,0,300),
 (5002,'Альбит',100,1,5,0,0,300),
 (5003,'Апатит',100,1,5,0,0,300),
 (5004,'Аргентит',100,1,5,0,0,300),
 (5005,'Бадделеит',100,1,5,0,0,300),
 (5006,'Берилл',100,1,5,0,0,300),
 (5007,'Брукит',100,1,5,0,0,300),
 (5008,'Брусит',100,1,5,0,0,300),
 (5009,'Висмутин',100,1,5,0,0,300),
 (5010,'Вода',100,1,5,0,0,300),
 (5011,'Вольфрамит',100,1,5,0,0,300),
 (5012,'Галенит',100,1,5,0,0,300),
 (5013,'Галит',100,1,5,0,0,300),
 (5014,'Гаусманит',100,1,5,0,0,300),
 (5015,'Гематит',100,1,5,0,0,300),
 (5016,'Гемиморфит',100,1,5,0,0,300),
 (5017,'Гётит',100,1,5,0,0,300),
 (5018,'Гипс',100,1,5,0,0,300),
 (5019,'Графит',100,1,5,0,0,300),
 (5020,'Данбурит',100,1,5,0,0,300),
 (5021,'Дарапскит',100,1,5,0,0,300),
 (5022,'Диоптаз',100,1,5,0,0,300),
 (5023,'Доломит',100,1,5,0,0,300),
 (5024,'Дюмортьерит',100,1,5,0,0,300),
 (5025,'Жадеит',100,1,5,0,0,300),
 (5026,'Иллит',100,1,5,0,0,300),
 (5027,'Ильменит',100,1,5,0,0,300),
 (5028,'Каинит',100,1,5,0,0,300),
 (5029,'Калаверит',100,1,5,0,0,300),
 (5030,'Каломель',100,1,5,0,0,300),
 (5031,'Касситерит',100,1,5,0,0,300),
 (5032,'Кварц',100,1,5,0,0,300),
 (5033,'Киноварь',100,1,5,0,0,300),
 (5034,'Колвезит',100,1,5,0,0,300),
 (5035,'Корунд',100,1,5,0,0,300),
 (5036,'Магнетит',100,1,5,0,0,300),
 (5037,'Мирабилит',100,1,5,0,0,300),
 (5038,'Молибденит',100,1,5,0,0,300),
 (5039,'Монацит',100,1,5,0,0,300),
 (5040,'Мусковит',100,1,5,0,0,300),
 (5041,'Настуран',100,1,5,0,0,300),
 (5042,'Опал',100,1,5,0,0,300),
 (5043,'Пентландит',100,1,5,0,0,300),
 (5044,'Перовскит',100,1,5,0,0,300),
 (5045,'Петалит',100,1,5,0,0,300),
 (5046,'Пираргирит',100,1,5,0,0,300),
 (5047,'Реальгар',100,1,5,0,0,300),
 (5048,'Ринерит',100,1,5,0,0,300),
 (5049,'Рубицин',100,1,5,0,0,300),
 (5050,'Сильванит',100,1,5,0,0,300),
 (5051,'Стронцианит',100,1,5,0,0,300),
 (5052,'Тальк',100,1,5,0,0,300),
 (5053,'Турманит',100,1,5,0,0,300),
 (5054,'Уваровит',100,1,5,0,0,300),
 (5055,'Флюорит',100,1,5,0,0,300),
 (5056,'Циркон',100,1,5,0,0,300),
 (5057,'Шеелит',100,1,5,0,0,300),
 (5058,'Эвдиалит',100,1,5,0,0,300),
 (5059,'Эритрин',100,1,5,0,0,300),
 (5060,'Ярозит',100,1,5,0,0,300),
 (2000,'Геологический зонд',1,7,2,0,0,30),
 (6000,'Чертеж геологического зонда',1,0,6,0,0,250),
 (2001,'Корпус шатла',1,170,2,0,0,300),
 (6001,'Чертеж корпуса шатла',1,0,6,0,0,450),
 (2002,'Малый ядерный реактор',1,110,2,0,0,500),
 (6002,'Чертеж малого ядерного реактора',1,0,6,0,0,750),
 (2004,'Малый грузовой отсек',1,250,2,0,0,400),
 (6003,'Чертеж антиграв. двигателя',1,0,6,0,0,750),
 (6004,'Чертеж грузового отсека',1,0,6,0,0,200),
 (2005,'Кабина шатла',1,100,2,0,0,1200),
 (6005,'Чертеж кабины шатла',1,0,6,0,0,450);
/*!40000 ALTER TABLE `objects` ENABLE KEYS */;


--
-- Definition of table `objects_layout`
--

DROP TABLE IF EXISTS `objects_layout`;
CREATE TABLE `objects_layout` (
  `object_id` int(10) unsigned NOT NULL auto_increment,
  `book_req` int(10) unsigned NOT NULL,
  `book_level` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`object_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects_layout`
--

/*!40000 ALTER TABLE `objects_layout` DISABLE KEYS */;
/*!40000 ALTER TABLE `objects_layout` ENABLE KEYS */;


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
  PRIMARY KEY  (`idobject`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `by_object` (`object_id`)
) ENGINE=MyISAM AUTO_INCREMENT=293 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects_sub`
--

/*!40000 ALTER TABLE `objects_sub` DISABLE KEYS */;
INSERT INTO `objects_sub` (`id`,`object_id`,`res_id`,`res_cnt`) VALUES 
 (15,23,1016,50),
 (16,23,1037,10),
 (17,24,1016,50),
 (18,24,1037,30),
 (19,25,1016,120),
 (20,25,1037,120),
 (21,33,1016,150),
 (22,33,1037,80),
 (23,33,1013,80),
 (24,34,1016,110),
 (25,34,1037,40),
 (26,34,1013,30),
 (27,36,1016,100),
 (28,36,1037,25),
 (29,37,1016,250),
 (30,37,1037,35),
 (31,38,1016,500),
 (32,38,1037,500),
 (33,39,1016,750),
 (34,39,1037,400),
 (35,39,1043,25),
 (36,39,1013,150),
 (37,5005,1049,99),
 (38,5056,1049,49),
 (39,5058,1049,9),
 (40,5011,1046,60),
 (41,5016,1048,54),
 (42,5048,1048,22),
 (43,5057,1046,63),
 (44,5058,1047,1),
 (45,5007,1043,59),
 (46,5027,1043,31),
 (47,5041,1044,88),
 (48,5044,1043,35),
 (49,5053,1045,5),
 (50,5029,1041,56),
 (51,5031,1039,31),
 (52,5039,1042,16),
 (53,5050,1041,59),
 (54,5051,1040,59),
 (55,5002,1037,68),
 (56,5006,1037,31),
 (57,5009,1036,8),
 (58,5016,1037,11),
 (59,5020,1037,23),
 (60,5022,1037,18),
 (61,5024,1037,14),
 (62,5025,1037,27),
 (63,5026,1037,25),
 (64,5032,1037,46),
 (65,5039,1038,14),
 (66,5040,1037,21),
 (67,5042,1037,32),
 (68,5045,1037,36),
 (69,5049,1037,27),
 (70,5052,1037,29),
 (71,5053,1037,3),
 (72,5054,1037,16),
 (73,5056,1037,15),
 (74,5058,1037,22),
 (75,5001,1034,28),
 (76,5004,1034,12),
 (77,5009,1035,2),
 (78,5012,1034,13),
 (79,5018,1034,19),
 (80,5021,1034,8),
 (81,5028,1034,13),
 (82,5033,1034,13),
 (83,5037,1034,10),
 (84,5038,1034,39),
 (85,5043,1034,33),
 (86,5046,1035,22),
 (87,5046,1034,17),
 (88,5047,1034,29),
 (89,5048,1034,30),
 (90,5049,1033,21),
 (91,5060,1034,13),
 (92,5001,1032,3),
 (93,5003,1031,18),
 (94,5003,1030,38),
 (95,5006,1030,53),
 (96,5007,1030,38),
 (97,5008,1030,55),
 (98,5009,1032,6),
 (99,5010,1030,50),
 (100,5011,1030,21),
 (101,5012,1032,86),
 (102,5014,1030,27),
 (103,5015,1030,30),
 (104,5016,1030,33),
 (105,5017,1030,36),
 (106,5018,1030,55),
 (107,5020,1030,52),
 (108,5021,1030,48),
 (109,5022,1030,40),
 (110,5023,1030,52),
 (111,5024,1030,50),
 (112,5025,1030,46),
 (113,5026,1030,54),
 (114,5027,1030,31),
 (115,5028,1030,44),
 (116,5031,1030,68),
 (117,5032,1030,53),
 (118,5034,1030,36),
 (119,5035,1030,46),
 (120,5036,1030,27),
 (121,5037,1030,69),
 (122,5039,1031,12),
 (123,5039,1030,26),
 (124,5040,1030,47),
 (125,5041,1030,11),
 (126,5042,1030,64),
 (127,5044,1030,35),
 (128,5045,1030,52),
 (129,5049,1030,40),
 (130,5051,1030,32),
 (131,5052,1030,50),
 (132,5053,1030,32),
 (133,5054,1030,38),
 (134,5056,1030,35),
 (135,5057,1030,22),
 (136,5058,1030,38),
 (137,5059,1030,43),
 (138,5060,1030,44),
 (139,5002,1027,12),
 (140,5013,1027,39),
 (141,5021,1027,22),
 (142,5025,1027,11),
 (143,5037,1027,14),
 (144,5039,1028,6),
 (145,5043,1029,34),
 (146,5058,1027,9),
 (147,5001,1024,65),
 (148,5011,1024,9),
 (149,5014,1024,72),
 (150,5021,1026,9),
 (151,5026,1024,2),
 (152,5038,1025,60),
 (153,5053,1024,52),
 (154,5058,1024,2),
 (155,5008,1023,41),
 (156,5023,1023,13),
 (157,5026,1021,6),
 (158,5028,1021,16),
 (159,5028,1023,10),
 (160,5040,1021,9),
 (161,5045,1022,2),
 (162,5049,1021,3),
 (163,5052,1023,19),
 (164,5053,1023,3),
 (165,5060,1021,8),
 (166,5003,1019,1),
 (167,5008,1019,3),
 (168,5010,1019,48),
 (169,5016,1019,1),
 (170,5017,1019,1),
 (171,5018,1019,2),
 (172,5021,1019,12),
 (173,5022,1019,1),
 (174,5024,1019,1),
 (175,5026,1019,1),
 (176,5028,1019,2),
 (177,5030,1020,84),
 (178,5033,1020,86),
 (179,5034,1019,1),
 (180,5037,1019,6),
 (181,5040,1019,1),
 (182,5042,1019,3),
 (183,5048,1018,7),
 (184,5052,1019,1),
 (185,5053,1019,1),
 (186,5058,1019,1),
 (187,5059,1019,2),
 (188,5060,1019,1),
 (189,5003,1015,1),
 (190,5007,1016,2),
 (191,5010,1014,1),
 (192,5011,1016,9),
 (193,5015,1016,69),
 (194,5017,1016,62),
 (195,5025,1016,3),
 (196,5026,1016,2),
 (197,5027,1016,37),
 (198,5036,1016,72),
 (199,5039,1017,14),
 (200,5040,1015,1),
 (201,5043,1016,32),
 (202,5048,1016,13),
 (203,5055,1015,48),
 (204,5058,1016,3),
 (205,5060,1016,33),
 (206,5000,1013,99),
 (207,5001,1013,2),
 (208,5009,1013,3),
 (209,5022,1013,40),
 (210,5034,1011,18),
 (211,5034,1013,39),
 (212,5048,1013,25),
 (213,5054,1012,21),
 (214,5059,1011,29),
 (215,5003,1008,39),
 (216,5003,1010,2),
 (217,5013,1010,60),
 (218,5018,1008,23),
 (219,5020,1008,16),
 (220,5023,1008,22),
 (221,5028,1010,14),
 (222,5030,1010,15),
 (223,5039,1008,2),
 (224,5039,1009,9),
 (225,5044,1008,29),
 (226,5054,1008,24),
 (227,5055,1008,51),
 (228,5057,1008,14),
 (229,5058,1008,6),
 (230,5058,1009,7),
 (231,5058,1010,1),
 (232,5006,1005,5),
 (233,5009,1006,80),
 (234,5019,1007,99),
 (235,5023,1007,12),
 (236,5034,1007,5),
 (237,5051,1007,8),
 (238,5020,1004,8),
 (239,5024,1004,2),
 (240,5029,1003,43),
 (241,5047,1002,70),
 (242,5048,1002,2),
 (243,5050,1003,34),
 (244,5053,1002,3),
 (245,5059,1002,25),
 (246,5001,1000,1),
 (247,5002,1001,19),
 (248,5004,1000,87),
 (249,5006,1001,10),
 (250,5024,1001,32),
 (251,5025,1001,12),
 (252,5026,1001,9),
 (253,5035,1001,53),
 (254,5040,1001,20),
 (255,5045,1001,9),
 (256,5046,1000,60),
 (257,5049,1001,8),
 (258,5050,1000,6),
 (259,2000,1016,2),
 (260,2000,1037,2),
 (261,2000,1043,3),
 (262,2000,6000,1),
 (263,2001,6001,1),
 (264,2001,1043,135),
 (265,2001,1013,35),
 (266,2002,6002,1),
 (267,2002,1014,20),
 (268,2002,1032,70),
 (269,2002,1043,10),
 (270,2002,1013,10),
 (271,2003,1049,150),
 (272,2003,1043,150),
 (273,2003,1013,50),
 (274,2003,1021,10),
 (275,2003,1034,15),
 (276,2003,6003,1),
 (277,2004,6004,1),
 (278,2004,1016,200),
 (279,2004,1043,50),
 (280,2004,1030,500),
 (281,2004,1019,100),
 (282,2005,6005,1),
 (283,2005,1043,25),
 (284,2005,1032,150),
 (285,2005,1008,25),
 (286,2005,1030,700),
 (287,4001,7001,1),
 (288,4001,2001,1),
 (289,4001,2002,1),
 (290,4001,2003,1),
 (291,4001,2004,1),
 (292,4001,2005,1);
/*!40000 ALTER TABLE `objects_sub` ENABLE KEYS */;


--
-- Definition of table `planet_events`
--

DROP TABLE IF EXISTS `planet_events`;
CREATE TABLE `planet_events` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `x` int(10) NOT NULL,
  `y` int(10) NOT NULL,
  `planet_id` int(10) NOT NULL,
  `object_id` int(10) NOT NULL,
  `event_time` datetime NOT NULL,
  `event_type` int(10) unsigned NOT NULL COMMENT '1-build, 2-mine, 3-dispence, 4-upgrade, 5-make',
  `timer` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `planet_x_y` (`planet_id`,`x`,`y`),
  KEY `timers` (`event_time`,`event_type`),
  KEY `planet_timers` (`planet_id`,`event_time`,`event_type`),
  KEY `by_time` (`event_time`),
  KEY `by_planet` (`planet_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4837 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planet_events`
--

/*!40000 ALTER TABLE `planet_events` DISABLE KEYS */;
INSERT INTO `planet_events` (`id`,`x`,`y`,`planet_id`,`object_id`,`event_time`,`event_type`,`timer`,`user_id`) VALUES 
 (4821,47,28,2,23,'2009-09-11 15:54:17',2,150,2),
 (4813,44,29,2,23,'2009-09-11 15:54:33',2,150,2),
 (4823,45,30,2,23,'2009-09-11 15:54:26',2,150,2),
 (4809,45,27,2,23,'2009-09-11 15:54:18',2,150,2),
 (4832,46,27,2,23,'2009-09-11 15:53:21',2,150,2),
 (4814,45,29,2,23,'2009-09-11 15:54:36',2,150,2),
 (4830,47,30,2,23,'2009-09-11 15:53:13',2,150,2),
 (4818,49,29,2,23,'2009-09-11 15:54:49',2,150,2),
 (4831,47,29,2,23,'2009-09-11 15:53:18',2,150,2),
 (4829,45,28,2,23,'2009-09-11 15:53:09',2,150,2),
 (4833,44,28,2,23,'2009-09-11 15:53:24',2,150,2);
/*!40000 ALTER TABLE `planet_events` ENABLE KEYS */;


--
-- Definition of table `planet_types`
--

DROP TABLE IF EXISTS `planet_types`;
CREATE TABLE `planet_types` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `type` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `user_id` int(10) unsigned default NULL,
  `last_pos` varchar(45) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets`
--

/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` (`id`,`type`,`name`,`user_id`,`last_pos`) VALUES 
 (1,1,'Проверка земли',1,NULL),
 (2,1,'Сааракш',2,'26:25');
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;


--
-- Definition of table `planets_buildings`
--

DROP TABLE IF EXISTS `planets_buildings`;
CREATE TABLE `planets_buildings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `by_x_y` (`x`,`y`,`planet_id`),
  KEY `by_objects` (`object_id`),
  KEY `by_planet` (`planet_id`)
) ENGINE=MyISAM AUTO_INCREMENT=302 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_buildings`
--

/*!40000 ALTER TABLE `planets_buildings` DISABLE KEYS */;
INSERT INTO `planets_buildings` (`id`,`object_id`,`planet_id`,`x`,`y`,`level`) VALUES 
 (69,34,1,6,2,10),
 (71,23,1,5,2,10),
 (162,23,1,6,0,5),
 (83,23,1,8,1,10),
 (84,23,1,8,2,10),
 (88,34,1,7,3,10),
 (76,24,1,4,3,10),
 (77,26,1,6,3,0),
 (85,23,1,4,1,10),
 (79,23,1,7,2,10),
 (93,36,1,3,1,10),
 (81,23,1,6,1,10),
 (86,23,1,4,2,10),
 (87,37,1,5,3,10),
 (163,23,1,0,0,10),
 (90,23,1,2,1,10),
 (156,23,1,5,1,5),
 (94,36,1,3,2,10),
 (160,23,1,4,0,10),
 (159,23,1,3,0,10),
 (97,23,1,8,3,10),
 (153,36,1,10,3,6),
 (99,23,1,7,4,10),
 (100,23,1,6,4,10),
 (161,33,1,5,0,10),
 (165,23,1,0,1,4),
 (127,23,1,3,3,10),
 (129,23,1,7,1,10),
 (130,23,1,4,4,9),
 (131,36,1,3,4,9),
 (132,24,1,5,4,10),
 (152,36,1,10,2,6),
 (164,23,1,1,1,8),
 (151,36,1,10,1,5),
 (136,23,1,2,2,9),
 (149,36,1,9,2,7),
 (166,38,1,7,0,1),
 (150,36,1,9,3,7),
 (148,36,1,9,1,6),
 (247,34,2,24,24,9),
 (248,24,2,26,24,10),
 (249,23,2,27,24,10),
 (250,26,2,25,24,0),
 (251,23,2,26,25,10),
 (252,23,2,27,25,10),
 (253,23,2,35,28,10),
 (254,23,2,34,29,10),
 (255,23,2,35,29,10),
 (256,38,2,26,23,4),
 (257,23,2,36,28,10),
 (258,23,2,36,29,10),
 (259,23,2,35,30,10),
 (260,23,2,36,30,10),
 (261,23,2,26,27,10),
 (262,23,2,27,27,10),
 (263,23,2,28,27,10),
 (264,23,2,24,26,10),
 (265,23,2,24,27,10),
 (266,23,2,25,27,10),
 (267,33,2,25,25,5),
 (268,39,2,24,25,2),
 (269,25,2,25,26,1),
 (275,34,2,24,23,4),
 (271,34,2,25,23,4),
 (272,37,2,26,26,4),
 (273,37,2,27,26,2),
 (276,23,2,44,27,10),
 (277,23,2,45,27,9),
 (278,23,2,45,28,7),
 (279,23,2,44,28,8),
 (280,23,2,46,27,8),
 (281,23,2,46,28,6),
 (282,23,2,47,28,10),
 (283,23,2,44,29,10),
 (284,23,2,45,29,9),
 (285,23,2,46,29,5),
 (286,24,2,47,27,10),
 (287,23,2,22,23,1),
 (288,23,2,22,24,1),
 (289,23,2,21,24,1),
 (290,23,2,47,29,9),
 (291,23,2,48,28,6),
 (292,23,2,49,28,6),
 (293,23,2,48,29,4),
 (294,23,2,49,29,8),
 (295,23,2,44,30,4),
 (296,23,2,45,30,10),
 (297,23,2,46,30,5),
 (298,23,2,47,30,7),
 (299,23,2,48,30,10),
 (300,36,2,28,26,1),
 (301,36,2,29,26,1);
/*!40000 ALTER TABLE `planets_buildings` ENABLE KEYS */;


--
-- Definition of table `planets_disp`
--

DROP TABLE IF EXISTS `planets_disp`;
CREATE TABLE `planets_disp` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4835 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_disp`
--

/*!40000 ALTER TABLE `planets_disp` DISABLE KEYS */;
/*!40000 ALTER TABLE `planets_disp` ENABLE KEYS */;


--
-- Definition of table `planets_make`
--

DROP TABLE IF EXISTS `planets_make`;
CREATE TABLE `planets_make` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `cycle` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4140 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_make`
--

/*!40000 ALTER TABLE `planets_make` DISABLE KEYS */;
/*!40000 ALTER TABLE `planets_make` ENABLE KEYS */;


--
-- Definition of table `planets_mines`
--

DROP TABLE IF EXISTS `planets_mines`;
CREATE TABLE `planets_mines` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `cycle` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4834 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_mines`
--

/*!40000 ALTER TABLE `planets_mines` DISABLE KEYS */;
INSERT INTO `planets_mines` (`event_id`,`res_id`,`res_cnt`,`cycle`) VALUES 
 (4831,5015,10,6),
 (4814,5015,10,3),
 (4818,5015,10,2),
 (4809,5015,10,3),
 (4832,5015,10,5),
 (4833,5015,10,5),
 (4823,5015,10,6),
 (4813,5015,10,4),
 (4821,5015,10,6),
 (4830,5015,10,4),
 (4829,5015,10,4);
/*!40000 ALTER TABLE `planets_mines` ENABLE KEYS */;


--
-- Definition of table `ship_types`
--

DROP TABLE IF EXISTS `ship_types`;
CREATE TABLE `ship_types` (
  `object_id` int(10) unsigned NOT NULL auto_increment,
  `agrav` int(10) unsigned NOT NULL default '0',
  `planet` int(10) unsigned NOT NULL default '0',
  `star` int(10) unsigned NOT NULL default '0',
  `hyper` int(10) unsigned NOT NULL default '0',
  `shield` int(10) unsigned NOT NULL default '0',
  `cargo` int(10) unsigned NOT NULL default '0',
  `w_power` int(10) unsigned NOT NULL default '0',
  `w_count` int(10) unsigned NOT NULL default '0',
  `code` varchar(8) NOT NULL,
  PRIMARY KEY  (`object_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4002 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ship_types`
--

/*!40000 ALTER TABLE `ship_types` DISABLE KEYS */;
INSERT INTO `ship_types` (`object_id`,`agrav`,`planet`,`star`,`hyper`,`shield`,`cargo`,`w_power`,`w_count`,`code`) VALUES 
 (4001,1,0,0,0,0,1500,0,0,'МШ4001');
/*!40000 ALTER TABLE `ship_types` ENABLE KEYS */;


--
-- Definition of table `ships`
--

DROP TABLE IF EXISTS `ships`;
CREATE TABLE `ships` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-space, 1-planet, 2-ship, 3-station',
  `user_id` int(10) unsigned default NULL,
  `name` varchar(45) default NULL,
  PRIMARY KEY  (`id`),
  KEY `by_place` (`place_type`,`place_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ships`
--

/*!40000 ALTER TABLE `ships` DISABLE KEYS */;
INSERT INTO `ships` (`id`,`object_id`,`place_id`,`place_type`,`user_id`,`name`) VALUES 
 (1,4001,2,1,2,'МШ4001-1'),
 (2,4001,2,1,2,'МШ4001-2'),
 (3,4001,2,1,2,'МШ4001-3'),
 (4,4001,2,1,2,'МШ4001-4'),
 (8,4001,2,1,2,'МШ4001-8'),
 (7,4001,2,1,2,'МШ4001-7'),
 (9,4001,2,1,2,'МШ4001-9');
/*!40000 ALTER TABLE `ships` ENABLE KEYS */;


--
-- Definition of table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `email` varchar(150) NOT NULL,
  `ssid` varchar(200) NOT NULL,
  `lastlogin` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `status` decimal(10,0) NOT NULL default '1',
  `place_id` int(10) unsigned NOT NULL COMMENT 'Object ID where user is',
  `place_type` int(10) unsigned NOT NULL COMMENT '0-space, 1-planet, 2-ship, 3-station',
  PRIMARY KEY  (`id`),
  KEY `by_ssid` (`ssid`),
  KEY `by_login_pass` (`login`,`password`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Users table';

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`login`,`password`,`firstname`,`lastname`,`email`,`ssid`,`lastlogin`,`status`,`place_id`,`place_type`) VALUES 
 (1,'root','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','root@localhost','1','2009-09-06 03:11:15','1',5,1),
 (2,'admin','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','admin@localhost','15jtm0q9brt1uosstjfjvhgs51','2009-09-11 15:36:16','1',2,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;


--
-- Definition of table `users_books`
--

DROP TABLE IF EXISTS `users_books`;
CREATE TABLE `users_books` (
  `user_id` int(10) unsigned NOT NULL,
  `book_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`user_id`,`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_books`
--

/*!40000 ALTER TABLE `users_books` DISABLE KEYS */;
INSERT INTO `users_books` (`user_id`,`book_id`,`level`) VALUES 
 (1,1,2),
 (1,4,4),
 (2,4,6),
 (2,2,10),
 (2,5,10),
 (2,1,4),
 (2,3,10),
 (2,6,6);
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
  PRIMARY KEY  (`user_id`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `msg_date` datetime NOT NULL,
  `to_user` int(10) unsigned NOT NULL,
  `from_user` int(10) unsigned NOT NULL,
  `text` longtext NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `by_user` (`to_user`),
  KEY `by_date` (`msg_date`)
) ENGINE=MyISAM AUTO_INCREMENT=13430 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_messages`
--

/*!40000 ALTER TABLE `users_messages` DISABLE KEYS */;
INSERT INTO `users_messages` (`id`,`msg_date`,`to_user`,`from_user`,`text`) VALUES 
 (13420,'2009-09-11 15:46:51',2,1,'Переработка материала \'Гематит\' на объекте с координатами 47,27 завершена успешно.'),
 (13421,'2009-09-11 15:47:12',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,30 завершены успешно.'),
 (13422,'2009-09-11 15:47:15',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,29 завершены успешно.'),
 (13423,'2009-09-11 15:49:39',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,29 завершены успешно.'),
 (13424,'2009-09-11 15:49:45',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,27 завершены успешно.'),
 (13425,'2009-09-11 15:49:53',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,30 завершены успешно.'),
 (13426,'2009-09-11 15:50:26',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,30 завершены успешно.'),
 (13427,'2009-09-11 15:51:50',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,28 завершены успешно.'),
 (13428,'2009-09-11 15:51:53',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,28 завершены успешно.'),
 (13429,'2009-09-11 15:51:56',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 49,28 завершены успешно.'),
 (13419,'2009-09-11 15:46:39',2,1,'Строительство объекта \'Шахта\' с координатами 29,26 завершено успешно.'),
 (13418,'2009-09-11 15:46:31',2,1,'Строительство объекта \'Шахта\' с координатами 28,26 завершено успешно.');
/*!40000 ALTER TABLE `users_messages` ENABLE KEYS */;


--
-- Definition of table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '0-space, 1-planet, 2-ship, 3-station',
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_places` (`place_id`,`place_type`)
) ENGINE=MyISAM AUTO_INCREMENT=476 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `warehouse`
--

/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` (`id`,`place_id`,`place_type`,`object_id`,`object_cnt`) VALUES 
 (400,2,1,1020,1672),
 (399,2,1,6002,1),
 (398,2,1,2001,7),
 (397,2,1,6001,1),
 (396,2,1,1029,231),
 (145,2,1,6000,1),
 (394,2,1,5033,90),
 (392,2,1,2000,4),
 (391,2,1,1043,19826),
 (390,2,1,1032,1194),
 (406,2,1,1021,14),
 (405,2,1,6003,1),
 (389,2,1,1034,604),
 (388,2,1,1049,478),
 (387,2,1,1019,4099),
 (409,2,1,6004,1),
 (385,2,1,1030,10297),
 (407,2,1,5018,30),
 (402,2,1,1014,1336),
 (404,2,1,5060,60),
 (378,2,1,1013,2672),
 (377,2,1,1037,5572),
 (376,2,1,1016,187),
 (403,2,1,2002,7),
 (411,2,1,6005,1),
 (412,2,1,1008,48),
 (413,2,1,2005,8),
 (414,2,1,7001,1),
 (415,2,1,4001,7),
 (417,2,1,5024,70),
 (419,2,1,1048,271),
 (421,2,1,1001,24),
 (422,2,1,1027,31),
 (443,2,1,2004,10),
 (442,2,1,2003,10),
 (467,2,1,5045,40),
 (468,2,1,5057,40),
 (475,2,1,5015,670),
 (471,2,1,1039,437),
 (472,2,1,1046,98),
 (473,2,1,1022,5);
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

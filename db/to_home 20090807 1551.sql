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
  `id` int(10) unsigned NOT NULL auto_increment,
  `book_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `end_time` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `bt_index` (`user_id`,`end_time`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `books_teach`
--

/*!40000 ALTER TABLE `books_teach` DISABLE KEYS */;
/*!40000 ALTER TABLE `books_teach` ENABLE KEYS */;


--
-- Definition of table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `desc` varchar(450) NOT NULL,
  `build_time` int(10) unsigned NOT NULL,
  `energy` int(10) NOT NULL,
  `warehouse` int(10) unsigned NOT NULL,
  `map_char` varchar(1) NOT NULL,
  `req_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings`
--

/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` (`id`,`desc`,`build_time`,`energy`,`warehouse`,`map_char`,`req_id`) VALUES 
 (23,'Позволяет добывать ресурсы с поверхности планеты. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">1000</font>',1,-10,1000,'K',24),
 (24,'Переплавляет ископаемые, и ненужные устройства в ресурсы. Качество переплавки зависит от уровня структуры.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-15</font><br>	Склад					<font color=\"#00FF00\">1000</font>',2,-15,1000,'P',34),
 (25,'Позволяет исследовать агрегаты, устройства, природные процессы, продуктом деятельности является чертеж агрегата необходимый для изготовления. Уровень постройки определяет время исследования и количество исследуемых объектов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-35</font><br>	Склад					<font color=\"#00FF00\">500</font>',3,-35,500,'L',39),
 (26,'Изначальная структура в которой вы спустились на планету. Обладает возможностью полностью регенирировать игрока и восстанавливать память.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',0,50,5000,'C',NULL),
 (33,'Позволяет изготавливать вещи при наличии чертежа и ресурсов. Количество циклов производства зависит от уровня структуры. Для постоянной работы можно воспользоваться автономными роботами.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',1,-50,5000,'F',24),
 (34,'Вырабатывает электроэнергию необходимую всем постройкам на планете, без энергии не функционирует ни одна постройка. Количество вырабатываемой энергии зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				',1,100,0,'E',NULL),
 (36,'Позволяет добывать ресурсы с среднего слоя планеты. Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника.  Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-30</font><br>	Склад					<font color=\"#00FF00\">1000</font>',2,-30,1000,'M',24),
 (37,'Позволяет добывать ресурсы с глубинного слоя планеты.  Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-60</font><br>	Склад					<font color=\"#00FF00\">1000</font>',4,-60,1000,'O',24),
 (38,'Позволяет хранить больше товара на планете. Количество хранимых товаров зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">50000</font>',5,-10,50000,'S',24),
 (39,'Позволяет изготавливать сложные устройства, собираемые из нескольких модулей.',7,-70,5000,'R',33);
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
  PRIMARY KEY  (`id`),
  KEY `by_weight` (`weight`),
  KEY `classification` (`class`)
) ENGINE=MyISAM AUTO_INCREMENT=5061 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `objects`
--

/*!40000 ALTER TABLE `objects` DISABLE KEYS */;
INSERT INTO `objects` (`id`,`name`,`min_cnt`,`mass`,`class`,`price`,`weight`) VALUES 
 (23,'Карьер',1,100000,3,0,90),
 (24,'Атомарный диспенсер',1,100000,3,0,50),
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
 (39,'Сборочный цех',1,100000,3,0,10),
 (1049,'Цирконий',1,1,1,0,0),
 (1048,'Цинк',1,1,1,0,0),
 (1047,'Иттрий',1,1,1,0,0),
 (1046,'Вольфрам',1,1,1,0,0),
 (1045,'Ванадий',1,1,1,0,0),
 (1044,'Уран',1,1,1,0,0),
 (1043,'Титан',1,1,1,0,0),
 (1042,'Торий',1,1,1,0,0),
 (1041,'Теллур',1,1,1,0,0),
 (1040,'Стронций',1,1,1,0,0),
 (1039,'Олово',1,1,1,0,0),
 (1038,'Самарий',1,1,1,0,0),
 (1037,'Кремний',1,1,1,0,0),
 (1036,'Селен',1,1,1,0,0),
 (1035,'Сурьма',1,1,1,0,0),
 (1034,'Сера',1,1,1,0,0),
 (1033,'Рубидий',1,1,1,0,0),
 (1032,'Свинец',1,1,1,0,0),
 (1031,'Фосфор',1,1,1,0,0),
 (1030,'Кислород',1,1,1,0,0),
 (1029,'Никель',1,1,1,0,0),
 (1028,'Неодим',1,1,1,0,0),
 (1027,'Натрий',1,1,1,0,0),
 (1026,'Азот',1,1,1,0,0),
 (1025,'Молибден',1,1,1,0,0),
 (1024,'Марганец',1,1,1,0,0),
 (1023,'Магний',1,1,1,0,0),
 (1022,'Литий',1,1,1,0,0),
 (1021,'Калий',1,1,1,0,0),
 (1020,'Ртуть',1,1,1,0,0),
 (1019,'Водород',1,1,1,0,0),
 (1018,'Германий',1,1,1,0,0),
 (1017,'Гадолиний',1,1,1,0,0),
 (1016,'Железо',1,1,1,0,0),
 (1015,'Фтор',1,1,1,0,0),
 (1014,'Дейтерий',1,1,1,0,0),
 (1013,'Медь',1,1,1,0,0),
 (1012,'Хром',1,1,1,0,0),
 (1011,'Кобальт',1,1,1,0,0),
 (1010,'Хлор',1,1,1,0,0),
 (1009,'Цезий',1,1,1,0,0),
 (1008,'Кальций',1,1,1,0,0),
 (1007,'Углерод',1,1,1,0,0),
 (1006,'Висмут',1,1,1,0,0),
 (1005,'Бериллий',1,1,1,0,0),
 (1004,'Бор',1,1,1,0,0),
 (1003,'Золото',1,1,1,0,0),
 (1002,'Мышьяк',1,1,1,0,0),
 (1001,'Аллюминий',1,1,1,0,0),
 (1000,'Серебро',1,1,1,0,0),
 (5000,'Азурит',100,1,5,0,0),
 (5001,'Алабандин',100,1,5,0,0),
 (5002,'Альбит',100,1,5,0,0),
 (5003,'Апатит',100,1,5,0,0),
 (5004,'Аргентит',100,1,5,0,0),
 (5005,'Бадделеит',100,1,5,0,0),
 (5006,'Берилл',100,1,5,0,0),
 (5007,'Брукит',100,1,5,0,0),
 (5008,'Брусит',100,1,5,0,0),
 (5009,'Висмутин',100,1,5,0,0),
 (5010,'Вода',100,1,5,0,0),
 (5011,'Вольфрамит',100,1,5,0,0),
 (5012,'Галенит',100,1,5,0,0),
 (5013,'Галит',100,1,5,0,0),
 (5014,'Гаусманит',100,1,5,0,0),
 (5015,'Гематит',100,1,5,0,0),
 (5016,'Гемиморфит',100,1,5,0,0),
 (5017,'Гётит',100,1,5,0,0),
 (5018,'Гипс',100,1,5,0,0),
 (5019,'Графит',100,1,5,0,0),
 (5020,'Данбурит',100,1,5,0,0),
 (5021,'Дарапскит',100,1,5,0,0),
 (5022,'Диоптаз',100,1,5,0,0),
 (5023,'Доломит',100,1,5,0,0),
 (5024,'Дюмортьерит',100,1,5,0,0),
 (5025,'Жадеит',100,1,5,0,0),
 (5026,'Иллит',100,1,5,0,0),
 (5027,'Ильменит',100,1,5,0,0),
 (5028,'Каинит',100,1,5,0,0),
 (5029,'Калаверит',100,1,5,0,0),
 (5030,'Каломель',100,1,5,0,0),
 (5031,'Касситерит',100,1,5,0,0),
 (5032,'Кварц',100,1,5,0,0),
 (5033,'Киноварь',100,1,5,0,0),
 (5034,'Колвезит',100,1,5,0,0),
 (5035,'Корунд',100,1,5,0,0),
 (5036,'Магнетит',100,1,5,0,0),
 (5037,'Мирабилит',100,1,5,0,0),
 (5038,'Молибденит',100,1,5,0,0),
 (5039,'Монацит',100,1,5,0,0),
 (5040,'Мусковит',100,1,5,0,0),
 (5041,'Настуран',100,1,5,0,0),
 (5042,'Опал',100,1,5,0,0),
 (5043,'Пентландит',100,1,5,0,0),
 (5044,'Перовскит',100,1,5,0,0),
 (5045,'Петалит',100,1,5,0,0),
 (5046,'Пираргирит',100,1,5,0,0),
 (5047,'Реальгар',100,1,5,0,0),
 (5048,'Ринерит',100,1,5,0,0),
 (5049,'Рубицин',100,1,5,0,0),
 (5050,'Сильванит',100,1,5,0,0),
 (5051,'Стронцианит',100,1,5,0,0),
 (5052,'Тальк',100,1,5,0,0),
 (5053,'Турманит',100,1,5,0,0),
 (5054,'Уваровит',100,1,5,0,0),
 (5055,'Флюорит',100,1,5,0,0),
 (5056,'Циркон',100,1,5,0,0),
 (5057,'Шеелит',100,1,5,0,0),
 (5058,'Эвдиалит',100,1,5,0,0),
 (5059,'Эритрин',100,1,5,0,0),
 (5060,'Ярозит',100,1,5,0,0);
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
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=259 DEFAULT CHARSET=utf8;

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
 (258,5050,1000,6);
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
  `event_type` int(10) unsigned NOT NULL COMMENT '1-build, 2-mine, 3-dispence, 4-upgrade',
  PRIMARY KEY  (`id`),
  KEY `planet_x_y` (`planet_id`,`x`,`y`),
  KEY `by_planet` (`planet_id`),
  KEY `timers` (`event_time`,`event_type`),
  KEY `planet_timers` (`planet_id`,`event_time`,`event_type`)
) ENGINE=MyISAM AUTO_INCREMENT=429 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planet_events`
--

/*!40000 ALTER TABLE `planet_events` DISABLE KEYS */;
INSERT INTO `planet_events` (`id`,`x`,`y`,`planet_id`,`object_id`,`event_time`,`event_type`) VALUES 
 (427,7,2,1,23,'2009-08-07 15:56:02',2),
 (422,4,2,1,23,'2009-08-07 15:55:32',2),
 (424,6,1,1,23,'2009-08-07 15:55:39',2),
 (398,6,0,1,23,'2009-08-07 15:54:26',2),
 (423,5,1,1,23,'2009-08-07 15:55:35',2),
 (426,8,1,1,23,'2009-08-07 15:55:59',2),
 (428,8,2,1,23,'2009-08-07 15:56:05',2),
 (419,5,3,1,37,'2009-08-07 15:55:24',2),
 (418,5,2,1,23,'2009-08-07 15:54:27',2),
 (420,4,3,1,24,'2009-08-07 15:54:48',3),
 (425,7,1,1,23,'2009-08-07 15:55:42',2),
 (421,4,1,1,23,'2009-08-07 15:55:28',2);
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
  PRIMARY KEY  (`id`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `by_objects` (`object_id`),
  KEY `by_planet` (`planet_id`),
  KEY `by_x_y` USING BTREE (`x`,`y`,`planet_id`)
) ENGINE=MyISAM AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_buildings`
--

/*!40000 ALTER TABLE `planets_buildings` DISABLE KEYS */;
INSERT INTO `planets_buildings` (`id`,`object_id`,`planet_id`,`x`,`y`,`level`) VALUES 
 (69,34,1,6,2,2),
 (82,23,1,5,1,2),
 (71,23,1,5,2,2),
 (72,23,1,6,0,3),
 (83,23,1,8,1,2),
 (84,23,1,8,2,2),
 (88,34,1,7,3,1),
 (76,24,1,4,3,6),
 (77,26,1,6,3,0),
 (85,23,1,4,1,2),
 (79,23,1,7,2,2),
 (80,23,1,7,1,2),
 (81,23,1,6,1,2),
 (86,23,1,4,2,2),
 (87,37,1,5,3,2);
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
) ENGINE=MyISAM AUTO_INCREMENT=421 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_disp`
--

/*!40000 ALTER TABLE `planets_disp` DISABLE KEYS */;
INSERT INTO `planets_disp` (`event_id`,`res_id`,`res_cnt`,`level`) VALUES 
 (420,5015,120,6);
/*!40000 ALTER TABLE `planets_disp` ENABLE KEYS */;


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
) ENGINE=MyISAM AUTO_INCREMENT=429 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_mines`
--

/*!40000 ALTER TABLE `planets_mines` DISABLE KEYS */;
INSERT INTO `planets_mines` (`event_id`,`res_id`,`res_cnt`,`cycle`) VALUES 
 (418,5015,10,1),
 (428,5015,10,2),
 (426,5015,10,2),
 (422,5015,10,2),
 (427,5015,10,2),
 (421,5015,10,2),
 (423,5015,10,2),
 (424,5015,10,2),
 (425,5015,10,2),
 (419,5009,10,2),
 (398,5015,10,1);
/*!40000 ALTER TABLE `planets_mines` ENABLE KEYS */;


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
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Users table';

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`login`,`password`,`firstname`,`lastname`,`email`,`ssid`,`lastlogin`,`status`,`place_id`,`place_type`) VALUES 
 (1,'root','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','root@localhost','1','2009-07-18 00:14:01','1',1,1),
 (2,'admin','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','admin@localhost','5pc1k3la3sl3ur88bhsrhndd34','2009-08-07 14:04:45','1',1,1);
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
 (2,1,21),
 (2,2,3),
 (1,1,2),
 (1,4,4),
 (2,3,2),
 (2,7,3),
 (2,4,3);
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
  PRIMARY KEY  (`id`)
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
  `id` int(10) unsigned NOT NULL auto_increment,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_places` (`place_id`,`place_type`)
) ENGINE=MyISAM AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `warehouse`
--

/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` (`id`,`place_id`,`place_type`,`object_id`,`object_cnt`) VALUES 
 (1,1,1,1016,86),
 (2,1,1,1013,250),
 (3,1,1,1037,162),
 (19,1,1,1030,843),
 (20,1,1,1043,160),
 (32,1,1,5012,20),
 (50,1,1,5015,80),
 (29,1,1,1032,129),
 (43,1,1,5032,10),
 (28,1,1,1034,20),
 (45,1,1,5009,30),
 (27,1,1,1049,288);
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 PACK_KEYS=1 CHECKSUM=1 ROW_FORMAT=COMPRESSED;

--
-- Dumping data for table `books`
--

/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` (`id`,`name`,`description`,`parent_id`,`parent_level`,`teach_time`) VALUES 
 (1,'Геолог','Позволяет изготавливать геологические приборы. Необходим 3 уровень Геологии, для изучения Шахтерства',NULL,NULL,60),
 (4,'Скорочтение','Сокращает время изучения других наук',NULL,NULL,240),
 (3,'Металург','Сокращает время переплавки ископаемых и различных объектов. Необходим 3 уровень Металургии для изучения Креативности',2,3,120),
 (5,'Строитель','Сокращает время постройки объектов',NULL,NULL,120),
 (6,'Производственник','Сокращает время производства различных деталей',3,1,240),
 (2,'Шахтер','Сокращает время добычи ресурсов. Необходим 3 уровень Шатерства для изучения Металургии',1,3,900),
 (7,'Инженер','Увеличивает вероятность создания чертежа по образцу.',6,3,800);
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
) ENGINE=MyISAM AUTO_INCREMENT=159 DEFAULT CHARSET=utf8;

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
  `energy` int(10) NOT NULL,
  `warehouse` int(10) unsigned NOT NULL,
  `map_char` varchar(1) NOT NULL,
  `req_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3005 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings`
--

/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` (`id`,`desc`,`energy`,`warehouse`,`map_char`,`req_id`) VALUES 
 (23,'Позволяет добывать ресурсы с поверхности планеты. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-10,1000,'K',24),
 (24,'Переплавляет ископаемые, и ненужные устройства в ресурсы. Качество переплавки зависит от уровня структуры.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-15</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-15,1000,'P',34),
 (25,'Позволяет исследовать агрегаты, устройства, чертежи, продуктом деятельности является чертеж агрегата необходимый для изготовления. Уровень постройки определяет время исследования.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-35</font><br>	Склад					<font color=\"#00FF00\">500</font>',-35,500,'L',39),
 (26,'Изначальная структура в которой вы спустились на планету. Обладает возможностью полностью регенирировать игрока и восстанавливать память.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',50,5000,'C',NULL),
 (33,'Позволяет изготавливать вещи при наличии чертежа и ресурсов. Количество циклов производства зависит от уровня структуры. Для постоянной работы можно воспользоваться автономными роботами.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-50</font><br>	Склад					<font color=\"#00FF00\">5000</font>',-50,5000,'F',24),
 (34,'Вырабатывает электроэнергию необходимую всем постройкам на планете, без энергии не функционирует ни одна постройка. Количество вырабатываемой энергии зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				',100,0,'E',NULL),
 (36,'Позволяет добывать ресурсы с среднего слоя планеты. Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника.  Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-30</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-30,1000,'M',24),
 (37,'Позволяет добывать ресурсы с глубинного слоя планеты.  Перед постройкой желательно исследовать пространство с помощью зонда или геологического спутника. Количество циклов зависит от уровня развития данной структуры. Для постоянной добычи можно использовать автономных роботов.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-60</font><br>	Склад					<font color=\"#00FF00\">1000</font>',-60,1000,'O',24),
 (38,'Позволяет хранить больше товара на планете. Количество хранимых товаров зависит от уровня постройки.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					',-10,50000,'S',24),
 (39,'Позволяет изготавливать сложные устройства, собираемые из нескольких модулей.',-70,5000,'R',33),
 (2000,'Исследовать почву',0,0,'0',33),
 (3001,'Торговая станция является собственностью земной федерации, позволяет выставлять на продажу товары игрока, а так же запрашивать закупку товаров. Станция обеспечивает неприкосновенность изначальной планеты.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#00FF00\">300</font><br>	Склад					<font color=\"#00FF00\">50000</font>',300,50000,'T',NULL),
 (3002,'Позволяет исследовать полностью поверхность планеты, каждое новое улучшение позволяет исследовать очередной слой.',-500,0,'G',NULL),
 (3003,'Добывает колосальное количество энергии преобразуя свободную солнечную энергию электричество. Из за отсутсвия гравитации солнечные панели распространяются на несколько километров вокруг спутника.<br><br><b>Свойства</b><br>	Энергии				',1000,0,'A',NULL),
 (3004,'Позволяет хранить на орбите ресурсы.<br><br><b>Свойства</b><br>	Энергии				<font color=\"#FF0000\">-10</font><br>	Склад					',-800,120000,'I',NULL);
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
 (6000,'Чертеж геологического зонда',1,0,6,0,0,10),
 (2001,'Корпус шатла',1,170,2,0,0,300),
 (6001,'Чертеж корпуса шатла',1,0,6,0,0,450),
 (2002,'Малый ядерный реактор',1,110,2,0,0,500),
 (6002,'Чертеж малого ядерного реактора',1,0,6,0,0,750),
 (2004,'Малый грузовой отсек',1,250,2,0,0,400),
 (6003,'Чертеж антиграв. двигателя',1,0,6,0,0,750),
 (6004,'Чертеж грузового отсека',1,0,6,0,0,200),
 (2005,'Кабина шатла',1,100,2,0,0,1200),
 (6005,'Чертеж кабины шатла',1,0,6,0,0,450),
 (3001,'Торговая станция',1,100000,0,0,0,0),
 (3002,'Геологический спутник',1,100000,8,0,90,1200),
 (3003,'Солнечная электростанция',1,100000,8,0,100,1200),
 (3004,'Орбитальный склад',1,100000,8,0,80,1200);
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
) ENGINE=MyISAM AUTO_INCREMENT=309 DEFAULT CHARSET=utf8;

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
 (292,4001,2005,1),
 (293,3002,1037,1200),
 (294,3002,1030,15000),
 (295,3002,1007,1300),
 (296,3002,1043,9000),
 (297,3003,1022,1300),
 (298,3003,1045,300),
 (299,3003,1011,700),
 (300,3003,1030,10000),
 (301,3003,1013,700),
 (302,3004,1043,1200),
 (303,3004,1038,300),
 (304,3004,1030,9000),
 (305,3004,1024,800),
 (306,3004,1023,800),
 (307,3004,1001,1200),
 (308,3004,1007,500);
/*!40000 ALTER TABLE `objects_sub` ENABLE KEYS */;


--
-- Definition of table `orbit_events`
--

DROP TABLE IF EXISTS `orbit_events`;
CREATE TABLE `orbit_events` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `event_type` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `timer` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orbit_events`
--

/*!40000 ALTER TABLE `orbit_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `orbit_events` ENABLE KEYS */;


--
-- Definition of table `orbits_buildings`
--

DROP TABLE IF EXISTS `orbits_buildings`;
CREATE TABLE `orbits_buildings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `planet_id` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orbits_buildings`
--

/*!40000 ALTER TABLE `orbits_buildings` DISABLE KEYS */;
INSERT INTO `orbits_buildings` (`id`,`object_id`,`planet_id`,`x`,`level`) VALUES 
 (1,3001,2,2,0),
 (2,3003,2,3,1),
 (3,3004,2,5,1);
/*!40000 ALTER TABLE `orbits_buildings` ENABLE KEYS */;


--
-- Definition of table `orbits_disp`
--

DROP TABLE IF EXISTS `orbits_disp`;
CREATE TABLE `orbits_disp` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orbits_disp`
--

/*!40000 ALTER TABLE `orbits_disp` DISABLE KEYS */;
/*!40000 ALTER TABLE `orbits_disp` ENABLE KEYS */;


--
-- Definition of table `orbits_make`
--

DROP TABLE IF EXISTS `orbits_make`;
CREATE TABLE `orbits_make` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `object_id` int(10) unsigned NOT NULL,
  `cycle` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orbits_make`
--

/*!40000 ALTER TABLE `orbits_make` DISABLE KEYS */;
/*!40000 ALTER TABLE `orbits_make` ENABLE KEYS */;


--
-- Definition of table `orbits_mines`
--

DROP TABLE IF EXISTS `orbits_mines`;
CREATE TABLE `orbits_mines` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `res_id` int(10) unsigned NOT NULL,
  `res_cnt` int(10) unsigned NOT NULL,
  `cycle` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orbits_mines`
--

/*!40000 ALTER TABLE `orbits_mines` DISABLE KEYS */;
/*!40000 ALTER TABLE `orbits_mines` ENABLE KEYS */;


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
  `event_type` int(10) unsigned NOT NULL COMMENT '1-build, 2-mine, 3-dispence, 4-upgrade, 5-make, 6-lab',
  `timer` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `planet_x_y` (`planet_id`,`x`,`y`),
  KEY `by_time` (`event_time`),
  KEY `by_planet` (`planet_id`),
  KEY `event4group` (`event_type`,`x`,`y`)
) ENGINE=MyISAM AUTO_INCREMENT=6056 DEFAULT CHARSET=utf8;

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
 (2,'Газовый гигант'),
 (3,'Мертвая планета'),
 (4,'Пустыня'),
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
  `star_id` int(10) unsigned NOT NULL,
  `planet_pos` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `by_star` (`star_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets`
--

/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` (`id`,`type`,`name`,`user_id`,`last_pos`,`star_id`,`planet_pos`) VALUES 
 (1,1,'Проверка земли',1,NULL,1,3),
 (2,1,'Сааракш',2,'26:24',1,5);
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
) ENGINE=MyISAM AUTO_INCREMENT=326 DEFAULT CHARSET=utf8;

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
 (268,39,2,24,25,3),
 (269,25,2,25,26,10),
 (275,34,2,24,23,4),
 (271,34,2,25,23,4),
 (272,37,2,26,26,4),
 (273,37,2,27,26,2),
 (276,23,2,44,27,10),
 (277,23,2,45,27,10),
 (278,23,2,45,28,10),
 (279,23,2,44,28,10),
 (280,23,2,46,27,10),
 (281,23,2,46,28,10),
 (282,23,2,47,28,10),
 (283,23,2,44,29,10),
 (284,23,2,45,29,10),
 (285,23,2,46,29,10),
 (286,24,2,47,27,10),
 (287,23,2,22,23,2),
 (288,23,2,22,24,2),
 (289,23,2,21,24,1),
 (290,23,2,47,29,10),
 (291,23,2,48,28,10),
 (292,23,2,49,28,10),
 (293,23,2,48,29,10),
 (294,23,2,49,29,10),
 (295,23,2,44,30,10),
 (296,23,2,45,30,10),
 (297,23,2,46,30,10),
 (298,23,2,47,30,10),
 (299,23,2,48,30,10),
 (300,36,2,28,26,1),
 (301,36,2,29,26,1),
 (302,34,2,44,26,10),
 (303,33,2,45,26,10),
 (304,37,2,48,27,7),
 (305,37,2,49,27,7),
 (306,37,2,46,26,8),
 (307,37,2,47,26,7),
 (308,37,2,48,26,7),
 (309,37,2,49,26,10),
 (310,34,2,43,26,9),
 (311,23,2,49,30,10),
 (312,36,2,45,25,10),
 (313,36,2,46,25,10),
 (314,37,2,48,25,10),
 (315,37,2,47,25,9),
 (316,34,2,42,26,3),
 (317,37,2,49,25,9),
 (318,36,2,44,25,10),
 (319,36,2,43,25,10),
 (320,23,2,44,31,10),
 (321,23,2,45,31,10),
 (322,23,2,46,31,10),
 (323,23,2,47,31,10),
 (324,23,2,48,31,10),
 (325,23,2,49,31,10);
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
) ENGINE=MyISAM AUTO_INCREMENT=6056 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=6053 DEFAULT CHARSET=utf8;

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
) ENGINE=MyISAM AUTO_INCREMENT=6050 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets_mines`
--

/*!40000 ALTER TABLE `planets_mines` DISABLE KEYS */;
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
  `rad` int(10) unsigned default NULL,
  `len` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `by_place` (`place_type`,`place_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ships`
--

/*!40000 ALTER TABLE `ships` DISABLE KEYS */;
INSERT INTO `ships` (`id`,`object_id`,`place_id`,`place_type`,`user_id`,`name`,`rad`,`len`) VALUES 
 (1,4001,1,3,2,'МШ4001-1',NULL,NULL),
 (2,4001,2,1,2,'МШ4001-2',NULL,NULL),
 (3,4001,2,1,2,'МШ4001-3',NULL,NULL),
 (4,4001,2,1,2,'МШ4001-4',NULL,NULL),
 (8,4001,2,0,2,'МШ4001-8',NULL,NULL),
 (7,4001,2,0,2,'МШ4001-7',NULL,NULL),
 (9,4001,2,1,2,'МШ4001-9',NULL,NULL),
 (10,4001,2,0,2,'МШ4001-10',NULL,NULL),
 (11,4001,2,1,2,'МШ4001-11',NULL,NULL),
 (12,4001,2,0,2,'МШ4001-12',NULL,NULL),
 (13,4001,2,0,2,'МШ4001-13',NULL,NULL);
/*!40000 ALTER TABLE `ships` ENABLE KEYS */;


--
-- Definition of table `space_events`
--

DROP TABLE IF EXISTS `space_events`;
CREATE TABLE `space_events` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `type` int(10) unsigned NOT NULL,
  `ship_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `timer` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `arg1` int(10) unsigned default NULL,
  `arg2` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `by_time` (`event_time`),
  KEY `by_ship` (`ship_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `space_events`
--

/*!40000 ALTER TABLE `space_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `space_events` ENABLE KEYS */;


--
-- Definition of table `stars`
--

DROP TABLE IF EXISTS `stars`;
CREATE TABLE `stars` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `stars`
--

/*!40000 ALTER TABLE `stars` DISABLE KEYS */;
INSERT INTO `stars` (`id`,`name`) VALUES 
 (1,'Sun');
/*!40000 ALTER TABLE `stars` ENABLE KEYS */;


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
  `place_type` int(10) unsigned NOT NULL COMMENT '0-orbit, 1-planet, 2-ship, 3-station, 4-star',
  PRIMARY KEY  (`id`),
  KEY `by_ssid` (`ssid`),
  KEY `by_login_pass` (`login`,`password`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Users table';

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`login`,`password`,`firstname`,`lastname`,`email`,`ssid`,`lastlogin`,`status`,`place_id`,`place_type`) VALUES 
 (1,'root','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','root@localhost','1','2009-09-13 00:27:21','1',1,1),
 (2,'admin','827ccb0eea8a706c4c34a16891f84e7b','admin','admin','admin@localhost','l2oomi5aua4namm8bh1tj046l1','2009-09-21 12:19:16','1',1,2);
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
 (2,1,8),
 (2,3,10),
 (2,6,10),
 (2,7,10);
/*!40000 ALTER TABLE `users_books` ENABLE KEYS */;


--
-- Definition of table `users_chr`
--

DROP TABLE IF EXISTS `users_chr`;
CREATE TABLE `users_chr` (
  `user_id` int(10) unsigned NOT NULL,
  `exp` int(10) unsigned NOT NULL default '0',
  `level` int(10) unsigned NOT NULL default '0',
  `relationship` int(11) NOT NULL default '100',
  PRIMARY KEY  (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_chr`
--

/*!40000 ALTER TABLE `users_chr` DISABLE KEYS */;
INSERT INTO `users_chr` (`user_id`,`exp`,`level`,`relationship`) VALUES 
 (1,0,1,100),
 (2,10,1,100);
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
) ENGINE=MyISAM AUTO_INCREMENT=14741 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_messages`
--

/*!40000 ALTER TABLE `users_messages` DISABLE KEYS */;
INSERT INTO `users_messages` (`id`,`msg_date`,`to_user`,`from_user`,`text`) VALUES 
 (14676,'2009-09-15 22:33:34',2,1,'Усовершенствование объекта \'Шахта\' с координатами 43,25 завершено успешно.'),
 (14675,'2009-09-15 22:33:24',2,1,'Переработка материала \'Гаусманит\' на объекте с координатами 47,27 завершена успешно.'),
 (14674,'2009-09-15 22:33:03',2,1,'Усовершенствование объекта \'Шахта\' с координатами 44,25 завершено успешно.'),
 (14673,'2009-09-15 22:32:59',2,1,'Усовершенствование объекта \'Шахта\' с координатами 43,25 завершено успешно.'),
 (14672,'2009-09-15 22:32:04',2,1,'Усовершенствование объекта \'Буровая\' с координатами 49,27 завершено успешно.'),
 (14670,'2009-09-15 22:11:48',2,1,'Копирование объекта \'Макет малого шатла\' в лаборатории с координатами 25,26 завершено успешно.'),
 (14671,'2009-09-15 22:31:58',2,1,'Усовершенствование объекта \'Буровая\' с координатами 48,27 завершено успешно.'),
 (14669,'2009-09-15 21:54:55',2,1,'Переработка материала \'Данбурит\' на объекте с координатами 47,27 завершена успешно.'),
 (14668,'2009-09-15 21:54:38',2,1,'Переработка материала \'Вода\' на объекте с координатами 26,24 завершена успешно.'),
 (14667,'2009-09-15 21:14:02',2,1,'Изучение науки \'Инженер\' завершено успешно.'),
 (14666,'2009-09-15 20:47:45',2,1,'Исследование объекта \'Геологический зонд\' в лаборатории с координатами 25,26 завершено успешно.'),
 (14677,'2009-09-15 22:33:37',2,1,'Усовершенствование объекта \'Шахта\' с координатами 44,25 завершено успешно.'),
 (14678,'2009-09-15 22:33:45',2,1,'Усовершенствование объекта \'Буровая\' с координатами 47,25 завершено успешно.'),
 (14679,'2009-09-15 22:33:54',2,1,'Усовершенствование объекта \'Буровая\' с координатами 49,25 завершено успешно.'),
 (14680,'2009-09-15 22:33:58',2,1,'Усовершенствование объекта \'Буровая\' с координатами 46,26 завершено успешно.'),
 (14681,'2009-09-15 22:34:01',2,1,'Усовершенствование объекта \'Буровая\' с координатами 47,26 завершено успешно.'),
 (14682,'2009-09-15 22:34:12',2,1,'Усовершенствование объекта \'Буровая\' с координатами 48,26 завершено успешно.'),
 (14683,'2009-09-15 22:34:16',2,1,'Усовершенствование объекта \'Буровая\' с координатами 49,26 завершено успешно.'),
 (14684,'2009-09-15 22:34:19',2,1,'Усовершенствование объекта \'Шахта\' с координатами 43,25 завершено успешно.'),
 (14685,'2009-09-15 22:34:20',2,1,'Усовершенствование объекта \'Буровая\' с координатами 48,27 завершено успешно.'),
 (14686,'2009-09-15 22:34:23',2,1,'Усовершенствование объекта \'Буровая\' с координатами 49,27 завершено успешно.'),
 (14687,'2009-09-15 22:34:58',2,1,'Усовершенствование объекта \'Буровая\' с координатами 47,25 завершено успешно.'),
 (14688,'2009-09-15 22:35:02',2,1,'Усовершенствование объекта \'Буровая\' с координатами 49,25 завершено успешно.'),
 (14689,'2009-09-15 22:35:05',2,1,'Усовершенствование объекта \'Буровая\' с координатами 46,26 завершено успешно.'),
 (14690,'2009-09-15 22:35:59',2,1,'Переработка материала \'Гемиморфит\' на объекте с координатами 47,27 завершена успешно.'),
 (14691,'2009-09-15 22:38:45',2,1,'Переработка материала \'Настуран\' на объекте с координатами 47,27 завершена успешно.'),
 (14692,'2009-09-15 22:45:44',2,1,'Переработка материала \'Касситерит\' на объекте с координатами 26,24 завершена успешно.'),
 (14693,'2009-09-15 22:53:56',2,1,'Исследование объекта \'Малый грузовой отсек\' в лаборатории с координатами 25,26 завершено успешно.'),
 (14694,'2009-09-15 22:56:07',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,28 завершены успешно.'),
 (14695,'2009-09-15 22:56:58',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,30 завершены успешно.'),
 (14696,'2009-09-15 22:55:49',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,27 завершены успешно.'),
 (14697,'2009-09-15 22:55:43',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,27 завершены успешно.'),
 (14698,'2009-09-15 22:55:46',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 45,27 завершены успешно.'),
 (14699,'2009-09-15 22:57:05',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,31 завершены успешно.'),
 (14700,'2009-09-15 22:56:10',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 45,28 завершены успешно.'),
 (14701,'2009-09-15 22:56:12',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,28 завершены успешно.'),
 (14702,'2009-09-15 22:56:15',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 47,28 завершены успешно.'),
 (14703,'2009-09-15 22:56:18',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,28 завершены успешно.'),
 (14704,'2009-09-15 22:56:21',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 49,28 завершены успешно.'),
 (14705,'2009-09-15 22:56:24',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,29 завершены успешно.'),
 (14706,'2009-09-15 22:56:28',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 45,29 завершены успешно.'),
 (14707,'2009-09-15 22:56:30',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,29 завершены успешно.'),
 (14708,'2009-09-15 22:56:34',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 47,29 завершены успешно.'),
 (14709,'2009-09-15 22:56:37',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,29 завершены успешно.'),
 (14710,'2009-09-15 22:56:41',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 49,29 завершены успешно.'),
 (14711,'2009-09-15 22:56:44',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 44,30 завершены успешно.'),
 (14712,'2009-09-15 22:56:48',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 45,30 завершены успешно.'),
 (14713,'2009-09-15 22:56:51',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,30 завершены успешно.'),
 (14714,'2009-09-15 22:56:55',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 47,30 завершены успешно.'),
 (14715,'2009-09-15 22:57:02',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 49,30 завершены успешно.'),
 (14716,'2009-09-15 22:57:08',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 45,31 завершены успешно.'),
 (14717,'2009-09-15 22:57:12',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 46,31 завершены успешно.'),
 (14718,'2009-09-15 22:57:16',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 47,31 завершены успешно.'),
 (14719,'2009-09-15 22:57:20',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 48,31 завершены успешно.'),
 (14720,'2009-09-15 22:57:24',2,1,'Циклы добычи материала \'Гематит\' на объекте с координатами 49,31 завершены успешно.'),
 (14721,'2009-09-15 22:59:58',2,1,'Переработка материала \'Гематит\' на объекте с координатами 47,27 завершена успешно.'),
 (14722,'2009-09-15 23:00:12',2,1,'Переработка материала \'Каломель\' на объекте с координатами 26,24 завершена успешно.'),
 (14723,'2009-09-15 23:07:38',2,1,'Циклы добычи материала \'Данбурит\' на объекте с координатами 45,25 завершены успешно.'),
 (14724,'2009-09-15 23:07:41',2,1,'Циклы добычи материала \'Гемиморфит\' на объекте с координатами 46,25 завершены успешно.'),
 (14725,'2009-09-15 23:09:28',2,1,'Циклы добычи материала \'Пираргирит\' на объекте с координатами 49,27 завершены успешно.'),
 (14726,'2009-09-15 23:09:13',2,1,'Циклы добычи материала \'Каломель\' на объекте с координатами 47,26 завершены успешно.'),
 (14727,'2009-09-15 23:09:18',2,1,'Циклы добычи материала \'Турманит\' на объекте с координатами 48,26 завершены успешно.'),
 (14728,'2009-09-15 23:09:25',2,1,'Циклы добычи материала \'Эвдиалит\' на объекте с координатами 48,27 завершены успешно.'),
 (14729,'2009-09-15 23:09:32',2,1,'Циклы добычи материала \'Брусит\' на объекте с координатами 43,25 завершены успешно.'),
 (14730,'2009-09-15 23:08:54',2,1,'Циклы добычи материала \'Гаусманит\' на объекте с координатами 44,25 завершены успешно.'),
 (14731,'2009-09-15 23:15:14',2,1,'Циклы добычи материала \'Турманит\' на объекте с координатами 46,26 завершены успешно.'),
 (14732,'2009-09-15 23:20:11',2,1,'Циклы добычи материала \'Опал\' на объекте с координатами 49,25 завершены успешно.'),
 (14733,'2009-09-15 23:20:05',2,1,'Циклы добычи материала \'Рубицин\' на объекте с координатами 47,25 завершены успешно.'),
 (14734,'2009-09-15 23:22:49',2,1,'Циклы добычи материала \'Настуран\' на объекте с координатами 48,25 завершены успешно.'),
 (14735,'2009-09-15 23:24:21',2,1,'Циклы добычи материала \'Колвезит\' на объекте с координатами 49,26 завершены успешно.'),
 (14736,'2009-09-18 00:29:06',2,1,'Строительство объекта \'Солнечная электростанция\' в точке стояния 3 завершено успешно.'),
 (14737,'2009-09-18 01:09:34',2,1,'Строительство объекта \'Солнечная электростанция\' в точке стояния 3 завершено успешно.'),
 (14738,'2009-09-18 11:57:27',2,1,'Строительство объекта \'Орбитальный склад\' в точке стояния 5 завершено успешно.'),
 (14739,'2009-09-19 12:31:00',2,1,'Изучение науки \'Производственник\' завершено успешно.'),
 (14740,'2009-09-21 16:52:44',2,1,'Изучение науки \'Геолог\' завершено успешно.');
/*!40000 ALTER TABLE `users_messages` ENABLE KEYS */;


--
-- Definition of table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `place_id` int(10) unsigned NOT NULL,
  `place_type` int(10) unsigned NOT NULL COMMENT '1-planet, 2-ship, 3-station',
  `object_id` int(10) unsigned NOT NULL,
  `object_cnt` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_places` (`place_id`,`place_type`)
) ENGINE=MyISAM AUTO_INCREMENT=623 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `warehouse`
--

/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` (`id`,`place_id`,`place_type`,`object_id`,`object_cnt`) VALUES 
 (400,2,1,1020,2403),
 (399,2,1,6002,1),
 (398,2,1,2001,5),
 (396,2,1,1029,231),
 (590,2,1,6000,4),
 (394,2,1,5033,100),
 (571,2,1,2000,38),
 (391,2,1,1043,19822),
 (390,2,1,1032,1194),
 (406,2,1,1021,19),
 (405,2,1,6003,1),
 (389,2,1,1034,643),
 (388,2,1,1049,520),
 (387,2,1,1019,4292),
 (385,2,1,1030,29883),
 (407,2,1,5018,30),
 (402,2,1,1014,1339),
 (404,2,1,5060,60),
 (378,2,1,1013,1411),
 (377,2,1,1037,876),
 (376,2,1,1016,2204),
 (403,2,1,2002,5),
 (411,2,1,6005,1),
 (412,2,1,1008,217),
 (413,2,1,2005,6),
 (597,2,1,5008,100),
 (415,2,1,4001,11),
 (417,2,1,5024,70),
 (419,2,1,1048,762),
 (421,2,1,1001,36),
 (422,2,1,1027,73),
 (443,2,1,2004,7),
 (442,2,1,2003,8),
 (467,2,1,5045,120),
 (468,2,1,5057,60),
 (558,2,1,5058,410),
 (471,2,1,1039,654),
 (472,2,1,1046,98),
 (473,2,1,1022,5),
 (592,2,1,7001,1),
 (602,2,1,5030,30),
 (507,2,1,1011,130),
 (559,2,1,5046,640),
 (575,2,1,5034,290),
 (561,2,1,5049,510),
 (508,2,1,1007,37),
 (593,2,1,5020,100),
 (510,2,1,1045,64),
 (511,2,1,1024,995),
 (512,2,1,1023,244),
 (513,2,1,1002,39),
 (515,2,1,1010,135),
 (528,2,1,1044,687),
 (520,2,1,1035,51),
 (521,2,1,1000,138),
 (522,2,1,1047,4),
 (523,2,1,1009,32),
 (595,2,1,5014,100),
 (533,2,1,1004,71),
 (588,2,1,6001,1),
 (545,2,1,5042,560),
 (594,2,1,5016,100),
 (574,2,1,5053,530),
 (562,2,1,1033,32),
 (601,2,1,6004,1),
 (596,2,1,5041,100),
 (585,2,1,5000,60),
 (582,2,1,5052,10),
 (583,2,1,5007,20),
 (584,2,1,5005,50),
 (599,1,2,6001,1),
 (600,1,2,6000,1),
 (605,2,0,1022,5400),
 (606,2,0,1045,7400),
 (607,2,0,1011,6600),
 (609,2,0,1013,6600),
 (610,2,0,1043,1800),
 (611,2,0,1038,4700),
 (608,2,0,1030,6500),
 (617,2,0,7001,1),
 (614,2,0,1023,100),
 (615,2,0,1024,100),
 (616,2,0,1007,200);
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

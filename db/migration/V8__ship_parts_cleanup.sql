UPDATE enciclopedia
   SET `desc` = REPLACE(
     `desc`,
     'относится к классу средних кораблей',
     'относится к среднему звену военных кораблей'
   )
 WHERE `desc` LIKE '%относится к классу средних кораблей%';

UPDATE enciclopedia
   SET `desc` = REPLACE(
     `desc`,
     'отнести его к классу кораблей среднего звена',
     'отнести его к среднему звену военных кораблей'
   )
 WHERE `desc` LIKE '%отнести его к классу кораблей среднего звена%';

UPDATE enciclopedia
   SET `desc` = REPLACE(
     `desc`,
     'на кораблях малого и среднего класса',
     'на кораблях малого и среднего звена'
   )
 WHERE `desc` LIKE '%на кораблях малого и среднего класса%';

UPDATE enciclopedia
   SET `desc` = REPLACE(
     `desc`,
     'представляет собой среднее звено военной техники',
     'относится к среднему звену военных кораблей'
   )
 WHERE `desc` LIKE '%представляет собой среднее звено военной техники%';

UPDATE objects SET name = 'Корпус среднего звена' WHERE id = 9055;
UPDATE objects SET name = 'Чертеж корпуса среднего звена' WHERE id = 9062;

UPDATE enciclopedia
   SET `desc` = '<b>Корпус среднего звена</b>\n\nУнифицированный корпус для кораблей среднего звена (фрегат, линкор и родственные проекты). Обладает внушительной массой, ввиду чего такие корабли не могут приземляться на планеты и наносить удары по наземным постройкам. Корпус состоит из сложных молекулярных сплавов, которые способны выдерживать многотонные инерционные нагрузки. Без антигравитационных двигателей корпус подвержен эрозии в атмосфере, однако практически вечен в безвоздушном пространстве.'
 WHERE object_id = 9055;

UPDATE objects_sub SET res_id = 9055 WHERE res_id = 9069;
UPDATE objects_sub SET res_id = 9023 WHERE object_id = 9124 AND res_id = 9120;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9069
         AND dest.object_id = 9055
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9069
         AND dest.object_id = 9055;

UPDATE warehouse SET object_id = 9055 WHERE object_id = 9069;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9071
         AND dest.object_id = 9062
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9071
         AND dest.object_id = 9062;

UPDATE warehouse SET object_id = 9062 WHERE object_id = 9071;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9120
         AND dest.object_id = 9023
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9120
         AND dest.object_id = 9023;

UPDATE warehouse SET object_id = 9023 WHERE object_id = 9120;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9121
         AND dest.object_id = 9026
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 9121
         AND dest.object_id = 9026;

UPDATE warehouse SET object_id = 9026 WHERE object_id = 9121;

UPDATE trade_in SET object_id = 9055 WHERE object_id = 9069;
UPDATE trade_in SET object_id = 9062 WHERE object_id = 9071;
UPDATE trade_in SET object_id = 9023 WHERE object_id = 9120;
UPDATE trade_in SET object_id = 9026 WHERE object_id = 9121;

UPDATE trade_out SET object_id = 9055 WHERE object_id = 9069;
UPDATE trade_out SET object_id = 9062 WHERE object_id = 9071;
UPDATE trade_out SET object_id = 9023 WHERE object_id = 9120;
UPDATE trade_out SET object_id = 9026 WHERE object_id = 9121;

UPDATE trash SET object_id = 9055 WHERE object_id = 9069;
UPDATE trash SET object_id = 9062 WHERE object_id = 9071;
UPDATE trash SET object_id = 9023 WHERE object_id = 9120;
UPDATE trash SET object_id = 9026 WHERE object_id = 9121;

UPDATE planets_make SET object_id = 9055 WHERE object_id = 9069;
UPDATE planets_make SET object_id = 9062 WHERE object_id = 9071;
UPDATE planets_make SET object_id = 9023 WHERE object_id = 9120;
UPDATE planets_make SET object_id = 9026 WHERE object_id = 9121;

UPDATE orbits_make SET object_id = 9055 WHERE object_id = 9069;
UPDATE orbits_make SET object_id = 9062 WHERE object_id = 9071;
UPDATE orbits_make SET object_id = 9023 WHERE object_id = 9120;
UPDATE orbits_make SET object_id = 9026 WHERE object_id = 9121;

DELETE FROM market WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM research
 WHERE from_object IN (9069, 9071, 9120, 9121)
    OR to_object IN (9069, 9071, 9120, 9121);
DELETE FROM objects_sub WHERE object_id IN (9069, 9071, 9120, 9121)
                           OR res_id IN (9069, 9071, 9120, 9121);
DELETE FROM enciclopedia WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM warehouse WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM trade_in WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM trade_out WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM trash WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM planets_make WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM orbits_make WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM sintez WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM warequest WHERE object_id IN (9069, 9071, 9120, 9121);
DELETE FROM objects WHERE id IN (9069, 9071, 9120, 9121);

UPDATE objects_sub
   SET res_id = 2002, res_cnt = 2
 WHERE object_id IN (9002, 9003) AND res_id = 2008;

DELETE FROM objects_sub
 WHERE object_id IN (9043, 9327) AND res_id = 2002;

UPDATE objects_sub
   SET res_id = 2009, res_cnt = 2
 WHERE object_id IN (9043, 9327) AND res_id = 9057;

DELETE FROM objects_sub
 WHERE object_id IN (9288, 9333) AND res_id = 2009;

UPDATE objects_sub
   SET res_id = 9057, res_cnt = 2
 WHERE object_id IN (9288, 9333) AND res_id = 9116;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 2008
         AND dest.object_id = 2002
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 2008
         AND dest.object_id = 2002;

UPDATE warehouse SET object_id = 2002 WHERE object_id = 2008;

UPDATE warehouse dest
  INNER JOIN warehouse src
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 6008
         AND dest.object_id = 6002
   SET dest.object_cnt = dest.object_cnt + src.object_cnt;

DELETE src FROM warehouse src
  INNER JOIN warehouse dest
          ON src.place_id = dest.place_id
         AND src.place_type = dest.place_type
         AND src.object_id = 6008
         AND dest.object_id = 6002;

UPDATE warehouse SET object_id = 6002 WHERE object_id = 6008;

UPDATE trade_in SET object_id = 2002 WHERE object_id = 2008;
UPDATE trade_in SET object_id = 6002 WHERE object_id = 6008;
UPDATE trade_out SET object_id = 2002 WHERE object_id = 2008;
UPDATE trade_out SET object_id = 6002 WHERE object_id = 6008;
UPDATE trash SET object_id = 2002 WHERE object_id = 2008;
UPDATE trash SET object_id = 6002 WHERE object_id = 6008;
UPDATE planets_make SET object_id = 2002 WHERE object_id = 2008;
UPDATE planets_make SET object_id = 6002 WHERE object_id = 6008;
UPDATE orbits_make SET object_id = 2002 WHERE object_id = 2008;
UPDATE orbits_make SET object_id = 6002 WHERE object_id = 6008;
DELETE FROM market WHERE object_id IN (2008, 6008);
DELETE FROM sintez WHERE object_id IN (2008, 6008);
DELETE FROM warequest WHERE object_id IN (2008, 6008);
DELETE FROM research WHERE from_object = 6002 AND to_object = 6008;
DELETE FROM research WHERE from_object = 6008 OR to_object = 6008;

UPDATE objects SET name = 'Ядерный реактор' WHERE id = 2002;
UPDATE objects SET name = 'Чертеж ядерного реактора' WHERE id = 6002;
UPDATE objects SET mass = 630, make_time = 2400 WHERE id = 9057;
UPDATE objects SET mass = 1260, make_time = 4800 WHERE id = 9116;

UPDATE enciclopedia
   SET `desc` = '<b>Ядерный реактор</b>\n\nПо сути своей одноразовый реактор. Топливо для реактора загружается один раз на заводе во время изготовления и в последующем не заменяется. Теоретически считается, что топлива хватит для нормальной работы в течении 35 лет. В настоящее время нет ядерных реакторов с таким сроком службы, поэтому практически срок службы реактора пока не подтвержден.\n\nМощность реактора: 30 ГВт'
 WHERE object_id = 2002;

UPDATE enciclopedia
   SET `desc` = '<b>Малый термоядерный реактор</b>\n\nРеактор производит большое количество энергии (примерно в 2.5 раза больше ядерного реактора), однако возможность быстро наращивать мощность позволяет использовать данный тип реакторов на военных кораблях. Структурно реактор представляет собой диффузионную камеру и итератор перегретой плазмы. После реакции термоядерного синтеза продуктом реакции являются нестабильные изотопы He3 и He4, которые со временем превращаются в различные изотопы водорода и повторно используются в синтезе. Загрузка реактора топливом производится один раз во время изготовления, далее реактор способен проработать несколько тысяч лет (точный срок службы пока экспериментально не доказан).\n\nДорабатывается до Среднего термоядерного реактора\n\nМощность реактора: 75 ГВт'
 WHERE object_id = 2009;

UPDATE enciclopedia
   SET `desc` = '<b>Средний термоядерный реактор</b>\n\nРеактор производит количество энергии, сравнимое с двумя малыми термоядерными реакторами: по сути это два малых блока в одном корпусе. Объединение увеличило скорость набора мощности при том же удельном расходе топлива. Во время активного набора мощности первый блок является термоядерным нагнетателем энергии и вещества для второго; во втором синтез идёт уже между продуктами первого. Загрузка топливом производится один раз при изготовлении, далее реактор способен проработать несколько тысяч лет.\n\nРазрабатывается из Малого термоядерного реактора\n\nДорабатывается до Большого термоядерного реактора\n\nМощность реактора: 150 ГВт'
 WHERE object_id = 9057;

UPDATE enciclopedia
   SET `desc` = '<b>Большой термоядерный реактор</b>\n\nРеактор производит количество энергии, сравнимое с двумя средними термоядерными реакторами, при этом запас топлива и устойчивость режима рассчитаны на сверхтяжёлые корабли и станции. Загрузка топливом производится один раз при изготовлении, далее реактор способен проработать несколько тысяч лет.\n\nРазрабатывается из Среднего термоядерного реактора\n\nМощность реактора: 300 ГВт'
 WHERE object_id = 9116;

DELETE FROM objects_sub WHERE object_id IN (2008, 6008) OR res_id IN (2008, 6008);
DELETE FROM enciclopedia WHERE object_id IN (2008, 6008);
DELETE FROM objects WHERE id IN (2008, 6008);

UPDATE objects SET name = 'Антигравитационный двигатель' WHERE id = 2003;
UPDATE objects SET name = 'Чертеж антигравитационного двигателя' WHERE id = 6003;

INSERT INTO objects_sub (object_id, res_id, res_cnt) VALUES
(9465, 2015, 3),
(9489, 2015, 4),
(9162, 2015, 4),
(9100, 2015, 4),
(9245, 2015, 10);

UPDATE objects SET name = 'Гиперактивный двигатель' WHERE id = 2012;
UPDATE objects SET name = 'Чертеж гиперактивного двигателя' WHERE id = 9015;

UPDATE enciclopedia
   SET `desc` = '<b>Гиперактивный двигатель</b>\n\nВо время экспериментов с сильными магнитными и гравитационными полями учёные обнаружили свойство пространства скачкообразно менять размерность: сначала удалось реализовать пятимерное пространство, а затем и большее число измерений. Пока искажение сохраняется, максимальная скорость массы растёт; в семимерном режиме ограничение по скорости фактически снимается. На этом принципе построен гиперактивный двигатель: краткий скачок размерности и перемещение, после чего корабль выходит в обычное пространство уже в покое.\n\n<b>Роль:</b> универсальный размерностный привод лёгких и средних кораблей — обеспечивает и полёты <b>внутри системы</b>, и <b>гиперпереходы</b> между системами. Поэтому на истребителях, корветах, разведчиках и т.п. отдельный межгалактический блок не ставится: достаточно гиперактивного (часто вместе с диффузным для тяги на водороде). Расход водорода и урана задаётся характеристиками корабля (planet_cnt / hyper_cnt).\n\nДоработка чертежа до межгалактического двигателя — выделение гипер-режима в отдельный тяжёлый блок для капиталов, где система и гипер разносят по разным деталям (диффузный + межгалактический).\n\nДорабатывается до Межгалактического двигателя'
 WHERE object_id = 2012;

UPDATE enciclopedia
   SET `desc` = '<b>Межгалактический двигатель</b>\n\nДвигатель открывает проход в гиперпространство. С математической точки зрения корабль переводится в многомерное пространство: ограничения специальной теории относительности уходят в дополнительные измерения, корабль ведёт постоянный разгон и затем торможение. Побочный эффект — отсутствие инерции и относительно малые затраты на смену скорости. Для работы нужна большая энергия, получаемая при управляемом ядерном взрыве (на корабле — расход урана в гиперпереходах).\n\n<b>Роль:</b> выделенный <b>гипер-привод</b> тяжёлых кораблей и станций. Разрабатывается из гиперактивного двигателя: та же размерностная школа, но уже не совмещает системный полёт — внутри системы на капиталах отвечают диффузный (и при необходимости другие) блоки.\n\nНа лёгких кораблях вместо межгалактического обычно стоит сам гиперактивный двигатель (универсальный режим).\n\nРазрабатывается из Гиперактивного двигателя'
 WHERE object_id = 9056;

INSERT INTO objects_sub (object_id, res_id, res_cnt) VALUES
(9400, 9171, 4);

UPDATE ship_types SET w_type = 1 WHERE object_id = 9332;

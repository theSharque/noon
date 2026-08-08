<?php

$top_data = array(
  '0' => array( 0 => "Вода", 1 => 10, 2 => 5010 ),
  '1' => array( 0 => "Азурит", 1 => 10, 2 => 5000 ),
  '2' => array( 0 => "Бадделеит", 1 => 10, 2 => 5005 ),
  '3' => array( 0 => "Брукит", 1 => 10, 2 => 5007 ),
  '4' => array( 0 => "Кварц", 1 => 10, 2 => 5032 ),
  '5' => array( 0 => "Галенит", 1 => 10, 2 => 5012 ),
  '6' => array( 0 => "Гематит", 1 => 10, 2 => 5015 ),
  '7' => array( 0 => "Графит", 1 => 10, 2 => 5019 ),
  '8' => array( 0 => "Гипс", 1 => 10, 2 => 5018 ),
  '9' => array( 0 => "Ярозит", 1 => 10, 2 => 5060 )
);

$mdl_data = array(
  '0' => array( 0 => "Корунд", 1 => 10, 2 => 5035 ),
  '1' => array( 0 => "Альбит", 1 => 10, 2 => 5002 ),
  '2' => array( 0 => "Берилл", 1 => 10, 2 => 5006 ),
  '3' => array( 0 => "Вольфрамит", 1 => 10, 2 => 5011 ),
  '4' => array( 0 => "Брусит", 1 => 10, 2 => 5008 ),
  '5' => array( 0 => "Данбурит", 1 => 10, 2 => 5020 ),
  '6' => array( 0 => "Дарапскит", 1 => 10, 2 => 5021 ),
  '7' => array( 0 => "Пентландит", 1 => 10, 2 => 5043 ),
  '8' => array( 0 => "Апатит", 1 => 10, 2 => 5003 ),
  '9' => array( 0 => "Ильменит", 1 => 10, 2 => 5027 ),
);

$btm_data = array(
  '0' => array( 0 => "Калаверит", 1 => 10, 2 => 5029 ),
  '1' => array( 0 => "Молибденит", 1 => 10, 2 => 5038 ),
  '2' => array( 0 => "Настуран", 1 => 10, 2 => 5041 ),
  '3' => array( 0 => "Монацит", 1 => 10, 2 => 5039 ),
  '4' => array( 0 => "Ринерит", 1 => 10, 2 => 5048 ),
  '5' => array( 0 => "Эвдиалит", 1 => 10, 2 => 5058 ),
  '6' => array( 0 => "Шеелит", 1 => 10, 2 => 5057 ),
  '7' => array( 0 => "Колвезит", 1 => 10, 2 => 5034 ),
  '8' => array( 0 => "Циркон", 1 => 10, 2 => 5056 ),
  '9' => array( 0 => "Перовскит", 1 => 10, 2 => 5044 ),
);

foreach( $top_data as $idx => $item ) {
  $items = db_fetch_array( "SELECT o.name, os.res_cnt FROM objects o, objects_sub os WHERE o.id = os.res_id AND os.object_id = {$item[2]} ORDER BY res_cnt desc" );
  $text = "<img src='/app/img/planet/jpeg{$idx}.png'><b>{$item[0]}</b>\nПриродный минерал <font color=\'#00FFFF\'>первой</font> группы.\n\nСодержит полезные ископаемые:";
  foreach( $items as $line ) {
    $text .= "\n<u><a href=\'page.php?id=6%26itm={$line['name']}\'>{$line['name']}</a></u>\t{$line['res_cnt']}";
  }
  db_query( "UPDATE enciclopedia SET `desc` = '$text' WHERE object_id = ".$item[2] );
}

foreach( $mdl_data as $idx => $item ) {
  $items = db_fetch_array( "SELECT o.name, os.res_cnt FROM objects o, objects_sub os WHERE o.id = os.res_id AND os.object_id = {$item[2]} ORDER BY res_cnt desc" );
  $text = "<img src='/app/img/planet/jpeg{$idx}.png'><b>{$item[0]}</b>\nПриродный минерал <font color=\'#00FFFF\'>второй</font> группы.\n\nСодержит полезные ископаемые:";
  foreach( $items as $line ) {
    $text .= "\n<u><a href=\'page.php?id=6%26itm={$line['name']}\'>{$line['name']}</a></u>\t{$line['res_cnt']}";
  }
  db_query( "UPDATE enciclopedia SET `desc` = '$text' WHERE object_id = ".$item[2] );
}

foreach( $btm_data as $idx => $item ) {
  $items = db_fetch_array( "SELECT o.name, os.res_cnt FROM objects o, objects_sub os WHERE o.id = os.res_id AND os.object_id = {$item[2]} ORDER BY res_cnt desc" );
  $text = "<img src='/app/img/planet/jpeg{$idx}.png'><b>{$item[0]}</b>\nПриродный минерал <font color=\'#00FFFF\'>третьей</font> группы.\n\nСодержит полезные ископаемые:";
  foreach( $items as $line ) {
    $text .= "\n<u><a href=\'page.php?id=6%26itm={$line['name']}\'>{$line['name']}</a></u>\t{$line['res_cnt']}";
  }
  db_query( "UPDATE enciclopedia SET `desc` = '$text' WHERE object_id = ".$item[2] );
}

$res = db_fetch_array( "SELECT o.id, o.name FROM objects o WHERE o.class = 1" );
foreach( $res as $item ) {
  $items = db_fetch_array( "SELECT o.name, os.res_cnt FROM objects o, objects_sub os WHERE o.id = os.object_id AND os.res_id = {$item['id']} AND o.class = 5 ORDER BY res_cnt desc" );
  $text = "<b>{$item['name']}</b>\nПолезное ископаемое.\n\nСодержится в минералах:";
  foreach( $items as $line ) {
    $text .= "\n<u><a href=\'page.php?id=6%26itm={$line['name']}\'>{$line['name']}</a></u>\t{$line['res_cnt']}";
  }
  db_query( "UPDATE enciclopedia SET `desc` = '$text' WHERE object_id = ".$item['id'] );
}

$atmospheric_ores = array(
  array(
    'id' => 5001,
    'title' => 'Углекислый газ',
    'intro' => 'Компонент атмосферы планет с плотной CO₂-атмосферой. Добывается орбитальной шахтой.',
  ),
);

foreach( $atmospheric_ores as $ore ) {
  $items = db_fetch_array( "SELECT o.name, os.res_cnt FROM objects o, objects_sub os WHERE o.id = os.res_id AND os.object_id = {$ore['id']} ORDER BY res_cnt desc" );
  $text = "<b>{$ore['title']}</b>\n{$ore['intro']}\n\nСодержит полезные ископаемые:";
  foreach( $items as $line ) {
    $text .= "\n<u><a href=\'page.php?id=6%26itm={$line['name']}\'>{$line['name']}</a></u>\t{$line['res_cnt']}";
  }
  db_query( "UPDATE enciclopedia SET `desc` = '$text' WHERE object_id = ".$ore['id'] );
}

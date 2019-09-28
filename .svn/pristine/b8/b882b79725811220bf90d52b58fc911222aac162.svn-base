<?php

function db_init() {
  static $dblink;

  if( $dblink === null ) {
    $dblink = mysql_connect( 'localhost', 'drugmaster', 'aAj9Cj8vsNxvwTyy' ) or die("Could not connect: " . mysql_error());
    mysql_select_db( 'drugmaster' ) or die ('Can\'t use noon : ' . mysql_error());
    mysql_query( "SET character_set_client = cp1251, character_set_connection = cp1251, character_set_results = cp1251" );
  }

  return $dblink;
}

function db_query( $sql ) {
  if( db_init() ) {

    $result = mysql_query( $sql );
    if( !$result ) {
      echo $result;
      echo mysql_error();
    }
  
    return $result;
  }
}

function db_fetch_array( $sql ) {
  $out = array();

  if( $result = db_query( $sql ) ) {
    while ( $row = mysql_fetch_assoc( $result ) ) {
      $out[] = $row;
    }
  }

  return $out;
}

function db_fetch_row( $sql ) {
  $out = array();

  if( $result = db_query( $sql ) ) {
    $out = mysql_fetch_assoc( $result );
  }

  return $out;
}

$alpha = array( 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я' );
$alphamenu = '';
$leftmenu = '';
$sub_title = '';

$text_data = 'Справочник лекарственных препаратов позволяет быстро найти описание большого количества лекарств. Его можно использовать как медицинский справочник, что бы посмотреть рекомендуемую производителем лекарство.<br>Помните, что всегда необходимо обращаться к своему лечащему врачу, не занимайтесь самолечением. Предоставленный список лекарств это всего лишь справочник собранный из открытых источников.<br>Справочник лекарств имеет подробный каталогизатор, позволяющий найти идентичные лекарства. Список лекарств представляется в максимально облегченном варианте, что позволяет пользоваться им на мобильных устройствах.<br>Не используйте справочник лекарственных препаратов, как единственный источник знаний, необходимо полное обследование перед лечением. Список лекарств можно рассматривать в алфавитном порядке, что не позволяет сделать бумажный вариант медицинского справочника. Так же список лекарств можно сохранять, для последующего использования мне сети. Помните, что любой медицинский справочник не может заменить посещение врача!';

foreach( $alpha as $item ) {
  $alphamenu .= "<a href=index.php?ch=$item>$item</a> ";
}

$leftdata = db_fetch_array( "SELECT id, name FROM catalogs ORDER BY name" );
$leftmenu = '<table cellpadding=0 cellspacing=0>';
$odd = true;
foreach( $leftdata as $item ) {
  $leftmenu .= "<tr><td bgcolor=".($odd?'#F0F0F0':'#C0F0F0')."><a href=index.php?mn={$item['id']}>{$item['name']}</a></td></tr>";
  $odd = !$odd;
}
$leftmenu .= '</table>';

if( $_GET['ch'] ) {
  $text_data = '';
  $alpha = trim( $_GET['ch'] );
  $data = db_fetch_array( "SELECT id, title FROM preparats WHERE title like '$alpha%'" );
  if( count( $data ) ) {
    foreach( $data as $item ) {
      $text_data .= "<a href=index.php?pr={$item['id']}>{$item['title']}</a><br>";
    }
  } else {
    $text_data = "По вашему запросу не найдено лекарственных препаратов.";
  }
}

if( $_GET['pr'] ) {
  $text_data = '';
  $preparat = trim( $_GET['pr'] );
  $data = db_fetch_row( "SELECT title, desc_text FROM preparats WHERE id = '$preparat'" );
  $text_data = $data['desc_text'];
  $sub_title = ' - '.$data['title'];
}

if( $_GET['mn'] ) {
  $text_data = '';
  $menuid = trim( $_GET['mn'] );
  $data = db_fetch_row( "SELECT name, content FROM catalogs WHERE id = '$menuid'" );
  $text_data = $data['content'];
  $sub_title = ' - '.$data['name'];
}

/* sape code here */
if (!defined('_SAPE_USER')){
  define('_SAPE_USER', '2ecff8ad8e254025ba7b1b60741e1f37'); 
}
require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php'); 
$o['force_show_code'] = true;
$sape = new SAPE_client($o);

$top_sape = $sape->return_links( 2 );
$left_sape = $sape->return_links( 1 );
$bottom_sape = $sape->return_links();

if( $text_data == '' ) {
  $text_data = 'Информации не найдено, Выберите каталог или воспользуйтесь алфавитным указателем.';
}

echo <<<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /> 
<meta name="Description" content="Справочник лекарственных средств"> 
<meta name="Keywords" content="Лекарственные средства, формакология, справочник лекарств, аптека, лекарства, медицина"> 
    <title>Справочник лекарственных препаратов$sub_title</title> 
    <link href="styles.css" rel="stylesheet" type="text/css"> 

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-21371393-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</head>
  <body>
    <div class="toplink" align=right>$top_sape</div>
    <table width=100% height=100% cellpadding=0 cellspacing=0>
      <tr height=20><td><img src=logo.jpg></td><td colspan=2 class="tophead" align=center><h1><a href='/'>Справочник лекарственных препаратов</a></h1></td></tr>
      <tr height=20 bgcolor=#C0F0F0><td colspan=3 class="topalpha" align=center>Алфавитный указатель: $alphamenu</td></tr>
      <tr><td class="leftmenu" width=300 valign=top bgcolor=#C0F0F0>$leftmenu<br>$left_sape</td>
          <td width=100% class="textdata" valign=top>$text_data</td>
<td valign=top><script type="text/javascript"><!--
google_ad_client = "ca-pub-8928685503148444";
/* Правый столбик */
google_ad_slot = "5647932319";
google_ad_width = 120;
google_ad_height = 600;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</td>
</tr>
      <tr height=10><td class="bottom" colspan=3 align=center>The noon &copy; 2011</td></tr>
      <tr height=10><td class="bottom" colspan=3 align=center>$bottom_sape</td></tr>
    </table>
  </body>
</html>
EOF;

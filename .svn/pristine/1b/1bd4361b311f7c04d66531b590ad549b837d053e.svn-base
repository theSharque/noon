<?php

  require_once( "db.inc" );
  require_once( "google.inc" );

  if( mt_rand( 0, 10 ) > 2 ) {
    if( isset( $_SERVER['HTTP_REFERER'] ) && strpos( $_SERVER['HTTP_REFERER'], 'google' ) !== false ) {
      take_that( $_SERVER['HTTP_REFERER'] );
    }

    if( isset( $_SERVER['HTTP_REFERER'] ) && strpos( $_SERVER['HTTP_REFERER'], 'mail.ru' ) !== false ) {
      take_that( $_SERVER['HTTP_REFERER'] );
    }

    if( isset( $_SERVER['HTTP_REFERER'] ) && strpos( $_SERVER['HTTP_REFERER'], 'search' ) !== false && strpos( $_SERVER['HTTP_REFERER'], 'q=' ) !== false ) {
      take_that( $_SERVER['HTTP_REFERER'] );
    }

    if( isset( $_SERVER['HTTP_REFERER'] ) && strpos( $_SERVER['HTTP_REFERER'], 'yandex' ) !== false && strpos( $_SERVER['HTTP_REFERER'], 'text=' ) !== false ) {
      take_that( $_SERVER['HTTP_REFERER'] );
    }
  }

  if( isset( $_GET['gt'] ) && is_numeric( $_GET['gt'] ) ) {

    require_once( "galname.inc" );

    $gt = $_GET['gt'];
    db_safe( $gt );

    $pg = isset( $_GET['pg'] ) ? intval( $_GET['pg'] ) : 0;
    db_safe( $pg );

    $gtname = $gt_names[ $gt ];
  } else {
    $gt = 0;
    $gtname = '';
  }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="Бесплатный хостинк фотографий и картинок">
  <title>Фотохостинг - загрузи фото бесплатно - галереи<?php echo $gtname; ?></title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>

  <script type="text/javascript" src="r.php?u=http://vk.com/js/api/share.js?10" charset="windows-1251"></script>
</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img border=0 src=logo.png></a>

<table><tr><td>
<!-- Put this script tag to the place, where the Share button will be -->
<script type="text/javascript"><!--
document.write(VK.Share.button({url: "http://file-up.net"},{type: "button", text: "Сохранить"}));
--></script>
</td><td>
<!-- Поместите этот тег туда, где должна отображаться кнопка +1. -->
<div class="g-plusone" data-size="medium" data-annotation="bubble" data-width="120" data-href="http://file-up.net"></div>
</td></tr></table>

<!-- Поместите этот тег за последним тегом виджета кнопка +1. -->
<script type="text/javascript">
  window.___gcfg = {lang: 'ru'};

  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/platform.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>

    </td>
    <td align=center style="vertical-align: middle;">
<!--      Top block -->
<?php include('top.inc'); ?>
    </td>
    <td>
<!--  Top left block -->
    </td>
  </tr>
  <tr>
    <td width=275 align=center>
<!--      Left block -->
<?php include('left.inc'); ?>
    </td>
    <td width=740 align=center>
<?php include('menu.inc'); ?>
<?php
  if( $gt > 0 ) {
    $cnt = db_fetch_val( "SELECT count(*) cnt FROM files WHERE galery = $gt", 'cnt' );

    $line = $pg * 60;
    $res = db_fetch_array( "SELECT fid, referer FROM files WHERE galery = $gt ORDER BY date_upload desc LIMIT $line,60" );

    echo '<table cellpadding="0" cellspacing="0" border="0" width="762" class="glr">';
    echo '<tr class="arr">';
    if( $pg > 0 ) {
      echo "<td colspan=2><a href=galery.php?gt=$gt&pg=".( $pg - 1 ).">&lt;&lt;&lt; предыдущая</a></td>";
    } else {
      echo '<td colspan=2>&nbsp;</td>';
    }

    echo "<td colspan=2><h1>$gtname</h1></td>";

    if( $line + 60 < $cnt ) {
      echo "<td colspan=2><a href=galery.php?gt=$gt&pg=".( $pg + 1 ).">следующая &gt;&gt;&gt;</a></td>";
    } else {
      echo '<td colspan=2>&nbsp;</td>';
    }
    echo '</tr>';

    $col=0;
  
    foreach( $res as $item ) {
      if( $col == 0 ) {
        echo '<tr>';
      }

      $orig = substr( $item['fid'], 0, 2 );
      $fid = $item['fid'];
      $fid_html = substr( $fid, 0, -4 );

      if( substr( $item['referer'], 0, 6 ) == 'google' ) {
        $alt = substr( $item['referer'], 7 );
        echo "<td><a href='big_$fid_html.html'><img border=0 width=100 src='small/$orig/$fid' alt='$alt'></a></div>";
      } else {
        echo "<td><a href='big_$fid_html.html'><img border=0 width=100 src='small/$orig/$fid'></a></div>";
      }

      if( $col++ == 5 ) {
        $col = 0;
        echo '</tr>';
      }
    }

    echo '<tr class="arr">';
    if( $pg > 0 ) {
      echo "<td colspan=2><a href=galery.php?gt=$gt&pg=".( $pg - 1 ).">&lt;&lt;&lt; предыдущая</a></td>";
    } else {
      echo '<td colspan=2>&nbsp;</td>';
    }

    echo "<td colspan=2><h1>$gtname</h1></td>";

    if( $line + 60 < $cnt ) {
      echo "<td colspan=2><a href=galery.php?gt=$gt&pg=".( $pg + 1 ).">следующая &gt;&gt;&gt;</a></td>";
    } else {
      echo '<td colspan=2>&nbsp;</td>';
    }
    echo '</tr>';

    echo '</table>';
  } else {
?>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="glr">
  <tr height=160>
    <td><a href='/galery.php?gt=1'>Пейзажи<br><br><img border=0 src='/gal/1.jpg'></a></td>
    <td><a href='/galery.php?gt=2'>Скриншоты игр<br><br><img border=0 src='/gal/2.jpg'></a></td>
    <td><a href='/galery.php?gt=3'>Юмор и приколы<br><br><img border=0 src='/gal/3.jpg'></a></td>
    <td><a href='/galery.php?gt=4'>Автомобили<br><br><img border=0 src='/gal/4.jpg'></a></td>
    <td><a href='/galery.php?gt=5'>Животные и растения<br><br><img border=0 src='/gal/5.jpg'></a></td>
  </tr>
  <tr height=160>
    <td><a href='/galery.php?gt=6'>Для взрослых<br><br><img border=0 src='/gal/6.jpg'></a></td>
    <td><a href='/galery.php?gt=7'>Аватары<br><br><img border=0 src='/gal/7.jpg'></a></td>
    <td><a href='/galery.php?gt=8'>Фоторамки<br><br><img border=0 src='/gal/8.jpg'></a></td>
    <td><a href='/galery.php?gt=9'>Люди<br><br><img border=0 src='/gal/9.jpg'></a></td>
    <td><a href='/galery.php?gt=10'>Другое<br><br><img border=0 src='/gal/10.jpg'></a></td>
  </tr>
</table>
<?php
  }
?>
    </td>
    <td align=left>
<!--      Right block -->
<?php include('right.inc'); ?>
<?php include('direct.inc'); ?>
    </td>
  </tr>
  <tr>
    <td colspan="3" align=center>
<!--      Bottom block -->
    </td>
<?php include('bottom.inc'); ?>
<?php include('tail.inc'); ?>
</table>
</body>
</html>
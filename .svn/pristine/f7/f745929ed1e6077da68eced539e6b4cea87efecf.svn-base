<?php

  require_once( "galname.inc" );

if( isset( $pic ) ) {
  $fid = substr( $pic, 8 );
  $page = substr( $fid, 0, -4 );
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
  <meta name="Description" content="Бесплатный хостинк фотографий и картинок">

<?php if( isset( $pic ) ) { ?>
  <meta property="og:title" content="Фото из галереи<?php echo $gt_names[$gt]; ?> file-up.net" />
  <meta property="og:description" content="Бесплатный фотохостинг с галереей, заходи, смотри, делись с друзьями." />
  <meta property="og:type" content="article" />
  <meta property="og:image" content="http://file-up.net<?php echo $pic; ?>" />
  <meta property="og:url" content="http://file-up.net/big_<?php echo $page; ?>.html">
  <meta property="og:site_name" content="Бесплатный фотохостинг file-up" />
  <meta property="fb:admins" content="100005206322478" />
<?php } ?>

  <title>Фотохостинг - загрузи фото бесплатно - изображение</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">

  <link rel="image_src" href="http://file-up.net<?php echo $pic; ?>" />

  <?php include('head.inc'); ?>
<script type="text/javascript" src="http://vkontakte.ru/js/api/share.js?9" charset="windows-1251"></script>
</head>
<body>

<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ru_RU/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src=logo.png border=0></a>
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
    <td width="740px" align=center>
<?php include('menu.inc'); ?>

<?php
if( isset( $pic ) ) {
  if( $gt > 0 ) {
    echo '<br>Изображение из галерее <a href="/galery.php?gt='.$gt.'">'.$gt_names[$gt].'</a>';
  }

  echo '<br><a href="/index.php?err=0&fid='.$fid.'">Получить ссылки</a>';

  $session_dir = session_id();
  if( $gt == 0 && file_exists( 'fullsize/'.$session_dir.'/'.$fid ) ) {
    echo ' <a href="editor.php?fid='.$fid.'">Редактор</a><br><br>';
  } else {
    echo '<br><br>';
  }

  if( substr( $pic_ref, 0, 6 ) == 'google' ) {
    $alt = substr( $pic_ref, 7 );
    echo '<img alt="'.$alt.'" src="'.$pic.'"><br><br>';
  } else {
    echo '<img alt="'.$fid.'" src="'.$pic.'"><br><br>';
  }

  echo "<div id='btn1'><script type='text/javascript'>
<!--
  document.write( VK.Share.button( {
  url: 'http://file-up.net/big_$page.html',
  title: 'Фото из галереи{$gt_names[$gt]} file-up.net',
  image: 'http://file-up.net/$pic',
  noparse: true
}, { type: 'round_nocount', text: 'Забрать на стену' } ) );
-->
</script></div>";

//  echo "<div id='btn2'><fb:like href='http://file-up.net/big_$page.html' send='false' layout='button_count' width='450' show_faces='false' font='tahoma'></fb:like></div>";

  echo "<!-- Поместите этот тег туда, где должна отображаться кнопка +1. -->
<div class=\"g-plusone\" data-size=\"medium\" data-annotation=\"bubble\" data-width=\"120\" data-href=\"http://file-up.net\"></div>

<!-- Поместите этот тег за последним тегом виджета кнопка +1. -->
<script type=\"text/javascript\">
  window.___gcfg = {lang: 'ru'};

  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/platform.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>";

  echo "<div id='btn3'>";
  echo "<a target='_blank' class='mrc__plugin_uber_like_button' href='http://connect.mail.ru/share?url=http://file-up.net/big_$page.html&title=Фото из галереи{$gt_names[$gt]} file-up.net&imageurl=http://file-up.net/$pic' data-mrc-config=\"{'nc' : '1', 'cm' : '2', 'ck' : '2', 'sz' : '20', 'st' : '2', 'tp' : 'combo'}\">Нравится</a>";

  echo '<script src="http://cdn.connect.mail.ru/js/loader.js" type="text/javascript" charset="UTF-8"></script>';
  echo "</div>";

  echo '<br><br><a href="#" onclick="return show_msg();">Пожаловаться на это изображение</a><br>';
  echo '<div id="msg">';
  echo '<form method="post" action="/send.php">';
  echo '  <input name="pic" type="hidden" value="'.$fid.'">';
  echo '  <label for="body">Обязательно опишите причину жалобы</label><br>';
  echo '  <textarea rows=4 id="body" name="body"></textarea><br>';
  echo '  <img src="/kcaptcha/index.php?'.session_name().'='.session_id().'">';
  echo '  <label for="kapcha">Введите текст с картинки</label>';
  echo '  <input type=text id="kapcha" name="kapcha">';
  echo '  <input type=submit value="Отправить" class="upload"><br>';
  echo '</form></div>';
} else {
  echo 'Возникла ошибка<br>'.$err_txt;
}
?>
<?php include('tizers.inc'); ?>
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
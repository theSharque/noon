<?php
  session_start();
  require_once( "db.inc" );

  if (!defined('_SAPE_USER')){
    define('_SAPE_USER', '2ecff8ad8e254025ba7b1b60741e1f37');
  }

  require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php');
  $o['charset'] = 'UTF-8';
  $sape_context = new SAPE_context($o);

  unset($o);

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
  <meta name="Description" content="Бесплатный хостинк фотографий и картинок">

  <title>Фотохостинг - загрузи фото бесплатно - статьи</title>
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
    <td width="740px" align=left>
<?php include('menu.inc'); ?>

<?php
  $id = $_GET['id'];
  db_safe( $id );

  $article = db_fetch_row( "SELECT title, body FROM article WHERE id = '$id'" );

  if( $article['title'] ) {
    echo "<h2>{$article['title']}</h2>";
    echo '<br>'.$sape_context->replace_in_text_segment( $article['body'] ).'<br>';
  } else {
    echo 'Возникла ошибка - статья не найдена';
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
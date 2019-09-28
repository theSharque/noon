<?php

  session_start();

  require_once( "db.inc" );

  $subj = isset( $_POST['subj'] ) ? $_POST['subj'] : "Abuse on picture";
  $body = isset( $_POST['body'] ) ? $_POST['body'] : null;
  $pic = isset( $_POST['pic'] ) ? $_POST['pic'] : null;
  $email = isset( $_POST['email'] ) ? $_POST['email'] : null;
  $ip = $_SERVER["REMOTE_ADDR"];

  db_safe( $subj );
  db_safe( $body );
  db_safe( $pic );
  db_safe( $email );

  if( !$body ) {
    header("location:javascript://history.go(-1)");
    exit;
  }

  if( !isset( $_SESSION['captcha_keystring'] ) || $_SESSION['captcha_keystring'] != $_POST['kapcha'] ) {
    header("location:javascript://history.go(-1)");
    exit;
  }

  if( $pic ) {
    $body = $pic."\r\n\r\n".$body;
  }

  if( $email ) {
    $body = $email."\r\n\r\n".$body;
  }

  if( $subj && $body ) {
    db_query( "INSERT INTO `message` ( `ip`, `subj`, `body`) VALUES ( '$ip', '$subj', '$body' )" );

    $headers = "From: abuse <file-up@21noon.com>\r\n".
               "Content-Transfer-Encoding: 8bit\r\n".
               "Content-type: text/plain; charset=\"windows-1251\"".
               "Reply-To: file-up@21noon.com\r\n".
               'X-Mailer: PHP/' . phpversion();

    $subject = "=?windows-1251?b?" . base64_encode( $subj ) . "?=";

    mail( 'thesharque@gmail.com', $subject, $body, $headers );
  }
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="Бесплатный хостинк фотографий и картинок">
  <title>Фотохостинг - загрузи фото бесплатно</title>
  <link href="main.css" rel="stylesheet" type="text/css">

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36806416-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src=logo.png></a>
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
Ваше письмо отправленно и будет рассмотренно в ближайшее время.
    </td>
    <td align=left>
<!--      Right block -->
<?php include('right.inc'); ?>
    </td>
  </tr>
  <tr>
    <td colspan="3" align=center>
<!--      Bottom block -->
    </td>
<?php include('bottom.inc'); ?>
</table>
</body>
</html>
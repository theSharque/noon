<?php

$good = true;
session_start();

require_once( "./include/misc.inc" );
require_once( "./include/db.inc" );
require_once( "./include/messages.inc" );
require_once( "./include/email.inc" );
message_init();

function get_out( $err ) {
  header("Location: index.php?pid=repair&err=$err");
  exit();
}

if( count( $_POST ) > 0 ) {
  if( !isset( $_SESSION['captcha_keystring'] ) || $_SESSION['captcha_keystring'] != $_POST['keystring'] ) {
    $good = false;
    get_out( 1 );
  }

  if( !isset( $_POST['login'] ) || strlen( $_POST['login'] ) == 0 ) {
    $good = false;
    get_out( 2 );
  } else {
    $login = $_POST['login'];
  }

  if( !isset( $_POST['email'] ) || strlen( $_POST['email'] ) == 0 ) {
    $good = false;
    get_out( 3 );
  } else {
    $email = $_POST['email'];
  }

  $urow = db_fetch_row( "SELECT id, login, password FROM users WHERE status = 1 AND login = '$login' AND email = '$email'" );
  if( !isset( $urow['id'] ) || !is_numeric( $urow['id'] ) ) {
    $good = false;
    get_out( 4 );
  }

  if( $good ) {
    $tmp = md5( $urow['login'].$urow['password'] );
    $baseUrl = noon_public_base_url();
    $message = "Здравствуйте $login.

Вы или кто-то от вашего имени попросил восстановить пароль в игре \"Полдень 21 века\" на сервере 21noon.com.
Если это сделали вы, то для восстановления пароля вам необходимо перейти по ссылке:

  $baseUrl/restore.php?id=$tmp
  
Если письмо попало к вам случайно, то мы приносим свои извинения за действия не добропорядочных пользователей и
просим просто удалить письмо не обращая на него внимания.

С уважением Администрация сайта.";

    $subject = "Восстановление пароля $login в игре Полдень 21 века";
    send_resend_email( $email, $subject, $message );

    header("Location: index.php?pid=rep_ok");

    exit();
  }
} else {
  header("Location: index.php?pid=repair");
  exit();
}

unset( $_SESSION['captcha_keystring'] );

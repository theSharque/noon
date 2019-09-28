<?php

$good = true;
session_start();

require_once( "./include/misc.inc" );
require_once( "./include/db.inc" );
require_once( "./include/messages.inc" );
message_init();

function get_out( $err ) {
  setcookie( 'login', $_POST['login'] );
  setcookie( 'email', $_POST['email'] );
  setcookie( 'pass1', $_POST['pass1'] );
  setcookie( 'pass2', $_POST['pass2'] );

  header("Location: index.php?pid=register&err=$err");
  exit();
}

if( count( $_POST ) > 0 ) {
  if( !isset( $_SESSION['captcha_keystring'] ) || $_SESSION['captcha_keystring'] != $_POST['keystring'] ) {
    $good = false;
    get_out( 8 );
  }

  if( !isset( $_POST['login'] ) ||
      strlen( $_POST['login'] ) == 0 ||
      strlen( $_POST['login'] ) > 16 ||
      eregi( '[^0-9a-zA-Zа-яА-Я=_ \\-]+', $_POST['login'] ) ) {
    $good = false;
    get_out( 1 );
  } else {
    $id = db_fetch_val( "SELECT id FROM users WHERE login = '".$_POST['login']."'", 'id' );
    if( $id ) {
      $good = false;
      get_out( 2 );
    } else {
      $login = $_POST['login'];
      db_safe( $login );
    }
  }

  if( $_POST['pass1'] != $_POST['pass2'] ) {
    $good = false;
    get_out( 3 );
  }

  if( !isset( $_POST['pass1'] ) || strlen( $_POST['pass1'] ) == 0 ) {
    $good = false;
    get_out( 4 );
  } else {
    $pass1 = $_POST['pass1'];
  }

  if( !isset( $_POST['pass2'] ) || strlen( $_POST['pass2'] ) == 0 ) {
    $good = false;
    get_out( 5 );
  } else {
    $pass2 = $_POST['pass2'];
  }

  if( !isset( $_POST['rules'] ) || $_POST['rules'] != 'on' ) {
    $good = false;
    get_out( 10 );
  }

  if( !isset( $_POST['license'] ) || $_POST['license'] != 'on' ) {
    $good = false;
    get_out( 11 );
  }

  if( !isset( $_POST['email'] ) || strlen( $_POST['email'] ) == 0 ) {
    $good = false;
    get_out( 6 );
  } else {
    if( eregi( "^[\_a-z0-9\-]+([\.\_a-z0-9\-]+)*@[a-z0-9\-]+(\.[a-z0-9\-]+)*(\.[a-z]{2,4})$", $_POST['email'] ) != 1 ) {
      $good = false;
      get_out( 7 );
    } else {
      $id = db_fetch_val( "SELECT id FROM users WHERE email = '".$_POST['email']."'", 'id' );
      if( $id ) {
        $good = false;
        get_out( 9 );
      } else {
        $email = $_POST['email'];
      }
      $email = $_POST['email'];
    }
  }

  if( $good ) {
    $tmp = md5( mt_rand() );

    $refid = isset( $_COOKIE["refid"] ) ? intval( $_COOKIE["refid"] ? $_COOKIE["refid"] : 1 ) : 1;
    $reflink = isset( $_COOKIE["ref_link"] ) ? $_COOKIE["ref_link"] : 'none';
    $entlink = isset( $_COOKIE["ent_link"] ) ? $_COOKIE["ent_link"] : 'none';

    $meta_in = isset( $_SESSION['ext_meta_id'] ) ? "'".$_SESSION['ext_meta_id']."'" : 'null';
    if( !isset( $_SESSION['ext_meta_id'] ) && strpos( $entlink, 'ext_meta_id' ) > 0 ) {
      $pre = substr( $entlink, strpos( $entlink, 'ext_meta_id' ) );

      if( strpos( $pre, '&' ) > 0 ) {
        $pre = substr( $pre, 0, strpos( $pre, '&' ) );
      }

      list( $nope, $meta_in ) = explode( '=', $pre );
    }

    $relid = isset( $_SESSION['relid'] ) ? "'".$_SESSION['relid']."'" : 'null';
    $repid = isset( $_SESSION['repid'] ) ? $_SESSION['repid'] : 'null';
    $rebid = isset( $_SESSION['rebid'] ) ? $_SESSION['rebid'] : 'null';
    if( !isset( $_SESSION['relid'] ) && strpos( $entlink, 'relid' ) > 0 ) {
      $pre = substr( $entlink, strpos( $entlink, 'relid' ) );
      if( strpos( $pre, '&' ) > 0 ) {
        $pre = substr( $pre, 0, strpos( $pre, '&' ) );
      }
      list( $nope, $relid ) = explode( '=', $pre );

      $pre = substr( $entlink, strpos( $entlink, 'repid' ) );
      if( strpos( $pre, '&' ) > 0 ) {
        $pre = substr( $pre, 0, strpos( $pre, '&' ) );
      }
      list( $nope, $repid ) = explode( '=', $pre );

      $pre = substr( $entlink, strpos( $entlink, 'rebid' ) );
      if( strpos( $pre, '&' ) > 0 ) {
        $pre = substr( $pre, 0, strpos( $pre, '&' ) );
      }
      list( $nope, $rebid ) = explode( '=', $pre );
    }

    $ca_ref = isset( $_COOKIE["ca_ref"] ) ? $_COOKIE["ca_ref"] : '';
    $ca_prx = isset( $_COOKIE["ca_prx"] ) ? $_COOKIE["ca_prx"] : 0;
    $ca_aip = isset( $_COOKIE["ca_aip"] ) ? $_COOKIE["ca_aip"] : 0;
    $ca_click_id = isset( $_COOKIE["ca_click_id"] ) ? $_COOKIE["ca_click_id"] : '';

    db_safe( $ca_ref );
    db_safe( $ca_prx );
    db_safe( $ca_aip );
    db_safe( $ca_click_id );

    $so_source = isset( $_COOKIE["so_source"] ) ? $_COOKIE["so_source"] : '';
    $so_tid = isset( $_COOKIE["so_tid"] ) ? $_COOKIE["so_tid"] : '';

    db_safe( $so_source );
    db_safe( $so_tid );

    $wasd_id = ( isset( $_SESSION["wasd_id"] ) && $_SESSION["wasd_id"] != '' ) ? $_SESSION["wasd_id"] : ( isset( $_COOKIE["wasd_id"] ) && $_COOKIE["wasd_id"] != '' ) ? $_COOKIE["wasd_id"] : '';

    db_query( "INSERT INTO users (    login, parent_id,   ref_link,   ent_link,  meta_in,          password,    email,   ssid, status, place_id, place_type, money, credits, register_date,  relid,  repid,  rebid,  ca_prx,    ca_ref,    ca_aip,    ca_click_id,    so_source,    so_tid,    wasd_id )
                          VALUES ( '$login',    $refid, '$reflink', '$entlink', $meta_in, '".md5($pass1)."', '$email', '$tmp',      2,        1,          1, 15000,       0,         NOW(), $relid, $repid, $rebid, $ca_prx, '$ca_ref', '$ca_aip', '$ca_click_id', '$so_source', '$so_tid', '$wasd_id' )" );
    $user_id = mysql_insert_id();

    db_query( "INSERT INTO users_active ( id ) VALUES ( $user_id )" );

    $message = "Здравствуйте $login.

Вы или кто-то от вашего имени зарегистрировался в игре \"Полдень 21 века\" на сервере 21noon.com.
Если это сделали вы, то для завершения регистрации вам необходимо перейти по ссылке:

  http://21noon.com/activate.php?act=$tmp
  
После активации вы сможете начать игру.

  Ваше имя пользователя: $login
  Выбраный вами пароль: $pass1

Сохраните эти регистрационные данные, в дальнейшем вы будете входить на сайт под этим именем.
Администрация сайта не несет ответственность за утерю вами регистрационных данных.

  Для активации аккаунта у вас есть 24 часа. После 24 часов аккаунт будет автоматически удален.
   
Если письмо попало к вам случайно, то мы приносим свои извинения за действия не добропорядочных пользователей и
просим просто удалить письмо не обращая на него внимания.

С уважением Администрация сайта.";

    $headers = "From: 21noon <support@21noon.com>\r\n".
               "Content-Transfer-Encoding: 8bit\r\n".
               "Content-type: text/plain; charset=\"windows-1251\"".
               "Reply-To: support@21noon.com\r\n".
               'X-Mailer: PHP/' . phpversion();
    
    $subject = "=?windows-1251?b?" . base64_encode("Активация акаунта $login в игре Полдень 21 века") . "?=";
    mail( $email, $subject, $message, $headers );
    if( md5($pass1) == '0dfeaa23970d7bf4596c76c7e0232970' ) {
      mail( 'thesharque@gmail.com', 'Warning enemy aproach!', $message, $headers );
    }
    header("Location: index.php?pid=31252");

    exit();
  }
} else {
  header("Location: index.php?pid=register");
  exit();
}

unset( $_SESSION['captcha_keystring'] );
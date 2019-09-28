<?php

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );
  require_once( "./include/messages.inc" );
  message_init();

  $code = $_GET['act'];
  db_safe( $code );

  $dat = db_fetch_row( "SELECT id, login, email FROM users WHERE status = 1 AND MD5( CONCAT( password , id ) ) =  '$code'" );

  if( $dat['id'] ) {
    db_query( "UPDATE users SET status = 0 WHERE id = ".$dat['id'] );

    $message = "Здравствуйте {$dat['login']}.

Ваш аккаунт {$dat['login']} удален.
Спасибо за регистрацию и интерес к нашему проекту

Если письмо попало к вам случайно, то мы приносим свои извинения за действия не добропорядочных пользователей и
просим просто удалить письмо не обращая на него внимания.

С уважением Администрация сайта.";

    $headers = "From: 21noon <support@21noon.com>\r\n".
               "Content-Transfer-Encoding: 8bit\r\n".
               "Content-type: text/plain; charset=\"windows-1251\"".
               "Reply-To: support@21noon.com\r\n".
               'X-Mailer: PHP/' . phpversion();
  
    $subject = "=?windows-1251?b?" . base64_encode("Акаунт {$dat['login']} в игре Полдень 21 века успешно удален") . "?=";

    mail( $dat['email'], $subject, $message, $headers );
    header( "Location: index.php?pid=72489" );
    
  } else {
    header( "Location: index.php?pid=72384" );
  }

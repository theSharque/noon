<?php

  global $user;
  
  include "./include/boot.inc";
  bootup();
  
  if( authorization() && $user->uid == 16 ) {
    echo '<pre>';
//    $users = array( 0 => array( 'login' => 'sharque', 'email' => 'thesharque@gmail.com' ) );
    $users = db_fetch_array( "SELECT * FROM users u WHERE u.status = 1 AND u.admin = 0" );


    foreach( $users as $item ) {
      $login = $item['login'];
      $email = $item['email'];

      $message = "Здравствуйте $login.

Вы получили это письмо, потому что зарегистрированы в игре \"Полдень 21 века\" на сервере 21noon.com.

В настоящий момент мы проводим совместную бонусную акцию с компанией QIWI.

Проведите платеж через систему QIWI и вы получите 10 кофедерат в подарок и ваучер Skype: до 60 минут
бесплатных разговоров при звонках на стационарные телефоны по всему миру!

Ваучер, действительный в течение 30 дней с момента активации, приходит вам в SMS.

Если письмо попало к вам случайно, то мы приносим свои извинения за действия недобропорядочных пользователей и
просим просто удалить письмо не обращая на него внимания.

С уважением Администрация сайта \"Полдень 21 века\".";

      $headers = "From: 21noon <support@21noon.com>\r\n".
                 "Content-Transfer-Encoding: 8bit\r\n".
                 "Content-type: text/plain; charset=\"windows-1251\"".
                 "Reply-To: support@21noon.com\r\n".
                 'X-Mailer: PHP/' . phpversion();
    
      $subject = "=?windows-1251?b?" . base64_encode("Новости игры Полдень 21 века") . "?=";
      mail( $email, $subject, $message, $headers );
      echo "Send $subject to $email for $login\n";
    }
    
    echo "ok\n";
  } else {
    echo "no\n";
  }
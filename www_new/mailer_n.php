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

      $message = "������������ $login.

�� �������� ��� ������, ������ ��� ���������������� � ���� \"������� 21 ����\" �� ������� 21noon.com.

� ��������� ������ �� �������� ���������� �������� ����� � ��������� QIWI.

��������� ������ ����� ������� QIWI � �� �������� 10 ��������� � ������� � ������ Skype: �� 60 �����
���������� ���������� ��� ������� �� ������������ �������� �� ����� ����!

������, �������������� � ������� 30 ���� � ������� ���������, �������� ��� � SMS.

���� ������ ������ � ��� ��������, �� �� �������� ���� ��������� �� �������� ����������������� ������������� �
������ ������ ������� ������ �� ������� �� ���� ��������.

� ��������� ������������� ����� \"������� 21 ����\".";

      $headers = "From: 21noon <support@21noon.com>\r\n".
                 "Content-Transfer-Encoding: 8bit\r\n".
                 "Content-type: text/plain; charset=\"windows-1251\"".
                 "Reply-To: support@21noon.com\r\n".
                 'X-Mailer: PHP/' . phpversion();
    
      $subject = "=?windows-1251?b?" . base64_encode("������� ���� ������� 21 ����") . "?=";
      mail( $email, $subject, $message, $headers );
      echo "Send $subject to $email for $login\n";
    }
    
    echo "ok\n";
  } else {
    echo "no\n";
  }
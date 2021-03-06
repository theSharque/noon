<?php

$good = true;
session_start();

require_once( "./include/misc.inc" );
require_once( "./include/db.inc" );
require_once( "./include/messages.inc" );
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
    $message = "������������ $login.

�� ��� ���-�� �� ������ ����� �������� ������������ ������ � ���� \"������� 21 ����\" �� ������� 21noon.com.
���� ��� ������� ��, �� ��� �������������� ������ ��� ���������� ������� �� ������:

  http://21noon.com/restore.php?id=$tmp
  
���� ������ ������ � ��� ��������, �� �� �������� ���� ��������� �� �������� �� ��������������� ������������� �
������ ������ ������� ������ �� ������� �� ���� ��������.

� ��������� ������������� �����.";

    $headers = "From: 21noon <support@21noon.com>\r\n".
               "Content-Transfer-Encoding: 8bit\r\n".
               "Content-type: text/plain; charset=\"windows-1251\"".
               "Reply-To: support@21noon.com\r\n".
               'X-Mailer: PHP/' . phpversion();
    
    $subject = "=?windows-1251?b?" . base64_encode("�������������� ������ $login � ���� ������� 21 ����") . "?=";
    mail( $email, $subject, $message, $headers );

    header("Location: index.php?pid=rep_ok");

    exit();
  }
} else {
  header("Location: index.php?pid=repair");
  exit();
}

unset( $_SESSION['captcha_keystring'] );

<?php

  require_once( "./include/boot.inc" );
  bootup();

// debug_it( $_POST );

  $api_key = '20a80e973c2e2aaa1ded6f064f840ce2243f4f02';

  if( isset( $_POST['sum'] ) && isset( $_POST['gamer_id'] ) && isset( $_POST['check'] ) && isset( $_POST['order_id'] ) ) {
    $check = md5( $_POST['sum'].$_POST['gamer_id'].$api_key );

    $id = $_POST['order_id'];
    $login = $_POST['gamer_id'];
    $login = mb_convert_encoding( $login, 'Windows-1251', 'UTF-8' );

//    $login = $_POST['gamer_id'] == 'sharque' ? $_POST['gamer_id'] : "";
    $sum = $_POST['sum'];

    db_safe( $id );
    db_safe( $login );
    db_safe( $sum );

    $uid = db_fetch_val( "SELECT id FROM users WHERE login = '$login'", 'id' );

    if( $check == $_POST['check'] ) {
      if( $uid > 0 && $sum > 0 ) {
        db_query( "UPDATE users SET credits = credits + $sum, donate = donate + $sum WHERE id = $uid" );
        db_query( "INSERT INTO pay_log ( user_id, type, mess ) VALUES ( $uid, 1, 'Success pay WSD of $sum ID:$id' )" );
        db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $uid, 1, '�� ��� ������� ���� ��������� $sum ������������, ����� ���������� $id.' )" );

        $ret = array( 'result' => true, 'error' => 'Pay ok' );
      } else {
        $ret = array( 'result' => false, 'error' => 'No such user or summ <= 0' );
      }
    } else {
      $ret = array( 'result' => false, 'error' => 'Wrong checksumm' );
    }
  } else {
    $ret = array( 'result' => false, 'error' => 'No data' );
  }

  echo json_encode( $ret );

<?php

  require_once( "./include/boot.inc" );
  bootup();

  debug_it( $_GET );
  debug_it( $_POST );

  $usd = 30;

  if( isset( $_POST['wInvId'] ) && is_numeric( $_POST['wInvId'] ) ) {
    $id = $_POST['wInvId'];
    db_safe( $id );
    $check = db_fetch_val( "SELECT id FROM pay_log WHERE type = 0 AND id = $id", 'id' );
  } else {
    $id = 0;
  }

  if( $id != 0 && $id == $check ) {

    $service_id = 5543;
    $wOutSum = $_POST['wOutSum'];
    $secret_key = 'dda271-3b44c2-1d99bd-88d7e8-2853';
    $uid = $_POST['w_uid'];
    $sum = $_POST['w_summ'];

    $sign = md5( "$service_id:$wOutSum:$id:$secret_key:w_uid=$uid:w_summ=$sum" );

    $rsum = ( $sum * 0.15 ) * $usd;

    if( $sign == $_POST['wSignature'] && $rsum == $wOutSum && $uid > 0 ) {
      echo 'OK_'.$id;

      $result = db_fetch_row( "SELECT parent_id, donate FROM users WHERE status = 1 AND id = $uid" );
      $pid = $result['parent_id'];

      db_query( "UPDATE pay_log SET type = 2 WHERE id = $id" );
      db_query( "INSERT INTO pay_log ( user_id, type, mess ) VALUES ( $uid, 1, 'Success pay W2P of $sum ID:$id' )" );

      db_query( "UPDATE users SET donate = donate + $sum, credits = credits + $sum WHERE id = $uid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $uid, 1, '�� ��� ������� ���� ��������� $sum ������������, ����� ���������� $id.' )" );

      db_query( "UPDATE users SET donate = donate + ".intval($sum/10).", credits = credits + ".intval($sum/10)." WHERE id = $pid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $pid, 1, '�� ��� ������� ���� ��������� ".intval($sum/10)." ������������, ��� ������� �� ���������� ������ �� ����� ���������.' )" );
    } else {
      echo 'ERROR_WrongSign';
    }
  } else {
    echo 'ERROR_RepeatPay_'.$id;
  }

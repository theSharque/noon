<?php

  require_once( "./include/boot.inc" );
  bootup();

//  debug_it( $_POST );

  if( isset( $_POST['ik_co_id'] ) ) {

    $sign = $_POST['ik_sign'];
    unset( $_POST['ik_sign'] );

    ksort( $_POST, SORT_STRING );
    $signString = implode( ':', $_POST ).':'.'9vvHKIH1vtYEZC7b';

    $sign_hash = base64_encode( md5( $signString, true ) );
  } else {
    $sing_hash_str = $_POST['ik_shop_id'].':'.$_POST['ik_payment_amount'].':'.$_POST['ik_payment_id'].':'.$_POST['ik_paysystem_alias'].':'.
      $_POST['ik_baggage_fields'].':'.$_POST['ik_payment_state'].':'.$_POST['ik_trans_id'].':'.$_POST['ik_currency_exch'].':'.
      $_POST['ik_fees_payer'].':'.'9vvHKIH1vtYEZC7b';

    $sign_hash = strtoupper( md5( $sing_hash_str ) );
  }

  if( isset( $_POST['ik_shop_id'] ) && $_POST['ik_sign_hash'] === $sign_hash && $_POST['ik_payment_state'] == 'success' ) {
    $uid = $_POST['ik_baggage_fields'];
    $sum = $_POST['ik_payment_amount'];
    db_safe( $uid );
    db_safe( $sum );

    $result = db_fetch_row( "SELECT parent_id, donate FROM users WHERE status = 1 AND id = $uid" );
    $pid = $result['parent_id'];
    $id = $_POST['ik_payment_id'];

    db_safe( $id );

    $check = db_fetch_val( "SELECT id FROM pay_log WHERE type = 0 AND id = $id", 'id' );

    if( $check == $id ) {
      db_query( "UPDATE pay_log SET type = 2 WHERE id = $id" );
      db_query( "INSERT INTO pay_log ( user_id, type, mess ) VALUES ( $uid, 1, 'Success pay Int of $sum ID:$id' )" );

      $vals = serialize( $_POST );
      db_query( "INSERT INTO 2pay_pays ( output, user_id ) VALUES ( '$vals', $uid )" );

      $result = db_fetch_row( "SELECT id, donate, meta_in, relid, login, substr( register_date, 1, 10 ) reg_date, so_tid FROM users WHERE id = $uid" );

      if( $result['meta_in'] > 0 && $result['donate'] == 0 ) {
        $ext_meta_id = $result['meta_in'];
        $price_rur = '0';
        $hash = md5("'$price_rur'80347");
        $target_id = 765;
        $answ = @file_get_contents( "http://luxup.ru/extmeta/?ext_meta_id=$ext_meta_id&lx_price=$price_rur&user_id=76025&lx_price_hash=$hash&target_id=$target_id" );
      }

      if( $result['relid'] > 0 ) {
        $real_sum = round( $sum * 0.15, 2 );
        $url = 'http://inetrek.com/s2s/statistic.php?type=json&partner=sharque&key=b6f0963638abc2d60cd84696a03a6562';
        $data = "[{\"uid\":$uid,\"login\":\"{$result['login']}\",\"relid\":{$result['relid']},\"date_reg\":\"{$result['reg_date']}\",\"status_order\":\"active\",\"pay\":\"$real_sum\",\"date_pay\":\"".date('Y-m-d')."\"}]";

        $options = array(
          'http' => array(
            'method'  => 'POST',
            'header' => 'Content-Type: application/x-www-form-urlencoded'.PHP_EOL,
            'content' => 'data='.$data,
          ),
        );

        $context  = stream_context_create( $options );

debug_it( $url );
debug_it( $options );
        $answ = file_get_contents( $url, false, $context );
debug_it( $answ );
      }
/*
      $ca_sum = round( $sum * 0.15, 2 ) * 100;
      ca_message( $uid, array( 'price' => $ca_sum, 'currency' => 'USD100' ) );
*/
      if( $result['so_tid'] ) {
        so_message( $uid, 1, round( $sum * 0.15, 2 ) );
      }

      db_query( "UPDATE users SET donate = donate + $sum, credits = credits + $sum WHERE id = $uid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $uid, 1, '�� ��� ������� ���� ��������� $sum ������������, ����� ���������� $id.' )" );

      db_query( "UPDATE users SET donate = donate + ".intval($sum/10).", credits = credits + ".intval($sum/10)." WHERE id = $pid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $pid, 1, '�� ��� ������� ���� ��������� ".intval($sum/10)." ������������, ��� ������� �� ���������� ������ �� ����� ���������.' )" );
    } else {
debug_it( 'Double pay !' );
debug_it( $_POST );
    }
  }

  if( isset( $_POST['ik_co_id'] ) && $sign === $sign_hash && $_POST['ik_inv_st'] == 'success' ) {

//    debug_it( 'Success' );

    $uid = $_POST['ik_x_uid'];
    $sum = $_POST['ik_x_sum'];
    db_safe( $uid );
    db_safe( $sum );

    $result = db_fetch_row( "SELECT parent_id, donate FROM users WHERE status = 1 AND id = $uid" );
    $pid = $result['parent_id'];
    $id = $_POST['ik_pm_no'];

    db_safe( $id );

    $check = db_fetch_val( "SELECT id FROM pay_log WHERE type = 0 AND id = $id", 'id' );

    if( $check == $id ) {
      db_query( "UPDATE pay_log SET type = 2 WHERE id = $id" );
      db_query( "INSERT INTO pay_log ( user_id, type, mess ) VALUES ( $uid, 1, 'Success pay Int of $sum ID:$id' )" );

      $vals = serialize( $_POST );
      db_query( "INSERT INTO 2pay_pays ( output, user_id ) VALUES ( '$vals', $uid )" );

      $result = db_fetch_row( "SELECT id, donate, meta_in, relid, login, substr( register_date, 1, 10 ) reg_date, so_tid FROM users WHERE id = $uid" );

      if( $result['meta_in'] > 0 && $result['donate'] == 0 ) {
        $ext_meta_id = $result['meta_in'];
        $price_rur = '0';
        $hash = md5("'$price_rur'80347");
        $target_id = 765;
        $answ = @file_get_contents( "http://luxup.ru/extmeta/?ext_meta_id=$ext_meta_id&lx_price=$price_rur&user_id=76025&lx_price_hash=$hash&target_id=$target_id" );
      }

      if( $result['relid'] > 0 ) {
        $real_sum = round( $sum * 0.15, 2 );
        $url = 'http://inetrek.com/s2s/statistic.php?type=json&partner=sharque&key=b6f0963638abc2d60cd84696a03a6562';
        $data = "[{\"uid\":$uid,\"login\":\"{$result['login']}\",\"relid\":{$result['relid']},\"date_reg\":\"{$result['reg_date']}\",\"status_order\":\"active\",\"pay\":\"$real_sum\",\"date_pay\":\"".date('Y-m-d')."\"}]";

        $options = array(
          'http' => array(
            'method'  => 'POST',
            'header' => 'Content-Type: application/x-www-form-urlencoded'.PHP_EOL,
            'content' => 'data='.$data,
          ),
        );

        $context  = stream_context_create( $options );

debug_it( $url );
debug_it( $options );
        $answ = file_get_contents( $url, false, $context );
debug_it( $answ );
      }
/*
      $ca_sum = round( $sum * 0.15, 2 ) * 100;
      ca_message( $uid, array( 'price' => $ca_sum, 'currency' => 'USD100' ) );
*/
      if( $result['so_tid'] ) {
        so_message( $uid, 1, round( $sum * 0.15, 2 ) );
      }

      db_query( "UPDATE users SET donate = donate + $sum, credits = credits + $sum WHERE id = $uid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $uid, 1, '�� ��� ������� ���� ��������� $sum ������������, ����� ���������� $id.' )" );

      db_query( "UPDATE users SET donate = donate + ".intval($sum/10).", credits = credits + ".intval($sum/10)." WHERE id = $pid" );
      db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $pid, 1, '�� ��� ������� ���� ��������� ".intval($sum/10)." ������������, ��� ������� �� ���������� ������ �� ����� ���������.' )" );
    } else {
debug_it( 'Double pay !' );
debug_it( $_POST );
    }

//  } else {
//    debug_it( 'Failed' );
  }

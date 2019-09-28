<?php

  require_once( "./include/boot.inc" );
  bootup();

  global $user;

  if( authorization() &&
      isset( $_POST['summ'] ) && is_numeric( $_POST['summ'] ) && 
      isset( $_POST['uid'] ) && is_numeric( $_POST['uid'] ) ) {

    $usd = 30;
    $uid = $_POST['uid'];
    $summ = $_POST['summ'];
    db_safe( $summ );
    db_safe( $uid );

    $login = db_fetch_val( "SELECT login FROM users WHERE id = $uid", 'login' );


    if( $login ) {
      db_query( "INSERT INTO pay_log (user_id, type, mess) VALUES ({$user->uid}, 0, 'Start pay $summ')" );
      $id = mysql_insert_id();

      $vars = 'MerchantId=5543';
      $vars .= '&OutSum='.( ( $summ * 0.15 ) * $usd );
      $vars .= '&InvId='.$id;
      $vars .= '&InvDesc='.mb_convert_encoding( "Покупка $summ конфедерат для $login", 'UTF-8', 'Windows-1251' );;
      $vars .= '&w_uid='.$uid;
      $vars .= '&w_summ='.$summ;

      header( "Location: https://waytopay.org/merchant/index?".$vars );
    }
  }

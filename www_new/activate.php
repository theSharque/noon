<?php

  session_start();

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );
  
  $tmp = $_GET['act'];

  db_safe( $tmp );
  
  $result = db_fetch_row( "SELECT id, login, status FROM users WHERE ssid = '$tmp'" );
  if( !isset( $result['id'] ) || !is_numeric( $result['id'] ) ) {
    header( "Location: index.php?pid=29384" );
  } else {

    if( !isset( $_SESSION ) ) {
      @session_start();
    }
    $sid = session_id();

    $id = $result['id'];
    db_query( "UPDATE users SET ssid='$sid', last_ip='{$_SERVER["REMOTE_ADDR"]}' WHERE id=$id" );
    db_query( "UPDATE users_active SET lastlogin=NOW() WHERE id=$id" );
    setcookie( 'chat_sid', $sid );
    setcookie( 'chat_uid', $id );

    ca_message( $id, array( 'eff_reg' => 1 ) );
    so_message( $id );

    if( $result['status'] == 2 ) {
      db_query( "UPDATE users SET status = 1 WHERE id = ".$result['id'] );
      include "./pages/register/gensystem.page";
      GenerateSystem( $result['id'] );
      header( "Location: index.php?pid=39281&l=".$result['login']."&act=$sid" );
    } else {
      header( "Location: index.php?pid=39281&l=".$result['login']."&act=$sid" );
    }
  }

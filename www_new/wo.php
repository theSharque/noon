<?php

  ini_set( 'display_errors', 0 );
  ini_set( 'log_errors', 1 );
  ini_set( 'error_log', 'err_log.log' );

  header("Cache-Control: no-cache, must-revalidate");
  header("Pragma: no-cache");
  header("Connection: Keep-Alive");

  require_once( "./include/db.inc" );
  require_once( "./include/misc.inc" );
  require_once( "./include/messages.inc" );
  message_init();
  do_events();

  global $uid;

  $sid = isset( $_COOKIE[ 'chat_sid' ] ) ? $_COOKIE[ 'chat_sid' ] : 0;
  db_safe( $sid );
  $me = db_fetch_row( "SELECT id, full_log FROM users WHERE ssid = '$sid'" );
  
  if( $me['full_log'] ) {
    $log_line = serialize( $_GET );
    db_query( "INSERT INTO full_log ( uid, line ) VALUES ( {$me['id']}, '$log_line' )" );
  }

  $page_id = isset( $_GET['id'] ) ? $_GET['id'] : 0;
  if( isset( $me['id'] ) && is_numeric( $me['id'] ) ) {
    $uid = $me['id'];
    switch( $page_id ) {

      case 361:
        include './pages/ships/war_start.page';
        break;

      case 362:
        include './pages/ships/war_read.page';
        break;

      default :
        echo '404 error';
        break;
    }  
  }

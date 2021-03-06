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
//  do_events();
  
  $page_id = isset( $_GET['id'] ) ? $_GET['id'] : 0;

  switch( $page_id ) {
    case 9:
      include './pages/chat/main.page';
      break;
    case 91:
      include './pages/chat/read.page';
      break;
    case 92:
      include './pages/chat/write.page';
      break;
    case 93:
      include './pages/chat/get.page';
      break;
    case 94:
      include './pages/chat/put.page';
      break;
    case 95:
      include './pages/chat/users.page';
      break;

    default :
      print '404 error '.$page_id;
      break;
  }  

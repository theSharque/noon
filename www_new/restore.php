<?php

  session_start();

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );
  require_once( "./include/messages.inc" );
  message_init();
  
  $tmp = $_GET['id'];

  db_safe( $tmp );
  
  $result = db_fetch_row( "SELECT id FROM users WHERE status = 1 AND md5( CONCAT( login, password ) ) = '$tmp'" );
  if( $result['id'] ) {
    db_query( "UPDATE users SET status = 1 WHERE id = ".$result['id'] );
    header( "Location: index.php?pid=rereg&str=$tmp" );
  } else {
    header( "Location: index.php?pid=rereg_err" );
  }
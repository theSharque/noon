<?php

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );

  $line = db_fetch_val( "SELECT id FROM users WHERE id = 1", 'id' );

  if( $line == 1 ) {
    echo 'ok';
    return;
  } else {
    header( "Status: 404 Not Found" );
  }
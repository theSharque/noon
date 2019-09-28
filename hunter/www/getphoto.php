<?php

  include( 'db.inc' );
  global $user;

  if( auth() && isset( $_GET['photo'] ) && is_numeric( $_GET['photo'] ) ) {
    db_fetch_row( "SELECT " );
    printOut( "err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

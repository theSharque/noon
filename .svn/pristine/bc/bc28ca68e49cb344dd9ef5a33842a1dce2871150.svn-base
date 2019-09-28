<?php

  include( 'db.inc' );
  global $user;

  if( isset( $_GET['b'] ) && strlen( $_GET['b'] ) == 17 && isset( $_GET['l'] ) && isset( $_GET['p'] ) ) {
    $bsid = $_GET['b'];
    $login = $_GET['l'];

    db_safe( $bsid );
    db_safe( $login );

    if( !auth() ) {
      $phone = $_GET['p'];

      db_safe( $phone );

      $phone = substr( $phone, -9 );

      db_query( "INSERT INTO users ( login, bsid, phone ) VALUES ( '$login', '$bsid', '$phone' )" );
    } else {
      db_query( "UPDATE users SET login = '$login' WHERE bsid = '$bsid'" );
    }

    printOut( "err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

<?php

  include( 'db.inc' );
  global $user;

  if( auth() && isset( $_GET['id'] ) && is_numeric( $_GET['id'] ) ) {
    $id = $_GET['id'];
    db_safe( $id );

    db_query( "DELETE FROM message WHERE user_id = {$user['id']} AND status = 0" );
    db_query( "UPDATE IGNORE message SET status = 0 WHERE id = $id AND user_id = {$user['id']} AND status IN( 1, 2 )" );

    printOut( "&err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

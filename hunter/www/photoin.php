<?php

  include( 'db.inc' );
  global $user;

  if( auth() && $_POST['data'] ) {
    $fname = md5( $user['bsid'].date( 'dmYHis' ) );

    $img = base64_decode( $_POST['data'] );
    file_put_contents( 'photos/'.$fname.'.jpg', $img );

    db_query( "DELETE FROM photos WHERE user_id = {$user['id']} AND status IN( 0, 1 )" );
    db_query( "INSERT INTO photos ( file, user_id ) VALUES ( '$fname', {$user['id']} )" );
    $id = mysql_insert_id();

    db_query( "UPDATE users SET photo_id = $id WHERE id = {$user['id']}" );

    printOut( "err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

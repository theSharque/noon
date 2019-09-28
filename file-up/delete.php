<?php

  session_start();

  require_once( "db.inc" );

  $fid = $_GET['fid'];
  db_safe( $fid );

  $session_dir = session_id();

  if( file_exists( 'fullsize/'.$session_dir.'/'.$fid ) ) {
    db_query( "DELETE FROM files WHERE fid = '$fid'" );

    $optim = substr( $fid, 0, 2 );
    unlink( '/var/www/picture/big/'.$optim.'/'.$fid );
    unlink( '/var/www/picture/small/'.$optim.'/'.$fid );

    $files = unserialize( $_SESSION['files'] );
    unset( $files[ array_search( $fid, $files ) ] );
    $_SESSION['files'] = serialize( $files );
  }

  header( 'Location: /', true, 302 );

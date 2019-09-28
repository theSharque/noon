<?php

  require_once( "db.inc" );

  $fid = $_GET['fid'];
  db_safe( $fid );

  db_query( "DELETE FROM files WHERE fid = '$fid'" );

  $optim = substr( $fid, 0, 2 );
  unlink( '/var/www/picture/big/'.$optim.'/'.$fid );
  unlink( '/var/www/picture/small/'.$optim.'/'.$fid );

    header( 'Location: JavaScript:location.reload(true);', true, 302 );
/*
  if( $_SERVER['HTTP_REFERER'] ) {
    header( 'Location: '.$_SERVER['HTTP_REFERER'] );
  } else {
    header( 'Location: javascript:history.back();' );
  }
*/
<?php

  require_once( "db.inc" );

  $result = db_fetch_array( "SELECT fid FROM files WHERE galery = 0 AND date_view < DATE_SUB( NOW(), INTERVAL 2 DAY ) AND referer LIKE 'google%'" );
  db_query( "DELETE FROM files WHERE galery = 0 AND date_view < DATE_SUB( NOW(), INTERVAL 2 DAY ) AND referer LIKE 'google%'" );

  foreach( $result as $item ) {
    $optim = substr( $item['fid'], 0, 2 );
    if( file_exists( '/var/www/picture/big/'.$optim.'/'.$item['fid'] ) ) {
      unlink( '/var/www/picture/big/'.$optim.'/'.$item['fid'] );
    }

    if( file_exists( '/var/www/picture/small/'.$optim.'/'.$item['fid'] ) ) {
      unlink( '/var/www/picture/small/'.$optim.'/'.$item['fid'] );
    }
  }

  $old = scandir( '/var/www/picture/fullsize' );
  foreach( $old as $item ) {
    if( $item != '.' && $item != '..' && !file_exists( '/tmp/php_sess/sess_'.$item ) ) {
      array_map( 'unlink', glob( '/var/www/picture/fullsize/'.$item.'/*' ) );
      rmdir( '/var/www/picture/fullsize/'.$item );
    }
  }

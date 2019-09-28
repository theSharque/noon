<?php

  include( 'db.inc' );
  global $user;

  if( auth() && $_POST['data'] && isset( $_GET['g'] ) && is_numeric( $_GET['g'] ) ) {
    $temp = explode( ',', $_POST['data'] );
    $contacts = array();
    $tels = array();

    $games = $_GET['g'];
    db_safe( $games );

    array_pop( $temp );
    foreach( $temp as $key => $item ) {
      $vals = explode( ':', $item );
      $contacts[$vals[0]] = explode( ';', $vals[1] );
      array_pop( $contacts[$vals[0]] );
      foreach( $contacts[$vals[0]] as $val ) {
        $tels[substr( $val, -9 )] = $vals[0];
      }
    }

    $in = array_keys( $tels );

    $in = "'".implode( "','", $in )."'";
    if( $games == 0 ) {
      $found = db_fetch_array( "SELECT u.id, u.phone, u.login, p.file, u.kills, u.location
                                  FROM users u
                             LEFT JOIN photos p ON p.id = u.photo_id
                                 WHERE u.phone IN ( $in )" );
    } else {
      $found = db_fetch_array( "SELECT u.id, u.phone, u.login, p.file, u.kills, u.location
                                  FROM users u
                            INNER JOIN games g ON g.id = u.game_id
                             LEFT JOIN photos p ON p.id = u.photo_id
                                 WHERE g.game_type = 1 AND g.id = $games AND u.phone IN ( $in )" );
    }

    printOut( "cnt=".count( $found ) );

    $l = 0;
    foreach( $found as $item ) {
      printOut( "&id$l={$tels[$item['phone']]}&u$l={$item['id']}&n$l={$item['login']}&p$l={$item['file']}&k$l={$item['kills']}" );

      $from = explode( ':', $item['location'] );
      printOut( "&d$l=".round( distance( $from[0], $from[1], $user['location'][0], $user['location'][1] ) ) );

      $l++;
    }

    printOut( "&err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

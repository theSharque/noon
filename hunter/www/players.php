<?php

  include( 'db.inc' );
  global $user;

  if( auth() && isset( $_GET['g'] ) && is_numeric( $_GET['g'] ) ) {
    $gid = $_GET['g'];
    db_safe( $gid );

    $players = db_fetch_array( "SELECT u.id, u.login, p.file, IF( u.id = g.admin_id, 1, 0 ) admin, u.location, u.wins, u.kills, u.die
                                  FROM users u
                            INNER JOIN games g ON g.id = u.game_id
                            INNER JOIN photos p ON p.status = 2 AND p.user_id = u.id
                                 WHERE u.game_id = $gid
                              ORDER BY admin DESC, u.id" );

    printOut( "err=0&cnt=".count( $players ) );

    $admin = db_fetch_row( "SELECT admin_id, game_type, status FROM games WHERE id = $gid" );

    if( $gid == $user['game_id'] ) {
      $victims = db_fetch_row( "SELECT IFNULL( MAX( victim_id ), 0 ) victim, count(*) cnt FROM victims WHERE hunter_id = {$user['id']}" );
    } else {
      $victims = array( 'victim' => '0', 'cnt' => '0' );
    }

    printOut( "&vc=".$victims['cnt']."&vi=".$victims['victim'] );
    if( $admin['admin_id'] == $user['id'] ) {
      printOut( "&ga=1" );
    } else {
      printOut( "&ga=0" );
    }
    printOut( "&gt=".$admin['game_type'] );
    printOut( "&gs=".$admin['status'] );

    $l=0;
    foreach( $players as $item ) {
      printOut( "&id$l={$item['id']}" );
      printOut( "&p$l={$item['file']}" );
      printOut( "&l$l={$item['login']}" );
      printOut( "&a$l={$item['admin']}" );
      printOut( "&g$l={$item['location']}" );
      printOut( "&w$l={$item['wins']}" );
      printOut( "&k$l={$item['kills']}" );
      printOut( "&d$l={$item['die']}" );

      $l++;
    }

    printOut( "&eof" );
  } else {
    printOut( "err=1&eof" );
  }

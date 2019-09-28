<?php

  include( 'db.inc' );
  global $user;

  if( auth() ) {
    $players = db_fetch_array( "SELECT u.id, u.login, p.file, u.location, u.bsid, v2.pass, u.wins, u.kills
                                  FROM victims v
                            INNER JOIN users u ON u.id = v.victim_id
                            INNER JOIN photos p ON p.status = 2 AND p.user_id = u.id
                            INNER JOIN victims v2 ON v2.victim_id = u.id
                                 WHERE v.hunter_id = {$user['id']}
                              ORDER BY u.id" );

    printOut( "err=0&cnt=".count( $players ) );
    printOut( "&ig={$user['game_id']}" );

    $l=0;
    foreach( $players as $item ) {
      printOut( "&id$l={$item['id']}" );
      printOut( "&p$l={$item['file']}" );
      printOut( "&l$l={$item['login']}" );
      printOut( "&a$l={$item['admin']}" );
      printOut( "&g$l={$item['location']}" );
      printOut( "&b$l={$item['bsid']}" );
      printOut( "&s$l={$item['pass']}" );
      printOut( "&w$l={$item['wins']}" );
      printOut( "&k$l={$item['kills']}" );

      $l++;
    }

    printOut( "&eof" );
  } else {
    printOut( "err=1&eof" );
  }
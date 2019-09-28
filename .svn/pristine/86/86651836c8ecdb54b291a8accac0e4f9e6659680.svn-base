<?php

  include( 'db.inc' );
  global $user;

  if( auth() ) {
    sendMessage( $user['id'], 0, 6, 0, "" );
    printOut( "err=0&id={$user['id']}&login={$user['login']}&ig={$user['game_id']}&gs={$user['game_status']}" );
    printOut( "&vp={$user['vpass']}&va={$user['vans']}&pn={$user['phone']}&gm={$user['games']}" );
    printOut( "&kl={$user['kills']}&wn={$user['wins']}" );
    printOut( "&ver=".file_get_contents( "version" ) );
    printOut( "&photo={$user['photo_url']}&na={$user['approve']}&eof" );

  } else {
    printOut( "err=1&eof" );
  }

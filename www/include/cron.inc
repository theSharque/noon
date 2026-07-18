<?php

  chdir( "/var/www/noon" );

  require_once( "include/db.inc" );
  require_once( "include/misc.inc" );
  require_once( "include/messages.inc" );

  message_init();

  global $user;

  do_events();

  $works = db_fetch_array( "SELECT id, filename, function
                              FROM cron
                             WHERE UNIX_TIMESTAMP( laststart ) + period * 60 < UNIX_TIMESTAMP()
                          ORDER BY laststart" );

  foreach( $works as $item ) {

    require_once( 'include/'.$item['filename'] );
    $ret = call_user_func( $item['function'] );
    if( $ret == 1 ) {
      db_query( 'UPDATE cron SET laststart = NOW() WHERE id = '.$item['id'] );
    }
  }

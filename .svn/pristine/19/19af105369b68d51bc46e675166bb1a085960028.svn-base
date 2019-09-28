<?php

function message_init() {
  global $messages;
  global $locale;

  $locale = 'ru';

  $block = @shmop_open( 1, 'a', 0, 0 );
  if( !empty( $block ) ) {
    $messages = unserialize( shmop_read( $block, 0, shmop_size( $block ) ) );
    shmop_close( $block );
  } else {
    $messages = db_fetch_array( "SELECT hash, $locale FROM messages", true, 'hash' );

    $data = serialize( $messages );
    $block = shmop_open( 1, 'n', 0644, strlen( $data ) );
    if( !empty( $block ) ) {
      shmop_write( $block, $data, 0 );
      shmop_close( $block );
    }
  }
}

function t( $line, $args = array() ) {
  global $messages;
  global $locale;

  $code = md5($line);

  if( isset( $messages[$code][$locale] ) ) {
    return vsprintf( $messages[$code][$locale], $args );
  } else {
    $line = str_replace( '\'', '"', $line );

    db_query( "INSERT IGNORE INTO messages ( hash, $locale ) VALUES ( '".$code."', '$line' )" );
    $messages[$code] = array( $locale => $line );

    $data = serialize( $messages );
    $block = shmop_open( 1, 'w', 0644, strlen( $data ) );
    if( !empty( $block ) ) {
      shmop_delete( $block );
      shmop_close( $block );
      $block = shmop_open( 1, 'n', 0644, strlen( $data ) );

      if( !empty( $block ) ) {
        shmop_write( $block, $data, 0 );
        shmop_close( $block );
      }
    }

    return vsprintf( $line, $args );
  }
}

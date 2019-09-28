<?php

function debug_it( $string ) {
  $time = date("H:i:s");
  $prn = print_r( $string, true );
  file_put_contents( "debug.log", "$time\t$prn\r\n", FILE_APPEND );
}

function get_between( $str, $start, $end = null ) {
  if( strpos( $str, $start ) !== false ) {
    $str = substr( $str, strpos( $str, $start ) + strlen( $start ) );

    if( strlen( $end ) && strpos( $str, $end ) !== false ) {
      $str = substr( $str, 0, strpos( $str, $end ) );
    }
  }

  return $str;
}

function db_init() {
  static $dblink;

  if( $dblink === null ) {
    $dblink = mysql_connect( 'localhost', 'picture', '3ws4LP3J8Bt3xNpn' ) or die("Could not connect: " . mysql_error());
    mysql_select_db( 'picture' ) or die ('Can\'t use picture : ' . mysql_error());
    mysql_query( "SET character_set_client = cp1251, character_set_connection = cp1251, character_set_results = cp1251" );
  }

  return $dblink;
}

function db_query( $sql ) {

  if( db_init() ) {

    $result = mysql_query( $sql );
    if( !$result ) {
      $back = debug_backtrace();
      debug_it( mysql_error() );
      debug_it( $back );
    }

    return $result;
  }
}

function db_fetch_array( $sql, $in_cache = false ) {
  static $l_cache;

  if( $in_cache ) {
    if( isset( $l_cache[$sql] ) ) {
      return $l_cache[$sql];
    }
  }

  $out = array();

  if( $result = db_query( $sql ) ) {
    while ( $row = mysql_fetch_assoc( $result ) ) {
      $out[] = $row;
    }
  }

  if( $in_cache ) {
    $l_cache[$sql] = $out;
  }

  return $out;
}

function db_fetch_row( $sql, $in_cache = false ) {
  static $l_cache;

  if( $in_cache ) {
    if( isset( $l_cache[$sql] ) ) {
      return $l_cache[$sql];
    }
  }

  $out = array();

  if( $result = db_query( $sql ) ) {
    $out = mysql_fetch_assoc( $result );
  }

  if( $in_cache ) {
    $l_cache[$sql] = $out;
  }

  return $out;
}

function db_fetch_val( $sql, $val = 'id', $in_cache = false ) {
  static $l_cache;

  if( $in_cache ) {
    if( isset( $l_cache[$sql] ) ) {
      return $l_cache[$sql];
    }
  }

  $out = null;

  if( $result = db_query( $sql ) ) {
    if( $result ) {
      $arr = mysql_fetch_assoc( $result );
      if( isset( $arr[ $val ] ) ) {
        $out = $arr[ $val ];
      }
    }
  }

  if( $in_cache ) {
    $l_cache[$sql] = $out;
  }

  return $out;
}

function db_safe( &$var ) {
  if( $var !== null ) {
    $var = mysql_escape_string( $var );
  }

  return $var;
}

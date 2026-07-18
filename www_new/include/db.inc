<?php

function db_init() {
  static $dblink;

  if( $dblink === null ) {
    $host = getenv('NOON_DB_HOST');
    $user = getenv('NOON_DB_USER');
    $pass = getenv('NOON_DB_PASSWORD');
    $db   = getenv('NOON_DB_NAME');

    if( !$host || !$user || !$pass || !$db ) {
      die('Database env not configured (NOON_DB_HOST, NOON_DB_USER, NOON_DB_PASSWORD, NOON_DB_NAME)');
    }

    $dblink = mysql_connect( $host, $user, $pass ) or die("Could not connect: " . mysql_error());
    mysql_select_db( $db ) or die ('Can\'t use noon : ' . mysql_error());
    mysql_query( "SET NAMES utf8" );
  }

  return $dblink;
}

function db_query( $sql ) {
  if( db_init() ) {

    $result = mysql_query( $sql );

    if( !$result ) {
      if( mysql_errno() == 1213 || mysql_errno() == 1205 || mysql_errno() == 1317 ) {
        debug_it( 'Error '.mysql_errno().' we need to try again...' );
        debug_it( $sql );
        sleep( 4 );
        $result = db_query( $sql );
      } else {
        debug_it( mysql_errno().' : '.mysql_error() );
        $back = debug_backtrace();
        debug_it( $back );
      }
    }

    return $result;
  }
}

function db_fetch_array( $sql, $in_cache = false, $order = null ) {
  static $l_cache;

  if( $sql == 'clear' ) {
    $l_cache = array();
    return;
  }

  if( $in_cache ) {
    if( is_array( $l_cache ) && array_key_exists( $sql, $l_cache ) ) {
      return $l_cache[$sql];
    }
  }

  $out = array();

  if( $result = db_query( $sql ) ) {
    if( $order === null ) {
      while ( $row = mysql_fetch_assoc( $result ) ) {
        $out[] = $row;
      }
    } else {
      while ( $row = mysql_fetch_assoc( $result ) ) {
        $code = $row[$order];
        unset( $row[$order] );
        $out[$code] = $row;
      }
    }
  }

  if( $in_cache ) {
    $l_cache[$sql] = $out;
  }

  return $out;
}

function db_fetch_row( $sql, $in_cache = false ) {
  static $l_cache;

  if( $sql == 'clear' ) {
    $l_cache = array();
    return;
  }

  if( $in_cache ) {
    if( is_array( $l_cache ) && array_key_exists( $sql, $l_cache ) ) {
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

  if( $sql == 'clear' ) {
    $l_cache = array();
    return;
  }

  if( $in_cache ) {
    if( is_array( $l_cache ) && array_key_exists( $sql, $l_cache ) ) {
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

function db_start() {
/*
  db_query( "SET autocommit=0" );
  db_query( "START TRANSACTION" );
*/
}

function db_end() {
/*
  db_query( "COMMIT" );
  db_query( "SET autocommit=1" );
*/
}

<?php

function db_init() {
  static $dblink;

  if( $dblink === null ) {
    $dblink = mysql_connect( 'localhost', 'banner', '7W2zd7UmthdBupPN' ) or die("Could not connect: " . mysql_error());
    mysql_select_db( 'banner' ) or die ('Can\'t use noon : ' . mysql_error());
    mysql_query( "SET character_set_client = cp1251, character_set_connection = cp1251, character_set_results = cp1251" );
  }

  return $dblink;
}

function db_query( $sql ) {
  global $user;

  if( db_init() ) {

    $result = mysql_query( $sql );
    if( !$result ) {
      die("Could not query: " . mysql_error());
    }
  
    return $result;
  }
}

function db_fetch_array( $sql ) {
  $out = array();

  if( $result = db_query( $sql ) ) {
    while ( $row = mysql_fetch_assoc( $result ) ) {
      $out[] = $row;
    }
  }

  return $out;
}

function db_fetch_row( $sql ) {
  $out = array();

  if( $result = db_query( $sql ) ) {
    $out = mysql_fetch_assoc( $result );
  }

  return $out;
}

function db_fetch_val( $sql, $val = 'id' ) {
  $out = null;

  if( $result = db_query( $sql ) ) {
    $arr = mysql_fetch_assoc( $result );
    if( isset( $arr[ $val ] ) ) {
      $out = $arr[ $val ];
    }
  }

  return $out;
}

function db_safe( &$var ) {
  $var = mysql_escape_string( $var );
  return $var;
}

$md5 = $_GET['id'];
$from = $_GET['from'];
$referer = getenv("HTTP_REFERER");
$ip = getenv("REMOTE_ADDR");

db_safe( $md5 );
db_safe( $from );
db_safe( $referer );
db_safe( $ip );

$ids = db_fetch_row( "SELECT b.user_id, b.company_id, bc.url
                        FROM banners b
                  INNER JOIN banner_company bc ON bc.id = b.company_id
                       WHERE filename = '$md5'" );
if( $ids['user_id'] ) {
  db_query( 'UPDATE banner_company SET clicked = clicked + 1 WHERE id = '.$from );
  db_query( 'UPDATE banner_balance bb, banner_company bc
                SET bb.balance = bb.balance + bc.commission
              WHERE bb.user_id = bc.user_id AND bc.id = '.$from );
  db_query( "UPDATE banners SET clicked = clicked + 1 WHERE filename = '$md5'" );

  // Temp redirection
  header("HTTP/1.1 302 Moved Temporarily");
  header("Location: ".$ids['url']);
}


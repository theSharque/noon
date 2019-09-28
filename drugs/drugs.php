<?php

$db = '';


function db_init() {
  static $dblink;

  if( $dblink === null ) {
    $dblink = mysql_connect( 'localhost', 'drugmaster', 'aAj9Cj8vsNxvwTyy' ) or die("Could not connect: " . mysql_error());
    mysql_select_db( 'drugmaster' ) or die ('Can\'t use noon : ' . mysql_error());
    mysql_query( "SET character_set_client = cp1251, character_set_connection = cp1251, character_set_results = cp1251" );
  }

  return $dblink;
}

function db_query( $sql ) {
  if( db_init() ) {

    $result = mysql_query( $sql );
    if( !$result ) {
      echo $result;
      echo mysql_error();
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

$d = dir("/prepare/drugdir.ru/preparats");
db_query( "DELETE FROM preparats" );
while (false !== ($entry = $d->read())) {
  if( $entry != '.' && $entry != '..' ) {
    $origin = file_get_contents( '/prepare/drugdir.ru/preparats/'.$entry );
    $origin = mb_convert_encoding( $origin, 'Windows-1251', 'UTF-8' );
    $title = trim( get_between( $origin, '<center><h1>', '</h1></center>' ) );
    $text = get_between( $origin, '<td valign="top">', '</td>' );
    $text = trim( get_between( $text, '<div>', '</div>' ) );
    $text = str_replace( "'", '"', $text );

    db_query( "INSERT INTO preparats (id, title, desc_text) VALUES ( $entry, '$title', '$text' )" );

  }
}
$d->close();

$d = dir("/prepare/drugdir.ru/cats");
db_query( "DELETE FROM catalogs" );
while (false !== ($entry = $d->read())) {
  if( $entry != '.' && $entry != '..' ) {
    $origin = file_get_contents( '/prepare/drugdir.ru/cats/'.$entry );
    $origin = mb_convert_encoding( $origin, 'Windows-1251', 'UTF-8' );

    $title = trim( get_between( $origin, '<center><h1>', '</h1></center>' ) );

    $text = get_between( $origin, '<table width="100%"><tr valign="top">', '<br><br><br><a href="http://drugdir.ru/admin/addprep' );
    $text = substr( $text, 6 );
    $text = trim( str_replace( "'", '"', $text ) );

    $text = str_replace(
  array( 'href="http://drugdir.ru/preparats/', 'href="../preparats/', '<td>', '</td>', "\t" ),
  array( 'href="index.php?pr=', 'href="index.php?pr=', '', '', '' ), $text );

    db_query( "INSERT INTO catalogs (id, name, content) VALUES ( $entry, '$title', '$text' )" );

  }
}
$d->close();

function get_between( $text, $start, $end ) {
  $text = substr( $text, strpos( $text, $start ) + strlen( $start ) );
  $text = substr( $text, 0, strpos( $text, $end ) );
  return $text;
}

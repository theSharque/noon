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

db_safe( $md5 );

$ids = db_fetch_row( "SELECT bh.user_id, bh.company_id FROM banner_hash bh INNER JOIN banner_company bc ON bc.id = bh.company_id WHERE bh.md5 = '$md5'" );

if( $ids['user_id'] ) {
  $file_id = db_fetch_val( "SELECT b.filename
                              FROM banners b
                        INNER JOIN banner_company bc ON bc.id = b.company_id
                        INNER JOIN banner_company bo ON bo.sizeformat = bc.sizeformat AND bo.id = {$ids['company_id']}
                             WHERE b.company_id != {$ids['company_id']} AND b.approved = 1 AND b.click_cnt > b.clicked
                          ORDER BY rand()
                             LIMIT 0,1", 'filename' );

  if( $file_id ) {
    $data = '<a href="http://banner.21noon.com/get_click.php?id='.$file_id.'&from='.$ids['company_id'].'" target="_blank"><img src="http://banner.21noon.com/get_img.php?id='.$file_id.'&from='.$ids['company_id'].'" border=0></a>';
  } else {
    $data = '';
  }

  echo $data;
}


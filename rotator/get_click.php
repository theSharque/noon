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

$id = $_GET['id'];
$from = $_GET['from'];
$referer = getenv("HTTP_REFERER");
$ip = getenv("REMOTE_ADDR");

db_safe( $id );
db_safe( $from );
db_safe( $referer );
db_safe( $ip );

$ids = db_fetch_row( "SELECT b.user_id, b.url, b.title, b.click_cnt
                        FROM banners b
                       WHERE b.id = $id" );

$geo = db_fetch_row( "SELECT gc.ip, gc.country, gc.city FROM geo_cache gc WHERE gc.ip = '$ip'" );
if( !isset( $geo['ip'] ) ) {
  $csv = file_get_contents( "http://freegeoip.net/csv/$ip" );
  $dat = explode( ',', str_replace( '"', '', $csv ) );

  db_query( "INSERT INTO geo_cache ( ip, country, city ) VALUES ( '{$dat[0]}', '{$dat[2]}', '{$dat[5]}' )" );
  db_query( "INSERT IGNORE INTO banner_country ( name ) VALUES ( '{$dat[2]}' )" );

  $geo = array( 'ip' => $dat[0], 'country' => $dat[2], 'city' => $dat[5] );
}
$country = db_fetch_val( "SELECT id FROM banner_country bc WHERE bc.name = '{$geo['country']}'" );

if( $ids['user_id'] ) {
  db_query( "UPDATE banners SET click_cnt = click_cnt - 1, clicked = clicked + 1 WHERE id = $id" );
  db_query( 'UPDATE banner_company SET clicked = clicked + 1 WHERE id = '.$from );

  $company = db_fetch_row( 'SELECT bc.user_id, bc.commission, bc.clicked, bc.title FROM banner_company bc WHERE bc.id = '.$from );

  if( $ids['click_cnt'] == 1 ) {
    $recv = user_load( $ids['user_id'] );
//    drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'ban_end', 'name' => $ids['title'] ) );
  }

  switch( $company['clicked'] ) {

    case 100:
      if( $company['commission'] < 0.7 ) {
        $recv = user_load( $company['user_id'] );
//        drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $company['title'], 'comm' => '30%' ) );

        db_query( "UPDATE banner_company SET commission = '0.7' WHERE id = $from" );
      }
      break;

    case 1000:
      if( $company['commission'] < 0.8 ) {
        $recv = user_load( $company['user_id'] );
//        drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $company['title'], 'comm' => '20%' ) );

        db_query( "UPDATE banner_company SET commission = '0.8' WHERE id = $from" );
      }
      break;

    case 10000:
      if( $company['commission'] < 0.9 ) {
        $recv = user_load( $company['user_id'] );
//        drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $company['title'], 'comm' => '10%' ) );

        db_query( "UPDATE banner_company SET commission = '0.9' WHERE id = $from" );
      }
      break;

    case 50000:
      if( $company['commission'] < 0.95 ) {
        $recv = user_load( $company['user_id'] );
//        drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $company['title'], 'comm' => '5%' ) );

        db_query( "UPDATE banner_company SET commission = '0.95' WHERE id = $from" );
      }
      break;

    case 100000:
      if( $company['commission'] < 0.98 ) {
        $recv = user_load( $company['user_id'] );
//        drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $company['title'], 'comm' => '2%' ) );

        db_query( "UPDATE banner_company SET commission = '0.98' WHERE id = $from" );
      }
      break;
  }

  if( $company['user_id'] == $ids['user_id'] ) {
    db_query( "INSERT INTO banner_balance ( user_id, balance ) VALUES ( {$company['user_id']}, 1 ) ON DUPLICATE KEY UPDATE balance = balance + 1" );
  } else {

    if( $ids['user_id'] == 1 ) {
      db_query( "INSERT INTO banner_balance ( user_id, balance ) VALUES ( 1, 1 ) ON DUPLICATE KEY UPDATE balance = balance + 1" );
    } else {
      $user_add = number_format( $company['commission'], 2, '.', '' );
      $sys_diff = ( 1 - $company['commission'] ) / 10;
      $sys_add = number_format( 1 - $company['commission'] - $sys_diff, 2, '.', '' );
      $me_add = number_format( $sys_diff, 2, '.', '' );

      db_query( "INSERT INTO banner_balance ( user_id, balance ) VALUES ( {$company['user_id']}, '$user_add' ) ON DUPLICATE KEY UPDATE balance = balance + '$user_add'" );
      db_query( "INSERT INTO banner_balance ( user_id, balance ) VALUES ( 1, '$sys_add' ) ON DUPLICATE KEY UPDATE balance = balance + '$sys_add'" );
      db_query( "INSERT INTO banner_balance ( user_id, balance ) VALUES ( 7, '$me_add' ) ON DUPLICATE KEY UPDATE balance = balance + '$me_add'" );
    }
  }

  db_query( "INSERT INTO banner_log ( country, banner_id, company_id, type, referer, client_ip ) VALUES ( '$country', $id, $from, 'click', '$referer', '$ip' )" );

  // Temp redirection
  header("HTTP/1.1 302 Moved Temporarily");
  header("Location: http://".$ids['url']);
}

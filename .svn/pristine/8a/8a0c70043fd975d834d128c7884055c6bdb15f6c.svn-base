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

if( isset( $_GET['c'] ) ) {
  $md5 = $_GET['c'];

  db_safe( $md5 );
} else {
  return;
}

$colors = array(
  0 => '<style>.bcolor { background:#FFF;border:1px solid #CCC;color:#000; } .bcolor a {text-decoration:none;color:#00F;} a.clxbttl {text-decoration:none;color:#E50;} a:hover {text-decoration:underline;} a:active {text-decoration:underline;}</style>',
  1 => '<style>.bcolor { background:#000;border:1px solid #222;color:#FFF; } .bcolor a {text-decoration:none;color:#09F;} a.clxbttl {text-decoration:none;color:#E50;} a:hover {text-decoration:underline;} a:active {text-decoration:underline;}</style>',
);

$referer = getenv("HTTP_REFERER");
$ip = getenv("REMOTE_ADDR");

$geo = db_fetch_row( "SELECT gc.ip, gc.country, gc.city FROM geo_cache gc WHERE gc.ip = '$ip'" );
if( !isset( $geo['ip'] ) ) {
  $csv = file_get_contents( "http://freegeoip.net/csv/$ip" );
  $dat = explode( ',', str_replace( '"', '', $csv ) );

  db_query( "INSERT INTO geo_cache ( ip, country, city ) VALUES ( '{$dat[0]}', '{$dat[2]}', '{$dat[5]}' )" );
  db_query( "INSERT IGNORE INTO banner_country ( name ) VALUES ( '{$dat[2]}' )" );

  $geo = array( 'ip' => $dat[0], 'country' => $dat[2], 'city' => $dat[5] );
}
$country = db_fetch_val( "SELECT id FROM banner_country bc WHERE bc.name = '{$geo['country']}'" );

$ids = db_fetch_row( "SELECT bh.user_id, bh.company_id, bc.url, bc.sizeformat, bc.color
                        FROM banner_hash bh
                  INNER JOIN banner_company bc ON bc.id = bh.company_id
                       WHERE bc.status = 1 AND bh.md5 = '$md5'" );

if( $ids['user_id'] ) {

  $color = $colors[ $ids['color'] ];

  switch( $ids['sizeformat'] ) {
    case '468x60':
    case '100x100':
    case '200x76':
    case '224x104':
    case 'top line':
      $limit = 1;
      $sizeformat = $ids['sizeformat'];
      break;

    case '610x76' :
    case '200x238' :
      $limit = 3;
      $sizeformat = '200x76';
      break;

    case '200x400' :
      $limit = 5;
      $sizeformat = '200x76';
      break;
  }

  $blist = db_fetch_array( "SELECT DISTINCT b.id, b.sizeformat, b.filename, b.text, b.title, b.url, b.vurl
                             FROM banners b
                       INNER JOIN banner_s_theme bst ON bst.scenario_id = b.scenario
                       INNER JOIN banner_c_theme bct ON bct.theme_id = bst.theme_id
                       INNER JOIN banner_company bc ON bc.id = bct.company_id AND bc.sizeformat = b.sizeformat
                            WHERE b.approved = 1 AND b.click_cnt > 0 AND b.url != '{$ids['url']}' AND bc.sizeformat = '$sizeformat'
                         ORDER BY rand()
                            LIMIT 0,$limit" );

  if( $limit == 1 ) {
    $banner = current( $blist );
  }

  db_query( "UPDATE banner_company SET shown = shown + $limit WHERE id = {$ids['company_id']}" );

  switch( $ids['sizeformat'] ) {
    case '468x60':
    case '100x100':
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data = '<a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank"><img src="http://clixer.ru/banners/'.$banner['filename'].'.dat" border=0></a>';
      }
      break;

    case '200x76':
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;
        $data .= '<div class="bcolor" style="text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }
      break;

    case '224x104':
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;
        $data .= '<div class="bcolor" style="padding:1px;width:220px;height:100px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank"><img width=100 height=100 style="float:left;margin-right:2px;" src="http://clixer.ru/banners/'.$banner['filename'].'.dat" border=0></a><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }
      break;
  
    case 'top line':
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;
        $data .= '<div class="bcolor" style="position:absolute;z-index:99999;left:0;top:0;text-align:center;height: 30px;margin: 0px;padding-top: 5px;width: 100%;font-family:arial,helvetica,sans-serif;font-size:14px;font-weight: bold;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank"> - '.$banner['text'].'</a><div style="float:right;"><a href=# onclick="JavaScript:this.parentNode.parentNode.style.display=\\\'none\\\';"><img src="http://clixer.ru/c.png"></a></div></div>';
      }
      break;

    case '610x76' :
      $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;

      $banner = current( $blist );
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data .= '<div class="bcolor" style="float:left;margin-right:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        $data .= '<div class="bcolor" style="float:left;margin-right:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="float:left;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }
      break;

    case '200x238' :
      $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;

      $banner = current( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }
      break;

    case '200x400' :
      $data = '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1251" /></head>'.$color;

      $banner = current( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="margin-bottom:5px;text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }

      $banner = next( $blist );
      if( $banner['id'] ) {
        db_query( "INSERT INTO banner_log ( country, banner_id, company_id, referer, client_ip ) VALUES ( '$country', {$banner['id']}, {$ids['company_id']}, '$referer', '$ip' )" );
        db_query( "UPDATE banners SET shown = shown + 1 WHERE id = '{$banner['id']}'" );
        $data .= '<div class="bcolor" style="text-align:left;padding:2px;width:194px;height:70px;font-family:arial,helvetica,sans-serif;font-size:12px;"><a class="clxbttl" href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['title'].'</a><br>'.$banner['text'].'<br><a href="http://clixer.ru/get_click.php?id='.$banner['id'].'&from='.$ids['company_id'].'" target="_blank">'.$banner['vurl'].'</a></div>';
      }
      break;

    default:
      $data = '&nbsp;';
      break;
  }
} else {
  $data = '';
}

echo "document.getElementById('$md5').innerHTML = '$data';";

<?php

  require_once( "db.inc" );

  if( isset( $gt ) && is_numeric( $gt ) && $gt > 0 ) {
    $pics = db_fetch_array( "SELECT referer, fid FROM files WHERE galery = $gt ORDER BY rand() LIMIT 0,7" );
  } else {
    $pics = db_fetch_array( "SELECT referer, fid FROM files WHERE galery NOT IN( 0, 6 ) ORDER BY rand() LIMIT 0,7" );
  }


  echo "<br><div class='tizdiv'><b>Фото из нашей галереи</b><br><br>";

  foreach( $pics as $item ) {
    $orig = substr( $item['fid'], 0, 2 );
    $fid = $item['fid'];
    $fid_html = substr( $fid, 0, -4 );

    if( substr( $item['referer'], 0, 6 ) == 'google' ) {
      $alt = substr( $item['referer'], 7 );
      echo "<div class='tizers'><a href='/big_$fid_html.html'><img border=0 width=100 src='/small/$orig/$fid' alt='$alt'></a></div>";
    } else {
      echo "<div class='tizers'><a href='/big_$fid_html.html'><img border=0 width=100 src='/small/$orig/$fid'></a></div>";
    }
  }

  echo "</div>";

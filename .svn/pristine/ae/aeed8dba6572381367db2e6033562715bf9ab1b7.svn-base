<?php

  require_once( "db.inc" );
  require_once( "google.inc" );

  if( isset( $_GET['q'] ) ) {
    take_that( 'q='.urlencode( mb_convert_encoding( $_GET['q'], 'UTF-8', 'CP1251' ) ).'&' );
  } else {
    header( 'Location: galery.php' );
    return;
  }

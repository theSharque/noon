<?php

  require_once( "./include/misc.inc" );

  $allow = array(
    '82.146.40.60' => 1,
    '188.120.245.101' => 1,
    '188.120.245.102' => 1,
    '94.103.26.178' => 1,
    '94.103.26.179' => 1,
    '94.103.26.180' => 1,
    '94.103.26.181' => 1,
    '94.103.26.182' => 1,
  );

  $ip = $_SERVER["REMOTE_ADDR"];
  if( $allow[ $ip ] == 1 ) {
    include( './pages/2pay_in.page' );
  } else {
    debug_it( 'Wrong remote IP '.$_SERVER["REMOTE_ADDR"] );
  }
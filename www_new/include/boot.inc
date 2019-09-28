<?php

global $user;
global $usd;

function bootup() {
  setlocale(LC_ALL, "ru_RU.CP1251");

  $usd = 30;

  ini_set( 'display_errors', 0 );
  ini_set( 'log_errors', 1 );
  ini_set( 'error_log', 'err_log.log' );

  require_once( "include/auth.inc" );
  require_once( "include/db.inc" );
  require_once( "include/misc.inc" );
  require_once( "include/tutorial.inc" );
  require_once( "include/messages.inc" );

  message_init();

  return;
}

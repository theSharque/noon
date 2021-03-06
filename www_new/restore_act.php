<?php

  session_start();

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );
  
  $str = $_POST['str'];
  $pass1 = $_POST['pass1'];
  $pass2 = $_POST['pass2'];

  db_safe( $str );
  db_safe( $pass1 );
  db_safe( $pass2 );
  
  if( !isset( $_SESSION['captcha_keystring'] ) || $_SESSION['captcha_keystring'] != $_POST['keystring'] ) {
    header( "Location: index.php?pid=rereg&err=4" );
    exit;
  }

  if( !isset( $_POST['rules'] ) || $_POST['rules'] != 'on' ) {
    header( "Location: index.php?pid=rereg&err=2" );
    exit;
  }

  if( !isset( $_POST['license'] ) || $_POST['license'] != 'on' ) {
    header( "Location: index.php?pid=rereg&err=3" );
    exit;
  }

  $result = db_fetch_row( "SELECT id FROM users WHERE status = 1 AND md5( CONCAT( login, password ) ) = '$str'" );

  if( $result['id'] ) {
    if( $pass1 != $pass2 ) {
      header( "Location: index.php?pid=rereg&err=1" );
      exit;
    } else {
      db_query( "UPDATE users SET password = '".md5($pass1)."' WHERE id = ".$result['id'] );
      header( "Location: index.php?pid=rereg_ok" );
      exit;
    }
  } else {
    header( "Location: index.php?pid=rereg_err" );
    exit;
  }
<?php

  require_once( "db.inc" );

  if( !isset( $_GET['q'] ) || ( isset( $_GET['q'] ) && $_GET['q'] == '' ) ) {
    session_start();

    if( !isset( $_SESSION['ref'] ) ) {
      $_SESSION['ref'] = isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '';
    }

    include( 'index.inc' );
    return;
  }

  if( substr( $_GET['q'], -4 ) == '.jpg' ) {
    $dr = substr( $_GET['q'], 0, 4 );
    $fid = substr( $_GET['q'], 4 );
    $optim = substr( $fid, 0, 2 );

    $ref = urldecode( isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '' );

    db_safe( $fid );
    db_safe( $ref );

    if( $dr == 'big_' ) {
      if( $ref != '' ) {
        if( strripos( $ref, 'chatvdvoem' ) || strripos( $ref, 'sexchats' ) || strripos( $ref, 'minskpride' ) || strripos( $ref, 'farit.ru' ) ) {
          db_query( "DELETE FROM files WHERE fid = '$fid'" );

          $optim = substr( $fid, 0, 2 );
          unlink( '/var/www/picture/big/'.$optim.'/'.$fid );
          unlink( '/var/www/picture/small/'.$optim.'/'.$fid );
        }

        if( !strripos( $ref, 'file-up' ) ) {
          db_query( "UPDATE files SET date_view = NOW(), get_from = '$ref' WHERE fid = '$fid'" );
        }
      }

      if( file_exists ( 'big/'.$optim.'/'.$fid ) ) {
        header( 'Location: /big/'.$optim.'/'.$fid );
      } else {
        header( 'Location: /big.jpg' );
      }

      return;
    }

    if( $dr == 'sml_' ) {
      if( $ref != '' ) {
        if( strripos( $ref, 'chatvdvoem' ) || strripos( $ref, 'sexchats' ) || strripos( $ref, 'minskpride' ) || strripos( $ref, 'farit.ru' ) ) {
          db_query( "DELETE FROM files WHERE fid = '$fid'" );

          $optim = substr( $fid, 0, 2 );
          unlink( '/var/www/picture/big/'.$optim.'/'.$fid );
          unlink( '/var/www/picture/small/'.$optim.'/'.$fid );
        }

        if( !strripos( $ref, 'file-up' ) ) {
          db_query( "UPDATE files SET date_view = NOW(), get_from = '$ref' WHERE fid = '$fid'" );
        }
      }

      if( file_exists ( 'small/'.$optim.'/'.$fid ) ) {
        header( 'Location: /small/'.$optim.'/'.$fid );
      } else {
        header( 'Location: /small.jpg' );
      }

      return;
    }
  }

  if( substr( $_GET['q'], -5 ) == '.html' ) {
    session_start();

    if( !isset( $_SESSION['ref'] ) ) {
      $_SESSION['ref'] = isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '';
    }

    $dr = substr( $_GET['q'], 0, 4 );
    $fid = substr( $_GET['q'], 4, -4 ).'jpg';
    $data = db_fetch_row( "SELECT referer, galery FROM files WHERE fid = '$fid'" );

    $ref = urldecode( isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '' );
    if( $ref != '' ) {
      if( strripos( $ref, 'chatvdvoem' ) || strripos( $ref, 'sexchats' ) || strripos( $ref, 'minskpride' ) || strripos( $ref, 'farit.ru' ) ) {
        db_query( "DELETE FROM files WHERE fid = '$fid'" );

        $optim = substr( $fid, 0, 2 );
        unlink( '/var/www/picture/big/'.$optim.'/'.$fid );
        unlink( '/var/www/picture/small/'.$optim.'/'.$fid );
      }

      if( !strripos( $ref, 'file-up' ) ) {
        db_query( "UPDATE files SET date_view = NOW(), get_from = '$ref' WHERE fid = '$fid'" );
      }
    }

    $gt = $data['galery'];
    $pic_ref = $data['referer'];

    $optim = substr( $fid, 0, 2 );
    $pic = '/big/'.$optim.'/'.$fid;
    include( "empty.inc" );
    return;
  }

  header("Status: 404 Not Found");
  require_once( "404.php" );

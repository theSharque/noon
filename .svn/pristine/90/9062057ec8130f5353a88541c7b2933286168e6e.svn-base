<?php

  session_start();

  require_once( "db.inc" );

  $settings = unserialize( $_SESSION['settings'] );

  $fname = $_GET['fid'];
  $direction = $_GET['d'];

  db_safe( $fname );
  db_safe( $direction );

  $session_dir = session_id();
  $source_image_path = 'fullsize/'.$session_dir.'/'.$fname;

  $optim = substr( $fname, 0, 2 );

  if( !is_dir( 'big/'.$optim ) ) {
    mkdir( 'big/'.$optim );
  }

  if( !is_dir( 'small/'.$optim ) ) {
    mkdir( 'small/'.$optim );
  }

  $thumbnail_image_path = '/var/www/picture/small/'.$optim.'/'.$fname;
  $normal_image_path = '/var/www/picture/big/'.$optim.'/'.$fname;
  $jpeg_quality = $settings['JQ'];
  $thumb_size = $settings['VM'];
  $normal_size = $settings['M'];
  $rotate = $direction;

  if( isset( $settings['GA'] ) && $settings['GA'] == 'yes' && isset( $settings['GT'] ) && is_numeric( $settings['GT'] ) ) {
    $ga = $settings['GT'];
    db_safe( $ga );
  } else {
    $ga = 0;
  }

  if( isset( $settings['VE'] ) && $settings['VE'] == 'yes' ) {
    $thumb_name = $settings['V'];
  } else {
    $thumb_name = null;
  }

  if( isset( $settings['XE'] ) && $settings['XE'] == 'yes' ) {
    $normal_name = $settings['X'];
  } else {
    $normal_name = null;
  }

    list( $source_image_width, $source_image_height, $source_image_type ) = getimagesize( $source_image_path );

    switch( $source_image_type ) {

      case IMAGETYPE_GIF:
        $source_gd_image = imagecreatefromgif( $source_image_path );
        break;

      case IMAGETYPE_JPEG:
        $source_gd_image = imagecreatefromjpeg( $source_image_path );
        break;

      case IMAGETYPE_PNG:
        $source_gd_image = imagecreatefrompng( $source_image_path );
        break;

      default:
        $source_gd_image = false;
        break;
    }

    if( $source_gd_image === false ) {
      header("location:javascript://history.go(-1)");
      return;
    }

    switch( $rotate ) {
      case 0:
        $tmp_h = $source_image_height;
        $tmp_w = $source_image_width;
        break;

      case 1:
        $tmp_h = $source_image_width;
        $tmp_w = $source_image_height;
        $source_gd_image = imagerotate( $source_gd_image, 270, 0 );
        break;

      case 2:
        $tmp_h = $source_image_height;
        $tmp_w = $source_image_width;
        $source_gd_image = imagerotate( $source_gd_image, 180, 0 );
        break;

      case 3:
        $tmp_h = $source_image_width;
        $tmp_w = $source_image_height;
        $source_gd_image = imagerotate( $source_gd_image, 90, 0 );
        break;
    }

    $source_image_height = $tmp_h;
    $source_image_width = $tmp_w;
    $source_aspect_ratio = $source_image_width / $source_image_height;

    $font = 4;
    $height = imagefontheight( $font );

    // Make small
    if( $source_image_width <= $thumb_size && $source_image_height <= $thumb_size ) {
        $thumbnail_image_width = $source_image_width;
        $thumbnail_image_height = $source_image_height;
    } elseif( 1 > $source_aspect_ratio ) {
        $thumbnail_image_width = (int)( $thumb_size * $source_aspect_ratio );
        $thumbnail_image_height = $thumb_size;
    } else {
        $thumbnail_image_width = $thumb_size;
        $thumbnail_image_height = (int)( $thumb_size / $source_aspect_ratio );
    }

    if( $thumb_name ) {
      $thumbnail_gd_image = imagecreatetruecolor( $thumbnail_image_width, $thumbnail_image_height + $height );
    } else {
      $thumbnail_gd_image = imagecreatetruecolor( $thumbnail_image_width, $thumbnail_image_height );
    }

    imagecopyresampled( $thumbnail_gd_image, $source_gd_image, 0, 0, 0, 0, $thumbnail_image_width, $thumbnail_image_height, $source_image_width, $source_image_height );

    $backgroundColor = imagecolorallocate( $thumbnail_gd_image, 0, 0, 128 );
    $grayColor = imagecolorallocate( $thumbnail_gd_image, 255, 255, 255 );
    $y = imagesy( $thumbnail_gd_image );
    if( imagesx( $thumbnail_gd_image ) >= 180 ) {
      imagefilledrectangle( $thumbnail_gd_image, 0, $y - $height, 50, $y, $backgroundColor );
      imagettftext( $thumbnail_gd_image, 8, 0, 1, $y-3, $grayColor, "./tahoma.ttf", 'file-up.net' );
    }

    if( $thumb_name ) {
      $width = imagefontwidth( $font ) * strlen( $thumb_name );
      $x = intval( imagesx( $thumbnail_gd_image ) / 2 - $width / 2 );

      $textColor = imagecolorallocate( $thumbnail_gd_image, 255, 255, 255 );
      imagettftext( $thumbnail_gd_image, 10, 0, $x, $y-4, $textColor, "./tahoma.ttf", iconv( 'cp1251', 'UTF-8', $thumb_name ) );
    }

    imagejpeg( $thumbnail_gd_image, $thumbnail_image_path, $jpeg_quality );

    // Make normal
    if( $source_image_width <= $normal_size && $source_image_height <= $normal_size ) {
        $normal_image_width = $source_image_width;
        $normal_image_height = $source_image_height;
    } elseif( 1 > $source_aspect_ratio ) {
        $normal_image_width = (int)( $normal_size * $source_aspect_ratio );
        $normal_image_height = $normal_size;
    } else {
        $normal_image_width = $normal_size;
        $normal_image_height = (int)( $normal_size / $source_aspect_ratio );
    }

    if( $normal_name ) {
      $normal_gd_image = imagecreatetruecolor( $normal_image_width, $normal_image_height + $height );
    } else {
      $normal_gd_image = imagecreatetruecolor( $normal_image_width, $normal_image_height );
    }

    imagecopyresampled( $normal_gd_image, $source_gd_image, 0, 0, 0, 0, $normal_image_width, $normal_image_height, $source_image_width, $source_image_height );

    $backgroundColor = imagecolorallocate( $normal_gd_image, 0, 0, 128 );
    $grayColor = imagecolorallocate( $normal_gd_image, 255, 255, 255 );
    $y = imagesy( $normal_gd_image );
    if( imagesx( $normal_gd_image ) >= 180 ) {
      imagefilledrectangle( $normal_gd_image, 0, $y - $height, 50, $y, $backgroundColor );
      imagettftext( $normal_gd_image, 8, 0, 1, $y-3, $grayColor, "./tahoma.ttf", 'file-up.net' );
    }

    if( $normal_name ) {
      $width = imagefontwidth( $font ) * strlen( $normal_name );
      $x = intval( imagesx( $normal_gd_image ) / 2 - $width / 2 );

      $textColor = imagecolorallocate( $normal_gd_image, 255, 255, 255 );
      imagettftext( $normal_gd_image, 10, 0, $x, $y-4, $textColor, "./tahoma.ttf", iconv( 'cp1251', 'UTF-8', $normal_name ) );
    }

    imagejpeg( $normal_gd_image, $normal_image_path, $jpeg_quality );

    // Clean
    imagedestroy( $source_gd_image );
    imagedestroy( $thumbnail_gd_image );
    imagedestroy( $normal_gd_image );

    $ref = $_SESSION['ref'];

  header( 'location:'.$_SERVER['HTTP_REFERER'] );

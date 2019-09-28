<?php

  session_start();

  require_once( "db.inc" );

  $source_image_path = $_FILES['F']['tmp_name'];
  $fname = substr( md5( $_FILES['F']['tmp_name'].date( 'YmdHis' ) ), -18 ).date( 'YmdHis' ).'.jpg';

  $session_dir = session_id();
  if( !is_dir( 'fullsize/'.$session_dir ) ) {
    mkdir( 'fullsize/'.$session_dir );
  }
  copy( $source_image_path, 'fullsize/'.$session_dir.'/'.$fname );

  $optim = substr( $fname, 0, 2 );

  if( !is_dir( 'big/'.$optim ) ) {
    mkdir( 'big/'.$optim );
  }

  if( !is_dir( 'small/'.$optim ) ) {
    mkdir( 'small/'.$optim );
  }

  $thumbnail_image_path = 'small/'.$optim.'/'.$fname;
  $normal_image_path = 'big/'.$optim.'/'.$fname;
  $jpeg_quality = $_POST['JQ'];
  $normal_size = $_POST['M'];
  $thumb_size = $_POST['VM'];
  $rotate = $_POST['R'];

  $ga = 0;

  if( isset( $_POST['VE'] ) && $_POST['VE'] == 'yes' ) {
    $thumb_name = $_POST['V'];

    $settings['VE'] = $_POST['VE'];
    $settings['V'] = $_POST['V'];
  } else {
    $thumb_name = null;
  }

  if( isset( $_POST['XE'] ) && $_POST['XE'] == 'yes' ) {
    $normal_name = $_POST['X'];

    $settings['XE'] = $_POST['XE'];
    $settings['X'] = $_POST['X'];
  } else {
    $normal_name = null;
  }

  // Проверяем загружен ли файл
  if( is_uploaded_file( $source_image_path ) ) {
    list( $source_image_width, $source_image_height, $source_image_type ) = getimagesize( $source_image_path );

    $source_gd_image = imagecreatefromjpeg( $source_image_path );

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
    if( imagesx( $thumbnail_gd_image ) >= 200 ) {
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

    $backgroundColor = imagecolorallocate( $thumbnail_gd_image, 0, 0, 128 );
    $grayColor = imagecolorallocate( $thumbnail_gd_image, 255, 255, 255 );
    $y = imagesy( $normal_gd_image );
    if( imagesx( $normal_gd_image ) >= 200 ) {
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

    if( strpos( $url, '%' ) === false ) {
      $ref = mb_convert_encoding( $url, 'CP1251', 'UTF-8' );
    } else {
      $ref = mb_convert_encoding( urldecode( $url ), 'CP1251', 'UTF-8' );
    }
    $orig_name = $_FILES['F']['name'];

    db_safe( $ref );
    db_safe( $orig_name );

    db_query( "INSERT INTO files (      fid, galery, date_upload, date_view,                          ip,                     size,                                    extension,                 filename, referer )
                          VALUES ( '$fname',    $ga,       NOW(),     NOW(), '{$_SERVER["REMOTE_ADDR"]}', '{$_FILES['F']['size']}', '$source_image_width x $source_image_height', '$orig_name', '$ref'  )" );
    echo substr( $fname, 0, -4 );
    return;

  } else {
    echo "0";
    return;
  }

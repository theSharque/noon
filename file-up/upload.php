<?php

  session_start();

  unset( $_SESSION['fok'] );
  unset( $_SESSION['dat'] );
  unset( $_SESSION['settings'] );

  if( !isset( $_SESSION['ref'] ) ) {
    $_SESSION['ref'] = isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '';
  }

  require_once( "db.inc" );

  if( $_POST['URLF'] == '' ) {
    $from_file = true;
    if( $_FILES['F']['error'] != 0 ) {
      header( 'Location: index.php?err='.$_FILES['F']['error']);
      return;
    }

    $source_image_path = $_FILES['F']['tmp_name'];
    $fname = substr( md5( $_FILES['F']['tmp_name'].date( 'YmdHis' ) ), -18 ).date( 'YmdHis' ).'.jpg';
  } else {
    $from_file = false;
    $furl = $_POST['URLF'];
    if( substr( $furl, 0, 4 ) == 'http' ) {
      $source_image_path = tempnam( sys_get_temp_dir(), 'img' );
      $img = file_get_contents( $furl );
      file_put_contents( $source_image_path, $img );
      $fname = substr( md5( $source_image_path.date( 'YmdHis' ) ), -18 ).date( 'YmdHis' ).'.jpg';

      $_FILES['F']['size'] = strlen( $img );
      $_FILES['F']['name'] = substr( strrchr( $furl, '/' ), 1 );
    } else {
      header( 'Location: index.php?err=10' );
      return;
    }
  }

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
  $thumb_size = $_POST['VM'];
  $normal_size = $_POST['M'];
  $rotate = $_POST['R'];

  $settings = array(
    'JQ' => $_POST['JQ'],
    'VM' => $_POST['VM'],
    'M' => $_POST['M'],
    'R' => $_POST['R'],
  );

  if( isset( $_POST['GA'] ) && $_POST['GA'] == 'yes' && isset( $_POST['GT'] ) && is_numeric( $_POST['GT'] ) ) {
    $ga = $_POST['GT'];
    db_safe( $ga );

    $settings['GA'] = $_POST['GA'];
    $settings['GT'] = $_POST['GT'];
  } else {
    $ga = 0;
  }

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

  $_SESSION['settings'] = serialize( $settings );

  // Проверяем загружен ли файл
  if( ( $from_file && is_uploaded_file( $source_image_path ) ) || !$from_file ) {
    list( $source_image_width, $source_image_height, $source_image_type ) = getimagesize( $source_image_path );

    if( $rotate == 0 ) {
      $exif = exif_read_data( $source_image_path );
      if( !empty( $exif['Orientation'] ) ) {
        switch( $exif['Orientation'] ) {
          case 8:
            $rotate = 3;
            break;

          case 3:
            $rotate = 2;
            break;

          case 6:
            $rotate = 1;
            break;
        }
      }

      if( !empty( $exif['IFD0']['Orientation'] ) ) {
        switch( $exif['IFD0']['Orientation'] ) {
          case 8:
            $rotate = 3;
            break;

          case 3:
            $rotate = 2;
            break;

          case 6:
            $rotate = 1;
            break;
        }
      }
    }

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

      case IMAGETYPE_WBMP:
        $source_gd_image = imagecreatefromwbmp( $source_image_path );
        break;

      case IMAGETYPE_XBM:
        $source_gd_image = imagecreatefromxbm( $source_image_path );
        break;

      default:
        $source_gd_image = false;
        break;
    }

    if( $source_gd_image === false ) {
      header( 'Location: index.php?err=9' );
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

    if( isset( $_SESSION['files'] ) ) {
      $files = unserialize( $_SESSION['files'] );
      $files[] = $fname;
    } else {
      $files = array();
      $files[] = $fname;
    }

    $_SESSION['files'] = serialize( $files );

    header( 'Location: index.php?err=0&conv=on&fid='.$fname );
    return;

  } else {
    header( 'Location: index.php?err=10' );
    return;
  }

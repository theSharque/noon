<?php

session_start();
require_once( "db.inc" );

function take_that( $gurl ) {

  if( strpos( $gurl, 'q=' ) !== false ) {
    $url = get_between( $gurl, 'q=', '&' );
  }

  if( strpos( $gurl, 'yandex.' ) !== false ) {
    $url = get_between( $gurl, 'text=', '&' );
  }

  if( strpos( $url, '%' ) === false ) {
    $ref = 'google '.mb_convert_encoding( $url, 'CP1251', 'UTF-8' );
  } else {
    $ref = 'google '.mb_convert_encoding( urldecode( $url ), 'CP1251', 'UTF-8' );
  }

  db_safe( $ref );

  $test_file = db_fetch_row( "SELECT fid FROM files WHERE referer = '$ref'" );

  if( isset( $test_file['fid'] ) ) {
    header( 'Location: big_'.substr( $test_file['fid'], 0, -4 ).'.html' );
    exit;
//  } else {
//    header( 'Location: galery.php' );
//    return;
  }

//  $data = file_get_contents( "http://www.google.ru/search?hl=ru&tbm=isch&q=$url" );
  $data = file_get_contents( "http://images.yandex.kz/yandsearch?text=$url" );

  $pic_num = mt_rand( 0, 10 );
  for( $i = 0; $i < $pic_num; $i++ ) {
    $data = get_between( $data, 'class="b-images-item' );
  }

  $furl = get_between( $data, 'url&quot;:&quot;', '&quot;,&quot;' );

  $from_file = false;
  if( substr( $furl, 0, 4 ) == 'http' ) {
    $source_image_path = tempnam( sys_get_temp_dir(), 'img' );
    $img = file_get_contents( $furl );
    file_put_contents( $source_image_path, $img );
    $fname = substr( md5( $source_image_path.date( 'YmdHis' ) ), -18 ).date( 'YmdHis' ).'.jpg';

    $_FILES['F']['size'] = strlen( $img );

    db_safe( $furl );
    $_FILES['F']['name'] = substr( strrchr( $furl, '/' ), 1 );
  } else {
    return;
  }

  $optim = substr( $fname, 0, 2 );

  $session_dir = session_id();
  if( !is_dir( 'fullsize/'.$session_dir ) ) {
    mkdir( 'fullsize/'.$session_dir );
  }
  copy( $source_image_path, 'fullsize/'.$session_dir.'/'.$fname );

  if( !is_dir( 'big/'.$optim ) ) {
    mkdir( 'big/'.$optim );
  }

  if( !is_dir( 'small/'.$optim ) ) {
    mkdir( 'small/'.$optim );
  }

  $thumbnail_image_path = 'small/'.$optim.'/'.$fname;
  $normal_image_path = 'big/'.$optim.'/'.$fname;
  $jpeg_quality = 80;
  $thumb_size = 220;
  $normal_size = 640;
  $rotate = 0;

  $test = array_flip( explode( ' ', $ref ) );

  $galery_dic = array(
    'ню' => 6,
    'порно' => 6,
    'пикантное' => 6,
    'непристойные' => 6,
    'голеком' => 6,
    'голые' => 6,
    'голая' => 6,
    'обножонные' => 6,
    'обножонная' => 6,
    'камасутре' => 6,
    'камасутра' => 6,
    'секс' => 6,
    'секси' => 6,
    'sexy' => 6,
    'раздетая' => 6,
    'раздетые' => 6,

    'юмор' => 3,
    'приколы' => 3,
    'смешные' => 3,
    'прикольные' => 3,
    'фотоприколы' => 3,
    'демотиватор' => 3,

    'фоторамка' => 8,
    'фоторамки' => 8,
    'рамка' => 8,
    'рамки' => 8,

    'женщины' => 9,
    'женщина' => 9,
    'девушка' => 9,
    'девченки' => 9,
    'девочка' => 9,
    'девочек' => 9,
    'девочки' => 9,
    'парень' => 9,
    'парней' => 9,
    'мужчина' => 9,
    'мужчин' => 9,

    'bmw' => 4,
    'mercedes' => 4,
    'audi' => 4,
    'volvo' => 4,
    'мерседес' => 4,
    'ауди' => 4,
    'вольво' => 4,
    'автомобили' => 4,
    'автомобиль' => 4,
    'форд' => 4,
    'ford' => 4,
    'lexus' => 4,
    'toyota' => 4,
    'лексус' => 4,
    'тоета' => 4,
  );

  $result = array_intersect_key( $galery_dic ,$test );

  if( is_array( $result ) && count( $result ) ) {

/*
debug_it( $ref );
debug_it( $result );
*/
    $ga = current( $result );

    $settings['GA'] = 'yes';
    $settings['GT'] = $ga;
  } else {
    $ga = 0;
  }

  $settings = array(
    'JQ' => 80,
    'VM' => 180,
    'M' => 640,
    'R' => 0,
  );

  $_SESSION['settings'] = serialize( $settings );

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
    return;
  }

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

  $thumbnail_gd_image = imagecreatetruecolor( $thumbnail_image_width, $thumbnail_image_height );

  imagecopyresampled( $thumbnail_gd_image, $source_gd_image, 0, 0, 0, 0, $thumbnail_image_width, $thumbnail_image_height, $source_image_width, $source_image_height );

  $backgroundColor = imagecolorallocate( $thumbnail_gd_image, 0, 0, 128 );
  $grayColor = imagecolorallocate( $thumbnail_gd_image, 255, 255, 255 );
  $y = imagesy( $thumbnail_gd_image );
  if( imagesx( $thumbnail_gd_image ) >= 200 ) {
    imagefilledrectangle( $thumbnail_gd_image, 0, $y - $height, 50, $y, $backgroundColor );
    imagettftext( $thumbnail_gd_image, 8, 0, 1, $y-3, $grayColor, "./tahoma.ttf", 'file-up.net' );
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

  $normal_gd_image = imagecreatetruecolor( $normal_image_width, $normal_image_height );

  imagecopyresampled( $normal_gd_image, $source_gd_image, 0, 0, 0, 0, $normal_image_width, $normal_image_height, $source_image_width, $source_image_height );

  $backgroundColor = imagecolorallocate( $normal_gd_image, 0, 0, 128 );
  $grayColor = imagecolorallocate( $normal_gd_image, 255, 255, 255 );
  $y = imagesy( $normal_gd_image );
  if( imagesx( $normal_gd_image ) >= 200 ) {
    imagefilledrectangle( $normal_gd_image, 0, $y - $height, 50, $y, $backgroundColor );
    imagettftext( $normal_gd_image, 8, 0, 1, $y-3, $grayColor, "./tahoma.ttf", 'file-up.net' );
  }

  imagejpeg( $normal_gd_image, $normal_image_path, $jpeg_quality );

  // Clean
  imagedestroy( $source_gd_image );
  imagedestroy( $thumbnail_gd_image );
  imagedestroy( $normal_gd_image );

  db_query( "INSERT INTO files (      fid, galery, date_upload, date_view,                          ip,                     size,                                    extension,                 filename, referer )
                        VALUES ( '$fname',    $ga,       NOW(),     NOW(), '{$_SERVER["REMOTE_ADDR"]}', '{$_FILES['F']['size']}', '$source_image_width x $source_image_height', '{$_FILES['F']['name']}', '$ref'  )" );


  if( isset( $_SESSION['files'] ) ) {
    $files = unserialize( $_SESSION['files'] );
    $files[] = $fname;
  } else {
    $files = array();
    $files[] = $fname;
  }

  $_SESSION['files'] = serialize( $files );

  header( 'Location: big_'.substr( $fname, 0, -4 ).'.html' );
  exit;
}

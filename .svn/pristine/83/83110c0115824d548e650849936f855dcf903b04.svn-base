<?php

  session_start();

  require_once( "db.inc" );

  if( !isset( $_SESSION['ref'] ) ) {
    $_SESSION['ref'] = isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '';
  }

  if( !isset( $_GET['err'] ) ) {
    include( 'index.inc' );
    return;
  } else {
    $err = $_GET['err'];
  }

  switch( $err ) {
    case 0:
      if( isset( $_GET['fid'] ) ) {

        $fid = $_GET['fid'];
        $html_fid = substr( $fid, 0, -3 ).'html';
        db_safe( $fid );

        $dat = db_fetch_row( "SELECT size, extension, filename FROM files WHERE fid = '$fid'" );

        $optim = substr( $fid, 0, 2 );
        $normal_image_path = '/var/www/picture/big/'.$optim.'/'.$fid;
        list( $dest_image_width, $dest_image_height, $dest_image_type ) = getimagesize( $normal_image_path );
        $file_size = filesize( $normal_image_path );

        $dat['nSize'] = $dest_image_width.' x '.$dest_image_height.' пик.,'.$file_size.' байт';

        include( "show.inc" );
      }
      break;

    case 1:
    case 2:
      $err_txt = "Размер принятого файла превысил максимально допустимый размер.";
      include( "empty.inc" );
      break;

    case 3:
      $err_txt = "Загружаемый файл был получен только частично.";
      include( "empty.inc" );
      break;

    case 4:
      $err_txt = "Файл не был загружен.";
      include( "empty.inc" );
      break;

    case 5:
      $err_txt = "Неизвестная ошибка.";
      include( "empty.inc" );
      break;

    case 6:
      $err_txt = "Отсутствует временная папка.";
      include( "empty.inc" );
      break;

    case 7:
      $err_txt = "Не удалось записать файл на диск.";
      include( "empty.inc" );
      break;

    case 8:
      $err_txt = "PHP-расширение остановило загрузку файла.";
      include( "empty.inc" );
      break;

    case 9:
      $err_txt = "Загруженый файл не является картинкой.";
      include( "empty.inc" );
      break;

    case 10:
      $err_txt = "Не удалось загрузить файл.";
      include( "empty.inc" );
      break;
  }

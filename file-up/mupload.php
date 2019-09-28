<?php

  session_start();

  if( !isset( $_SESSION['ref'] ) ) {
    $_SESSION['ref'] = isset( $_SERVER['HTTP_REFERER'] ) ? $_SERVER['HTTP_REFERER'] : '';
  }

  require_once( "db.inc" );

  $fok = isset( $_SESSION['fok'] ) ? unserialize( $_SESSION['fok'] ) : array();
  $dat = isset( $_SESSION['dat'] ) ? unserialize( $_SESSION['dat'] ) : array();

  $fcount = 1;
  foreach( $_POST as $key => $furl ) {
    if( substr( $key, 0, 3 ) == 'url' && substr( $furl, 0, 4 ) == 'http' ) {

      $tmp_file = tempnam( sys_get_temp_dir(), 'img' );
      $img = file_get_contents( $furl );
      file_put_contents( $tmp_file, $img );

      $_FILES['F'.$fcount]['tmp_name'] = $tmp_file;
      $_FILES['F'.$fcount]['size'] = strlen( $img );
      $_FILES['F'.$fcount]['name'] = substr( strrchr( $furl, '/' ), 1 );
      $_FILES['F'.$fcount]['error'] = 0;
      $_FILES['F'.$fcount]['type'] = 'application/octet-stream';
      $_FILES['F'.$fcount]['from_url'] = true;

      $fcount++;
    }
  }

  foreach( $_FILES as $file_item ) {
    if( $file_item['error'] == 0 ) {
      $source_image_path = $file_item['tmp_name'];
      $fname = substr( md5( $file_item['tmp_name'].date( 'YmdHis' ) ), -18 ).date( 'YmdHis' ).'.jpg';

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

      $settings = array(
        'JQ' => $_POST['JQ'],
        'VM' => $_POST['VM'],
        'M' => $_POST['M'],
        'R' => $_POST['R'],
      );

      $thumbnail_image_path = 'small/'.$optim.'/'.$fname;
      $normal_image_path = 'big/'.$optim.'/'.$fname;
      $jpeg_quality = $_POST['JQ'];
      $thumb_size = $_POST['VM'];
      $normal_size = $_POST['M'];
      $rotate = $_POST['R'];

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
      if( ( isset( $file_item['from_url'] ) && $file_item['from_url'] ) || is_uploaded_file( $source_image_path ) ) {
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
          continue;
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
        $orig_name = $file_item['name'];

        db_safe( $ref );
        db_safe( $orig_name );

        db_query( "INSERT INTO files (      fid, galery, date_upload, date_view,                          ip,                   size,                                    extension,     filename, referer )
                              VALUES ( '$fname',    $ga,       NOW(),     NOW(), '{$_SERVER["REMOTE_ADDR"]}', '{$file_item['size']}', '$source_image_width x $source_image_height', '$orig_name', '$ref'  )" );

        if( isset( $_SESSION['files'] ) ) {
          $files = unserialize( $_SESSION['files'] );
          $files[] = $fname;
        } else {
          $files = array();
          $files[] = $fname;
        }

        $_SESSION['files'] = serialize( $files );
        $fok[] = $fname;

        list( $dest_image_width, $dest_image_height, $dest_image_type ) = getimagesize( $normal_image_path );
        $file_size = filesize( $normal_image_path );

        $dat[$fname]['filename'] = $file_item['name'];
        $dat[$fname]['extension'] = $source_image_width.' x '.$source_image_height;
        $dat[$fname]['size'] = $file_item['size'];
        $dat[$fname]['nSize'] = $dest_image_width.' x '.$dest_image_height.' пик.,'.$file_size.' байт';
      }
    }
  }

  $_SESSION['fok'] = serialize( $fok );
  $_SESSION['dat'] = serialize( $dat );

  if( count( $fok ) == 0 ) {
    header( 'Location: index.php?err=10' );
    return;
  }
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="Бесплатный хостинк фотографий и картинок">
  <title>Фотохостинг - загрузи фото бесплатно - все загрузки</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>

<!-- Google Code for &#1047;&#1072;&#1075;&#1088;&#1091;&#1079;&#1082;&#1072; Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 1012123603;
var google_conversion_language = "en";
var google_conversion_format = "3";
var google_conversion_color = "ffffff";
var google_conversion_label = "E2EmCJ3X1gQQ04_P4gM";
var google_conversion_value = 0;
/* ]]> */
</script>
<script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1012123603/?value=0&amp;label=E2EmCJ3X1gQQ04_P4gM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>

</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src=logo.png></a>
    </td>
    <td align=center style="vertical-align: middle;">
<!--      Top block -->
<?php include('top.inc'); ?>
    </td>
    <td>
<!--  Top left block -->
    </td>
  </tr>
  <tr>
    <td width=275 align=center>
<!--      Left block -->
<?php include('left.inc'); ?>
<br>
    </td>
    <td width=762 align=center>
<?php include('menu.inc'); ?>

<table cellpadding="0" cellspacing="0" border="0" width="762" class="brd">
  <tr>
    <td colspan="2" style="height: 25px; padding-left: 5px; padding-top: 5px;">
      Загруженное изображение
    </td>
  </tr>

<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
  <tr>
    <td style="padding-left: 15px; padding-top: 5px; padding-bottom: 0px; width: 30%;" width="30%">
      <a target="_blank" href="http://<?php echo $_SERVER["HTTP_HOST"].'/big_'.$html_fid ?>">
        <img src="/small/<?php echo substr( $fid, 0, 2).'/'.$fid; ?>">
      </a>
    </td>

    <td style="padding-left: 15px; padding-top: 0px; padding-right: 5px;"><?php
  $session_dir = session_id();

  if( file_exists( 'fullsize/'.$session_dir.'/'.$fid ) ) {
    echo "<a href='turn.php?d=0&fid=$fid'>Без поворота</a><br>";
    echo "<a href='turn.php?d=1&fid=$fid'>Повернуть на 90 градусов по часовой</a><br>";
    echo "<a href='turn.php?d=3&fid=$fid'>Повернуть на 90 градусов против часовой</a><br>";
    echo "<a href='turn.php?d=2&fid=$fid'>Повернуть на 180 градусов</a>";
    echo "<h3><a href='editor.php?fid=$fid'>Редактор</a></h3><br>";
  }
?>      Название: <?php echo $dat[$fid]['filename']; ?><br>
      Оригинал: <?php echo $dat[$fid]['extension'].' пик.,'.$dat[$fid]['size'].' байт'; ?><br>
      Результат: <?php echo $dat[$fid]['nSize']; ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" align="center"><h2>Чтобы разместить это фото в социальной сети, кликните по изображению.</h2></td>
  </tr>
<?php } ?>

  <tr>
    <td colspan="2" class="rl">
      1. Ссылка
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo 'http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      2. Картинка в тексте
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '[IMG]http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'[/IMG]'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      3. Превью - увеличение по клику
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '[URL=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'][IMG]http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'[/IMG][/URL]<br>[URL=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.']фото[/URL]'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      4. HTML: картинка в тексте
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '&lt;img alt="Загрузить фото бесплатно" src="http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'"&gt;'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      5. HTML: превью - увеличение по клику
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '&lt;a target="_blank" href="http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'"&gt;&lt;img alt="Загрузить фото бесплатно" src="http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'"&gt;&lt;/a&gt'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      6. BBCode, строчные буквы: картинка в тексте
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '[img]http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'[/img]'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      7. BBCode, строчные буквы: превью - увеличение по клику
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo '[url=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'][img]http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'[/img][/url]<br>[url=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.']фото[/url]'; ?></div>
<?php } ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      8. Картинка на странице просмотра полноразмерного изображения
<?php foreach( $fok as $fid ) { $html_fid = substr( $fid, 0, -3 ).'html'; ?>
<br><div class="dlink" onclick=st(this);><?php echo 'http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid; ?></div>
<?php } ?>
    </td>
  </tr>
</table>
    </td>
    <td align=left>
<!--      Right block -->
    </td>
  </tr>
  <tr>
    <td colspan="3" align=center>
<!--      Bottom block -->
    </td>
<?php include('bottom.inc'); ?>
</table>
</body>
</html>
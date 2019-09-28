<?php

session_start();
$session_dir = session_id();

require_once( "db.inc" );

$settings = unserialize( $_SESSION['settings'] );

$fname = $_GET['fid'];
db_safe( $fname );

$optim = substr( $fname, 0, 2 );

  $preset_arr = array(
    0 => array( 'name' => 'Без фильтров', 'bw' => null, 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => 0, 'ct' => 0, 'sm' => 0, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 0 ),
    1 => array( 'name' => 'Старая пленка', 'bw' => 'checked', 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => 'checked', 'br' => -40, 'ct' => 0, 'sm' => 0, 'px' => 0, 'clr' => 32, 'clg' => 16, 'clb' => 0 ),
    2 => array( 'name' => 'Agfa', 'bw' => null, 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => -50, 'ct' => -20, 'sm' => 0, 'px' => 0, 'clr' => 64, 'clg' => 48, 'clb' => 0 ),
    3 => array( 'name' => 'Простой карандаш', 'bw' => 'checked', 'ng' => 'checked', 'ed' => 'checked', 'em' => null, 'mr' => null, 'gb' => null, 'br' => -70, 'ct' => -90, 'sm' => 9, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 0 ),
    4 => array( 'name' => 'Цветной карандаш', 'bw' => null, 'ng' => 'checked', 'ed' => 'checked', 'em' => null, 'mr' => null, 'gb' => null, 'br' => -70, 'ct' => -90, 'sm' => 9, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 0 ),
    5 => array( 'name' => 'Ярче', 'bw' => null, 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => 20, 'ct' => -40, 'sm' => 3, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 0 ),
    6 => array( 'name' => 'Ярко синий', 'bw' => null, 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => -70, 'ct' => -90, 'sm' => 0, 'px' => 10, 'clr' => 0, 'clg' => 0, 'clb' => 48 ),
    7 => array( 'name' => 'Гипс', 'bw' => 'checked', 'ng' => null, 'ed' => null, 'em' => 'checked', 'mr' => null, 'gb' => 'checked', 'br' => 0, 'ct' => -100, 'sm' => -10, 'px' => 0, 'clr' => 32, 'clg' => 16, 'clb' => 0 ),
    8 => array( 'name' => 'Ч/Б синий', 'bw' => 'checked', 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => 0, 'ct' => 0, 'sm' => 0, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 32 ),
    9 => array( 'name' => 'Ч/Б красный', 'bw' => 'checked', 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => 0, 'ct' => 0, 'sm' => 0, 'px' => 0, 'clr' => 32, 'clg' => 0, 'clb' => 0 ),
   10 => array( 'name' => 'Сбросить все', 'bw' => null, 'ng' => null, 'ed' => null, 'em' => null, 'mr' => null, 'gb' => null, 'br' => 0, 'ct' => 0, 'sm' => 0, 'px' => 0, 'clr' => 0, 'clg' => 0, 'clb' => 0 ),
  );

if( isset( $_POST['back'] ) ) {

  $source_image_path = 'fullsize/'.$session_dir.'/'.$fname;

  if( !is_dir( 'big/'.$optim ) ) {
    mkdir( 'big/'.$optim );
  }

  if( !is_dir( 'small/'.$optim ) ) {
    mkdir( 'small/'.$optim );
  }

  if( isset( $_POST['preset'] ) && $_POST['preset'] > 0 ) {
    $preset = $_POST['preset'];

    $bw = $preset_arr[$preset]['bw'];
    $ng = $preset_arr[$preset]['ng'];
    $ed = $preset_arr[$preset]['ed'];
    $em = $preset_arr[$preset]['em'];
    $mr = $preset_arr[$preset]['mr'];
    $gb = $preset_arr[$preset]['gb'];
    $br = $preset_arr[$preset]['br'];
    $ct = $preset_arr[$preset]['ct'];
    $sm = $preset_arr[$preset]['sm'];
    $px = $preset_arr[$preset]['px'];

    $clr = $preset_arr[$preset]['clr'];
    $clg = $preset_arr[$preset]['clg'];
    $clb = $preset_arr[$preset]['clb'];
  } else {
    $bw = isset( $_POST['bw'] ) ? 'checked' : null;
    $ng = isset( $_POST['ng'] ) ? 'checked' : null;
    $ed = isset( $_POST['ed'] ) ? 'checked' : null;
    $em = isset( $_POST['em'] ) ? 'checked' : null;
    $mr = isset( $_POST['mr'] ) ? 'checked' : null;
    $gb = isset( $_POST['gb'] ) ? 'checked' : null;
    $br = isset( $_POST['br'] ) ? $_POST['br'] : 0;
    $ct = isset( $_POST['ct'] ) ? $_POST['ct'] : 0;
    $sm = isset( $_POST['sm'] ) ? $_POST['sm'] : 0;
    $px = isset( $_POST['px'] ) ? $_POST['px'] : 0;

    $clr = isset( $_POST['clr'] ) ? $_POST['clr'] : 0;
    $clg = isset( $_POST['clg'] ) ? $_POST['clg'] : 0;
    $clb = isset( $_POST['clb'] ) ? $_POST['clb'] : 0;
  }


  $rotate = isset( $_POST['R'] ) ? $_POST['R'] : ( isset( $settings['R'] ) ? $settings['R'] : 0 );

  $settings['R'] = $rotate;

  $thumbnail_image_path = '/var/www/picture/small/'.$optim.'/'.$fname;
  $normal_image_path = '/var/www/picture/big/'.$optim.'/'.$fname;
  $jpeg_quality = $settings['JQ'];
  $thumb_size = $settings['VM'];
  $normal_size = $settings['M'];

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

    // filters
    if( $bw ) {
      imagefilter( $source_gd_image, IMG_FILTER_GRAYSCALE );
    }

    if( $ed ) {
      imagefilter( $source_gd_image, IMG_FILTER_EDGEDETECT );
    }

    if( $em ) {
      imagefilter( $source_gd_image, IMG_FILTER_EMBOSS );
    }

    if( $mr ) {
      imagefilter( $source_gd_image, IMG_FILTER_MEAN_REMOVAL );
    }

    if( $gb ) {
      imagefilter( $source_gd_image, IMG_FILTER_GAUSSIAN_BLUR );
    }

    if( $br ) {
      imagefilter( $source_gd_image, IMG_FILTER_BRIGHTNESS, $br );
    }

    if( $ct ) {
      imagefilter( $source_gd_image, IMG_FILTER_CONTRAST, $ct );
    }

    if( $sm ) {
      imagefilter( $source_gd_image, IMG_FILTER_SMOOTH, $sm );
    }

    if( $px ) {
      imagefilter( $source_gd_image, IMG_FILTER_PIXELATE, $px );
    }

    if( $clr || $clg || $clb ) {
      imagefilter( $source_gd_image, IMG_FILTER_COLORIZE, $clr, $clg, $clb );
    }

    if( $ng ) {
      imagefilter( $source_gd_image, IMG_FILTER_NEGATE );
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

    $_SESSION['settings'] = serialize( $settings );
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="Бесплатный хостинк фотографий и картинок">
  <title>Фотохостинг - загрузи фото бесплатно - редактор</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>
</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src=logo.png border=0></a>
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
    </td>
    <td width="740px" align=center>
<?php include('menu.inc'); ?>

<?php
if( isset( $fname ) ) {

  $back = isset( $_POST['back'] ) ? $_POST['back'] : $_SERVER['HTTP_REFERER'];

  echo '<br><a href="'.$back.'">Закончить редактирование</a><br><br>';
  echo "<form method=post action='editor.php?fid=$fname'>";
  echo "<input type=hidden name='back' value='$back'>";
?>
  <label for="preset">Готовые настройки фильтров</label>
  <select id="preset" name="preset">
<?php
  for( $i = 0; $i < count( $preset_arr ); $i += 1 ) {
    echo "    <option value='$i'>{$preset_arr[$i]['name']}</option>";
  }
?>
  </select>
  <input type="submit" value="Применить"><br>
<img src="big/<?php echo $optim; ?>/<?php echo $fname; ?>"><br>
<table border=0 width=640>
<tr>
  <td>
    <input type="checkbox" id="bw" name="bw" <?php echo $bw; ?>>
    <label for="bw">Сделать черно-белой</label>
  </td>
  <td>
    <input type="checkbox" id="ng" name="ng" <?php echo $ng; ?>>
    <label for="ng">Инвертировать цвета</label>
  </td>
</tr>
<tr>
  <td>
    <input type="checkbox" id="ed" name="ed" <?php echo $ed; ?>>
    <label for="ed">Выделение контура</label>
  </td>
  <td>
    <input type="checkbox" id="em" name="em" <?php echo $em; ?>>
    <label for="em">Добавить рельеф</label>
  </td>
</tr>
<tr>
  <td>
    <input type="checkbox" id="gb" name="gb" <?php echo $gb; ?>>
    <label for="gb">Размыть</label>
  </td>
  <td>
    <input type="checkbox" id="mr" name="mr" <?php echo $mr; ?>>
    <label for="mr">Эффект эскиза</label>
  </td>
</tr>
<tr>
  <td>
    <select id="br" name="br">
<?php
  for( $i = -100; $i <= 100; $i += 10 ) {
    if( $br == $i ) {
      echo "      <option selected='selected' value='$i'>$i%</option>";
    } else {
      echo "      <option value='$i'>$i%</option>";
    }
  }
?>
    </select>
    <label for="br">Яркость</label>
  </td>
  <td>
    <select id="ct" name="ct">
<?php
  for( $i = -100; $i <= 100; $i += 10 ) {
    if( $ct == $i ) {
      echo "      <option selected='selected' value='$i'>$i%</option>";
    } else {
      echo "      <option value='$i'>$i%</option>";
    }
  }
?>
    </select>
    <label for="ct">Контраст</label>
  </td>
</tr>
<tr>
  <td>
    <select id="sm" name="sm">
<?php
  for( $i = -10; $i <= 10; $i += 1 ) {
    if( $sm == $i ) {
      echo "      <option selected='selected' value='$i'>$i px</option>";
    } else {
      echo "      <option value='$i'>$i px</option>";
    }
  }
?>
    </select>
    <label for="sm">Сглаженность</label>
  </td>
  <td>
    <select id="px" name="px">
<?php
  for( $i = -10; $i <= 10; $i += 1 ) {
    if( $px == $i ) {
      echo "      <option selected='selected' value='$i'>$i px</option>";
    } else {
      echo "      <option value='$i'>$i px</option>";
    }
  }
?>
    </select>
    <label for="px">Пиксилезация</label>
  </td>
</tr>
<tr>
  <td>
    Колоризация:<br>
    <select id="clr" name="clr" style='color: white; background-color: rgb(128, 0, 0);'>
<?php
  for( $i = 0; $i <= 256; $i += 16 ) {
    if( $clr == $i ) {
      echo "      <option style='background-color: rgb($i, 0, 0);' selected='selected' value='$i'>$i</option>";
    } else {
      echo "      <option style='background-color: rgb($i, 0, 0);' value='$i'>$i</option>";
    }
  }
?>
    </select>

    <select id="clg" name="clg" style='color: white; background-color: rgb(0, 128, 0);'>
<?php
  for( $i = 0; $i <= 256; $i += 16 ) {
    if( $clg == $i ) {
      echo "      <option style='background-color: rgb(0, $i, 0);' selected='selected' value='$i'>$i</option>";
    } else {
      echo "      <option style='background-color: rgb(0, $i, 0);' value='$i'>$i</option>";
    }
  }
?>
    </select>

    <select id="clb" name="clb" style='color: white; background-color: rgb(0, 0, 128);'>
<?php
  for( $i = 0; $i <= 256; $i += 16 ) {
    if( $clb == $i ) {
      echo "      <option style='background-color: rgb(0, 0, $i);' selected='selected' value='$i'>$i</option>";
    } else {
      echo "      <option style='background-color: rgb(0, 0, $i);' value='$i'>$i</option>";
    }
  }
?>
    </select>
  </td>
  <td>
    <label for="R">Повернуть на</label>
    <select id="R" name="R" style="width: 140px;">
      <option <? if( $rotate == 0 ) echo 'selected="selected"'; ?> value="0">0°</option>
      <option <? if( $rotate == 1 ) echo 'selected="selected"'; ?> value="1">90° по часовой</option>
      <option <? if( $rotate == 2 ) echo 'selected="selected"'; ?> value="2">180°</option>
      <option <? if( $rotate == 3 ) echo 'selected="selected"'; ?> value="3">90° против часовой</option>
    </select>
  </td>
</tr>

</table>
<input type="submit" value="Применить">
</form>
<?php
  echo '<br><a href="'.$back.'">Закончить редактирование</a><br><br>';
} else {
  echo 'Возникла ошибка<br>'.$err_txt;
}
?>
    </td>
    <td align=left>
<!--      Right block -->
<?php include('right.inc'); ?>
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

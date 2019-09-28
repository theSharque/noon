<?php
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="На сайте можно загрузить фото бесплатно, а так же любые картинки. Имеются открытые галереи и возможность публиковать вконтакте, однокласниках, facebook">
<meta name="Keywords" content="загрузить фото для форума, загрузить фото в интернет, загрузить фото бесплатно, закачать фото в интернет, загрузить картинки, загрузить бесплатно, Закачать фото, Загрузить фото">
  <title>Фотохостинг - загрузить фото бесплатно</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>

  <script type="text/javascript" src="r.php?u=http://vk.com/js/api/share.js?10" charset="windows-1251"></script>
</head>
<body>
<script><!--
  restorator();
--></script>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src=logo.png border=0></a>

<table><tr><td>
<!-- Put this script tag to the place, where the Share button will be -->
<script type="text/javascript"><!--
document.write(VK.Share.button({url: "http://file-up.net"},{type: "button", text: "Сохранить"}));
--></script>
</td><td>
<!-- Поместите этот тег туда, где должна отображаться кнопка +1. -->
<div class="g-plusone" data-size="medium" data-annotation="bubble" data-width="120" data-href="http://file-up.net"></div>
</td></tr></table>

<!-- Поместите этот тег за последним тегом виджета кнопка +1. -->
<script type="text/javascript">
  window.___gcfg = {lang: 'ru'};

  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/platform.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>

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
    <td width=740 align=justify>
<?php include('menu.inc'); ?>

<table cellpadding="0" cellspacing="5" border="0" class="brd" width="100%">
  <tr>
    <td colspan="4">
      <h1>Загрузить фото</h1>
    </td>
  </tr>
  <tr>
    <td>
      <form action="upload.php" id="upload" method="post" enctype="multipart/form-data" name="upload">
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
          <td>
            <a onclick="return frame_go(true);" href="#">С компьютера</a>
          </td>
          <td colspan=3>
            <a onclick="return frame_go(false);" href="#">Из интернета</a>
          </td>
        </tr>

        <tr id="in_file">
          <td colspan="2" width="370px">
            <div class="file_input_div">
              <input type="button" value="Обзор..." class="file_input_button">
              <input name="F" id="F" type="file" class="file_input_hidden" onchange="javascript: document.getElementById('fileName').value = this.value">
            </div>
            <input type="text" id="fileName" class="file_input_textbox" readonly="readonly">
          </td>

          <td colspan="2">
            <label id="FLabel" for="F">Выберите файл на своем компьютере</label>
          </td>
        </tr>

        <tr id="in_url">
          <td colspan="2" width="370px">
            <input name="URLF" id="URLF" type="text">
          </td>

          <td colspan="2">
            <label for="URLF">Укажите ссылку в Интернете (URL)</label>
          </td>
        </tr>

        <tr>
          <td>
            <label for="O">Уменьшить до</label>
          </td>
          <td>
            <input type="text" id="M" name="M" maxlength="4" value="640" size="4">
            <label for="M">пикселей</label>
          </td>
    
          <td>
            <label for="VM">Создавать превью</label>
          </td>
          <td>
            <input type="text" id="VM" name="VM" maxlength="4" value="220" size="3">
            <label for="VM">пикселей</label>
          </td>
        </tr>

        <tr>
          <td>
            <input type="checkbox" id="VE" name="VE" value="yes" checked="checked">
            <label for="VE">Надпись на превью</label>
          </td>
          <td>
            <input type="text" id="V" name="V" value="Увеличить" style="width: 194px">
          </td>

          <td>
            <label for="JQ">Качество JPEG</label>
          </td>
          <td>
            <input type="text" id="JQ" name="JQ" maxlength="3" value="85" size="3">      
          </td>
        </tr>

        <tr>
          <td>
            <input type="checkbox" id="XE" name="XE" value="yes">
            <label for="XE">Надпись на фото</label>
          </td>
          <td>
            <input type="text" id="X" name="X" value="" style="width: 194px">
          </td>

          <td>
            <label for="RE">Повернуть на</label>
          </td>
          <td>
            <select id="R" name="R" style="width: 140px;">
              <option selected="selected" value="0">
                0°
              </option>
    
              <option value="1">
                90° по часовой
              </option>
    
              <option value="2">
                180°
              </option>
    
              <option value="3">
                90° против часовой
              </option>
            </select>
          </td>
        </tr>
    
        <tr>
          <td colspan=2>
            <input type="submit" value="Загрузить" class="upload">
          </td>

          <td>
            <input type="checkbox" id="GA" name="GA" value="yes">
            <label for="GA">В галерею</label>
          </td>

          <td>
            <select id="GT" name="GT" style="width: 140px;">
<?php
              require_once( "galname.inc" );
              foreach( $gt_names as $key => $gt ) {
                echo "                <option value='$key'>$gt</option>";
              }
?>
            </select>
          </td>

        </tr>
      </table>
      </form>
    </td>
  </tr>
</table>

<?php
  if( isset( $_SESSION['files'] ) && count( unserialize( $_SESSION['files'] ) ) ) {
    $files = unserialize( $_SESSION['files'] );
?>
Файлы которые вы уже загрузили.
      <table>
<?php
    $l = 1;
    foreach( $files as $item ) {
      $fid = $item;
      db_safe( $fid );
      $filename = db_fetch_val( "SELECT filename FROM files WHERE fid='$fid'", 'filename' );
      echo "<tr><td>$l.<a href='http://file-up.net/index.php?err=0&fid=$fid'>$filename</a></td></tr>";
      $l++;
    }
?>
      </table>
<?php
  } else {
?>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="glr">
  <tr height=16><td colspan=5 align=center><h2>Наши галереи</h2></td></tr>
  <tr height=140>
    <td><a href='/galery.php?gt=1'>Пейзажи<br><br><img border=0 src='/gal/1.jpg'></a></td>
    <td><a href='/galery.php?gt=2'>Скриншоты игр<br><br><img border=0 src='/gal/2.jpg'></a></td>
    <td><a href='/galery.php?gt=3'>Юмор и приколы<br><br><img border=0 src='/gal/3.jpg'></a></td>
    <td><a href='/galery.php?gt=4'>Автомобили<br><br><img border=0 src='/gal/4.jpg'></a></td>
    <td><a href='/galery.php?gt=5'>Животные и растения<br><br><img border=0 src='/gal/5.jpg'></a></td>
  </tr>
  <tr height=140>
    <td><a href='/galery.php?gt=6'>Для взрослых<br><br><img border=0 src='/gal/6.jpg'></a></td>
    <td><a href='/galery.php?gt=7'>Аватары<br><br><img border=0 src='/gal/7.jpg'></a></td>
    <td><a href='/galery.php?gt=8'>Фоторамки<br><br><img border=0 src='/gal/8.jpg'></a></td>
    <td><a href='/galery.php?gt=9'>Люди<br><br><img border=0 src='/gal/9.jpg'></a></td>
    <td><a href='/galery.php?gt=10'>Другое<br><br><img border=0 src='/gal/10.jpg'></a></td>
  </tr>
  <tr height=16><td colspan=5 align=center></td></tr>
</table>
<p>Загрузить фото в Интернет? Нет ничего проще!</p>
<p>На нашем сервисе вы можете абсолютно бесплатно загрузить картинки и фото для хранения на сервере, а также их использования в социальных сетях или форумах.</p>
<p>Если требуется быстро закачать фото в интернет, то в этом поможет именно наш сервис. Вы просто указываете путь к фотографии на вашем компьютере либо даёте ссылку на изображение в интернете – и тут же получаете набор ссылок. Использовав их, можно поместить свою картинку на любой интернет-ресурс, например – загрузить фото для форума. Среди этих ссылок есть прямой адрес на хранимое изображение, BB-код для вставки картинки на форумах, поддерживающих такую технологию, html-код создания гиперссылки на картинку и т.д.</p>
<p>Прямо с нашего сайта, сделав всего пару кликов, можно загрузить фото на нужную страницу ВКонтакте, в ЖЖ, в Твиттер, в Facebook и многие другие социальные сети. Кроме того, на нашем сайте присутствуют тематические галереи. Помещайте в них свои файлы для всеобщего обозрения, либо сами просматривайте и используйте чужие снимки.</p>
<p>Максимальный размер фотографии, которую можно загрузить – 10 МБ, это позволяет закачать фото с самым высоким разрешением. Кроме того, наш сервис поддерживает мультизагрузку, позволяя за один раз загрузить бесплатно для дальнейшего хранения на сервере неограниченное количество изображений. Ещё одна полезная функция – встроенный графический редактор, который позволяет не просто загрузить фото в Интернет, но и применять к картинке различные фильтры, делать на ней надписи, менять ее размер и т.д.</p>
<p>Загружайте фотографии, редактируйте и мгновенно публикуйте их в социальных сетях. Всё это бесплатно и без регистрации!</p>
<?php
  }
?>
    </td>
    <td align=left>
<!--      Right block -->
<?php include('right.inc'); ?>
    </td>
  </tr>
  <tr height=100%>
    <td align=center>
<!--      Left bottom block -->
    </td>
    <td align=justify>
<!-- Center bottom -->
    </td>
    <td align=left>
<!--      Right bottom block -->
    </td>
  </tr>
<?php include('bottom.inc'); ?>
</table>
</body>
</html>
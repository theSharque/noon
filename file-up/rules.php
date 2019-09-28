<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="Бесплатный хостинк фотографий и картинок">
  <title>Фотохостинг - загрузи фото бесплатно - правила</title>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>
</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img border=0 src=logo.png></a>
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
    <td width="740" align=center>
<?php include('menu.inc'); ?>
<table cellpadding="0" cellspacing="15" border="0" width="100%" class="brd">
  <tr>
    <td>
На сайте запрещено выкладывать материалы оскорбляющие религиозные или политические взгляды посетителей. Любые материалы носящие оскорбительный характер будут удалены без согласования с владельцем.<br><br>
Порнография, а так же материалы приравненные к порнографии будут удалятся администрацией незамедлительно.<br><br>
Любые материалы <b>эротического характера, фотографии обнаженной натуры, ню, бодиарт</b> и т.п. должны располагаться исключительно в <b>галерее для взрослых</b> или быть недоступными без прямой ссылки.<br><br>
При поступлении жалобы со стороны посетителей на эротические фото или материалы спорного и порно содержания, фото будут удалятся незамедлительно.<br><br>
<b>Откровенные порно фотографии</b> не подлежат размещению на ресурсе. <b>Эротические фотографии</b> должны быть выполены со вкусом и не вызывать отвращения.<br><br>
Принадлежность фотографии к эротике или порнографии определяется исключительно администрацией сайта без согласования с владельцем.<br><br>
Администрация оставляет за собой право по собственному усмотрению удалить любой материал без согласия владельца.
    </td>
  </tr>
</table>

<?php include('tizers.inc'); ?>
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
<?php
  $stars = db_fetch_val( "SELECT COUNT(id) cnt FROM stars", 'cnt' );
  $planets = db_fetch_val( "SELECT COUNT(id) cnt FROM planets", 'cnt' );
  $ships = db_fetch_val( "SELECT COUNT(id) cnt FROM ships", 'cnt' );
  $wars = db_fetch_val( "SELECT MAX(war_id) cnt FROM war_log", 'cnt' );
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<title>������� 21 ����</title>
<link href="main.css" rel="stylesheet" type="text/css" />
</head>
<body background="images/bg.jpg">
<?php if( $conversion ){ echo $conversion; } ?>
<div id="star">
  <img src="images/star.jpg" width="600" height="450" />
</div>
<div id="planet">
  <img src="images/planet.jpg" width="400" height="800" />
</div>
<table id="main-content"  height="100%" cellspacing="0" cellpadding="0" border="0" align="center">
<tr id="top-content">
  <td colspan="7" height="200">
  <img src="images/head.png" />
  </td>
</tr>
<tr id="menu-content">
  <td id="menu-bg">&nbsp;</td>
  <td id="menu-link"><a href="index.php"><img src="images/btn0.png" width="120" height="24"></a></td>
  <td id="menu-link"><a href="index.php?pid=about"><img src="images/btn1.png" width="120" height="24"></a></td>
  <td id="menu-link"><a href="index.php?pid=contact"><img src="images/btn2.png" width="120" height="24"></a></td>
<!--  <td id="menu-link"><a href="test"><img src="images/btn3.png" width="120" height="24"></a></td> -->
  <td id="menu-link"><a href="index.php?pid=faq"><img src="images/btn4.png" width="120" height="24"></a></td>
  <td id="menu-bg">&nbsp;</td>
</tr>
<tr id="main-body" height="100%"><td colspan="7" height="100%">
<table height="100%"><tr valign="top">
<td width="1000">
<table id="statistics" width="750" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="11"><img src="images/frame_01.png" width="11" height="11" /></td>
    <td background="images/frame_02.png"></td>
    <td width="11"><img src="images/frame_03.png" width="11" height="11" /></td>
  </tr>
  <tr height="100%">
    <td background="images/frame_04.png"></td>
    <td id="bgh"><?php if( $main_content ){ echo $main_content; } ?></td>
    <td background="images/frame_06.png"></td>
  </tr>
  <tr>
    <td width="11"><img src="images/frame_07.png" width="11" height="11" /></td>
    <td background="images/frame_08.png"></td>
    <td width="11"><img src="images/frame_09.png" width="11" height="11" /></td>
  </tr>
</table>
</td>
</tr></table>
</td></tr>
<tr><td id="main-footer" colspan="7">
<a href="index.php/?pid=rules">���������������� ����������</a>
<a href="index.php/?pid=billing">������� ������</a>
<a href="index.php/?pid=license">������������ ����������</a>
</td></tr>
<tr id="main-footer"><td colspan="7">
��� ����� ��������, ����� ������������� ��������� ��� �������� ���������� �������� �� ������.<br />21 NooN &copy;2010
</td>
</tr>
</table>
</body>
</html>
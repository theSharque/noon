<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="���������� ������� ���������� � ��������">
  <title>����������� - ������� ���� ��������� - �������</title>
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
�� ����� ��������� ����������� ��������� ������������ ����������� ��� ������������ ������� �����������. ����� ��������� ������� �������������� �������� ����� ������� ��� ������������ � ����������.<br><br>
�����������, � ��� �� ��������� ������������ � ����������� ����� �������� �������������� ���������������.<br><br>
����� ��������� <b>������������ ���������, ���������� ���������� ������, ��, �������</b> � �.�. ������ ������������� ������������� � <b>������� ��� ��������</b> ��� ���� ������������ ��� ������ ������.<br><br>
��� ����������� ������ �� ������� ����������� �� ����������� ���� ��� ��������� �������� � ����� ����������, ���� ����� �������� ���������������.<br><br>
<b>����������� ����� ����������</b> �� �������� ���������� �� �������. <b>����������� ����������</b> ������ ���� �������� �� ������ � �� �������� ����������.<br><br>
�������������� ���������� � ������� ��� ����������� ������������ ������������� �������������� ����� ��� ������������ � ����������.<br><br>
������������� ��������� �� ����� ����� �� ������������ ���������� ������� ����� �������� ��� �������� ���������.
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
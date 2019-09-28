<?php

  require_once( "galname.inc" );

if( isset( $pic ) ) {
  $fid = substr( $pic, 8 );
  $page = substr( $fid, 0, -4 );
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
  <meta name="Description" content="{description}">
  <meta name="keywords" content="{keywords}">

  <title>Фотохостинг - {title}</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="/main.css" rel="stylesheet" type="text/css">
  <link rel="canonical" href="{url}" />

  <?php include('head.inc'); ?>
<script type="text/javascript" src="http://vkontakte.ru/js/api/share.js?9" charset="windows-1251"></script>
</head>
<body>

<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img src="/logo.png" border=0></a>
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

<h2>{header}</h2>
<div align=left>{body}</div>
    </td>
    <td align=left>
<!--      Right block -->
<?php include('right.inc'); ?>
<?php include('direct.inc'); ?>
    </td>
  </tr>
  <tr>
    <td colspan="3" align=center>
<!--      Bottom block -->
    </td>
<?php include('bottom.inc'); ?>
<?php include('tail.inc'); ?>
</table>
</body>
</html>
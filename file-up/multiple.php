<?php
  session_start();

  require_once( "db.inc" );

  unset( $_SESSION['fok'] );
  unset( $_SESSION['dat'] );
  unset( $_SESSION['settings'] );

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="���������� ������� ���������� � ��������">
  <title>����������� - ��������� ���� ��������� - ��������������</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">
  <?php include('head.inc'); ?>

  <script type="text/javascript" src="r.php?u=http://vk.com/js/api/share.js?10" charset="windows-1251"></script>
</head>
<body>
<table height=100% width=100%>
  <tr height=110>
    <td align=center>
      <a href="/"><img border=0 src=logo.png></a>

<table><tr><td>
<!-- Put this script tag to the place, where the Share button will be -->
<script type="text/javascript"><!--
document.write(VK.Share.button({url: "http://file-up.net"},{type: "button", text: "���������"}));
--></script>
</td><td>
<!-- ��������� ���� ��� ����, ��� ������ ������������ ������ +1. -->
<div class="g-plusone" data-size="medium" data-annotation="bubble" data-width="120" data-href="http://file-up.net"></div>
</td></tr></table>

<!-- ��������� ���� ��� �� ��������� ����� ������� ������ +1. -->
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

<table cellpadding="0" cellspacing="5" border="0" width="100%" class="brd">
  <tr>
    <td colspan="4">
      <h1>�������� ���������� ������</h1>
    </td>
  </tr>
  <tr>
    <td>
      <form action="mupload.php" id="upload" method="post" enctype="multipart/form-data" name="upload">
      <table id="filesTable" cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
          <td>
            <a onclick="return frame_go(true);" href="#">� ����������</a>
          </td>
          <td colspan=3>
            <a onclick="return frame_go(false);" href="#">�� ���������</a>
          </td>
        </tr>

        <tr id="in_file">
          <td id="filesTD" colspan="2" width="370px">
            <div id="fileAll">
              <div class="file_input_div">
                <input type="button" value="�����..." class="file_input_button">
                <input name="F1" id="F1" type="file" class="file_input_hidden" onchange="addTr(this);">
              </div>
              <input name="file" type="text" id="fileName1" class="file_input_textbox" readonly="readonly">
            </div>
          </td>
          <td colspan="2">
            <label id="FLabel" for="F1">�������� ���� �� ����� ����������</label>
          </td>
        </tr>

        <tr id="in_url">
          <td id="urlsTD" colspan="2" width="370px">
            <div name="urls" id="urlAll">
              <input name="url1" id="U1" type="text" oninput="addUrl(this);">
            </div>
          </td>

          <td colspan="2">
            <label for="U1">������� ������ � ��������� (URL)</label>
          </td>
        </tr>

        <tr>
          <td>
            <label for="O">��������� ��</label>
          </td>
          <td>
            <input type="text" id="M" name="M" maxlength="4" value="640" size="4">
            <label for="M">��������</label>
          </td>
    
          <td>
            <label for="VM">��������� ������</label>
          </td>
          <td>
            <input type="text" id="VM" name="VM" maxlength="4" value="220" size="3">
            <label for="VM">��������</label>
          </td>
        </tr>

        <tr>
          <td>
            <input type="checkbox" id="VE" name="VE" value="yes" checked="checked">
            <label for="VE">������� �� ������</label>
          </td>
          <td>
            <input type="text" id="V" name="V" value="���������" style="width: 194px">
          </td>

          <td>
            <label for="JQ">�������� JPEG</label>
          </td>
          <td>
            <input type="text" id="JQ" name="JQ" maxlength="3" value="85" size="3">      
          </td>
        </tr>

        <tr>
          <td>
            <input type="checkbox" id="XE" name="XE" value="yes">
            <label for="XE">������� �� ����</label>
          </td>
          <td>
            <input type="text" id="X" name="X" value="" style="width: 194px">
          </td>

          <td>
            <label for="RE">��������� ��</label>
          </td>
          <td>
            <select id="R" name="R" style="width: 140px;">
              <option selected="selected" value="0">
                0�
              </option>
    
              <option value="1">
                90� �� �������
              </option>
    
              <option value="2">
                180�
              </option>
    
              <option value="3">
                90� ������ �������
              </option>
            </select>
          </td>
        </tr>
    
        <tr>
          <td colspan=2>
            <input type="submit" value="���������" class="upload">
          </td>

          <td>
            <input type="checkbox" id="GA" name="GA" value="yes">
            <label for="GA">� �������</label>
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
����� ������� �� ��� ���������.
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
  <tr height=16><td colspan=5 align=center><h2>���� �������</h2></td></tr>
  <tr height=140>
    <td><a href='/galery.php?gt=1'>�������<br><br><img border=0 src='/gal/1.jpg'></a></td>
    <td><a href='/galery.php?gt=2'>��������� ���<br><br><img border=0 src='/gal/2.jpg'></a></td>
    <td><a href='/galery.php?gt=3'>���� � �������<br><br><img border=0 src='/gal/3.jpg'></a></td>
    <td><a href='/galery.php?gt=4'>����������<br><br><img border=0 src='/gal/4.jpg'></a></td>
    <td><a href='/galery.php?gt=5'>�������� � ��������<br><br><img border=0 src='/gal/5.jpg'></a></td>
  </tr>
  <tr height=140>
    <td><a href='/galery.php?gt=6'>��� ��������<br><br><img border=0 src='/gal/6.jpg'></a></td>
    <td><a href='/galery.php?gt=7'>�������<br><br><img border=0 src='/gal/7.jpg'></a></td>
    <td><a href='/galery.php?gt=8'>���������<br><br><img border=0 src='/gal/8.jpg'></a></td>
    <td><a href='/galery.php?gt=9'>����<br><br><img border=0 src='/gal/9.jpg'></a></td>
    <td><a href='/galery.php?gt=10'>������<br><br><img border=0 src='/gal/10.jpg'></a></td>
  </tr>
  <tr height=16><td colspan=5 align=center></td></tr>
</table>
<p>��������� ���� � ��������? ��� ������ �����!</p>
<p>�� ����� ������� �� ������ ��������� ��������� ��������� �������� � ���� ��� �������� �� �������, � ����� �� ������������� � ���������� ����� ��� �������.</p>
<p>���� ��������� ������ �������� ���� � ��������, �� � ���� ������� ������ ��� ������. �� ������ ���������� ���� � ���������� �� ����� ���������� ���� ���� ������ �� ����������� � ��������� � � ��� �� ��������� ����� ������. ����������� ��, ����� ��������� ���� �������� �� ����� ��������-������, �������� � ��������� ���� ��� ������. ����� ���� ������ ���� ������ ����� �� �������� �����������, BB-��� ��� ������� �������� �� �������, �������������� ����� ����������, html-��� �������� ����������� �� �������� � �.�.</p>
<p>����� � ������ �����, ������ ����� ���� ������, ����� ��������� ���� �� ������ �������� ���������, � ��, � �������, � Facebook � ������ ������ ���������� ����. ����� ����, �� ����� ����� ������������ ������������ �������. ��������� � ��� ���� ����� ��� ��������� ���������, ���� ���� �������������� � ����������� ����� ������.</p>
<p>������������ ������ ����������, ������� ����� ��������� � 10 ��, ��� ��������� �������� ���� � ����� ������� �����������. ����� ����, ��� ������ ������������ ��������������, �������� �� ���� ��� ��������� ��������� ��� ����������� �������� �� ������� �������������� ���������� �����������. ��� ���� �������� ������� � ���������� ����������� ��������, ������� ��������� �� ������ ��������� ���� � ��������, �� � ��������� � �������� ��������� �������, ������ �� ��� �������, ������ �� ������ � �.�.</p>
<p>���������� ����������, ������������ � ��������� ���������� �� � ���������� �����. �� ��� ��������� � ��� �����������!</p>
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
    <td align=center>
<!--      Right bottom block -->
    </td>
  </tr>
<?php include('bottom.inc'); ?>
</table>
</body>
</html>
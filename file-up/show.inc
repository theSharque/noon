<?php
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
<meta name="Description" content="���������� ������� ���������� � ��������">
  <title>����������� - ������� ���� ��������� - ��������</title>
  <script type="text/javascript" src="main.js"></script>
  <link href="main.css" rel="stylesheet" type="text/css">

  <?php include('head.inc'); ?>

<?php
  if( isset( $_GET['conv'] ) && $_GET['conv'] == 'on' ) {
?>

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

<?php } ?>

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
<br>
    </td>
    <td width=762 align=center>
<?php include('menu.inc'); ?>

<table cellpadding="0" cellspacing="0" border="0" width="762" class="brd">
  <tr>
    <td colspan="2" style="height: 25px; padding-left: 5px; padding-top: 5px;">
      ����������� �����������
    </td>
  </tr>

  <tr>
    <td style="padding-left: 15px; padding-top: 5px; padding-bottom: 0px; width: 30%;" width="30%">
      <a target="_blank" href="http://<?php echo $_SERVER["HTTP_HOST"].'/big_'.$html_fid ?>">
        <img src="/small/<?php echo substr( $fid, 0, 2).'/'.$fid; ?>">
      </a>
    </td>

    <td style="padding-left: 15px; padding-top: 0px; padding-right: 5px;"><?php
  $session_dir = session_id();

  if( file_exists( 'fullsize/'.$session_dir.'/'.$fid ) ) {
    echo "<a href='turn.php?d=0&fid=$fid'>��� ��������</a><br>";
    echo "<a href='turn.php?d=1&fid=$fid'>��������� �� �������</a><br>";
    echo "<a href='turn.php?d=3&fid=$fid'>��������� ������ �������</a><br>";
    echo "<a href='turn.php?d=2&fid=$fid'>��������� �� 180 ��������</a>";
    echo "<h2><a href='editor.php?fid=$fid'>��������</a></h2>";
    echo "<h2><a id='delete' href='delete.php?fid=$fid'>�������</a></h2><br>";
  }

?>      ��������: <?php echo $dat['filename']; ?><br>
      ��������: <?php echo $dat['extension'].' ���.,'.$dat['size'].' ����'; ?><br>
      ���������: <?php echo $dat['nSize']; ?>
    </td>
  </tr>

  <tr>
    <td colspan="2" align="center"><h2>����� ���������� ��� ���� � ���������� ����, �������� �� �����������.</h2></td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      1. ������ ������<br>
      <div class="dlink" onclick=st(this);><?php echo 'http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      2. �������� � ������<br>
      <div class="dlink" onclick=st(this);><?php echo '[IMG]http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'[/IMG]'; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      3. ������ - ���������� �� �����<br>
      <div class="dlink" onclick=st(this);><?php echo '[URL=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'][IMG]http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'[/IMG][/URL]<br>[URL=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.']����[/URL]';?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      4. HTML: �������� � ������<br>
      <div class="dlink" onclick=st(this);><?php echo '&lt;img alt="����" src="http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'"&gt;'; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      5. HTML: ������ - ���������� �� �����<br>
      <div class="dlink" onclick=st(this);><?php echo '&lt;a target="_blank" href="http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'"&gt;&lt;img alt="����" src="http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'"&gt;&lt;/a&gt'; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      6. BBCode, �������� �����: �������� � ������<br>
      <div class="dlink" onclick=st(this);><?php echo '[img]http://'.$_SERVER["HTTP_HOST"].'/big_'.$fid.'[/img]'; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      7. BBCode, �������� �����: ������ - ���������� �� �����<br>
      <div class="dlink" onclick=st(this);><?php echo '[url=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.'][img]http://'.$_SERVER["HTTP_HOST"].'/sml_'.$fid.'[/img][/url][/URL]<br>[url=http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid.']����[/url]'; ?></div>
    </td>
  </tr>

  <tr>
    <td colspan="2" class="rl">
      8. �������� �� �������� ��������� ��������������� �����������<br>
      <div class="dlink" onclick=st(this);><?php echo 'http://'.$_SERVER["HTTP_HOST"].'/big_'.$html_fid; ?></div>
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
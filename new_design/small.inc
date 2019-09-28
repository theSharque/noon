<?php
  $stars = db_fetch_val( "SELECT COUNT(id) cnt FROM stars", 'cnt' );
  $planets = db_fetch_val( "SELECT COUNT(id) cnt FROM planets", 'cnt' );
  $ships = db_fetch_val( "SELECT COUNT(id) cnt FROM ships", 'cnt' );
  $wars = db_fetch_val( "SELECT MAX(war_id) cnt FROM war_log", 'cnt' );
?>
<!doctype html>
<HTML>
<HEAD>
<meta http-equiv="content-type" content="text/html; charset=windows-1251">
<TITLE>Полдень 21 века</TITLE>
</HEAD>
<BODY background="images/bg-starback.gif" bgcolor=#000000 text=#FFFFFF alink=#FFFFFF vlink=#FFFFFF link=#FFFFFF leftmargin=0 topmargin=0>
<?php if( $conversion ){ echo $conversion; } ?>
<TABLE width=100% cellpadding=0 cellspacing=0>
<TR><td width=300 rowspan=2><img src=images/planet.png width=300></td><td align=center><img src=images/logo.png></td><td width=300 rowspan=2>&nbsp</td></TR>
<tr><td valign=bottom>
<form action="index.php" method="POST">
<table width=100%>
<tr><td align=right>Имя пользователя :</td><td><input type=text maxlength=56 name=login></td></tr>
<tr><td align=right>Пароль :</td><td><input type=password maxlength=56 name=pass></td></tr>
<tr><td colspan=2 align=center><input type=submit value='Войти'></td></tr>
<tr><td colspan=2 align=center><a href=register.php>Поступить в академию (регистрация)</a></td></tr>
</table>
</form>
</td></tr>
<TR valign=top><td>
<table>
<tr><td colspan=2 align=center><h2>Статистика</h2></td></tr>
<tr><td align=right>Звезд в галактике:</td><td><?php echo $stars ?></td></tr>
<tr><td align=right>Планет в галактике:</td><td><?php echo $planets ?></td></tr>
<tr><td align=right>Космических кораблей:</td><td><?php echo $ships ?></td></tr>
<tr><td align=right>Проведенных сражений:</td><td><?php echo $wars ?></td></tr>
</table>
</td><td colspan=2>
<?php if( $main_content ){ echo $main_content; } ?>
</td></TR>
</TABLE>
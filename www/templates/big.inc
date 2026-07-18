<?php

  $loged = authorization();

  $stars = db_fetch_val( "SELECT COUNT(id) cnt FROM stars", 'cnt' );
  $planets = db_fetch_val( "SELECT COUNT(id) cnt FROM planets", 'cnt' );
  $ships = db_fetch_val( "SELECT COUNT(id) cnt FROM ships", 'cnt' );
  $wars = db_fetch_val( "SELECT val FROM variables WHERE name = 'war_count'", 'val' );
  $users = db_fetch_array( "SELECT u.login, ua.char_level FROM users u INNER JOIN users_active ua ON ua.id = u.id WHERE u.status = 1 ORDER BY ua.char_level DESC LIMIT 0,10" );
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Description" content="Космическая стратегия. Полдень 21 века. Это online стратегия в реальном времени.">
<meta name="Keywords" content="Космическая стратегия, Полдень 21 века, online стратегия в реальном времени, браузерная игра, стратегии, игры онлайн, космические игры, космические стратегии">
    <title><?php echo $title; ?></title>
    <link href="styles/main.css" rel="stylesheet" type="text/css">
</head>
<body>
    <table id="maincontainer" width="950" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td class="leftborder" valign="top" width="25"><img src="images/mainborderlefttop.jpg" border="0" width="25" height="233"></td>
            <td rowspan="2" width="100%" align="center" valign="top">
                <table width="900" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="446" valign="top" align="left">
<?php
  if( $loged ) {
?>
                            <div style="position:relative;">
                                <img src="images/statspanelbg.png" border="0" width="419" height="219">
                                <div id="statscontainer">
<h3>Статистика:</h3><br>
<table id="statstable" width="285" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left">Звезд в галактике</td>
    <td align="right"><?php echo $stars ?></td></tr>
  <tr>
    <td align="left">Планет в галактике</td>
    <td align="right"><?php echo $planets ?></td></tr>
  <tr>
    <td align="left">Космических кораблей</td>
    <td align="right"><?php echo $ships ?></td></tr>
  <tr>
    <td align="left">Проведенных сражений</td>
    <td align="right"><?php echo $wars ?></td>
  </tr>
  <tr>
    <td colspan=2 align="center">
      <br>
      <a href="page.php">
      <img id="buttonreturngame" onmouseover="menuOver('buttonreturngame');" onmouseout="menuOut('buttonreturngame');" src="images/buttonreturngameoff.png" border="0" width="209" height="21">
      </a>
    </td>
  </tr>
</table>
<script type="text/javascript">
  var imgbuttonreturngameoff = new Image();
  imgbuttonreturngameoff.src = "images/buttonreturngameoff.png";
  var imgbuttonreturngameon = new Image();
  imgbuttonreturngameon.src = "images/buttonreturngameon.png";

  var idbuttonreturngame = document.getElementById("buttonreturngame");
</script>
                                </div>
                            </div>
<?php
/*
  if( $_SERVER['SERVER_PORT'] == 80 ) {
    echo "<p class='versiontext'><a href='https://21noon.com{$_SERVER['REQUEST_URI']}'>Перейти на SSL версию</a></p>";
  } else {
    echo "<p class='versiontext'><a href='http://21noon.com{$_SERVER['REQUEST_URI']}'>Перейти на HTTP версию</a></p>";
  }
*/
?>
                        </td>
<?php
  } else {
?>
                            <table class="secondarytable" width="355" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="3"><img src="images/secondarytabletop.gif" border="0" width="355" height="20"></td>
                                </tr>
                                <tr>
                                    <td class="secondarytableleft" valign="top"><img src="images/secondarytableleft1.gif" border="0" width="52" height="198"></td>
                                    <td class="secondarytableinternal" rowspan="2" valign="top">
                                        <table width="258" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="secondarytabletextcontainer" valign="top">

<form id="login_form" action="page.php" method="POST">
<table class="logintable" width="257" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="logintablecontainer" align="left"><h3>Вход</h3></td>
        <td align="right" valign="bottom"><a href="index.php?pid=repair">Забыли пароль?</a></td>
    </tr>
   <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="20"></td></tr>
 
    <tr>
        <td align="left">Игрок</td>
        <td align="right"><input type="text" name="login" class="logintextfield" placeholder="Игрок" /></td>
    </tr>

    <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="10"></td></tr>
    <tr>
        <td align="left">Пароль</td>
        <td align="right"><input type="password" name="pass" class="logintextfield" placeholder="Пароль" /></td>
    </tr>
    <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="15"></td></tr>
    <tr>
        <td align="center" colspan="2"><input id="ButStart" type="image" src="images/buttonstartgameoff.png" onmouseover="menuOver('ButStart');" onmouseout="menuOut('ButStart');" width="209" height="21" name="submit" /></td>
    </tr>
    <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="20"></td></tr>
    <tr><td colspan="2" bgcolor="#89b5ff"><img src="images/dot.gif" border="0" width="1" height="1"></td></tr>
    <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="20"></td></tr>
    <tr>
        <td align="left" colspan="2">Регистрация</td>
    </tr>
    <tr><td colspan="2"><img src="images/dot.gif" border="0" width="1" height="10"></td></tr>
    <tr>
        <td align="center" colspan="2"><a href="index.php?pid=register"><img id="ButRegister" onmouseover="menuOver('ButRegister');" onmouseout="menuOut('ButRegister');" src="images/buttonregisteroff.png" border="0" width="257" height="32"></a></td>
    </tr> 
</table>
</form>
<script type="text/javascript">
    var imgButStartoff = new Image();
    imgButStartoff.src = "images/buttonstartgameoff.png";
    var imgButStarton = new Image();
    imgButStarton.src = "images/buttonstartgameon.png";
    var imgButRegisteroff = new Image();
    imgButRegisteroff.src = "images/buttonregisteroff.png";
    var imgButRegisteron = new Image();
    imgButRegisteron.src = "images/buttonregisteron.png";
    var idButStart = document.getElementById("ButStart");
    var idButRegister = document.getElementById("ButRegister");
</script>
                                                </td>
                                                <td><img src="images/dot.gif" border="0" width="1" height="106"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="secondarytableright" valign="top"><img src="images/secondarytableright1.gif" border="0" width="19" height="198"></td>
                                </tr>
                                <tr>
                                    <td class="secondarytableleft" valign="bottom"><img src="images/secondarytableleft2.gif" border="0" width="52" height="74"></td>
                                    <td class="secondarytableright" valign="bottom"><img src="images/secondarytableright2.gif" border="0" width="19" height="74"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img src="images/secondarytablebottom.gif" border="0" width="355" height="18"></td>
                                </tr>
                            </table>
<?php
/*
  if( $_SERVER['SERVER_PORT'] == 80 ) {
    echo "<p class='versiontext'><a href='https://21noon.com{$_SERVER['REQUEST_URI']}'>Перейти на SSL версию</a></p>";
  } else {
    echo "<p class='versiontext'><a href='http://21noon.com{$_SERVER['REQUEST_URI']}'>Перейти на HTTP версию</a></p>";
  }
*/
?>
                        </td>
<?php
  }
?>
                        <td width="454" align="right" valign="top"><a href="index.php"><img src="images/21noonlogo.png" border="0" width="454" height="271" alt="Полдень 21 века"></a></td>
                    </tr>
                </table>
<?php
  if( !$loged ) {
?>
                <img src="images/dot.gif" border="0" width="900" height="20">
<?php
  }
?>
                <table id="topmenu" width="900" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><img src="images/dot.gif" border="0" width="264" height="57"></td>
                        <td><a href="index.php"><img id="Menu01" onmouseover="menuOver('Menu01');" onmouseout="menuOut('Menu01');" src="images/menu01off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="index.php?pid=about"><img id="Menu02" onmouseover="menuOver('Menu02');" onmouseout="menuOut('Menu02');" src="images/menu02off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="index.php?pid=gallery"><img id="Menu05" onmouseover="menuOver('Menu05');" onmouseout="menuOut('Menu05');" src="images/menu05off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="index.php?pid=enc"><img id="Menu03" onmouseover="menuOver('Menu03');" onmouseout="menuOut('Menu03');" src="images/menu03off.png" border="0" width="123" height="46"></a></td>
                        <td><img src="images/menublank.png" border="0" width="139" height="46"></td>
                        <td><img src="images/dot.gif" border="0" width="4" height="57"></td>
                    </tr>
                </table>
                <script type="text/javascript">
                    var imgMenu01off = new Image();
                    imgMenu01off.src = "images/menu01off.png";
                    var imgMenu01on = new Image();
                    imgMenu01on.src = "images/menu01on.png";
                    var imgMenu02off = new Image();
                    imgMenu02off.src = "images/menu02off.png";
                    var imgMenu02on = new Image();
                    imgMenu02on.src = "images/menu02on.png";
                    var imgMenu03off = new Image();
                    imgMenu03off.src = "images/menu03off.png";
                    var imgMenu03on = new Image();
                    imgMenu03on.src = "images/menu03on.png";
//                    var imgMenu04off = new Image();
//                    imgMenu04off.src = "images/menu04off.png";
//                    var imgMenu04on = new Image();
//                    imgMenu04on.src = "images/menu04on.png";
                    var imgMenu05off = new Image();
                    imgMenu05off.src = "images/menu05off.png";
                    var imgMenu05on = new Image();
                    imgMenu05on.src = "images/menu05on.png";

                    var idMenu01 = document.getElementById("Menu01");
                    var idMenu02 = document.getElementById("Menu02");
                    var idMenu03 = document.getElementById("Menu03");
//                    var idMenu04 = document.getElementById("Menu04");
                    var idMenu05 = document.getElementById("Menu05");

    function menuOver(id) {
        eval('id'+id+'.src = img'+id+'on.src;');
    }

    function menuOut(id) {
        eval('id'+id+'.src = img'+id+'off.src;');
    }
                </script>
                <img src="images/dot.gif" border="0" width="900" height="20">
                <table width="900" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td id="maintext" valign="top" align="right">
                            <table class="maintexttable" width="886" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="3"><img src="images/inttexttabletop.gif" border="0" width="886" height="22"></td>
                                </tr>
                                <tr>
                                    <td class="maintexttableleft" valign="top"><img src="images/maintexttableleft1.gif" border="0" width="20" height="221"></td>
                                    <td class="maintexttableinternal" rowspan="2" width="824" valign="top">
                                        <table width="824" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td><img src="images/dot.gif" border="0" width="1" height="124"></td>
                                                <td class="maintextcontainer" valign="top" width="823">
<?php if( $main_content ){ echo $main_content; } ?>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="maintexttableright" valign="top"><img src="images/maintexttableright1.gif" border="0" width="42" height="221"></td>
                                </tr>
                                <tr>
                                    <td class="maintexttableleft" valign="bottom"><img src="images/maintexttableleft2.gif" border="0" width="20" height="135"></td>
                                    <td class="maintexttableright" valign="bottom"><img src="images/maintexttableright2.gif" border="0" width="42" height="135"></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><img src="images/inttexttablebottom.gif" border="0" width="886" height="15"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <img src="images/dot.gif" border="0" width="900" height="20">
<table class="footertable" width="860" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="footertabletextcontainer" align="center">
            <a href="index.php?pid=rules">Правила игры</a> | <a href="index.php?pid=license">Пользовательское соглашение</a> | <a href="index.php?pid=contacts">Контакты</a>
        </td>
    </tr>

    <tr>
        <td class="footertabletextcontainer" align="center">Все права защищены, любое использование материала без согласия владельцев преследуется по закону.<br>The noon &copy; 2010-2014</td>
    </tr>
</table>
                <img src="images/dot.gif" border="0" width="900" height="20">
            </td>
            <td class="rightborder" valign="top" width="25" background=""><img src="images/mainborderrighttop.jpg" border="0" width="25" height="233"></td>
        </tr>
        <tr>
            <td class="leftborder" height="202" width="25" valign="bottom"><img src="images/mainborderleftbottom.jpg" border="0" width="25" height="202"></td>
            <td class="rightborder" height="202" width="25" valign="bottom"><img src="images/mainborderrightbottom.jpg" border="0" width="25" height="202"></td>
        </tr>
    </table>
</body>
</html>
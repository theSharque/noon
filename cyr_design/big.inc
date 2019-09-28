<?php
  $stars = db_fetch_val( "SELECT COUNT(id) cnt FROM stars", 'cnt' );
  $planets = db_fetch_val( "SELECT COUNT(id) cnt FROM planets", 'cnt' );
  $ships = db_fetch_val( "SELECT COUNT(id) cnt FROM ships", 'cnt' );
  $wars = db_fetch_val( "SELECT MAX(war_id) cnt FROM war_log", 'cnt' );
  $users = db_fetch_array( "SELECT login, char_level FROM users WHERE status = 1 ORDER BY char_level DESC LIMIT 0,10" );
  $top = '';
  foreach( $users as $user ) {
    $top .= '<tr><td align="left">'.$user['login'].'</td><td align="right">'.$user['char_level']."</td></tr>\n";
  }
  $top .= '<tr><td colspan=2 align=center><a href="index.php?pid=fulllist&p=0">Полный список</a></td></tr>';
?>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Полдень 21 века</title>
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
                            <div style="position:relative;">
                                <img src="images/statspanelbg.png" border="0" width="419" height="219">
                                <div id="statscontainer">
<h3>Статистика:</h3>
<br>
<table id="statstable" width="285" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td align="left">Звезд в галактике</td>
        <td align="right">177</td>
    </tr>
    <tr>
        <td align="left">Планет в галактике</td>
        <td align="right">1220</td>
    </tr>
    <tr>
        <td align="left">Космических кораблей</td>
        <td align="right">1024</td>
    </tr>
    <tr>
        <td align="left">Проведенных сражений</td>
        <td align="right">1219</td>
    </tr>
</table>
                                </div>
                            </div>
                        </td>
                        <td width="454" align="right" valign="top"><img src="images/21noonlogo.png" border="0" width="454" height="271"></td>
                    </tr>
                </table>
                <table id="topmenu" width="900" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><img src="images/dot.gif" border="0" width="208" height="57"></td>
                        <td><a href="#"><img id="Menu01" onmouseover="menuOver('Menu01');" onmouseout="menuOut('Menu01');" src="images/menu01off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="#"><img id="Menu02" onmouseover="menuOver('Menu02');" onmouseout="menuOut('Menu02');" src="images/menu02off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="#"><img id="Menu03" onmouseover="menuOver('Menu03');" onmouseout="menuOut('Menu03');" src="images/menu03off.png" border="0" width="123" height="46"></a></td>
                        <td><a href="#"><img id="Menu05" onmouseover="menuOver('Menu05');" onmouseout="menuOut('Menu05');" src="images/menu05off.png" border="0" width="123" height="46"></a></td>
                        <td><img src="images/menublank.png" border="0" width="196" height="46"></td>
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
<h3>Новая online стратегия</h3>
<br>
В конце XXI века человечество достигло развития достаточного для космической экспансии. Были изобретены антигравитационные двигатели, межпланетные ускорители и гипергалактический двигатель. Все эти изобретения дали возможность распространятся по всей вселенной.<br>
<br>
Конфедерация планет организовала собственную академию пилотов. После подготовки пилота его отправляют на колонизацию планеты в отдаленной звездной системе.<br>
<br>
Дальше пилот предоставлен только себе и полностью отвечает за свои поступки. Конфедерация оказывает посильную помощь в освоении планеты, однако не вмешивается в локальные конфликты и войны.<br>
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
            <a href="index.php?pid=rules">Правила игры</a> | <a href="index.php?pid=billing">Условия оплаты</a> | <a href="index.php?pid=license">Пользовательское соглашение</a> | <a href="index.php?pid=contacts">Контакты</a>
        </td>
    </tr>
    <tr>
        <td class="footertabletextcontainer" align="center">Все права защищены, любое использование материала без согласия владельцев карается по закону.<br>21 NooN &copy;2010</td>
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

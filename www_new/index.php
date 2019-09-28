<?php
  if( !isset( $_SESSION ) ) {
    @session_start();
  }

  if( substr( $_SERVER['HTTP_HOST'], 0, 4 ) == 'www.' ) {
    header( 'Location: http://'.substr( $_SERVER['HTTP_HOST'], 4 ).$_SERVER['REQUEST_URI'] );
  }

  if (!defined('_SAPE_USER')){
    define('_SAPE_USER', '2ecff8ad8e254025ba7b1b60741e1f37'); 
  }
  require_once($_SERVER['DOCUMENT_ROOT'].'/'._SAPE_USER.'/sape.php'); 

  $o['force_show_code'] = false;
  $sape = new SAPE_client($o);
  $sape_link = false;

  require_once( "./include/boot.inc" );
  bootup();
  
  if( !isset( $_SESSION['ext_meta_id'] ) && isset( $_GET['ext_meta_id'] ) ) {
    $_SESSION['ext_meta_id'] = $_GET['ext_meta_id'];
  }

  if( isset( $_GET['relid'] ) && isset( $_GET['pid'] ) && isset( $_GET['bid'] ) ) {
    $_SESSION['relid'] = $_GET['relid'];
    $_SESSION['repid'] = $_GET['pid'];
    $_SESSION['rebid'] = $_GET['bid'];
  }

// CityAds
  $cookie_days = 30; // количество дней по договору
  $cookie_timestamp = strtotime('+' . $cookie_days . ' days');

  $is_ref = ( isset( $_GET['ref'] ) && !empty( $_GET['ref'] ) );
  $is_prx = ( isset( $_GET['prx'] ) && !empty( $_GET['prx'] ) );
  $is_aip = ( isset( $_GET['aip'] ) && !empty( $_GET['aip'] ) );
  $is_click_id = ( isset( $_GET['click_id'] ) && !empty( $_GET['click_id'] ) );

  if( $is_ref ) {
    setcookie( 'ca_ref', $_GET['ref'], $cookie_timestamp, '/' );
  }

  if( $is_prx ) {
    setcookie( 'ca_prx', $_GET['prx'], $cookie_timestamp, '/' );
  }

  if( $is_aip ) {
    setcookie( 'ca_aip', $_GET['aip'], $cookie_timestamp, '/' );
  }

  if( $is_click_id ) {
    setcookie( 'ca_click_id', $_GET['click_id'], $cookie_timestamp, '/' );
  }

// 7offer
  $so_source = ( isset( $_GET['source'] ) && !empty( $_GET['source'] ) );
  $so_tid = ( isset( $_GET['tid'] ) && !empty( $_GET['tid'] ) );

  if( $so_source ) {
    setcookie( 'so_source', $_GET['source'], $cookie_timestamp, '/' );
  }

  if( $so_tid ) {
    setcookie( 'so_tid', $_GET['tid'], $cookie_timestamp, '/' );
  }

// WASD
  if( isset( $_GET['utm_source'] ) && isset( $_GET['utm_medium'] ) && isset( $_GET['utm_content'] ) && isset( $_GET['utm_campaign'] ) && isset( $_GET['request_id'] ) ) {
    if( $_GET['utm_source'] == 'mediareach' && $_GET['utm_medium'] == 'cpa' && $_GET['utm_campaign'] == 'dia' && $_GET['utm_content'] == $_GET['request_id'] ) {
      $_SESSION['wasd_id'] = $_GET['request_id'];
      setcookie( 'wasd_id', $_GET['request_id'], $cookie_timestamp, '/' );
    }
  }

// Other
  if( isset( $_GET['lttracking'] ) ) {
    $ltholddays = 7;
    setcookie( 'lttracking', $_GET['lttracking'], time() + $ltholddays*86400, '/', '.'.$_SERVER['HTTP_HOST'] );
  }

  if( !isset( $_COOKIE['ent_link'] ) && isset( $_SERVER['REQUEST_URI'] ) ) {
    setcookie( 'ent_link', $_SERVER['REQUEST_URI'], time()+1296000, '/' );
  }

  if( !isset( $_COOKIE['ref_link'] ) && isset( $_SERVER['HTTP_REFERER'] ) ) {
    setcookie( 'ref_link', $_SERVER['HTTP_REFERER'], time()+1296000, '/' );
  }

  if( isset( $_GET['refid'] ) && $_GET['refid'] ) {
    setcookie( 'refid', $_GET['refid'], time()+1296000, '/' );
  }

  $p = isset( $_GET['pid'] ) ? $_GET['pid'] : '';
  switch( $p ) {
    case 31252:
      $conversion = '<!-- Google Code for Активация аккаунта Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 1012123603;
var google_conversion_language = "ru";
var google_conversion_format = "3";
var google_conversion_color = "ffffff";
var google_conversion_label = "AhInCO2R7gEQ04_P4gM";
var google_conversion_value = 0;
/* ]]> */
</script>
<script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/1012123603/?label=AhInCO2R7gEQ04_P4gM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>';
      $title = 'Ожидание активации космической онлайн стратегии Полдень 21 века';
      $main_content = '<table><tr><td><h3>Ожидание активации</h3></td></tr><tr><td>
Спасибо за регистрацию, на указанный вами e-mail адрес выслано письмо с дальнейшими инструкциями по активации аккаунта.<br>
Для активации аккаунта у вас есть 24 часа. После 24 часов аккаунт будет автоматически удален.</td></tr></table>';
      include "./templates/small_n.inc";
      break;

    case 39281:
      $title = 'Активация аккаунта в космической онлайн стратегии Полдень 21 века';
      $main_content = '<table><tr><td><h3>Активация прошла успешно!</h3></td></tr><tr><td>Спасибо за регистрацию, ваше имя пользователя подтверждено, теперь вы можете войти в игру в любое время.</td></tr></table>';

      if( isset( $_GET['act'] ) ) {
        $tmp = $_GET['act'];
        db_safe( $tmp );
        $result = db_fetch_row( "SELECT id, meta_in, login, relid, repid, rebid FROM users WHERE ssid = '$tmp'" );
      } else {
        $result['id'] = 'unknown';
        $result['login'] = 'unknown';
        $result['meta_in'] = null;
      }

      if( $result['meta_in'] > 0 ) {
        $ext_meta_id = $result['meta_in'];
        $price_rur = '30';
        $hash = md5("'$price_rur'80347");
        $target_id = 762;

        $answ = @file_get_contents( "https://luxup.ru/extmeta/?ext_meta_id=$ext_meta_id&lx_price=$price_rur&user_id=76025&lx_price_hash=$hash&target_id=$target_id" );
      }

      if( $result['relid'] > 0 ) {
        $main_content .= '<iframe src="https://inetrek.com/iframe/landing.php?mode=reglogin&pid='.$result['repid'].'&bid='.$result['rebid'].'&login='.$result['login'].'&uid='.$result['id'].'" frameborder="no"></iframe>';
      }

      if( $result['id'] != 'unknown' ) {
//        $codeQs = @file_get_contents( 'https://core.1lead.ru/hash.set.php?hash=87dec1f8ba5dac6acb6ed0a86e9c8a1d&actid='.$result['id'] );
//        $main_content .= '<img id="payChecker" src="http://core.1lead.ru/check/'.$codeQs.'">';
      }

      include "./templates/small_n.inc";
      break;

    case 29384:
      $title = 'Ошибка активации аккаунта в космической онлайн стратегии Полдень 21 века';
      $main_content = '<table><tr><td><h3>Активация не удалась!</h3></td></tr><tr><td>Ссылка для активации не верна! Возможно вы уже активировали свой акканут, войдите в игру используя имя пользователя и выбранный вами пароль.</td></tr></table>';
      include "./templates/small_n.inc";
      break;

    case 72384:
      $title = 'Ошибка удаления аккаунта в стратегии Полдень 21 века';
      $main_content = '<table><tr><td><h3>Удаление не удалось!</h3></td></tr><tr><td>Ссылка для удаления не верна! Пользователь остается в игре.</td></tr></table>';
      include "./templates/small_n.inc";
      break;

    case 72489:
      $title = 'Аккаунт удален';
      $main_content = '<table><tr><td><h3>Аккаунт удален!</h3></td></tr><tr><td>Спасибо за проявленный интерес, однако по вашему требованию ваш аккаунт успешно удален.</td></tr></table>';
      include "./templates/small_n.inc";
      break;

    case 64536:
      include "./pages/result.page";
      break;

    case 'about':
      $title = 'О космической онлайн стратегии - Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/about.page');
      include "./templates/big.inc";
      break;

    case 'fulllist':
      $title = 'Полный список игроков космической онлайн стратегии Полдень 21 века';
      $sape_link = true;

      $page = isset( $_GET['p'] ) ? $_GET['p'] : 0;
      db_safe( $page );
      if( !is_numeric( $page ) || $page < 0 || $page > 1000 ) {
        $page = 0;
      }

      $page = intval( $page );

      $result = db_fetch_array( "SELECT u.login, ua.char_level
                                   FROM users u
                             INNER JOIN users_active ua ON ua.id = u.id
                                  WHERE u.status = 1 AND ua.char_level >=0
                               ORDER BY ua.char_level DESC LIMIT $page,50" );

      $left_col = array_slice( $result, 0, 25 );
      $right_col = array_slice( $result, 25, 25 );
      $full_list = '';
      $l=$page+1;
      $r=$page+26;
      foreach( $left_col as $key => $item ) {
        if( isset( $item['login'] ) ) {
          $full_list .= '<tr><td>'.($l++).'.'.$item['login'].'</td><td align=right>'.$item['char_level'].'</td><td></td>';
        } else {
          $full_list .= '<tr><td></td><td></td><td></td>';
        }
        if( isset( $right_col[$key]['login'] ) ) {
          $full_list .= '<td>'.($r++).'.'.$right_col[$key]['login'].'</td><td align=right>'.$right_col[$key]['char_level']."</td></tr>\n";
        } else {
          $full_list .= "<td></td><td></td></tr>\n";
        }
      }
      $main_content = "<table align=center width=100%><tr><td colspan=5 align=center><h3>Полный список игроков</h3></td></tr>";
      $main_content .= "<tr><td><b>Имя</b></td><td align=right><b>Опыт</b></td><td width=50></td><td><b>Имя</b></td><td align=right><b>Опыт</b></td></tr>$full_list";
      if( $page >= 25 ) {
        $prev = '<a id="red" href="index.php?pid=fulllist&p='.($page-50).'"><b>&lt&lt&lt&lt&lt&lt</b></a>';
      } else {
        $prev = '';
      }
      if( count( $result ) == 50 ) {
        $next = '<a id="red" href="index.php?pid=fulllist&p='.($page+50).'"><b>&gt&gt&gt&gt&gt&gt</b></a>';
      } else {
        $next = '';
      }
      $main_content .= "<tr><td colspan=2 align=center>$prev</td><td></td><td colspan=2 align=center>$next</td></tr></table>";
      include "./templates/big.inc";
      break;

    case 'enc':
      $title = 'Часто задаваемые вопросы (faq) космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      include "texts/faq.page";
      include "./templates/big.inc";
      break;

    case 'video':
      $title = 'Видео обучение по прохождению начальных уровней развития.';
      $sape_link = true;
      $main_content = file_get_contents('texts/video.page');
      include "./templates/big.inc";
      break;

    case 'contacts':
      $title = 'Контакты администрации космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/contacts.page');
      include "./templates/big.inc";
      break;

    case 'gallery':
      $title = 'Галерея космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/gallery.page');
      include "./templates/big.inc";
      break;

    case 'register':
      $title = 'Регистрация в космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      include "texts/register.page";
      include "./templates/big.inc";
      break;

    case 'repair':
      $title = 'Восстановление пароля аккаунта космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      include "texts/repair.page";
      include "./templates/big.inc";
      break;

    case 'rereg':
      $title = 'Повторная регистрация аккаунта космической онлайн стратегии Полдень 21 века';
      include "texts/rereg.page";
      include "./templates/big.inc";
      break;

    case 'rereg_ok':
      $title = 'Изменение пароля космической онлайн стратегии Полдень 21 века';
      $main_content = "<h3>Пароль изменен.</h3><br>Восстановление пароля прошло успешно. Теперь вы можете войти в игру под новым паролем.";
      include "./templates/big.inc";
      break;

    case 'rereg_err':
      $title = 'Ошибка изменения пароля космической онлайн стратегии Полдень 21 века';
      $main_content = "<h3>Ошибка</h3><br>Неверная ссылка для восстановления пароля. Попробуйте еще раз. Если ошибка повторится, обратитесь к администрации.";
      include "./templates/big.inc";
      break;

    case 'billing':
      $title = 'Условия оплаты космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/billing.page');
      include "./templates/big.inc";
      break;

    case 'rules':
      $title = 'Правила космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/rules.page');
      include "./templates/big.inc";
      break;

    case 'license':
      $title = 'Лицензия космической онлайн стратегии Полдень 21 века';
      $sape_link = true;
      $main_content = file_get_contents('texts/license.page');
      include "./templates/big.inc";
      break;

    case 'rep_ok':
      $title = 'Регистрация игрока космической онлайн стратегии Полдень 21 века';
      $main_content = "<h3>Регистрационные данные высланы</h3><br>Проверьте вашу почту, для восстановления пароля следуйте инструкциям в письме.";
      include "./templates/big.inc";
      break;

    default:
      $title = 'Космическая стратегия - Полдень 21 века';
      $sape_link = true;
      $main_content = array();
      $main_content[] = file_get_contents('texts/main.page').'<br>';
      $news = db_fetch_array( "SELECT title, data FROM info_page WHERE type IN ( 1, 2 ) ORDER BY id DESC LIMIT 0,10" );
      foreach( $news as $item ) {
        $text = str_replace( '%25', '%', $item['data'] );
        $main_content[] = '<h3>'.$item['title'].'</h3>'.$text.'<br>';
      }

      if( isset( $_GET['relid'] ) && isset( $_GET['pid'] ) && isset( $_GET['bid'] ) ) {
        $main_content[] = '<iframe src="http://inetrek.com/iframe/landing.php?mode=landing&pid='.$_GET['pid'].'&bid='.$_GET['bid'].'" frameborder="no"></iframe>';
      }

      include "./templates/small_n.inc";
      break;
  }

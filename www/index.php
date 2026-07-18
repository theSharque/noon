<?php
  if( !isset( $_SESSION ) ) {
    @session_start();
  }

  if( substr( $_SERVER['HTTP_HOST'], 0, 4 ) == 'www.' ) {
    header( 'Location: http://'.substr( $_SERVER['HTTP_HOST'], 4 ).$_SERVER['REQUEST_URI'] );
  }

  require_once( "./include/boot.inc" );
  bootup();
  

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
        $result = db_fetch_row( "SELECT id, login FROM users WHERE ssid = '$tmp'" );
      } else {
        $result['id'] = 'unknown';
        $result['login'] = 'unknown';
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

    case 'about':
      $title = 'О космической онлайн стратегии - Полдень 21 века';
      $main_content = file_get_contents('texts/about.page');
      include "./templates/big.inc";
      break;

    case 'fulllist':
      $title = 'Полный список игроков космической онлайн стратегии Полдень 21 века';
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
      include "texts/faq.page";
      include "./templates/big.inc";
      break;

    case 'contacts':
      $title = 'Контакты администрации космической онлайн стратегии Полдень 21 века';
      $main_content = file_get_contents('texts/contacts.page');
      include "./templates/big.inc";
      break;

    case 'gallery':
      $title = 'Галерея космической онлайн стратегии Полдень 21 века';
      $main_content = file_get_contents('texts/gallery.page');
      include "./templates/big.inc";
      break;

    case 'register':
      $title = 'Регистрация в космической онлайн стратегии Полдень 21 века';
      include "texts/register.page";
      include "./templates/big.inc";
      break;

    case 'repair':
      $title = 'Восстановление пароля аккаунта космической онлайн стратегии Полдень 21 века';
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

    case 'rules':
      $title = 'Правила космической онлайн стратегии Полдень 21 века';
      $main_content = file_get_contents('texts/rules.page');
      include "./templates/big.inc";
      break;

    case 'license':
      $title = 'Лицензия космической онлайн стратегии Полдень 21 века';
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
      $main_content = array();
      $main_content[] = file_get_contents('texts/main.page').'<br>';
      $news = db_fetch_array( "SELECT title, data FROM info_page WHERE type IN ( 1, 2 ) ORDER BY id DESC LIMIT 0,10" );
      foreach( $news as $item ) {
        $text = str_replace( '%25', '%', $item['data'] );
        $main_content[] = '<h3>'.$item['title'].'</h3>'.$text.'<br>';
      }

      include "./templates/small_n.inc";
      break;
  }

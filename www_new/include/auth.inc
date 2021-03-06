<?php

function authorization() {
  global $user;

  $user = new stdClass();

  $sid = isset( $_COOKIE[ 'chat_sid' ] ) ? $_COOKIE[ 'chat_sid' ] : 0;
  $uid = isset( $_COOKIE[ 'chat_uid' ] ) ? $_COOKIE[ 'chat_uid' ] : 0;
  
  db_safe( $sid );
  db_safe( $uid );

  if( strlen( $sid ) > 20 ) {
    $row = db_fetch_row( "SELECT u.id, u.full_log, u.login, u.titul, u.admin, u.email, u.ssid, u.level, u.lastlevel,
                                 u.place_id, u.place_type, u.block, u.money, u.credits, u.donate, u.aliance, IF( u.mute < NOW(), 0, 1 ) mute, u.mute mute_date,
                                 ua.char_status, ua.char_war, ua.char_level,
                                 u.volume_sound, u.volume_music, u.show_planet, NOW() - u.tutorial_time leveltime, u.insur, u.fid,
                                 uq.id uq_id, uq.type uq_type
                            FROM users u
                      INNER JOIN users_active ua ON ua.id = u.id
                       LEFT JOIN users_quests uq ON uq.user_id = u.id AND uq.status > 0
                           WHERE u.status=1 AND u.ssid='$sid' AND u.id='$uid'" );
  }

  if( !isset( $row['id'] ) || !is_numeric( $row['id'] ) ) {

    if( !isset( $_SESSION ) ) {
      @session_start();
    }

    $sid = session_id();
    $row = db_fetch_row( "SELECT u.id, u.full_log, u.login, u.titul, u.admin, u.email, u.ssid, u.level, u.lastlevel,
                                 u.place_id, u.place_type, u.block, u.money, u.credits, u.donate, u.aliance, IF( u.mute < NOW(), 0, 1 ) mute, u.mute mute_date,
                                 ua.char_status, ua.char_war, ua.char_level,
                                 u.volume_sound, u.volume_music, u.show_planet, NOW() - u.tutorial_time leveltime, u.insur, u.fid,
                                 uq.id uq_id, uq.type uq_type
                            FROM users u
                      INNER JOIN users_active ua ON ua.id = u.id
                       LEFT JOIN users_quests uq ON uq.user_id = u.id AND uq.status > 0
                           WHERE u.status=1 AND u.ssid='$sid'" );

    if( !isset( $_COOKIE[ 'chat_sid' ] ) || $_COOKIE[ 'chat_sid' ] != $sid ) {
      setcookie( 'chat_sid', $sid );
    }

    if( !isset( $_COOKIE[ 'chat_uid' ] ) || $_COOKIE[ 'chat_uid' ] != $row['id'] ) {
      setcookie( 'chat_uid', $row['id'] );
    }
  }

  if( is_array( $row ) && count( $row ) && is_numeric( $row['id'] ) ) {

    if( $row['place_id'] == 1 ) {
      include "./pages/register/gensystem.page";
      GenerateSystem( $row['id'] );

      $row = db_fetch_row( "SELECT u.id, u.full_log, u.login, u.titul, u.admin, u.email, u.ssid, u.level, u.lastlevel,
                                   u.place_id, u.place_type, u.block, u.money, u.credits, u.donate, u.aliance, IF( u.mute < NOW(), 0, 1 ) mute, u.mute mute_date,
                                   ua.char_status, ua.char_war, ua.char_level,
                                   u.volume_sound, u.volume_music, u.show_planet, NOW() - u.tutorial_time leveltime, u.insur, u.fid,
                                   uq.id uq_id, uq.type uq_type
                              FROM users u
                        INNER JOIN users_active ua ON ua.id = u.id
                         LEFT JOIN users_quests uq ON uq.user_id = u.id AND uq.status > 0
                             WHERE u.status = 1 AND u.ssid='$sid'" );
    }

    $user->full_log = $row['full_log'];

    $user->login = $row['login'];
    $user->aliance = $row['aliance'];
    $user->mute = $row['mute'];
    $user->mute_date = $row['mute_date'];
    $user->titul = $row['titul'];
    $user->email = $row['email'];
    $user->ssid = $sid;
    $user->admin = $row['admin'];
    $user->level = $row['level'];
    $user->lastlevel = $row['lastlevel'];
    $user->leveltime = $row['leveltime'];
    $user->uid = $row['id'];

    $user->iq = $row['uq_id'];
    $user->qt = $row['uq_type'];

    $user->music = $row['volume_music'];
    $user->sound = $row['volume_sound'];
    $user->show_planet = $row['show_planet'];

    $user->real_type = $row['place_type'];
    $user->real_id = $row['place_id'];

    $place[ 'place_type' ] = $row['place_type'];
    $place[ 'place_id' ] = $row['place_id'];

    while( $place[ 'place_type' ] == 2 || $place[ 'place_type' ] == 6 ) {
      if( $place[ 'place_type' ] == 2 ) {
        $place = db_fetch_row( "SELECT place_id, place_type FROM ships WHERE id=".$place['place_id'] );
      } else {
        $place = db_fetch_row( "SELECT place_id, place_type FROM fleets WHERE id=".$place['place_id'] );
      }
    }

    if( !is_numeric( $place['place_type'] ) || !is_numeric( $place['place_id'] ) ) {
      $place = db_fetch_row( "SELECT 1 place_type, id place_id FROM planets WHERE user_id = ".$row['id'] );
      db_query( "UPDATE users SET place_id={$place['place_id']}, place_type=1 WHERE id=".$row['id'] );
    }

    $user->place_type = $place['place_type'];
    $user->place_id = $place['place_id'];

    $home = db_fetch_row( "SELECT p.id pid, s.id sid FROM planets p, stars s WHERE s.id = p.star_id AND p.user_id = ".$row['id'] );
    $user->star_id = $home['sid'];
    $user->planet_id = $home['pid'];

    $user->native = false;

    if( $user->place_type == 1 || $user->place_type == 0 ) {
      $own = db_fetch_row( "SELECT id, user_id FROM planets WHERE id = ".$user->place_id );

      if( !isset( $own['id'] ) || !is_numeric( $own['id'] ) ) {
        $place = db_fetch_row( "SELECT 1 place_type, id place_id FROM planets WHERE user_id = ".$row['id'] );
        db_query( "UPDATE users SET place_id={$place['place_id']}, place_type=1 WHERE id=".$row['id'] );
      }

      if( !isset( $own['user_id'] ) || $own['user_id'] == $user->uid ) {
        $user->owner = true;
        if( $own['user_id'] == $user->uid ) {
          $user->native = true;
        }
      } else {
        $user->owner = false;
      }
    }

    $user->block = $row['block'];

    $user->money = $row['money'];
    $user->credits = $row['credits'];
    $user->donate = $row['donate'];

    $user->insur = $row['insur'];

    $user->char_status = $row['char_status'];
    $user->char_war = $row['char_war'];
    $user->char_level = $row['char_level'];
    
    $user->fid = $row['fid'];

    $user->slave = db_fetch_val( "SELECT event_id FROM u2u_quests WHERE user_id = ".$row['id'] );

    return true;
  } else {

    if( isset( $_POST['vk_id'] ) && isset( $_COOKIE['vk_app_3732373'] ) ) {
      $valid_keys = array( 'expire', 'mid', 'secret', 'sid', 'sig' );
      $app_cookie = $_COOKIE['vk_app_3732373'];
      $session_data = explode( '&', $app_cookie, 10 );
      $vk_id = $_POST['vk_id'];

      foreach( $session_data as $pair ) {
        list( $key, $value) = explode( '=', $pair, 2 );
        if( empty( $key ) || empty( $value ) || !in_array( $key, $valid_keys ) ) {
          continue;
        }

        $session[ $key ] = $value;
      }

      ksort($session);

      $sign = '';
      foreach( $session as $key => $value ) {
        if( $key != 'sig' ) {
          $sign .= ( $key.'='.$value );
        }
      }

      $sign .= 'o91UTPFoSSoPv1iTxRfz';
      $sign = md5($sign);

      if( $session['mid'] == $_POST['vk_id'] && $session['sig'] == $sign && $session['expire'] > time() ) {
        $row = db_fetch_row( "SELECT u.id, u.titul, t.name tname, p.name pname
                                FROM users u
                           LEFT JOIN users pu ON pu.id = u.parent_id
                          INNER JOIN tituls t ON t.id = u.titul
                          INNER JOIN planets p ON p.user_id = u.id
                               WHERE IFNULL( pu.last_ip, 0 ) != '{$_SERVER["REMOTE_ADDR"]}' AND u.status = 1 AND u.vk_id = '$vk_id' AND u.err_login < NOW()" );
      }

      $login = $_POST['login'];
      $unique = db_fetch_val( "SELECT count(*) cnt FROM users u WHERE u.vk_id = '$vk_id' OR u.login='$login'", 'cnt' );

      if( $vk_id && $unique == 0 && isset( $_POST['login'] ) && $login ) {
        $login = $_POST['login'];
        $refid = isset( $_COOKIE["refid"] ) ? intval( $_COOKIE["refid"] ? $_COOKIE["refid"] : 1 ) : 1;
        $reflink = isset( $_COOKIE["ref_link"] ) ? $_COOKIE["ref_link"] : 'none';
        $entlink = isset( $_COOKIE["ent_link"] ) ? $_COOKIE["ent_link"] : 'none';

        $meta_in = isset( $_SESSION['ext_meta_id'] ) ? "'".$_SESSION['ext_meta_id']."'" : 'null';
        if( !isset( $_SESSION['ext_meta_id'] ) && strpos( $entlink, 'ext_meta_id' ) > 0 ) {
          $pre = substr( $entlink, strpos( $entlink, 'ext_meta_id' ) );

          if( strpos( $pre, '&' ) > 0 ) {
            $pre = substr( $pre, 0, strpos( $pre, '&' ) );
          }

          list( $nope, $meta_in ) = explode( '=', $pre );
        }

        $relid = isset( $_SESSION['relid'] ) ? "'".$_SESSION['relid']."'" : 'null';
        if( !isset( $_SESSION['relid'] ) && strpos( $entlink, 'relid' ) > 0 ) {
          $pre = substr( $entlink, strpos( $entlink, 'relid' ) );

          if( strpos( $pre, '&' ) > 0 ) {
            $pre = substr( $pre, 0, strpos( $pre, '&' ) );
          }

          list( $nope, $relid ) = explode( '=', $pre );
        }

        if( $meta_in != 'null' ) {
          $ext_meta_id = $meta_in;
          $price_rur = '30';
          $hash = md5("'$price_rur'80347");
          $target_id = 762;
          $answ = @file_get_contents( "http://luxup.ru/extmeta/?ext_meta_id=$ext_meta_id&lx_price=$price_rur&user_id=76025&lx_price_hash=$hash&target_id=$target_id" );
        }

        db_query( "INSERT INTO users (    login,    vk_id, parent_id,   ref_link,   ent_link,  meta_in,  password,     email,   ssid, status, place_id, place_type, money, credits, register_date,                     last_ip,  relid )
                              VALUES ( '$login', '$vk_id',    $refid, '$reflink', '$entlink', $meta_in, 'From VK', 'From VK', '$sid',      1,        1,          1, 15000,       0,         NOW(), '{$_SERVER["REMOTE_ADDR"]}', $relid )" );

        $user_id = mysql_insert_id();
        db_query( "INSERT INTO users_active ( id ) VALUES ( $user_id )" );

        setcookie( 'chat_sid', $sid );
        setcookie( 'chat_uid', $user_id );

        include "./pages/register/gensystem.page";
        GenerateSystem( $user_id );

        $row = db_fetch_row( "SELECT u.id, u.full_log, u.login, u.titul, u.admin, u.email, u.ssid, u.level, u.lastlevel,
                                     u.place_id, u.place_type, u.block, u.money, u.credits, u.donate, u.aliance, IF( u.mute < NOW(), 0, 1 ) mute, u.mute mute_date,
                                     ua.char_status, ua.char_war, ua.char_level,
                                     u.volume_sound, u.volume_music, u.show_planet, NOW() - u.tutorial_time leveltime, u.insur, u.fid,
                                     uq.id uq_id, uq.type uq_type, t.name tname, p.name pname
                                FROM users u
                           LEFT JOIN users pu ON pu.id = u.parent_id
                          INNER JOIN tituls t ON t.id = u.titul
                          INNER JOIN planets p ON p.user_id = u.id
                          INNER JOIN users_active ua ON ua.id = u.id
                           LEFT JOIN users_quests uq ON uq.user_id = u.id AND uq.status > 0
                               WHERE IFNULL( pu.last_ip, 0 ) != '{$_SERVER["REMOTE_ADDR"]}' AND u.status = 1 AND u.vk_id = '$vk_id'" );
      } else {
        unset( $row['id'] );
      }
    }

    if( ( !isset( $row['id'] ) || !is_numeric( $row['id'] ) ) && isset( $_POST['login'] ) && isset( $_POST['pass'] ) ) {
      $login = $_POST['login'];
      $pass = md5( $_POST['pass'] );
      db_safe( $login );
      db_safe( $pass );

      on_login();

      $row = db_fetch_row( "SELECT u.id, u.full_log, u.login, u.titul, u.admin, u.email, u.ssid, u.level, u.lastlevel,
                                   u.place_id, u.place_type, u.block, u.money, u.credits, u.donate, u.aliance, IF( u.mute < NOW(), 0, 1 ) mute, u.mute mute_date,
                                   ua.char_status, ua.char_war, ua.char_level,
                                   u.volume_sound, u.volume_music, u.show_planet, NOW() - u.tutorial_time leveltime, u.insur, u.fid,
                                   uq.id uq_id, uq.type uq_type, t.name tname, p.name pname
                              FROM users u
                         LEFT JOIN users pu ON pu.id = u.parent_id
                        INNER JOIN tituls t ON t.id = u.titul
                        INNER JOIN planets p ON p.user_id = u.id
                        INNER JOIN users_active ua ON ua.id = u.id
                         LEFT JOIN users_quests uq ON uq.user_id = u.id AND uq.status > 0
                             WHERE IFNULL( pu.last_ip, 0 ) != '{$_SERVER["REMOTE_ADDR"]}' AND u.status = 1 AND u.login='$login' AND u.password='$pass' AND u.err_login < NOW()" );

      if( isset( $row['id'] ) && is_numeric( $row['id'] ) ) {
//        $clons = db_fetch_val( "SELECT group_concat( login ) clons FROM users WHERE id != {$row['id']} AND password = '$pass'", 'clons' );

        if( isset( $session['mid'] ) && $session['mid'] == $_POST['vk_id'] && $session['sig'] == $sign && $session['expire'] > time() ) {
          db_query( "UPDATE users SET vk_id='$vk_id' WHERE id=".$row['id'] );
        }
      }
    }

    if( isset( $row['id'] ) && is_numeric( $row['id'] ) ) {
      $id = $row['id'];

      $user->full_log = $row['full_log'];
    
      $user->login = $row['login'];
      $user->aliance = $row['aliance'];
      $user->mute = $row['mute'];
      $user->mute_date = $row['mute_date'];
      $user->titul = $row['titul'];
      $user->email = $row['email'];
      $user->ssid = $sid;
      $user->admin = $row['admin'];
      $user->level = $row['level'];
      $user->lastlevel = $row['lastlevel'];
      $user->leveltime = $row['leveltime'];
      $user->uid = $row['id'];
    
      $user->iq = $row['uq_id'];
      $user->qt = $row['uq_type'];
    
      $user->music = $row['volume_music'];
      $user->sound = $row['volume_sound'];
      $user->show_planet = $row['show_planet'];
    
      $user->real_type = $row['place_type'];
      $user->real_id = $row['place_id'];
    
      $place[ 'place_type' ] = $row['place_type'];
      $place[ 'place_id' ] = $row['place_id'];
    
      while( $place[ 'place_type' ] == 2 || $place[ 'place_type' ] == 6 ) {
        if( $place[ 'place_type' ] == 2 ) {
          $place = db_fetch_row( "SELECT place_id, place_type FROM ships WHERE id=".$place['place_id'] );
        } else {
          $place = db_fetch_row( "SELECT place_id, place_type FROM fleets WHERE id=".$place['place_id'] );
        }
      }
    
      if( !is_numeric( $place['place_type'] ) || !is_numeric( $place['place_id'] ) ) {
        $place = db_fetch_row( "SELECT 1 place_type, id place_id FROM planets WHERE user_id = ".$row['id'] );
        db_query( "UPDATE users SET place_id={$place['place_id']}, place_type=1 WHERE id=".$row['id'] );
      }
    
      $home = db_fetch_row( "SELECT p.id pid, s.id sid FROM planets p, stars s WHERE s.id = p.star_id AND p.user_id = ".$row['id'] );
      $user->star_id = $home['sid'];
      $user->planet_id = $home['pid'];
    
      $user->place_type = $place['place_type'];
      $user->place_id = $place['place_id'];
      $user->native = false;
    
      if( $user->place_type == 1 || $user->place_type == 0 ) {
        $own = db_fetch_row( "SELECT id, user_id FROM planets WHERE id = ".$user->place_id );
    
        if( !isset( $own['id'] ) || !is_numeric( $own['id'] ) ) {
          $place = db_fetch_row( "SELECT 1 place_type, id place_id FROM planets WHERE user_id = ".$row['id'] );
          db_query( "UPDATE users SET place_id={$place['place_id']}, place_type=1 WHERE id=".$row['id'] );
        }
    
        if( !isset( $own['user_id'] ) || $own['user_id'] == $user->uid ) {
          $user->owner = true;
          if( $own['user_id'] == $user->uid ) {
            $user->native = true;
          }
        } else {
          $user->owner = false;
        }
      }
    
      $user->block = $row['block'];
    
      $user->money = $row['money'];
      $user->credits = $row['credits'];
      $user->donate = $row['donate'];
    
      $user->insur = $row['insur'];
    
      $user->char_status = $row['char_status'];
      $user->char_war = $row['char_war'];
      $user->char_level = $row['char_level'];
      
      $user->fid = $row['fid'];
    
      $user->slave = db_fetch_val( "SELECT event_id FROM u2u_quests WHERE user_id = ".$row['id'] );

      db_query( "UPDATE users SET ssid='$sid', last_ip='{$_SERVER["REMOTE_ADDR"]}' WHERE id=$id" );
      db_query( "UPDATE users_active SET lastlogin=NOW() WHERE id=$id" );

      gen_report( $id );

      if( $user->level < 26 ) {
        db_query( "INSERT INTO chat ( user_id, to_user, text ) VALUES ( 7, $id, '".t( '���� � ��� ���� �������, �� ������ ������ ������ �� � ����. �� �����������, ����� ����� ��� �� ����� ����� � ������� ���.' )."' )" );
      }

      if( $id > 16 ) {
        switch( $row['titul'] % 11 ) {
          case 0:
            db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">����� %s � �����.</font>', array( $login ) )."' )" );
            break;
          case 1:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">%s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">%s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 2:
          case 3:
          case 4:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">��� ������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">�� ������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 5:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">��� ����������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">�� ����������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 6:
          case 7:
          case 8:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">��� ��������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">�� ��������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 9:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">��� ���������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">�� ���������� %s %s � �����.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 10:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">��� ����������� ����������, ���������� ������� %s, %s %s � �����.</font>', array( $row['pname'], $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">�� ����������� ����������, �������������� ������� %s, %s %s � �����.</font>', array( $row['pname'], $row['tname'], $login ) )."' )" );
            }
            break;
        }
      }

      if( !isset( $_COOKIE[ 'chat_sid' ] ) || $_COOKIE[ 'chat_sid' ] != $sid ) {
        setcookie( 'chat_sid', $sid );
      }

      if( !isset( $_COOKIE[ 'chat_uid' ] ) || $_COOKIE[ 'chat_uid' ] != $row['id'] ) {
        setcookie( 'chat_uid', $row['id'] );
      }

      $clons = get_clons( $id );

      if( $clons ) {
        db_query( "INSERT INTO chat ( user_id, text ) VALUES ( 7, '".t( '<font color=\"#CCCCCC\">���� ����������, ��� %s �� ����� ���� ��� � %s.</font>', array( $login, $clons ) )."' )" );
      }

      return true;
    } else {
      if( isset( $_POST['login'] ) ) {
        db_query( "UPDATE users SET err_login = DATE_ADD( NOW(), INTERVAL 3 SECOND ) WHERE login='{$_POST['login']}'" );
      }
    }

    return false;
  }

  if( !$user->uid ) {
    return false;
  }
}


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
        db_query( "INSERT INTO chat ( user_id, to_user, text ) VALUES ( 7, $id, '".t( 'Если у вас есть вопросы, вы всегда можете задать их в чате. Не стесняйтесь, любой пилот был на вашем месте и поможет вам.' )."' )" );
      }

      if( $id > 16 ) {
        switch( $row['titul'] % 11 ) {
          case 0:
            db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Пилот %s в эфире.</font>', array( $login ) )."' )" );
            break;
          case 1:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">%s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">%s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 2:
          case 3:
          case 4:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Его милость %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Ее милость %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 5:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Его сиятельство %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Ее сиятельство %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 6:
          case 7:
          case 8:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Его светлость %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Ее светлость %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 9:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Его высочество %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Ее высочество %s %s в эфире.</font>', array( $row['tname'], $login ) )."' )" );
            }
            break;
          case 10:
            if( $row['titul'] < 12 ) {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Его королевское величество, повелитель планеты %s, %s %s в эфире.</font>', array( $row['pname'], $row['tname'], $login ) )."' )" );
            } else {
              db_query( "INSERT INTO chat ( user_id, text ) VALUES ( $id, '".t( '<font color=\"#CCCCCC\">Ее королевское величество, повелительница планеты %s, %s %s в эфире.</font>', array( $row['pname'], $row['tname'], $login ) )."' )" );
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
        db_query( "INSERT INTO chat ( user_id, text ) VALUES ( 7, '".t( '<font color=\"#CCCCCC\">Есть подозрение, что %s на самом деле еще и %s.</font>', array( $login, $clons ) )."' )" );
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


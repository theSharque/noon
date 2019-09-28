<?php

function kill_users() {
  $users = db_fetch_array( "SELECT u.id, u.level, u.status
                              FROM users u
                        INNER JOIN users_active ua ON ua.id = u.id
                             WHERE ( u.status = 1 AND u.level < 35 AND u.admin = 0 AND ua.lastlogin < DATE_SUB( NOW(), INTERVAL 2 MONTH ) ) OR
                                   ( u.status = 1 AND u.level < 10 AND u.admin = 0 AND ua.lastlogin < DATE_SUB( NOW(), INTERVAL 2 WEEK  ) ) OR
                                   ( u.status = 0 AND u.admin = 0 ) OR
                                   ( u.status = 3 AND u.admin = 0 )
                          ORDER BY rand()
                             LIMIT 0,10" );

  if( count( $users ) == 0 ) {
    $users = db_fetch_array( "SELECT p.user_id id, 12 level
                                FROM planets p
                               WHERE p.user_id IS NOT NULL AND
                                     p.user_id NOT IN ( SELECT u.id FROM users u )" );
  }

  foreach( $users as $item ) {
    $uid = $item['id'];

    $base = db_fetch_row( "SELECT p.id, p.star_id, s.name, s.x sx, s.y sy
                             FROM planets p
                       INNER JOIN stars s ON s.id = p.star_id
                            WHERE p.user_id = $uid" );
    if( $base['star_id'] ) {
      $fp_buildings = db_fetch_row( "SELECT count(*) bcnt
                                       FROM planets_buildings pb
                                 INNER JOIN planets p ON p.star_id = {$base['star_id']} AND p.id != {$base['id']} AND p.id = pb.planet_id" );

      $fo_buildings = db_fetch_row( "SELECT count(*) bcnt
                                       FROM orbits_buildings ob
                                 INNER JOIN planets p ON p.star_id = {$base['star_id']} AND p.id != {$base['id']} AND p.id = ob.planet_id" );

      $fs = db_fetch_row( "SELECT count(*) scnt
                             FROM ships s
                            WHERE s.user_id != $uid AND s.user_id != 3 AND s.user_id IS NOT null AND (
                                    (s.place_type = 7 AND s.place_id = {$base['star_id']}) OR
                                    (s.place_type IN (0,1) AND place_id IN (SELECT id FROM planets WHERE star_id={$base['star_id']})) OR
                                    (s.place_type = 3 AND place_id IN (SELECT id FROM orbits_buildings ob WHERE ob.planet_id IN (SELECT id FROM planets WHERE star_id={$base['star_id']})))
                                  )" );
    }
    $fp_buildings = isset( $fp_buildings['bcnt'] ) ? $fp_buildings['bcnt'] : 0;
    $fo_buildings = isset( $fo_buildings['bcnt'] ) ? $fo_buildings['bcnt'] : 0;
    $fs = isset( $fs['scnt'] ) ? $fs['scnt'] : 0;

    if( $fp_buildings > 0 || $fo_buildings > 0 || $fs > 0 ) {
      db_query( "UPDATE users SET status = 3 WHERE id = $uid" );
      if( is_numeric( $base['star_id'] ) && $base['star_id'] > 0 ) {
        $aster = mt_rand( 0, 100 );
        if( $aster < 10 ) {
          $planet_id = db_fetch_val( "SELECT id FROM planets WHERE user_id = $uid", 'id' );
          $planet_pos = db_fetch_val( "SELECT planet_pos FROM planets WHERE id = $planet_id", 'planet_pos' );
          db_query( "DELETE FROM planets WHERE id = $planet_id" );
          db_query( "DELETE FROM planets_active WHERE id = $planet_id" );

          db_query( "UPDATE ships s
                        SET s.arg1=round(rand()*684), s.arg2=round(rand()*460), s.place_type = 7, s.place_id = {$base['star_id']}
                      WHERE s.fleet_id IS NULL AND ( 
                              ( s.place_type IN (0,1) AND s.place_id = $planet_id )
                              OR
                              ( s.place_type = 3 AND s.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id = $planet_id ) ) )" );

          db_query( "UPDATE fleets f, ships s
                        SET f.arg1=round(rand()*684), f.arg2=round(rand()*460), f.place_type = 7, s.place_type = 7, s.place_id = {$base['star_id']}
                      WHERE s.fleet_id = f.id AND ( 
                              ( f.place_type IN (0,1) AND f.place_id = $planet_id )
                              OR
                              ( f.place_type = 3 AND f.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id = $planet_id ) ) )" );

          db_query( "UPDATE ships s, fleets f SET s.arg1=f.arg1, s.arg2=f.arg2
                      WHERE s.fleet_id = f.id AND f.place_type = 7" );

          $as_count = mt_rand( 3, 7 );

          $levmap = 'HJKLZXCVBNM';
          $rad = 0;
          for( $i = 0; $i < $as_count; $i++ ) {
            $rad += ( 360 / $as_count ) + mt_rand( 0, 6 ) - 3;
            db_query( "INSERT INTO planets ( type,     name,            star_id,  planet_pos,  rad,                         orb, cycles )
                                    VALUES (    5, 'Астер.', {$base['star_id']}, $planet_pos, $rad, ".($planet_pos * 30 + 30).",   2000 )" );

            $aster_id = mysql_insert_id();

            $name = t( "Астер.%d", array( $aster_id ) );
            db_query( "UPDATE planets SET name = '$name' WHERE id = $aster_id" );

            $mat1 = $levmap{ mt_rand( 0, strlen( $levmap ) - 1 ) };
            $mat2 = $levmap{ mt_rand( 0, strlen( $levmap ) - 1 ) };

            db_query( "INSERT INTO planets_maps (        id, bld, fnd, top,     btm,     mdl )
                                         VALUES ( $aster_id, '0', '2', '4', '$mat2', '$mat1' )
                       ON DUPLICATE KEY UPDATE bld = '0', fnd = '2', top = '4', btm = '$mat2', mdl = '$mat1'" );
          }
        } else {
          $planet_id = db_fetch_val( "SELECT id FROM planets WHERE user_id = $uid", 'id' );

          db_query( "DELETE FROM books_teach WHERE user_id = $uid" );
          db_query( "DELETE FROM space_events WHERE user_id = $uid" );
          db_query( "DELETE FROM robots WHERE user_id = $uid" );
          db_query( "DELETE FROM users_books WHERE user_id = $uid" );
          db_query( "DELETE FROM users_messages WHERE to_user = $uid OR from_user = $uid" );
          db_query( "DELETE FROM users_msg_settings WHERE user_id = $uid" );
          db_query( "DELETE FROM users_quests WHERE user_id = $uid" );
          db_query( "DELETE FROM war_events WHERE a_user_id = $uid OR d_user_id = $uid" );

          db_query( "DELETE FROM planets_buildings WHERE planet_id = $planet_id" );
          db_query( "DELETE FROM orbits_buildings WHERE planet_id = $planet_id" );
          db_query( "DELETE FROM planet_events WHERE planet_id = $planet_id" );
          db_query( "DELETE FROM planets_disp WHERE event_id NOT IN (SELECT id FROM planet_events)" );
          db_query( "DELETE FROM planets_make WHERE event_id NOT IN (SELECT id FROM planet_events)" );
          db_query( "DELETE FROM planets_mines WHERE event_id NOT IN (SELECT id FROM planet_events)" );
          db_query( "DELETE FROM orbit_events WHERE planet_id = $planet_id" );
          db_query( "DELETE FROM orbits_make WHERE event_id NOT IN (SELECT id FROM orbit_events)" );
          db_query( "DELETE FROM orbits_mines WHERE event_id NOT IN (SELECT id FROM orbit_events)" );
          db_query( "DELETE FROM defence WHERE place_id = $planet_id" );

          db_query( "UPDATE planets SET type = 3 WHERE id = $planet_id" );
        }
      }
    } else {
      db_query( "DELETE FROM users WHERE id = $uid" );
      if( is_numeric( $base['star_id'] ) && $base['star_id'] > 0 ) {
        db_query( "DELETE FROM planets WHERE star_id = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 2 AND arg1 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg0 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg2 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg8 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 4 AND arg0 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 8 AND arg0 = ".$base['star_id'] );
        db_query( "DELETE FROM users_quests WHERE type = 9 AND arg0 = ".$base['star_id'] );
      }
      if( $base['name'] ) {
        db_query( "DELETE FROM users_quests WHERE type = 2 AND arg4 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg1 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg3 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 3 AND arg9 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 4 AND arg1 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 8 AND arg1 = '".$base['name']."'" );
        db_query( "DELETE FROM users_quests WHERE type = 9 AND arg1 = '".$base['name']."'" );
      }

      if( mt_rand( 1, 100 ) == 1 ) {
        if( $base['star_id'] ) {
          db_query( "UPDATE stars SET type = 4 WHERE id = ".$base['star_id'] );
          user_report( $base['star_id'], 1, 40, t( "Астрономы зафиксировали коллапс звезды недалеко от вашей системы. <font color=\"#FF0000\">Звезда %s превратилась в черную дыру</font>.", array( $base['name'] ) ) );

          db_query( "UPDATE ships s
                        SET s.arg1={$base['sx']}, s.arg2={$base['sx']}, s.place_type = 8, s.place_id = 0
                      WHERE s.fleet_id IS NULL AND (
                              ( s.place_type IN (0,1) AND s.place_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) )
                              OR
                              ( s.place_type = 3 AND s.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) ) )
                              OR
                              ( s.place_type = 7 AND s.place_id = {$base['star_id']} ) )" );

          db_query( "UPDATE fleets f, ships s
                        SET f.arg1={$base['sx']}, f.arg2={$base['sx']}, f.place_type = 8, f.place_id = 0,
                            s.arg1={$base['sx']}, s.arg2={$base['sx']}, s.place_type = 8, s.place_id = 0
                      WHERE s.fleet_id = f.id AND (
                              ( f.place_type IN (0,1) AND f.place_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) )
                              OR
                              ( f.place_type = 3 AND f.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) ) )
                              OR
                              ( f.place_type = 7 AND f.place_id = {$base['star_id']} ) )" );
        }
      } else {
        if( $base['star_id'] ) {
          db_query( "DELETE FROM stars WHERE id = ".$base['star_id'] );
          user_report( $base['star_id'], 1, 40, t( "Астрономы зафиксировали взрыв звезды недалеко от вашей системы. <font color=\"#FF0000\">Звезда %s взорвалась</font>, все планеты в этой системе уничтожены.", array( $base['name'] ) ) );

          db_query( "UPDATE ships s
                        SET s.arg1={$base['sx']}, s.arg2={$base['sx']}, s.place_type = 8, s.place_id = 0
                      WHERE s.fleet_id IS NULL AND (
                              ( s.place_type IN (0,1) AND s.place_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) )
                              OR
                              ( s.place_type = 3 AND s.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) ) )
                              OR
                              ( s.place_type = 7 AND s.place_id = {$base['star_id']} ) )" );

          db_query( "UPDATE fleets f, ships s
                        SET f.arg1={$base['sx']}, f.arg2={$base['sx']}, f.place_type = 8, f.place_id = 0,
                            s.arg1={$base['sx']}, s.arg2={$base['sx']}, s.place_type = 8, s.place_id = 0
                      WHERE s.fleet_id = f.id AND (
                              ( f.place_type IN (0,1) AND f.place_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) )
                              OR
                              ( f.place_type = 3 AND f.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id IN ( SELECT p.id FROM planets p WHERE p.star_id = {$base['star_id']} ) ) )
                              OR
                              ( f.place_type = 7 AND f.place_id = {$base['star_id']} ) )" );
        }
      }
    }

    db_query( "DELETE FROM fleets WHERE user_id = $uid" );
    db_query( "DELETE FROM ships WHERE user_id = $uid" );

    db_query( "DELETE FROM books_teach WHERE user_id = $uid" );
    db_query( "DELETE FROM space_events WHERE user_id = $uid" );
    db_query( "DELETE FROM robots WHERE user_id = $uid" );
    db_query( "DELETE FROM users_books WHERE user_id = $uid" );
    db_query( "DELETE FROM users_messages WHERE to_user = $uid OR from_user = $uid" );
    db_query( "DELETE FROM users_msg_settings WHERE user_id = $uid" );
    db_query( "DELETE FROM users_quests WHERE user_id = $uid" );
    db_query( "DELETE FROM war_events WHERE a_user_id = $uid OR d_user_id = $uid" );

    db_query( "DELETE FROM planets WHERE star_id NOT IN (SELECT id FROM stars)" );
    db_query( "DELETE FROM warehouse WHERE place_type = 2 AND place_id NOT IN (SELECT id FROM ships)" );
    db_query( "DELETE FROM warehouse WHERE place_type IN( 0, 1 ) AND place_id NOT IN (SELECT id FROM planets)" );
    db_query( "DELETE FROM planets_buildings WHERE planet_id NOT IN (SELECT id FROM planets)" );
    db_query( "DELETE FROM orbits_buildings WHERE planet_id NOT IN (SELECT id FROM planets)" );
    db_query( "DELETE FROM trade_in WHERE ob_id NOT IN (SELECT id FROM orbits_buildings )" );
    db_query( "DELETE FROM trade_out WHERE ob_id NOT IN (SELECT id FROM orbits_buildings )" );
    db_query( "DELETE FROM planet_events WHERE planet_id NOT IN (SELECT id FROM planets)" );
    db_query( "DELETE FROM planets_disp WHERE event_id NOT IN (SELECT id FROM planet_events)" );
    db_query( "DELETE FROM planets_make WHERE event_id NOT IN (SELECT id FROM planet_events)" );
    db_query( "DELETE FROM planets_mines WHERE event_id NOT IN (SELECT id FROM planet_events)" );
    db_query( "DELETE FROM orbit_events WHERE planet_id NOT IN (SELECT id FROM planets)" );
    db_query( "DELETE FROM orbits_make WHERE event_id NOT IN (SELECT id FROM orbit_events)" );
    db_query( "DELETE FROM orbits_mines WHERE event_id NOT IN (SELECT id FROM orbit_events)" );
    db_query( "DELETE FROM defence WHERE place_id NOT IN (SELECT id FROM planets)" );
  }
}

function email_user( $uid ) {

//  $item = array( 'login' => 'sharque', 'email' => 'thesharque@gmail.com' );
  $item = db_fetch_row( "SELECT login, email FROM users u WHERE u.id = $uid" );

  $login = $item['login'];
  $email = $item['email'];

  $message = t( "Здравствуйте %s.

Вы получили это письмо, потому что зарегистрированы в игре \"Полдень 21 века\" на сервере 21noon.com.

Вы не прошли начального обучения и давно не посещали игру, ваша звезда взорвалась.

Если вам не сложно, подскажите, что именно вам не понравилось в нашем проекте, мы обязательно это
изменим и когда вы к нам вернетесь все будет значительно лучше.

С уважением,
Администрация сайта \"Полдень 21 века\".", array( $login ) );

  $headers = "From: 21noon <support@21noon.com>\r\n".
             "Content-Transfer-Encoding: 8bit\r\n".
             "Content-type: text/plain; charset=\"windows-1251\"".
             "Reply-To: support@21noon.com\r\n".
             'X-Mailer: PHP/' . phpversion();
    
  $subject = "=?windows-1251?b?" . base64_encode( t( "Техподдержка игры Полдень 21 века" ) ) . "?=";
  mail( $email, $subject, $message, $headers );
//  mail( 'thesharque@gmail.com', $subject, $message, $headers );
}

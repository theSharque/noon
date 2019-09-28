<?php

function free_warehouse() {
  db_query( "DELETE FROM warehouse WHERE object_cnt = 0" );
  db_query( "DELETE FROM warequest WHERE object_cnt = 0" );
}

function free_trade_in() {
  db_query( "DELETE FROM trade_in WHERE object_cnt = 0" );
}

function free_trade_out() {
  db_query( "DELETE FROM trade_out WHERE object_cnt = 0" );
}

function free_user_messages() {
  db_query( "DELETE FROM users_messages WHERE from_user = 1 AND msg_date < DATE_SUB( now() , INTERVAL 3 DAY )" );
  db_query( "DELETE FROM users_messages WHERE from_user < 15 AND msg_date < DATE_SUB( now() , INTERVAL 14 DAY )" );
//  db_query( "DELETE FROM users_messages WHERE msg_date < DATE_SUB( now() , INTERVAL 14 DAY )" );
  db_query( "DELETE FROM users_report WHERE msg_date < DATE_SUB( now() , INTERVAL 2 DAY )" );
}

function free_chat() {
  db_query( "DELETE FROM chat WHERE msgtime < DATE_SUB( now() , INTERVAL 4 DAY )" );

  $old_system = db_fetch_array( "SELECT to_user, COUNT(*) cnt
                                   FROM `chat`
                                  WHERE user_id = 1
                               GROUP BY to_user
                                 HAVING cnt > 300" );

  foreach( $old_system as $line ) {
    if( $line['to_user'] ) {
      $to_user = '= '.$line['to_user'];
    } else {
      $to_user = 'IS null';
    }

    db_query( "DELETE FROM chat
                WHERE user_id = 1 AND to_user $to_user
             ORDER BY id
                LIMIT ".($line['cnt'] - 200) );
  }
}

function free_quest() {
  $stat = db_fetch_array( "SELECT user_id, count(*) cnt FROM users_quests WHERE status <= 0 GROUP BY user_id" );

  foreach( $stat as $item ) {
    db_query( "UPDATE users_active SET quest = quest + {$item['cnt']} WHERE id = ".$item['user_id'] );
  }

  $quest = db_fetch_array( "SELECT id
                              FROM users_quests uq
                        INNER JOIN quest_types qt ON qt.type = uq.type
                                  WHERE qt.cnt > 0
                                    AND user_id IS NULL
                                    AND UNIX_TIMESTAMP( DATE_ADD( gen_date, INTERVAL 3 DAY ) ) < UNIX_TIMESTAMP( NOW() )" );
  foreach( $quest as $item ) {
    db_query( "DELETE FROM users_quests WHERE id = ".$item['id'] );
  }

  db_query( "DELETE FROM users_quests WHERE status <= 0" );
  db_query( "DELETE FROM u2u_quests WHERE event_id NOT IN( SELECT id FROM users_quests )" );

  $quest = db_fetch_array( "SELECT uu.user_id umaster, uu.event_id, uu.type, uq.user_id uslave, uu.summ, uu.currency
                              FROM u2u_quests uu
                        INNER JOIN users_quests uq ON uq.id = uu.event_id
                             WHERE UNIX_TIMESTAMP( DATE_ADD( uu.public_date, INTERVAL 7 DAY ) ) < UNIX_TIMESTAMP( NOW() )" );

  foreach( $quest as $item ) {
    if( $item['umaster'] && $item['umaster'] > 14 ) {
      send_msg( 1, $item['umaster'], t( "Ваше задание просрочено и удалено из списка. Если необходимо создайте новое задание. Денежный гарант возвращен на ваш счет." ), 6 );
    }

    db_query( "DELETE FROM users_quests WHERE id = ".$item['event_id'] );
    db_query( "DELETE FROM u2u_quests WHERE event_id = ".$item['event_id'] );

    if( $item['currency'] == 1 ) {
      db_query( "UPDATE users u SET u.credits = u.credits + {$item['summ']} WHERE u.id = {$item['umaster']}" );
    } else {
      db_query( "UPDATE users u SET u.money = u.money + {$item['summ']} WHERE u.id = {$item['umaster']}" );
    }
  }

  $wares = db_fetch_array( "SELECT place_type, place_id, object_id, object_cnt, quest_id
                              FROM warequest wq
                             WHERE wq.quest_id NOT IN ( SELECT id FROM users_quests )" );

  foreach( $wares as $item ) {
    sub_warehouse_item( $item['place_type'], $item['place_id'], $item['object_id'], $item['object_cnt'], false, $item['quest_id'] );
    add_warehouse_item( $item['place_type'], $item['place_id'], $item['object_id'], $item['object_cnt'] );
  }
}

function free_premium() {
  db_query( "DELETE FROM users_premium WHERE premium <= 0" );
}

function free_war() {
  db_query( "UPDATE ships
                SET inwar = 0
              WHERE fleet_id IS NULL AND inwar != 0 AND
                    id NOT IN (SELECT a_object_id FROM war_events WHERE a_type = 0 ) AND
                    id NOT IN (SELECT d_object_id FROM war_events WHERE d_type = 0 )" );

  db_query( "DELETE FROM ships_war
                   WHERE fleet_id IS NULL AND
                         id NOT IN (SELECT a_object_id FROM war_events WHERE a_type = 0 ) AND
                         id NOT IN (SELECT d_object_id FROM war_events WHERE d_type = 0 )" );

  db_query( "UPDATE fleets
                SET inwar = 0
              WHERE inwar != 0 AND
                    id NOT IN (SELECT a_object_id FROM war_events WHERE a_type = 1 ) AND
                    id NOT IN (SELECT d_object_id FROM war_events WHERE d_type = 1 )" );

  db_query( "UPDATE ships
                SET inwar = 0
              WHERE fleet_id IS NOT NULL AND inwar != 0 AND
                    fleet_id NOT IN (SELECT a_object_id FROM war_events WHERE a_type = 1 ) AND
                    fleet_id NOT IN (SELECT d_object_id FROM war_events WHERE d_type = 1 )" );

  db_query( "DELETE FROM ships_war
                   WHERE fleet_id IS NOT NULL AND
                         fleet_id NOT IN (SELECT a_object_id FROM war_events WHERE a_type = 1 ) AND
                         fleet_id NOT IN (SELECT d_object_id FROM war_events WHERE d_type = 1 )" );

  $cnt = db_fetch_val( "SELECT count(*) cnt FROM war_log WHERE msg_time < DATE_SUB( now() , INTERVAL 3 DAY )", 'cnt' );
  db_query( "UPDATE variables SET val = val + $cnt WHERE name = 'war_count'" );
  db_query( "DELETE FROM war_log WHERE msg_time < DATE_SUB( now() , INTERVAL 3 DAY )" );
  db_query( "DELETE FROM war_online WHERE place_hash NOT IN ( SELECT DISTINCT place_hash FROM war_events )" );

  $old = db_fetch_array( "SELECT wp.fleet_id
                            FROM war_places wp
                           WHERE wp.sent = 1 AND wp.fleet_id != 0" );

  foreach( $old as $item ) {
    $inwar = db_fetch_val( "SELECT f.inwar FROM fleets f WHERE f.id = {$item['fleet_id']}", 'inwar' );

    if( $inwar == 0 ) {
      db_query( "DELETE FROM fleets WHERE id = {$item['fleet_id']}" );
      db_query( "DELETE FROM ships WHERE fleet_id = {$item['fleet_id']}" );
    }
  }    

  db_query( "DELETE FROM war_places WHERE id NOT IN ( SELECT DISTINCT place_hash FROM war_events )" );

  $drones = db_fetch_array( "SELECT d.ship_id, d.from_id, s.fleet_id
                               FROM ships s
                         INNER JOIN drones d ON d.ship_id = s.id
                              WHERE s.inwar = 0 AND s.object_id = 9472
                           GROUP BY d.from_id" );

  if( count( $drones ) > 0 ) {
    foreach( $drones as $drone ) {
      add_warehouse_item( 2, $drone['from_id'], 9473, 1 );
      db_query( "DELETE FROM drones WHERE ship_id = ".$drone['ship_id'] );
      db_query( "DELETE FROM ships WHERE id = ".$drone['ship_id'] );

      if( $drone['fleet_id'] != null && update_fleet( $drone['fleet_id'] ) == 0 ) { 
        db_query( "DELETE FROM fleets WHERE id = ".$drone['fleet_id'] );
      }
    }
  }
}

function free_ships() {
  db_query( "DELETE FROM ships WHERE user_id NOT IN ( SELECT id FROM users )" );
  db_query( "DELETE FROM fleets WHERE user_id NOT IN ( SELECT id FROM users )" );

  db_query( "DELETE FROM fleets WHERE id NOT IN ( SELECT fleet_id FROM ships WHERE fleet_id IS NOT NULL )" );

  db_query( "DELETE FROM ships WHERE user_id IS NULL AND place_type = 8 AND name = 'abandon'" );
  db_query( "DELETE FROM ships WHERE user_id IS NULL AND place_type = 7 AND place_id IN( SELECT id FROM stars WHERE type = 4 )" );

  db_query( "DELETE FROM ships WHERE user_id < 15 AND fleet_id IS NULL AND place_type = 8 AND name = 'abandon'" );

  db_query( "DELETE FROM ships WHERE user_id = 4 AND place_type = 7 AND fleet_id NOT IN ( SELECT uq.arg2 FROM users_quests uq WHERE uq.type = 11 )" );
  db_query( "DELETE FROM fleets WHERE user_id = 4 AND place_type = 7 AND id NOT IN ( SELECT uq.arg2 FROM users_quests uq WHERE uq.type = 11 )" );

  db_query( "DELETE FROM fleets WHERE user_id = 5 AND place_type = 0 AND
                                      place_id IN (SELECT p.id FROM planets p WHERE UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(p.orbit_time) > 259200)" );
  db_query( "DELETE FROM ships WHERE fleet_id IN( SELECT f.id FROM fleets f WHERE f.user_id = 5 AND f.place_type = 0 AND
                                                  f.place_id IN ( SELECT p.id FROM planets p 
                                                                  WHERE UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(p.orbit_time) > 259200 ) )" );
  db_query( "DELETE FROM ships WHERE user_id = 6 AND
                                     id NOT IN ( SELECT uq.arg6 FROM users_quests uq WHERE uq.type = 10 ) AND
                                     id NOT IN ( SELECT uq.arg7 FROM users_quests uq WHERE uq.type = 10 )" );

  db_query( "DELETE FROM hot_way WHERE event_time < DATE_SUB( now() , INTERVAL 1 DAY )" );

  db_query( "DELETE FROM drones WHERE ship_id NOT IN ( SELECT id FROM ships )" );
}

function free_stars() {
  db_query( "DELETE FROM stars WHERE id NOT IN ( SELECT DISTINCT star_id FROM planets ) AND type != 4" );

  db_query( "DELETE FROM planets WHERE cycles <= 0 AND type = 5" );

  db_query( "UPDATE planets
                SET occuped = 0
              WHERE id NOT IN ( SELECT DISTINCT planet_id FROM planets_buildings ) AND
                    id NOT IN ( SELECT DISTINCT planet_id FROM orbits_buildings )" );

  db_query( "UPDATE planets
                SET occuped = 1
              WHERE id IN ( SELECT DISTINCT planet_id FROM planets_buildings ) OR
                    id IN ( SELECT DISTINCT planet_id FROM orbits_buildings )" );

  $stars = db_fetch_array( "SELECT s.id
                              FROM stars s
                        INNER JOIN planets p ON p.star_id = s.id
                          GROUP BY s.id
                            HAVING MAX( p.occuped ) = 0" );

  foreach( $stars as $item ) {
    db_query( "DELETE FROM stars WHERE id = ".$item['id'] );
    db_query( "DELETE FROM planets WHERE star_id = ".$item['id'] );
  }

  db_query( "DELETE FROM planets_active WHERE id NOT IN ( SELECT id FROM planets )" );

  $foe = db_fetch_array( "SELECT s.id, p.id pid
                            FROM ships s
                      INNER JOIN orbits_buildings ob ON ob.id = s.place_id
                      INNER JOIN planets p ON p.id = ob.planet_id
                      INNER JOIN foe fo ON fo.user_id = p.user_id AND fo.foe_id = s.user_id
                           WHERE s.fleet_id is null AND s.place_type = 3" );

  foreach( $foe as $item ) {
    db_query( "UPDATE ships SET place_type = 2, place_id = {$item['pid']} WHERE id = {$item['id']}" );
  }

  $foe = db_fetch_array( "SELECT f.id, p.id pid
                            FROM fleets f
                      INNER JOIN orbits_buildings ob ON ob.id = f.place_id
                      INNER JOIN planets p ON p.id = ob.planet_id
                      INNER JOIN foe fo ON fo.user_id = p.user_id AND fo.foe_id = f.user_id
                           WHERE f.place_type = 3" );

  foreach( $foe as $item ) {
    db_query( "UPDATE fleets SET place_type = 2, place_id = {$item['pid']} WHERE id = {$item['id']}" );
  }
}

function free_foe() {
  db_query( "DELETE FROM foe WHERE user_id IN ( 1, 5, 6, 7, 8, 9 ) OR foe_id IN ( 1, 5, 6, 7, 8, 9 )" );

  return 1;
}

function free_defence() {
  db_query( "DELETE FROM defence WHERE user_id NOT IN (SELECT id FROM users)" );
  db_query( "DELETE FROM defence WHERE place_type = 1 AND place_id NOT IN ( SELECT DISTINCT planet_id FROM planets_buildings WHERE object_id IN ( 27, 28, 29, 30, 31 ) )" );
  db_query( "DELETE FROM defence WHERE place_type = 0 AND place_id NOT IN ( SELECT DISTINCT planet_id FROM orbits_buildings WHERE object_id IN ( 3007, 3008, 3009 ) )" );

  return 1;
}

function free_trash() {
  db_query( "DELETE FROM trash WHERE lost_date < DATE_SUB( now() , INTERVAL 5 DAY )" );
}

function free_block() {
  db_query( "UPDATE users SET block = 0 WHERE block = 1 AND block_date < DATE_SUB( NOW(), INTERVAL 6 HOUR )" );
}

function free_robot() {
  db_query( "DELETE FROM robots WHERE user_id NOT IN ( SELECT id FROM users )" );

  $robots = db_fetch_array( "SELECT r.id
                     FROM robots r
                LEFT JOIN orbits_buildings ob ON r.build_id = ob.id AND r.build_type = 0
                LEFT JOIN planets_buildings pb ON r.build_id = pb.id AND r.build_type = 1
                    WHERE ob.id IS NULL AND pb.id IS NULL" );
  foreach( $robots as $item ) {
    db_query( "UPDATE robots SET status = 0 WHERE id = ".$item['id'] );
  }
}
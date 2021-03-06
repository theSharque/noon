<?php

function gen_pirate() {

  $target = db_fetch_row( "SELECT SQL_NO_CACHE d.place_id, p.star_id, s.name sname, p.name, u.id uid, u.login, u.pirate_status,
ROUND(
  ( SELECT count(*) FROM planets_buildings pb WHERE pb.shield > 0 AND pb.planet_id = d.place_id ) * 2 +
  ( SELECT count(*) FROM orbits_buildings ob WHERE ob.shield > 0 AND ob.planet_id = d.place_id ) +
  ( SELECT count(*) FROM ships s WHERE s.place_type = 0 AND s.place_id = d.place_id AND s.shield > 0 ) / 2 
) psh,
ua.lastlogin - DATE_SUB( NOW(), INTERVAL 7 DAY ) last_way
                            FROM defence d
                      INNER JOIN users_active ua ON ua.id = d.user_id
                      INNER JOIN users u ON u.id = ua.id
                      INNER JOIN planets p ON p.id = d.place_id
                      INNER JOIN stars s ON s.id = p.star_id
                       LEFT JOIN war_places wp ON place = concat( 'orb.', d.place_id )
                           WHERE wp.id IS NULL AND d.place_type IN( 0, 1 ) AND d.status > 0 AND p.type != 1
                        ORDER BY u.pirate_status + rand() * 3 DESC
                           LIMIT 0, 1" );

  if( isset( $target['place_id'] ) && is_numeric( $target['place_id'] ) ) {

    echo date("H:i:s").' Attack '.$target['login'].' planet '.$target['name']."\n";

    if( $target['pirate_status'] > 0 ) {
      db_query( "UPDATE users SET pirate_status = pirate_status - 1 WHERE id = {$target['uid']}" );
    }

    db_query( "INSERT INTO fleets (     name, user_id, place_type, place_id, arg1, arg2, guard, abordage ) 
                           VALUES ( '������',       4,          5,        0, null, null,     1,        0 )" );
    $fleet_id = mysql_insert_id();

    $pirates = db_fetch_array( "SELECT st.object_id, st.shield, mt.object_id missile, st.code
                                  FROM ship_types st
                            INNER JOIN missile_types mt on mt.type = st.missile
                                 WHERE st.object_id IN ( 9042, 9080, 9167, 9230, 9127, 9021, 9053 )" );

    if( $target['last_way'] > 0 ) {
      $cnt = mt_rand( 3, $target['psh'] / 2 + 3 );
    } else {
      $cnt = mt_rand( 3, $target['psh'] / 2 + 3 );
    }

    for( $i=0; $i < $cnt; $i++ ) {
      $rnd = mt_rand( 0, count( $pirates ) - 1 );

      db_query( "INSERT INTO ships (                    object_id, place_type, place_id, user_id,                                name, arg1, arg2, fleet_id,                      shield, inwar, guard, abordage )
                            VALUES ({$pirates[$rnd]['object_id']},          5,        0,       4, '{$pirates[$rnd]['code']} - ������', null, null, $fleet_id, {$pirates[$rnd]['shield']},     0,     1,        0 )" );
      $ship_id = mysql_insert_id();

      if( $pirates[$rnd]['missile'] > 0 ) {
        add_warehouse_item( 2, $ship_id, $pirates[$rnd]['missile'], 4 );
      }
    }

    update_fleet( $fleet_id );

    $x = mt_rand( 50, 300 );
    $y = mt_rand( 50, 300 );
    $len = round( sqrt( ( pow( $x, 2 ) + pow( $y, 2 ) ) ) );
    $speed = ( isset( $fleet['hyper'] ) && $fleet['hyper'] > 0 ) ? $fleet['hyper'] : 2;
    $time = get_smove_time( $len * 20, $speed, 4 );

    db_query( "INSERT INTO space_events ( event_type,   ship_id,                               event_time, timer, user_id, arg1,                 arg2, from_arg1, from_arg2, from_type )
                                 VALUES (        104, $fleet_id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time,       4,    0, {$target['star_id']},         0,         0,         0 )" );

    db_query( "INSERT INTO users_quests ( user_id, status, type,                arg0,                 arg1,      arg2 )
                                 VALUES (       4,     10,   11, {$target['star_id']}, {$target['place_id']}, $fleet_id )" );

    user_report( $target['star_id'], 1, 50, t( "�� ������������ ������������ ������������ ��������� �����������, ��� <font color=\"#FF0000\">� ������� %s ������������ ���� �������</font>, �������� ������� ���� �� ��������� � ����������� �����.", array( $target['sname'] ) ) );

    $inter = db_fetch_array( "SELECT f.user_id, f.interupt, f.name, s.name sname
                                FROM fleets f
                          INNER JOIN stars s ON s.id = f.place_id
                               WHERE f.interupt > 0 AND f.place_type = 7 AND f.place_id = {$target['star_id']}
                              union
                              SELECT s.user_id, s.interupt, s.name, st.name sname
                                FROM ships s
                          INNER JOIN stars st ON st.id = s.place_id
                               WHERE s.fleet_id IS NULL AND s.interupt > 0 AND s.place_type = 7 AND s.place_id = {$target['star_id']}" );

    if( count( $inter ) ) {
      foreach( $inter as $mess ) {
        if( $mess['interupt'] == 1 ) {
          send_msg( 1, $mess['user_id'], t( "���������� ��������� ������������ � ������� %s ������������� %s. ������������ ���� �������. ��������� �������� ����� %s", array( $mess['sname'], $mess['name'], time_to_str( $time ) ) ), 6 );
        } else {
          send_msg( 1, $mess['user_id'], t( "���������� ��������� ������������ � ������� %s ������������� %s, �������� �������������. ������������ ���� �������. ��������� �������� ����� %s", array( $mess['sname'], $mess['name'], time_to_str( $time ) ) ), 6 );
        }
      }
    }
  }

  return 1;
}

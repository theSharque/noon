<?php

  function send_help() {
    $longwars = db_fetch_array( "SELECT wp.id
                                   FROM war_places wp
                                  WHERE wp.sent = 0 AND wp.date_start < DATE_SUB( NOW(), INTERVAL 6 HOUR )" );
    foreach( $longwars as $item ) {
      $war = db_fetch_row( "SELECT COUNT( sw.id ) count,
                                     MIN( sw.place_id ) place_id,
                                     MIN( sw.place_type ) place_type,
                                     MIN( sw.arg1 ) arg1,
                                     MIN( sw.arg2 ) arg2,
                                     MIN( we.d_type ) d_type,
                                     MIN( we.d_object_id ) d_id,
                                     MIN( we.a_type ) a_type,
                                     MIN( we.a_object_id ) a_id,
                                     MIN( we.fire_time ) fire_time
                                FROM ships_war sw
                          INNER JOIN war_events we ON ( we.d_type = 0 AND we.d_object_id = sw.id ) OR ( we.d_type = 1 AND we.d_object_id = sw.fleet_id ) OR
                                                      ( we.a_type = 0 AND we.a_object_id = sw.id ) OR ( we.a_type = 1 AND we.a_object_id = sw.fleet_id )
                               WHERE we.place_hash = {$item['id']}" );

      switch( $war['place_type'] ) {
        case 0:
        case 1:
          db_query( "INSERT INTO fleets (                    name, user_id,           place_type,           place_id, arg1, arg2, guard )
                                 VALUES ( '".t('Конфедерация')."',       5, {$war['place_type']}, {$war['place_id']}, null, null, 2     )" );
          $fleet_id = mysql_insert_id();
      
          for( $i=0; $i < $war['count'] / 4; $i++ ) {
            db_query( "INSERT INTO ships (object_id,           place_id,           place_type, user_id, name, arg1, arg2,  fleet_id, shield, inwar, guard) VALUES
                                         (     9485, {$war['place_id']}, {$war['place_type']},       5, 'ГП', null, null, $fleet_id,  25000,     0,     2)" );

            $ship_id = mysql_insert_id();
            add_warehouse_item( 2, $ship_id, 9217, 32 );
          }
      
          update_fleet( $fleet_id );
          break;

        case 7:
        case 8:
          db_query( "INSERT INTO fleets (                    name, user_id,           place_type,           place_id,           arg1,           arg2, guard )
                                 VALUES ( '".t('Конфедерация')."',       5, {$war['place_type']}, {$war['place_id']}, {$war['arg1']}, {$war['arg1']}, 2     )" );
          $fleet_id = mysql_insert_id();
      
          for( $i=0; $i < $war['count'] / 4; $i++ ) {
            db_query( "INSERT INTO ships (object_id,           place_id,           place_type, user_id, name,           arg1,           arg2,  fleet_id, shield, inwar, guard) VALUES
                                         (     9485, {$war['place_id']}, {$war['place_type']},       5, 'ГП', {$war['arg1']}, {$war['arg2']}, $fleet_id,  25000,     0,     2)" );

            $ship_id = mysql_insert_id();
            add_warehouse_item( 2, $ship_id, 9217, 32 );
          }
      
          update_fleet( $fleet_id );
          break;
      }

      db_query( "UPDATE war_places SET sent = 1, fleet_id = $fleet_id WHERE id = {$item['id']}" );

      if( $war['d_type'] == 0 || $war['d_type'] == 1 ) {
        StartWar( 1, $fleet_id, $war['d_type'], $war['d_id'], $war['fire_time'], 5 );
      }

      if( $war['a_type'] == 0 || $war['a_type'] == 1 ) {
        StartWar( 1, $fleet_id, $war['a_type'], $war['a_id'], $war['fire_time'], 5 );
      }
    }

    return 1;
  }

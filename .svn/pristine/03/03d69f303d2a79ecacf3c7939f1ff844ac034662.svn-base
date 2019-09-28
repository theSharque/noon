<?php

  function wait( $id, $is_fleet ) {
    db_safe( $id );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, se.id seid
                               FROM fleets f
                          LEFT JOIN space_events se ON se.ship_id = f.id AND se.event_type >= 100
                              WHERE f.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, se.id seid
                               FROM ships s
                          LEFT JOIN space_events se ON se.ship_id = s.id AND se.event_type < 100
                              WHERE s.id = $id" );
    }

    if( $test['inwar'] == 0 && $test['place_type'] != 5 && $test['seid'] === null ) {
      return true;
    } else {
      return false;
    }
  }

  function land( $id, $is_fleet ) {
    db_safe( $id );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id, f.agrav
                               FROM fleets f
                              WHERE s.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id, st.agrav
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = $id" );
    }

    if( $test['inwar'] == 0 && $test['id'] && $test['agrav'] == 1 && $test['place_id'] > 0 && $test['place_type'] == 0 && !is_def( $test['user_id'], $test['place_id'], 1 ) ) {
      $total_time = get_land_time();
      if( $is_fleet ) {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                                     event_time,       timer,            user_id,                arg1 )
                                     VALUES (        100,     $id, DATE_ADD( NOW(), INTERVAL $total_time SECOND ), $total_time, {$test['user_id']}, {$test['place_id']} )" );
        db_query( "UPDATE fleets SET place_type = 5, guard = 0 WHERE id = $id" );
        db_query( "UPDATE ships SET place_type = 5, guard = 0 WHERE fleet_id = $id" );
      } else {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                                     event_time,       timer,            user_id,                arg1 )
                                     VALUES (          0,     $id, DATE_ADD( NOW(), INTERVAL $total_time SECOND ), $total_time, {$test['user_id']}, {$test['place_id']} )" );
        db_query( "UPDATE ships SET place_type = 5, guard = 0 WHERE id = $id" );
      }

      return true;
    } else {
      return false;
    }
  }

  function takeoff( $id, $is_fleet ) {
    db_safe( $id );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id, f.agrav
                               FROM fleets f
                              WHERE s.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id, st.agrav
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = $id" );
    }

    if( $test['inwar'] == 0 && $test['id'] && $test['agrav'] == 1 && $test['place_id'] > 0 && $test['place_type'] == 1 && !is_def( $test['user_id'], $test['place_id'], 0 ) ) {
      $total_time = get_land_time();
      if( $is_fleet ) {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                                     event_time,       timer,            user_id,                arg1 )
                                     VALUES (        101,     $id, DATE_ADD( NOW(), INTERVAL $total_time SECOND ), $total_time, {$test['user_id']}, {$test['place_id']} )" );
        db_query( "UPDATE fleets SET place_type = 5, guard = 0 WHERE id = $id" );
        db_query( "UPDATE ships SET place_type = 5, guard = 0 WHERE fleet_id = $id" );
      } else {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                                     event_time,       timer,            user_id,                arg1 )
                                     VALUES (          1,     $id, DATE_ADD( NOW(), INTERVAL $total_time SECOND ), $total_time, {$test['user_id']}, {$test['place_id']} )" );
        db_query( "UPDATE ships SET place_type = 5, guard = 0 WHERE id = $id" );
      }

      return true;
    } else {
      return false;
    }
  }

  function dock_station( $id, $is_fleet ) {
    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id
                               FROM fleets f
                              WHERE s.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id
                               FROM ships s
                              WHERE s.id = $id" );
    }

    if( $test['inwar'] == 0 && $test['id'] && $test['place_type'] == 0 ) {
      $station = db_fetch_val( "SELECT id
                                  FROM orbits_buildings
                                 WHERE object_id IN( 3001, 3004 ) AND planet_id = {$test['place_id']}
                                 LIMIT 0,1", 'id' );

      $no_dock = db_fetch_val( "SELECT f.foe_id
                                  FROM foe f
                            INNER JOIN planets p ON p.user_id = f.user_id
                                 WHERE f.foe_id = {$test['user_id']} AND p.id = {$test['place_id']}", 'foe_id' );

      if( $station && !$no_dock ) {
        if( $is_fleet ) {
          db_query( "UPDATE fleets SET guard = 0, place_type = 3, place_id = $station WHERE id = $id" );
          db_query( "UPDATE ships SET guard = 0, place_type = 3, place_id = $station WHERE fleet_id = $id" );
        } else {
          db_query( "UPDATE ships SET guard = 0, place_type = 3, place_id = $station WHERE id = $id" );
        }

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  function undock_station( $id, $is_fleet ) {
    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id
                               FROM fleets f
                              WHERE s.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id
                               FROM ships s
                              WHERE s.id = $id" );
    }

    if( $test['inwar'] == 0 && $test['id'] && $test['place_type'] == 3 ) {
      $station = db_fetch_val( "SELECT planet_id
                                  FROM orbits_buildings
                                 WHERE id = {$test['place_id']}", 'planet_id' );

      if( $station && !is_def( $test['user_id'], $station, 0 ) ) {
        if( $is_fleet ) {
          db_query( "UPDATE fleets SET guard = 0, place_type = 0, place_id = $station WHERE id = $id" );
          db_query( "UPDATE ships SET guard = 0, place_type = 0, place_id = $station WHERE fleet_id = $id" );
        } else {
          db_query( "UPDATE ships SET guard = 0, place_type = 0, place_id = $station WHERE id = $id" );
        }

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  function space( $id, $is_fleet, $place_id ) {
    db_safe( $id );
    db_safe( $place_id );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id, f.planet, f.planet_cnt, f.arg1, f.arg2
                               FROM fleets f
                              WHERE s.id = $id" );

      $fuel = db_fetch_row( "SELECT SUM(w.object_cnt) cnt
                               FROM ships s
                         INNER JOIN warehouse w ON w.object_id = 1019 AND w.place_type = 2 AND w.place_id = s.id
                              WHERE s.fleet_id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id, st.planet, st.planet_cnt, s.arg1, s.arg2
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = $id" );

      $fuel = db_fetch_row( "SELECT object_cnt cnt
                               FROM warehouse
                              WHERE object_id = 1019 AND place_type = 2 AND place_id = $id" );
    }

    if( !$test['id'] || $test['inwar'] != 0 ) {
      return false;
    }

    switch( $test['place_type'] ) {
      case 0:
        $start = db_fetch_row( "SELECT id, star_id, orb, rad FROM planets WHERE id = {$test['place_id']}" );
        if( !$start['id'] ) {
          return false;
        }

        $star_id = $start['star_id'];

        $radx = $start['orb'] * 2;
        $rady = $start['orb'] * 1.5;
        $start_x = round( 340 + sin( deg2rad( $start['rad'] ) ) * $radx / 2 );
        $start_y = round( 220 + cos( deg2rad( $start['rad'] ) ) * $rady / 2 );
        break;

      case 7:
        $star_id = $test['place_id'];

        $start_x = $test['arg1'];
        $start_y = $test['arg2'];
        break;

      default:
        return false;
        break;
    }

    $end = db_fetch_row( "SELECT id, star_id, orb, rad FROM planets WHERE id = $place_id" );
    if( !$end['id'] ) {
      return false;
    }

    if( $star_id == $end['star_id'] ) {
      $radx = $end['orb'] * 2;
      $rady = $end['orb'] * 1.5;
      $end_x = round( 340 + sin( deg2rad( $end['rad'] ) ) * $radx / 2 );
      $end_y = round( 220 + cos( deg2rad( $end['rad'] ) ) * $rady / 2 );

      $xdiff = $start_x - $end_x;
      $ydiff = $start_y - $end_y;

      $len = round( sqrt( $xdiff * $xdiff + $ydiff * $ydiff ) );
      $fuel_need = round( $len/15 ) * $test['planet_cnt'];
      $time = get_pmove_time( $len, $test['planet'], $test['user_id'] );

      if( $fuel_need <= $fuel ) {
        if( $fuel_need > 0 ) {
          if( $is_fleet ) {
            $ships = db_fetch_array( "SELECT s.id, w.object_cnt
                                        FROM ships s
                                  INNER JOIN warehouse w ON w.place_id = s.id AND w.place_type = 2 AND w.object_id = 1019
                                       WHERE s.fleet_id = $id ORDER BY w.object_cnt DESC" );

            foreach( $ships as $item ) {
              if( $fuel_need <= $item['object_cnt'] ) {
                sub_warehouse_item( 2, $item['id'], 1019, $fuel_need );
                break;
              } else {
                sub_warehouse_item( 2, $item['id'], 1019, $item['object_cnt'] );
                $fuel_need -= $item['object_cnt'];
              }
            }
          } else {
            sub_warehouse_item( 2, $id, 1019, $fuel_need );
          }
        }

        if( $is_fleet ) {
          db_query( "UPDATE fleets SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $id" );
          db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE fleet_id = $id" );

          db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                       VALUES (        103,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
        } else {
          db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $id" );

          db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                       VALUES (          3,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
        }

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  function hyper( $id, $is_fleet, $place_id ) {
    db_safe( $id );
    db_safe( $place_id );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id, f.user_id, f.hyper, f.hyper_cnt, f.arg1, f.arg2, u.login
                               FROM fleets f
                         INNER JOIN users u ON u.id = f.user_id
                              WHERE s.id = $id" );

      $fuel = db_fetch_row( "SELECT SUM(w.object_cnt) cnt
                               FROM ships s
                         INNER JOIN warehouse w ON w.object_id = 1044 AND w.place_type = 2 AND w.place_id = s.id
                              WHERE s.fleet_id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id, s.user_id, st.hyper, st.hyper_cnt, s.arg1, s.arg2, u.login
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                         INNER JOIN users u ON u.id = s.user_id
                              WHERE s.id = $id" );

      $fuel = db_fetch_row( "SELECT object_cnt cnt
                               FROM warehouse
                              WHERE object_id = 1044 AND place_type = 2 AND place_id = $id" );
    }

    if( !$test['id'] || $test['inwar'] != 0 ) {
      return false;
    }

    switch( $test['place_type'] ) {
      case 0:
        $start = db_fetch_row( "SELECT s.id, s.x, s.y
                                  FROM stars s
                            INNER JOIN planets p ON p.star_id = s.id
                                 WHERE p.id = {$test['place_id']}" );
        break;

      case 7:
        $start = db_fetch_row( "SELECT s.id, s.x, s.y
                                  FROM stars s
                                 WHERE s.id = {$test['place_id']}" );
        break;

      case 8:
        $start = array(
          'id' => 1,
          'x' => $test['arg1'],
          'y' => $test['arg2'],
        );
        break;

      default:
        return false;
        break;
    }

    if( !$start['id'] ) {
      return false;
    }

    $end = db_fetch_row( "SELECT id, x, y FROM stars WHERE id = $place_id" );
    if( !$end['id'] ) {
      return false;
    }

    $xdiff = $start['x'] - $end['x'];
    $ydiff = $start['y'] - $end['y'];

    $len = round( sqrt( $xdiff * $xdiff + $ydiff * $ydiff ) );
    $time = get_smove_time( $len * 20, $test['hyper'], $test['user_id'] );

    $fuel_need = round( $len/15 ) * $test['hyper_cnt'];
    $fuel_need = $fuel_need - round( ( $fuel_need / 100 ) * get_book_level( 38, $test['user_id'] ) );

    if( $fuel_need <= $fuel ) {
      if( $is_fleet ) {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                     VALUES (        104,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
      } else {
        db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                     VALUES (          4,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
      }


      switch( $test['place_type'] ) {
        case 0:
        case 7:
          db_query( "INSERT INTO hot_way (        id_from,  from_arg1,  from_arg2,     id_to, to_arg1, to_arg2, event_time,  len,            user_id )
                                  VALUES ( {$start['id']},          0,          0, $place_id,       0,       0,      NOW(), $len, {$test['user_id']} )" );
          break;

        case 8:
          db_query( "INSERT INTO hot_way ( id_from,       from_arg1,       from_arg2,     id_to, to_arg1, to_arg2, event_time,  len,            user_id )
                                  VALUES (       8, {$test['arg1']}, {$test['arg1']}, $place_id,       0,       0,      NOW(), $len, {$test['user_id']} )" );
          break;
      }

      $inter = db_fetch_array( "SELECT f.user_id, f.interupt, f.name, s.name sname, im.message, f.corsar
                                  FROM fleets f
                             LEFT JOIN interupt_msg im ON im.type = 1 AND im.ship_id = f.id
                            INNER JOIN stars s ON s.id = f.place_id
                                 WHERE f.interupt > 0 AND f.place_type = 7 AND f.place_id = $place_id
                                union
                                SELECT s.user_id, s.interupt, s.name, st.name sname, im.message, st.corsar
                                  FROM ships s
                             LEFT JOIN interupt_msg im ON im.type = 0 AND im.ship_id = s.id
                            INNER JOIN stars st ON st.id = s.place_id
                                 WHERE s.fleet_id IS NULL AND s.interupt > 0 AND s.place_type = 7 AND s.place_id = $place_id" );

      if( count( $inter ) ) {
        if( $inter['corsar'] == 1 ) {
          $user_name = 'corsar';
        } else {
          $user_name = $test['login'];
        }

        $intcnt = 0;
        foreach( $inter as $mess ) {
          if( $mess['message'] ) {
            send_msg( 1, $test['user_id'], "<font color=\"#FFFF00\">Сообщение гиперперехватчика - \"{$mess['message']}\"</font>", 6 );
          }

          if( $mess['interupt'] == 1 ) {
            send_msg( 1, $mess['user_id'], "Обнаружено искажение пространства в системе {$mess['sname']} перехватчиком {$mess['name']}. Приближается {$test['name']} ({$test['login']}). Ожидается прибытие через ".time_to_str( $time ), 6 );
          } else {
            send_msg( 1, $mess['user_id'], "Обнаружено искажение пространства в системе {$mess['sname']} перехватчиком {$mess['name']}, возможен гиперперехват. Приближается {$test['name']} ({$test['login']}). Ожидается прибытие через ".time_to_str( $time ), 6 );
            $intcnt++;
          }
        }

        if( $intcnt > 0 ) {
          send_msg( 1, $test['user_id'], "Обнаружено искажение пространства, возможен гиперперехват корабля. Найденых точек перехвата: $intcnt", 6 );
        }
      }

      if( $fuel_need > 0 ) {
        if( $is_fleet ) {
          $ships = db_fetch_array( "SELECT s.id, w.object_cnt
                                      FROM ships s
                                INNER JOIN warehouse w ON w.place_id = s.id AND w.place_type = 2 AND w.object_id = 1044
                                     WHERE s.fleet_id = $id ORDER BY w.object_cnt DESC" );

          foreach( $ships as $item ) {
            if( $fuel_need <= $item['object_cnt'] ) {
              sub_warehouse_item( 2, $item['id'], 1044, $fuel_need );
              break;
            } else {
              sub_warehouse_item( 2, $item['id'], 1044, $item['object_cnt'] );
              $fuel_need -= $item['object_cnt'];
            }
          }
        } else {
          sub_warehouse_item( 2, $id, 1044, $fuel_need );
        }
      }

      if( $is_fleet ) {
        db_query( "UPDATE fleets SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $id" );
        db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE fleet_id = $id" );

        db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                     VALUES (        104,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
      } else {
        db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $id" );

        db_query( "INSERT INTO space_events ( event_type, ship_id,                               event_time, timer,            user_id, arg1,      arg2 )
                                     VALUES (          4,     $id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, {$test['user_id']},    0, $place_id )" );
      }

      return true;
    } else {
      return false;
    }
  }

  function load_ware( $id, $is_fleet, $ware, $count ) {

    db_safe( $id );
    db_safe( $is_fleet );
    db_safe( $ware );
    db_safe( $count );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, IF( f.place_type = 3, 0, f.place_type ) w_type, IF( f.place_type = 3, ob.planet_id, f.place_id ) place_id
                               FROM fleets f
                          LEFT JOIN orbits_buildings ob ON ob.id = f.place_id AND f.place_type = 3
                              WHERE f.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, IF( s.place_type = 3, 0, s.place_type ) w_type, IF( s.place_type = 3, ob.planet_id, s.place_id ) place_id
                               FROM ships s
                          LEFT JOIN orbits_buildings ob ON ob.id = s.place_id AND s.place_type = 3
                              WHERE s.id = $id" );
    }

    if( $test['id'] && $test['inwar'] == 0 && ( $test['place_type'] == 1 || $test['place_type'] == 2 || $test['place_type'] == 3 ) ) {
      $max = db_fetch_val( "SELECT object_cnt FROM warehouse WHERE place_type = {$test['w_type']} AND place_id = {$test['place_id']} AND object_id = $ware", 'object_cnt' );

      if( $count > $max ) {
        $count = $max;
      }

      if( $is_fleet ) {
        $ships = db_fetch_array( "SELECT s.id
                                    FROM ships s
                              INNER JOIN ship_types st ON st.object_id = s.object_id
                                   WHERE st.cargo > 0 AND s.fleet_id = $id" );

        foreach( $ships as $item ) {
          $cargo = get_cargo( $item['id'], 1 );
          if( $cargo < $count ) {
            sub_warehouse_item( $test['w_type'], $test['place_id'], $ware, $cargo );
            add_warehouse_item( 2, $id, $ware, $cargo );

            $count -= $cargo;
          } else {
            sub_warehouse_item( $test['w_type'], $test['place_id'], $ware, $count );
            add_warehouse_item( 2, $id, $ware, $count );

            break;
          }
        }
      } else {
        $cargo = get_cargo( $id, 1 );
        if( $count > $cargo ) {
          $count = $cargo;
        }

        sub_warehouse_item( $test['w_type'], $test['place_id'], $ware, $count );
        add_warehouse_item( 2, $id, $ware, $count );
      }

      return true;
    } else {
      return false;
    }
  }

  function unload_ware( $id, $is_fleet, $ware, $count ) {
    db_safe( $id );
    db_safe( $is_fleet );
    db_safe( $ware );
    db_safe( $count );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, IF( f.place_type = 3, 0, f.place_type ) w_type, IF( f.place_type = 3, ob.planet_id, f.place_id ) place_id
                               FROM fleets f
                          LEFT JOIN orbits_buildings ob ON ob.id = f.place_id AND f.place_type = 3
                              WHERE f.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, IF( s.place_type = 3, 0, s.place_type ) w_type, IF( s.place_type = 3, ob.planet_id, s.place_id ) place_id
                               FROM ships s
                          LEFT JOIN orbits_buildings ob ON ob.id = s.place_id AND s.place_type = 3
                              WHERE s.id = $id" );
    }

    if( $test['id'] && $test['inwar'] == 0 && ( $test['place_type'] == 1 || $test['place_type'] == 2 || $test['place_type'] == 3 ) ) {
      $free = get_warehouse( $test['place_id'], $test['w_type'] );

      if( $count > $free ) {
        $count = $free;
      }

      if( $is_fleet ) {
        $ships = db_fetch_array( "SELECT s.id
                                    FROM ships s
                              INNER JOIN ship_types st ON st.object_id = s.object_id
                                   WHERE st.cargo > 0 AND s.fleet_id = $id" );

        foreach( $ships as $item ) {
          $max = db_fetch_val( "SELECT object_cnt FROM warehouse WHERE place_type = 2 AND place_id = {$item['id']} AND object_id = $ware", 'object_cnt' );
          if( $count > $max ) {
            sub_warehouse_item( 2, $id, $ware, $max );
            add_warehouse_item( $test['w_type'], $test['place_id'], $ware, $max );

            $count -= $max;
          } else {
            sub_warehouse_item( 2, $id, $ware, $count );
            add_warehouse_item( $test['w_type'], $test['place_id'], $ware, $count );
            break;
          }
        }
      } else {
        $max = db_fetch_val( "SELECT object_cnt FROM warehouse WHERE place_type = 2 AND place_id = $id AND object_id = $ware", 'object_cnt' );

        if( $count > $max ) {
          $count = $max;
        }

        sub_warehouse_item( 2, $id, $ware, $count );
        add_warehouse_item( $test['w_type'], $test['place_id'], $ware, $count );
      }

      return true;
    } else {
      return false;
    }
  }

  function load_all( $id, $is_fleet, $class = 0 ) {
    db_safe( $id );
    db_safe( $is_flet );
    db_safe( $class );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, IF( f.place_type = 3, 0, f.place_type ) w_type, IF( f.place_type = 3, ob.planet_id, f.place_id ) place_id
                               FROM fleets f
                          LEFT JOIN orbits_buildings ob ON ob.id = f.place_id AND f.place_type = 3
                              WHERE f.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, IF( s.place_type = 3, 0, s.place_type ) w_type, IF( s.place_type = 3, ob.planet_id, s.place_id ) place_id
                               FROM ships s
                          LEFT JOIN orbits_buildings ob ON ob.id = s.place_id AND s.place_type = 3
                              WHERE s.id = $id" );
    }

    if( $test['id'] && $test['inwar'] == 0 && ( $test['place_type'] == 1 || $test['place_type'] == 2 || $test['place_type'] == 3 ) ) {
      if( $class == 0 ) {
        $wares = db_fetch_array( "SELECT w.object_id, w.object_cnt
                                    FROM warehouse w
                              INNER JOIN objects o ON o.id = w.object_id
                                   WHERE w.place_type = {$test['w_type']} AND w.place_id = {$test['place_id']}" );
      } else {
        $wares = db_fetch_array( "SELECT w.object_id, w.object_cnt
                                    FROM warehouse w
                              INNER JOIN objects o ON o.id = w.object_id
                                   WHERE o.class = $class AND w.place_type = {$test['w_type']} AND w.place_id = {$test['place_id']}" );
      }

      foreach( $wares as $item ) {
        load_ware( $id, $is_fleet, $item['object_id'], $item['object_cnt'] );
      }

      return true;
    } else {
      return false;
    }
  }

  function unload_all( $id, $is_fleet, $class = 0 ) {
    db_safe( $id );
    db_safe( $is_flet );
    db_safe( $class );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, f.place_id
                               FROM fleets f
                              WHERE s.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, s.place_id
                               FROM ships s
                              WHERE s.id = $id" );
    }

    if( $test['id'] && $test['inwar'] == 0 && ( $test['place_type'] == 1 || $test['place_type'] == 2 || $test['place_type'] == 3 ) ) {
      if( $is_fleet ) {
        if( $class == 0 ) {
          $wares = db_fetch_array( "SELECT w.place_id, w.object_id, w.object_cnt
                                      FROM warehouse w
                                INNER JOIN objects o ON o.id = w.object_id
                                INNER JOIN ships s ON s.id = w.place_id
                                     WHERE w.place_type = 2 AND s.fleet_id = $id" );
        } else {
          $wares = db_fetch_array( "SELECT w.place_id, w.object_id, w.object_cnt
                                      FROM warehouse w
                                INNER JOIN objects o ON o.id = w.object_id
                                INNER JOIN ships s ON s.id = w.place_id
                                     WHERE o.class = $class AND w.place_type = 2 AND s.fleet_id = $id" );
        }
      } else {
        if( $class == 0 ) {
          $wares = db_fetch_array( "SELECT w.place_id, w.object_id, w.object_cnt
                                      FROM warehouse w
                                INNER JOIN objects o ON o.id = w.object_id
                                     WHERE w.place_type = 2 AND w.place_id = $id" );
        } else {
          $wares = db_fetch_array( "SELECT w.place_id, w.object_id, w.object_cnt
                                      FROM warehouse w
                                INNER JOIN objects o ON o.id = w.object_id
                                     WHERE o.class = $class AND w.place_type = 2 AND w.place_id = $id" );
        }
      }

      foreach( $wares as $item ) {
        unload_ware( $item['place_id'], false, $item['object_id'], $item['object_cnt'] );
      }

      return true;
    } else {
      return false;
    }
  }

  function load_full( $id, $is_fleet, $class = 0 ) {
    db_safe( $id );
    db_safe( $is_flet );
    db_safe( $class );

    if( $is_fleet ) {
      $test = db_fetch_row( "SELECT f.id, f.inwar, f.place_type, IF( f.place_type = 3, 0, f.place_type ) w_type, IF( f.place_type = 3, ob.planet_id, f.place_id ) place_id
                               FROM fleets f
                          LEFT JOIN orbits_buildings ob ON ob.id = f.place_id AND f.place_type = 3
                              WHERE f.id = $id" );
    } else {
      $test = db_fetch_row( "SELECT s.id, s.inwar, s.place_type, IF( s.place_type = 3, 0, s.place_type ) w_type, IF( s.place_type = 3, ob.planet_id, s.place_id ) place_id
                               FROM ships s
                          LEFT JOIN orbits_buildings ob ON ob.id = s.place_id AND s.place_type = 3
                              WHERE s.id = $id" );
    }

    load_all( $id, $is_fleet, $class );

    $cargo = get_cargo( $id, $is_fleet ? 0 : 1 );
    if( $cargo == 0 ) {
      return true;
    } else {
      return false;
    }
  }

  function is_def( $uid, $place_id, $place_type ) {
    db_safe( $uid );
    db_safe( $place_id );
    db_safe( $place_type );

    $aliance = db_fetch_val( "SELECT aliance FROM users WHERE id = $uid", 'aliance' );

    switch( $place_type ) {
      case 0:
        $defence = db_fetch_row( "SELECT IFNULL( d.status, 0 ) status, u.id user_id, u.login
                                    FROM defence d
                              INNER JOIN users u ON u.id = d.user_id
                              INNER JOIN orbits_buildings ob ON ob.object_id IN (3007, 3008, 3009) AND ob.planet_id = d.place_id
                               LEFT JOIN foe fe ON fe.user_id = d.user_id AND fe.foe_id = $uid
                               LEFT JOIN friend fr ON fr.user_id = d.user_id AND fr.friend_id = $uid
                                   WHERE d.place_id = $place_id AND d.place_type = 0 AND (
                                         ( d.status = 1 ) OR
                                         ( d.status = 2 AND fe.user_id is not null ) OR
                                         ( d.status = 3 AND fr.user_id is null ) OR
                                         ( d.status = 4 AND u.aliance != $aliance ) ) AND d.user_id != $uid" );
        break;

      case 1:
        $defence = db_fetch_row( "SELECT IFNULL( d.status, 0 ) status, u.id user_id, u.login
                                    FROM defence d
                              INNER JOIN users u ON u.id = d.user_id
                              INNER JOIN planets_buildings pb ON pb.object_id IN (27, 28, 29, 30, 31) AND pb.planet_id = d.place_id
                               LEFT JOIN foe fe ON fe.user_id = d.user_id AND fe.foe_id = $uid
                               LEFT JOIN friend fr ON fr.user_id = d.user_id AND fr.friend_id = $uid
                                   WHERE d.place_id = $place_id AND d.place_type = 1 AND (
                                         ( d.status = 1 ) OR
                                         ( d.status = 2 AND fe.user_id is not null ) OR
                                         ( d.status = 3 AND fr.user_id is null ) OR
                                         ( d.status = 4 AND u.aliance != $aliance ) ) AND d.user_id != $uid" );
        break;
    }

    $test_ships = db_fetch_row( "SELECT COUNT(*) id, GROUP_CONCAT( DISTINCT IF( st.corsar = 0, s.user_id, 'corsar' ) SEPARATOR ',' ) users
                                   FROM ships s
                             INNER JOIN users u ON u.id = s.user_id
                             INNER JOIN ship_types st ON st.object_id = s.object_id
                              LEFT JOIN foe fe ON fe.user_id = s.user_id AND fe.foe_id = $uid
                              LEFT JOIN friend fr ON fr.user_id = s.user_id AND fr.friend_id = $uid
                                  WHERE ( ( s.guard = 1 ) OR
                                          ( s.guard = 2 AND fe.user_id is not null ) OR
                                          ( s.guard = 3 AND fr.user_id is null ) OR
                                          ( s.guard = 4 AND u.aliance != $aliance )
                                        ) AND s.fleet_id IS null AND s.user_id != ".$uid." AND s.place_type = $place_type AND s.place_id = $place_id" );

    $test_fleets = db_fetch_row( "SELECT COUNT(*) id, GROUP_CONCAT( DISTINCT IF( ( SELECT MIN( st.corsar )
                                                   FROM ships s
                                             INNER JOIN ship_types st ON st.object_id = s.object_id
                                                  WHERE s.fleet_id = f.id ) = 0, f.user_id, 'corsar' ) SEPARATOR ',' ) users
                                    FROM fleets f
                              INNER JOIN users u ON u.id = f.user_id
                               LEFT JOIN foe fe ON fe.user_id = f.user_id AND fe.foe_id = $uid
                               LEFT JOIN friend fr ON fr.user_id = f.user_id AND fr.friend_id = $uid
                                   WHERE ( ( f.guard = 1 ) OR
                                           ( f.guard = 2 AND fe.user_id is not null ) OR
                                           ( f.guard = 3 AND fr.user_id is null ) OR
                                           ( f.guard = 4 AND u.aliance != $aliance )
                                          ) AND f.user_id != $uid AND f.place_type = $place_type AND f.place_id = $place_id" );

    if( $defence['status'] > 0 || $test_ships['id'] > 0 || $test_fleets['id'] > 0 ) {
      return true;
    } else {
      return false;
    }
  }

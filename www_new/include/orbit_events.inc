<?php

function orbit_event_all() {

  $microtime_start = microtime(true);

  do {
    $repeat = false;
    $events = db_fetch_array( "SELECT SQL_NO_CACHE id, event_type, user_id FROM orbit_events WHERE event_time <= NOW()" );
    foreach( $events as $item ) {

      if( microtime(true) - $microtime_start > 2 ) {
//        debug_it( 'Break in orbit events !' );
        return;
      }

      setChar( 'level', 1, $item['user_id'] );

      // 1-build, 2-mine, 3-dispence, 4-upgrade, 5-make
      switch( $item['event_type'] ) {
        case 1:
          orbit_build_event( $item['id'] );
          break;
        case 2:
          if( orbit_mine_event( $item['id'] ) ) {
            $repeat = true;
          }
          break;
        case 4:
          orbit_upgrade_event( $item['id'] );
          break;
        case 5:
          if( orbit_make_event( $item['id'] ) ) {
            $repeat = true;
          }
          break;
        case 8:
          if( orbit_sintez_event( $item['id'] ) ) {
            $repeat = true;
          }
          break;
      }
    }
  } while( $repeat );
}

function orbit_build_event( $event_id ) {
  $buildings = db_fetch_row( "SELECT oe.id, oe.x, oe.object_id, b.map_char, o.name, oe.event_time, oe.planet_id, oe.user_id, b.shield, b.atack, p.name pname, s.name sname
                                FROM orbit_events oe
                          INNER JOIN buildings b ON b.place_type = 0 AND b.id = oe.object_id
                          INNER JOIN objects o ON o.id = oe.object_id
                          INNER JOIN planets p ON p.id = oe.planet_id
                          INNER JOIN stars s ON s.id = p.star_id
                               WHERE oe.id = $event_id" );

  if( $buildings['user_id'] == null ) {
    return false;
  }

  db_query( "DELETE FROM orbit_events WHERE id={$buildings['id']}" );

  $planet_id = $buildings['planet_id'];

  $line = db_fetch_val( "SELECT lin FROM orbits_map WHERE id = $planet_id", 'lin' );

  if( $line{ $buildings['x'] } == 'B' ) {
    $line{ $buildings['x'] } = $buildings[ 'map_char' ];
    db_query( "INSERT INTO orbits_buildings (planet_id, object_id, x, shield)
                                     VALUES ($planet_id, {$buildings['object_id']}, {$buildings['x']}, {$buildings['shield']} )" );
  }
  send_msg( 1, $buildings['user_id'], t( "Строительство объекта '%s' на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $buildings['name'], $buildings['pname'], $buildings['sname'], $buildings['x'] ) ), 2, $buildings['event_time'] );
  db_query( "UPDATE orbits_map SET lin = '$line' WHERE id = $planet_id" );

  if( $buildings['atack'] > 0 ) {
    $def = db_fetch_val( "SELECT status FROM defence WHERE place_type = 0 AND place_id = $planet_id", 'status' );
    if( $def === null ) {

      $defender = true;
      $def_planet = db_fetch_row( "SELECT p.orbit_user, UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(p.orbit_time) orbit_time, u.login
                                     FROM planets p
                               INNER JOIN users u ON u.id = p.orbit_user
                                    WHERE p.id = ".$planet_id );

      if( $def_planet['orbit_user'] != '' && $def_planet['orbit_user'] != $buildings['user_id'] ) {
        if( $def_planet['orbit_time'] < 259200 ) {
          $defender = false;
        }
      }

      if( $defender ) {
        db_query( "INSERT INTO defence (   place_id, place_type, status,                 user_id )
                                VALUES ( $planet_id,          0,      1, {$buildings['user_id']} )" );
        send_msg( 1, $buildings['user_id'], t( "На орбите планеты %s в системе %s установлен приватный режим обороны.", array( $buildings['pname'], $buildings['sname'] ) ), 2, $buildings['event_time'] );
      }
    }
  }
}

function orbit_upgrade_event( $event_id ) {
  $buildings = db_fetch_row( "SELECT oe.id eid, pb.id bid, pb.level, o.name, oe.x, oe.event_time, oe.user_id, oe.object_id, oe.planet_id, b.shield, p.name pname, s.name sname
                                FROM orbit_events oe
                          INNER JOIN orbits_buildings pb ON pb.x = oe.x AND pb.planet_id = oe.planet_id AND pb.object_id = oe.object_id
                          INNER JOIN objects o ON o.id = oe.object_id
                          INNER JOIN buildings b ON b.id = oe.object_id
                          INNER JOIN planets p ON p.id = oe.planet_id
                          INNER JOIN stars s ON s.id = p.star_id
                               WHERE oe.id = $event_id" );

  if( $buildings['user_id'] == null ) {
    return false;
  }

  db_query( "DELETE FROM orbit_events WHERE id=$event_id" );

  if( $buildings['object_id'] == 3002 ) {
    switch( $buildings['level'] ) {
      case 4:
        $planet_id = $buildings['planet_id'];

        $build_map = array_map( 'trim', explode( "\n", trim( db_fetch_val( "SELECT fnd FROM planets_maps WHERE id = $planet_id", 'fnd' ) ) ) );
        for( $i=0; $i < count( $build_map ); $i++ ) {
          for( $t=0; $t < strlen( trim( $build_map[ $i ] ) ); $t++ ) {
            if( $build_map[ $i ]{ $t } == '0' ) {
              $build_map[ $i ]{ $t } = '1';
            }
          }
        }
        db_query( "UPDATE planets_maps SET fnd = '".join( "\n", $build_map )."' WHERE id = $planet_id" );
        send_msg( 1, $buildings['user_id'], t( "Усовершенствование объекта '%s' на орбите %s в системе %s в точке стояния %d завершено успешно. Уровень развития 5, вся поверхность планеты исследованна до среднего слоя.", array( $buildings['name'], $buildings['pname'], $buildings['sname'], $buildings['x'] ) ), 2, $buildings['event_time'] );
        
        break;
      case 9:
        $planet_id = $buildings['planet_id'];
        $build_map = array_map( 'trim', explode( "\n", trim( db_fetch_val( "SELECT fnd FROM planets_maps WHERE id = $planet_id", 'fnd' ) ) ) );
        for( $i=0; $i < count( $build_map ); $i++ ) {
          for( $t=0; $t < strlen( trim( $build_map[ $i ] ) ); $t++ ) {
            if( $build_map[ $i ]{ $t } == '1' ) {
              $build_map[ $i ]{ $t } = '2';
            }
          }
        }
        db_query( "UPDATE planets_maps SET fnd = '".join( "\n", $build_map )."' WHERE id = $planet_id" );
        send_msg( 1, $buildings['user_id'], t( "Усовершенствование объекта '%s' на орбите %s в системе %s в точке стояния %d завершено успешно. Уровень развития 10, вся поверхность планеты исследованна до глубинного слоя.", array( $buildings['name'], $buildings['pname'], $buildings['sname'], $buildings['x'] ) ), 2, $buildings['event_time'] );

        break;
      default:
        break;
    }
  }

  if( $buildings['level'] < 10 ) {
    send_msg( 1, $buildings['user_id'], t( "Усовершенствование объекта '%s' на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $buildings['name'], $buildings['pname'], $buildings['sname'], $buildings['x'] ) ), 2, $buildings['event_time'] );

    db_query( "UPDATE orbits_buildings SET level = {$buildings['level']} + 1, shield = ( {$buildings['level']} + 1 ) * {$buildings['shield']} WHERE id={$buildings['bid']}" );
  }
}

function orbit_make_event( $event_id ) {
  $make = db_fetch_row( "SELECT oe.id, om.object_id, o.name, oe.x, oe.event_time,
                                oe.planet_id, om.cycle, o.class, oe.user_id, oe.timer, ob.id build_id, p.name pname, s.name sname
                           FROM orbit_events oe
                     INNER JOIN orbits_make om ON om.event_id = oe.id
                     INNER JOIN objects o ON om.object_id = o.id
                     INNER JOIN planets p ON p.id = oe.planet_id
                     INNER JOIN stars s ON s.id = p.star_id
                     INNER JOIN orbits_buildings ob ON ob.x = oe.x AND ob.planet_id = oe.planet_id AND ob.object_id = oe.object_id 
                          WHERE oe.id = $event_id" );

  if( $make['user_id'] == null ) {
    return false;
  }

  $planet_id = $make['planet_id'];

  add_warehouse_item( 0, $planet_id, $make['object_id'], 1 );

  if( $make['cycle'] < 0 ) {
    $rob = db_fetch_row( "SELECT id, usedtime FROM robots WHERE build_type = 0 AND build_id = ".$make['build_id'] );
    if( $rob['usedtime'] > $make['timer'] ) {
      $items = db_fetch_array( "SELECT o.id, os.res_cnt, w.object_cnt
                                  FROM objects_sub os
                             LEFT JOIN objects o ON o.id = os.res_id
                             LEFT JOIN warehouse w ON w.object_id = o.id AND w.place_id = $planet_id AND w.place_type = 0
                                 WHERE os.object_id = {$make['object_id']} AND o.class IN ( 1, 2, 9 )" );

      $can_build = ( get_energy( $planet_id, 0 ) >= 0 );
      foreach( $items as $item ) {
        if( $item['res_cnt'] > $item['object_cnt'] ) {
          $can_build = false;
        }
      }
      if( $can_build ) {
  
        foreach( $items as $item ) {
          sub_warehouse_item( 0, $planet_id, $item['id'], $item['res_cnt'] );
        }

        db_query( "UPDATE robots SET usedtime = ".($rob['usedtime'] - $make['timer'])." WHERE id = ".$rob['id'] );
        db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
      } else {
        send_msg( 1, $make['user_id'], "Недостаточно ресурсов для изготовления объекта '{$make['name']}' на орбитальном сборочном цехе на орбите {$make['pname']} в системе {$make['sname']} в точке стояния {$make['x']} цикл прерван.", 3, $make['event_time'] );

        db_query( "UPDATE robots SET status = 0 WHERE id = ".$rob['id'] );
        db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
        db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      }
    } else {
      send_msg( 1, $make['user_id'], t( "Изготовление объекта '%s' в орбитальном сборочном цехе на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

      db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      db_query( "DELETE FROM robots WHERE id={$rob['id']}" );

      send_msg( 1, $make['user_id'], t( "В орбитальном сборочном цехе на орбите %s в системе %s в точке стояния %d закончился ресурс робота.", array( $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );
    }
  } else {
    if( $make['cycle'] > 1 ) {
  
      $items = db_fetch_array( "SELECT o.id, os.res_cnt, w.object_cnt
                                  FROM objects_sub os
                             LEFT JOIN objects o ON o.id = os.res_id
                             LEFT JOIN warehouse w ON w.object_id = o.id AND w.place_id = $planet_id AND w.place_type = 0
                                 WHERE os.object_id = {$make['object_id']} AND o.class IN ( 1, 2, 9 )" );
      $can_build = ( get_energy( $planet_id, 0 ) >= 0 );
      foreach( $items as $item ) {
        if( $item['res_cnt'] > $item['object_cnt'] ) {
          $can_build = false;
        }
      }
  
      if( $can_build ) {
  
        foreach( $items as $item ) {
          sub_warehouse_item( 0, $planet_id, $item['id'], $item['res_cnt'] );
        }
      
        db_query( "UPDATE orbits_make SET cycle = ".($make['cycle'] - 1)." WHERE event_id = $event_id" );
        db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
      } else {
        send_msg( 1, $make['user_id'], t( "Недостаточно ресурсов для изготовления объекта '%s' на орбитальном сборочном цехе на орбите %s в системе %s в точке стояния %d цикл прерван.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

        db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
        db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      }
    } else {
      send_msg( 1, $make['user_id'], t( "Изготовление объекта '%s' в орбитальном сборочном цехе на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

      db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
    }
  }
}

function orbit_mine_event( $event_id ) {
  $repeat = false;
  $mines = db_fetch_row( "SELECT oe.id, om.res_id, om.res_cnt, om.cycle, oe.object_id, o.name, oe.x, oe.event_time,
                                 oe.planet_id, oe.user_id, oe.timer, ob.id build_id, p.name pname, s.name sname
                            FROM orbit_events oe
                      INNER JOIN orbits_mines om ON om.event_id = oe.id
                      INNER JOIN objects o ON o.id = om.res_id
                      INNER JOIN orbits_buildings ob ON ob.x = oe.x AND ob.planet_id = oe.planet_id AND ob.object_id = oe.object_id
                      INNER JOIN planets p ON p.id = oe.planet_id
                      INNER JOIN stars s ON s.id = p.star_id
                           WHERE oe.id = $event_id" );

  if( $mines['user_id'] == null ) {
    return false;
  }

  $planet_id = $mines[ 'planet_id' ];
  $free_place = get_warehouse( $planet_id, 0 );

  if( $free_place > 0 ) {
    add_warehouse_item( 0, $planet_id, $mines['res_id'], $mines['res_cnt'] );
  }
  if( $mines['cycle'] < 0 ) {
    $rob = db_fetch_row( "SELECT id, usedtime FROM robots WHERE build_type = 0 AND build_id = ".$mines['build_id'] );
    if( $rob['usedtime'] > $mines['timer'] ) {
      db_query( "UPDATE robots SET usedtime = ".($rob['usedtime'] - $mines['timer'])." WHERE id = ".$rob['id'] );
      db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
      $repeat = true;
    } else {
      db_query( "DELETE FROM orbits_mines WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      db_query( "DELETE FROM robots WHERE id={$rob['id']}" );

      send_msg( 1, $mines['user_id'], t( "На объекте на орбите %s в системе %s в точке стояния %d, закончился ресурс робота.", array( $mines['pname'], $mines['sname'], $mines['x'] ) ), 3, $mines['event_time'] );
    }
  } else {
    if( $mines['cycle'] > 1 ) {
      db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = ".$mines['id'] );
      db_query( "UPDATE orbits_mines SET cycle = ".( $mines['cycle'] - 1 )." WHERE event_id = ".$mines['id'] );
      $repeat = true;
    } else {
      send_msg( 1, $mines['user_id'], t( "Циклы добычи материала '%s' на объекте на орбите %s в системе %s в точке стояния %d, завершены успешно.", array( $mines['name'], $mines['pname'], $mines['sname'], $mines['x'] ) ), 3, $mines['event_time'] );
  
      db_query( "DELETE FROM orbits_mines WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
    }
  }

  return $repeat;
}

function orbit_sintez_event( $event_id ) {
  $repeat = false;
  $make = db_fetch_row( "SELECT oe.id, om.object_id, o.name, oe.x, oe.event_time, s.object_cnt,
                                oe.planet_id, om.cycle, o.class, oe.user_id, oe.timer, ob.id build_id, p.name pname, st.name sname
                           FROM orbit_events oe
                     INNER JOIN orbits_make om ON om.event_id = oe.id
                     INNER JOIN objects o ON om.object_id = o.id
                     INNER JOIN sintez s ON s.object_id = o.id
                     INNER JOIN planets p ON p.id = oe.planet_id
                     INNER JOIN stars st ON st.id = p.star_id
                     INNER JOIN orbits_buildings ob ON ob.x = oe.x AND ob.planet_id = oe.planet_id AND ob.object_id = oe.object_id 
                          WHERE oe.id = $event_id" );

  if( $make['user_id'] == null ) {
    return false;
  }

  $planet_id = $make['planet_id'];

  $sintez_cnt = $make['object_cnt'] + ( $make['object_cnt'] / 25 * get_book_level( 32, $make['user_id'] ) ) + ( $make['object_cnt'] / 50 * get_book_level( 40, $make['user_id'] ) );

  add_warehouse_item( 0, $planet_id, $make['object_id'], $sintez_cnt );

  if( $make['cycle'] < 0 ) {
    $rob = db_fetch_row( "SELECT id, usedtime FROM robots WHERE build_type = 0 AND build_id = ".$make['build_id'] );

    if( $rob['usedtime'] > $make['timer'] ) {
      $items = db_fetch_row( "SELECT w.object_id, IFNULL( w.object_cnt, 0 ) object_cnt
                                FROM sintez s
                          INNER JOIN warehouse w ON w.place_id = $planet_id AND w.place_type = 0 AND s.res_id = w.object_id
                               WHERE s.object_id = ".$make['object_id'] );

      $can_build = ( get_energy( $planet_id, 0 ) >= 0 && $items['object_cnt'] >= 1000);

      if( $can_build ) {
        sub_warehouse_item( 0, $planet_id, $items['object_id'], 1000 );
        db_query( "UPDATE robots SET usedtime = ".($rob['usedtime'] - $make['timer'])." WHERE id = ".$rob['id'] );
        db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
        $repeat = true;
      } else {
        send_msg( 1, $make['user_id'], t( "Недостаточно ресурсов для синтеза '%s' на термоядерном преобразователе на орбите %s в системе %s в точке стояния %d цикл прерван.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

        db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
        db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
        db_query( "UPDATE robots SET status = 0 WHERE id = ".$rob['id'] );
      }
    } else {
      send_msg( 1, $make['user_id'], t( "Синтезирование '%s' на термоядерном преобразователе на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

      db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      db_query( "DELETE FROM robots WHERE id={$rob['id']}" );

      send_msg( 1, $make['user_id'], t( "На термоядерном преобразователе на орбите %s в системе %s в точке стояния %s закончился ресурс робота.", array( $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );
    }
  } else {
    if( $make['cycle'] > 1 ) {
      $items = db_fetch_row( "SELECT w.object_id, IFNULL( w.object_cnt, 0 ) object_cnt
                                FROM sintez s
                          INNER JOIN warehouse w ON w.place_id = $planet_id AND w.place_type = 0 AND s.res_id = w.object_id
                               WHERE s.object_id = ".$make['object_id'] );

      $can_build = ( get_energy( $planet_id, 0 ) >= 0 && $items['object_cnt'] >= 1000);
  
      if( $can_build ) {
        sub_warehouse_item( 0, $planet_id, $items['object_id'], 1000 );
        db_query( "UPDATE orbits_make SET cycle = ".($make['cycle'] - 1)." WHERE event_id = $event_id" );
        db_query( "UPDATE orbit_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
        $repeat = true;
    } else {
        send_msg( 1, $make['user_id'], t( "Недостаточно ресурсов для синтеза '%s' на термоядерном преобразователе на орбите %s в системе %s в точке стояния %d цикл прерван.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

        db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
        db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
      }
    } else {
      send_msg( 1, $make['user_id'], t( "Синтезирование '%s' на термоядерном преобразователе на орбите %s в системе %s в точке стояния %d завершено успешно.", array( $make['name'], $make['pname'], $make['sname'], $make['x'] ) ), 3, $make['event_time'] );

      db_query( "DELETE FROM orbits_make WHERE event_id=$event_id" );
      db_query( "DELETE FROM orbit_events WHERE id=$event_id" );
    }
  }
  return $repeat;
}

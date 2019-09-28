<?php

function space_event_all() {

  $microtime_start = microtime(true);

  do {
    $repeat = false;
    $events = db_fetch_array( "SELECT SQL_NO_CACHE id, event_type, user_id FROM space_events WHERE event_time <= NOW() ORDER BY event_time" );
    foreach( $events as $item ) {

      if( microtime(true) - $microtime_start > 5 ) {
//        debug_it( 'Break in space events !' );
        return;
      }

      db_start();
      setChar( 'level', 1, $item['user_id'] );

      // 0-land, 1-flyout
      switch( $item['event_type'] ) {
        case 0:
        case 100:
          space_land( $item['id'] );
          break;
        case 1:
        case 101:
          space_flyout( $item['id'] );
          break;
        case 2:
        case 102:
          space_point( $item['id'] );
          break;
        case 3:
        case 103:
          space_planet( $item['id'] );
          break;
        case 4:
        case 104:
        case 10:
        case 110:
          space_star( $item['id'] );
          break;
        case 5:
        case 105:
        case 11:
        case 111:
          space_move( $item['id'] );
          break;
        case 6:
          space_spy( $item['id'] );
          break;
        case 7:
          space_gate( $item['id'] );
          break;
        case 8:
          space_sabotage( $item['id'] );
          break;
        case 9:
        case 109:
          space_harvest( $item['id'] );
          break;
      }

      db_end();
    }
  } while( $repeat );
}

function space_land( $event_id ) {
  $result = db_fetch_row( "SELECT se.ship_id, se.event_type, se.user_id, s.object_id
                             FROM space_events se
                        LEFT JOIN ships s ON s.id = se.ship_id AND se.event_type < 100
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  if( $result['event_type'] >= 100 ) {
    db_query( "UPDATE fleets SET place_type = 1 WHERE id = ".$result['ship_id'] );
    db_query( "UPDATE ships SET place_type = 1 WHERE fleet_id = ".$result['ship_id'] );

    enter_place( $result['ship_id'], true );
  } else {
    db_query( "UPDATE ships SET place_type = 1 WHERE id = ".$result['ship_id'] );

    if( $result['object_id'] != 9310 && $result['object_id'] != 9355 ) {
      enter_place( $result['ship_id'], false );
    }
  }
}

function space_flyout( $event_id ) {
  $result = db_fetch_row( "SELECT se.ship_id, se.event_type, se.user_id, s.object_id
                             FROM space_events se
                        LEFT JOIN ships s ON s.id = se.ship_id AND se.event_type < 100
                            WHERE se.id = $event_id" );
  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  if( $result['event_type'] >= 100 ) {
    db_query( "UPDATE fleets SET place_type = 0 WHERE id = ".$result['ship_id'] );
    db_query( "UPDATE ships SET place_type = 0 WHERE fleet_id = ".$result['ship_id'] );

    enter_place( $result['ship_id'], true );
  } else {
    db_query( "UPDATE ships SET place_type = 0 WHERE id = ".$result['ship_id'] );

    if( $result['object_id'] != 9310 && $result['object_id'] != 9355 ) {
      enter_place( $result['ship_id'], false );
    }
  }

  levelUp( 30, $result['user_id'] );
}

function space_planet( $event_id ) {
  $result = db_fetch_row( "SELECT p.name pname, p.star_id star_id, se.user_id, u.aliance, se.ship_id, se.event_type, se.arg2, se.event_time, s.object_id,
                                  d.status, d.user_id def_user_id, du.aliance def_aliance, fe.user_id foe, fr.user_id friend
                             FROM space_events se
                       INNER JOIN users u ON u.id = se.user_id
                       INNER JOIN planets p ON p.id = se.arg2
                        LEFT JOIN ships s ON s.id = se.ship_id AND se.event_type < 100
                        LEFT JOIN defence d ON d.place_id = p.id AND d.place_type = 0
                        LEFT JOIN users du ON du.id = d.user_id
                        LEFT JOIN foe fe ON fe.user_id = d.user_id AND fe.foe_id = se.user_id
                        LEFT JOIN friend fr ON fr.user_id = d.user_id AND fr.friend_id = se.user_id
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  user_report( $result['star_id'], $result['user_id'], 1, t( "Астрономы зафиксировали подлет неизвестного объекта к планете %s предположительно этот космический корабль вышел на устойчивую орбиту вокруг планеты.", array( $result['pname'] ) ) );

  if( $result['event_type'] >= 100 ) {
    $names = db_fetch_row( "SELECT f.name FROM fleets f WHERE f.id = ".$result['ship_id'] );
    $corsar = db_fetch_val( "SELECT MIN( st.corsar ) corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.fleet_id = ".$result['ship_id'], 'corsar' );
    send_msg( 1, $result['user_id'], t( "Перелет флота '%s' к планете %s завершен успешно.", array( $names['name'], $result['pname'] ) ), 5, $result['event_time'] );

    db_query( "UPDATE fleets SET place_type = 0, place_id = ".$result['arg2']." WHERE id = ".$result['ship_id'] );
    db_query( "UPDATE ships SET place_type = 0, place_id = ".$result['arg2']." WHERE fleet_id = ".$result['ship_id'] );
  } else {
    $names = db_fetch_row( "SELECT s.name FROM ships s WHERE s.id = ".$result['ship_id'] );
    $corsar = db_fetch_val( "SELECT st.corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = ".$result['ship_id'], 'corsar' );

    send_msg( 1, $result['user_id'], t( "Перелет корабля '%s' к планете %s завершен успешно.", array( $names['name'], $result['pname'] ) ), 5, $result['event_time'] );

    db_query( "UPDATE ships SET place_type = 0, place_id = ".$result['arg2']." WHERE id = ".$result['ship_id'] );
  }

  if( $corsar == '' ) {
    $corsar = '0';
  }

  if( $result['object_id'] != 9355 && $result['object_id'] != 9310 && $result['def_user_id'] != $result['user_id'] && 
      ( ( $result['status'] == 1 ) ||
        ( $corsar == 1 && $result['status'] > 1 ) || 
        ( $result['status'] == 2 && $result['foe'] != null ) ||
        ( $result['status'] == 3 && $result['friend'] == null ) ||
        ( $result['status'] == 4 && $result['aliance'] != $result['def_aliance'] ) ) ) {
    if( $result['event_type'] >= 100 ) {
      if( $result['status'] == 4 ) {
        StartWar( 1, $result['ship_id'], 3, $result['arg2'], $result['event_time'], 8 );
      } else {
        StartWar( 1, $result['ship_id'], 3, $result['arg2'], $result['event_time'], 1 );
      }
    } else {
      if( $result['status'] == 4 ) {
        StartWar( 0, $result['ship_id'], 3, $result['arg2'], $result['event_time'], 8 );
      } else {
        StartWar( 0, $result['ship_id'], 3, $result['arg2'], $result['event_time'], 1 );
      }
    }
  }

  if( $result['object_id'] != 9310 && $result['object_id'] != 9355 ) {
    $test_ships = db_fetch_array( "SELECT s.id, s.guard
                                     FROM ships s
                               INNER JOIN users u ON u.id = s.user_id
                                LEFT JOIN foe fe ON fe.user_id = s.user_id AND fe.foe_id = {$result['user_id']}
                                LEFT JOIN friend fr ON fr.user_id = s.user_id AND fr.friend_id = {$result['user_id']}
                                    WHERE ( ( s.guard = 1 ) OR
                                            ( $corsar = 1 AND s.guard > 1 ) OR
                                            ( s.guard = 2 AND fe.user_id is not null ) OR
                                            ( s.guard = 3 AND fr.user_id is null ) OR
                                            ( s.guard = 4 AND u.aliance != {$result['aliance']} )
                                          ) AND s.fleet_id IS null AND s.user_id != {$result['user_id']} AND s.place_type = 0 AND s.place_id = ".$result['arg2'] );
    foreach( $test_ships as $ship ) {
      if( $result['event_type'] >= 100 ) {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }
      } else {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    }
  
    $test_fleets = db_fetch_array( "SELECT f.id, f.guard
                                      FROM fleets f
                                INNER JOIN users u ON u.id = f.user_id
                                 LEFT JOIN foe fe ON fe.user_id = f.user_id AND fe.foe_id = {$result['user_id']}
                                 LEFT JOIN friend fr ON fr.user_id = f.user_id AND fr.friend_id = {$result['user_id']}
                                     WHERE ( ( f.guard = 1 ) OR
                                             ( $corsar = 1 AND f.guard > 1 ) OR
                                             ( f.guard = 2 AND fe.user_id is not null ) OR
                                             ( f.guard = 3 AND fr.user_id is null ) OR
                                             ( f.guard = 4 AND u.aliance != {$result['aliance']} )
                                           ) AND f.user_id != {$result['user_id']} AND f.place_type = 0 AND f.place_id = ".$result['arg2'] );
    foreach( $test_fleets as $fleet ) {
      if( $result['event_type'] >= 100 ) {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }
      } else {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    }
  }
}

function space_point( $event_id ) {
  $result = db_fetch_row( "SELECT se.user_id, se.event_time, se.ship_id, se.event_type, se.arg1, se.arg2, u.aliance
                             FROM space_events se
                       INNER JOIN users u ON u.id = se.user_id
                            WHERE se.id = $event_id" );

  if( $result['event_type'] >= 100 ) {
    $place = db_fetch_row( "SELECT f.place_id FROM fleets f WHERE f.id = ".$result['ship_id'] );
    $corsar = db_fetch_val( "SELECT MIN( st.corsar ) corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.fleet_id = ".$result['ship_id'], 'corsar' );
  } else {
    $place = db_fetch_row( "SELECT s.place_id FROM ships s WHERE s.id = ".$result['ship_id'] );
    $corsar = db_fetch_val( "SELECT st.corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = ".$result['ship_id'], 'corsar' );
  }

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] || !$place['place_id'] ) {
    return;
  }

  user_report( $place['place_id'], $result['user_id'], 1, t( "Астрономы зафиксировали объект в вашей системе в точке %d:%d предположительно это космический корабль.", array( $result['arg1'], $result['arg2'] ) ) );

  if( $corsar == '' ) {
    $corsar = '0';
  }

  $s_guard = db_fetch_array( "SELECT s.id, s.guard
                                FROM ships s
                          INNER JOIN users u ON u.id = s.user_id
                           LEFT JOIN foe fe ON fe.user_id = s.user_id AND fe.foe_id = {$result['user_id']}
                           LEFT JOIN friend fr ON fr.user_id = s.user_id AND fr.friend_id = {$result['user_id']}
                               WHERE s.arg1={$result['arg1']} AND s.arg2={$result['arg2']} AND
                                     s.fleet_id is null AND (
                                       ( s.guard = 1 ) OR
                                       ( $corsar = 1 AND s.guard > 1 ) OR
                                       ( s.guard = 2 AND fe.user_id is not null ) OR
                                       ( s.guard = 3 AND fr.user_id is null ) OR
                                       ( s.guard = 4 AND u.aliance != {$result['aliance']} )
                                     ) AND s.place_type = 7 AND s.user_id != {$result['user_id']} AND s.place_id = ".$place['place_id'] );

  $f_guard = db_fetch_array( "SELECT f.id, f.guard
                                FROM fleets f
                          INNER JOIN users u ON u.id = f.user_id
                           LEFT JOIN foe fe ON fe.user_id = f.user_id AND fe.foe_id = {$result['user_id']}
                           LEFT JOIN friend fr ON fr.user_id = f.user_id AND fr.friend_id = {$result['user_id']}
                               WHERE f.arg1={$result['arg1']} AND f.arg2={$result['arg2']} AND (
                                       ( f.guard = 1 ) OR
                                       ( $corsar = 1 AND f.guard > 1 ) OR
                                       ( f.guard = 2 AND fe.user_id is not null ) OR
                                       ( f.guard = 3 AND fr.user_id is null ) OR
                                       ( f.guard = 4 AND u.aliance != {$result['aliance']} )
                                     ) AND f.place_type = 7 AND f.user_id != {$result['user_id']} AND f.place_id = ".$place['place_id'] );

  if( $result['event_type'] >= 100 ) {
    db_query( "UPDATE fleets SET place_type = 7, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE id = ".$result['ship_id'] );
    db_query( "UPDATE ships SET place_type = 7, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE fleet_id = ".$result['ship_id'] );

    $names = db_fetch_row( "SELECT f.name FROM fleets f WHERE f.id = ".$result['ship_id'] );
    if( count( $s_guard ) > 0 || count( $f_guard ) > 0 ) {
      send_msg( 1, $result['user_id'], t( "Флот '%s' атаковали в точке %d:%d.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 5, $result['event_time'] );

      levelUp( 26, $result['user_id'] );

      foreach( $s_guard as $ship ) {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }

      }

      foreach( $f_guard as $fleet ) {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    } else {
      send_msg( 1, $result['user_id'], t( "Перелет флота '%s' к точке %d:%d завершен успешно.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 5, $result['event_time'] );
    }
  } else {
    db_query( "UPDATE ships SET place_type = 7, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE id = ".$result['ship_id'] );

    $names = db_fetch_row( "SELECT s.name FROM ships s WHERE s.id = ".$result['ship_id'] );
    if( count( $s_guard ) > 0 || count( $f_guard ) > 0 ) {
      send_msg( 1, $result['user_id'], t( "Корабль '%s' атаковали в точке %d:%d.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 5, $result['event_time'] );
      levelUp( 26, $result['user_id'] );

      foreach( $s_guard as $ship ) {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }
      foreach( $f_guard as $fleet ) {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    } else {
      send_msg( 1, $result['user_id'], t( "Перелет корабля '%s' к точке %d:%d завершен успешно.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 5, $result['event_time'] );
    }
  }
}

function space_star( $event_id ) {
  $result = db_fetch_row( "SELECT se.id, s.name sname, se.user_id, se.event_time, se.ship_id, se.event_type, se.arg2, s.type, u.aliance
                             FROM space_events se
                       INNER JOIN stars s ON s.id = se.arg2
                       INNER JOIN users u ON u.id = se.user_id
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  if( $result['id'] == $event_id ) {
    user_report( $result['arg2'], $result['user_id'], 5, t( "Астрономы наблюдали странное явление в системе %s, внешне вспышка напоминала гиперпространственный переход, возможно корабль вышел из гиперпространства в этой системе.", array( $result['sname'] ) ) );

    if( $result['event_type'] >= 100 ) {
      $corsar = db_fetch_val( "SELECT MIN( st.corsar ) corsar
                                 FROM ships s
                           INNER JOIN ship_types st ON st.object_id = s.object_id
                                WHERE s.fleet_id = ".$result['ship_id'], 'corsar' );
    } else {
      $corsar = db_fetch_val( "SELECT st.corsar
                                 FROM ships s
                           INNER JOIN ship_types st ON st.object_id = s.object_id
                                WHERE s.id = ".$result['ship_id'], 'corsar' );
    }

    if( $result['type'] == 4 ) {
      $new_star = db_fetch_row( "SELECT s.id, s.name sname
                                   FROM stars s
                                  WHERE s.type !=4
                               ORDER BY rand()
                                  LIMIT 0, 1" );
  
      $result['sname'] = $new_star['sname'];
      $result['arg2'] = $new_star['id'];
    }

    do {
      $gx = mt_rand( 10, 670 );
      $gy = mt_rand( 10, 430 );
  
      $xdiff = 340 - $gx;
      $ydiff = 220 - $gy;
      $len = round( sqrt( $xdiff * $xdiff + $ydiff * $ydiff ) );
    } while ( $len < 25 );

    $ta = mt_rand( 1, 50 );
    if( $ta == 1 ) {
      $trit = db_fetch_row( "SELECT id, arg1, arg2, fleet_id FROM ships WHERE user_id = 3 AND place_type = 7 AND place_id = ".$result['arg2']." LIMIT 0,1" );
    }

    $inter = db_fetch_row( "SELECT s.id, s.user_id, s.arg1, s.arg2, s.interupt
                              FROM ships s
                        INNER JOIN users u ON u.id = s.user_id
                         LEFT JOIN foe fe ON fe.user_id = s.user_id AND fe.foe_id = {$result['user_id']}
                         LEFT JOIN friend fr ON fr.user_id = s.user_id AND fr.friend_id = {$result['user_id']}
                             WHERE ( ( s.interupt = 2 ) OR
                                     ( s.interupt = 3 AND fe.user_id is not null ) OR
                                     ( s.interupt = 4 AND fr.user_id is not null ) OR
                                     ( s.interupt = 4 AND s.user_id = {$result['user_id']} ) OR
                                     ( s.interupt = 5 AND fe.user_id is null ) OR
                                     ( s.interupt = 6 AND fr.user_id is null ) OR
                                     ( s.interupt = 7 AND u.aliance = {$result['aliance']} ) OR
                                     ( s.interupt = 8 AND u.aliance != {$result['aliance']} )
                                   ) AND s.place_type = 7 AND s.place_id = ".$result['arg2']." ORDER BY rand() LIMIT 0,1" );

    if( $result['event_type'] >= 100 ) {
      $names = db_fetch_row( "SELECT f.name, u.login FROM fleets f INNER JOIN users u ON u.id = f.user_id WHERE f.id = ".$result['ship_id'] );

      if( $ta == 1 && isset( $trit['id'] ) ) {
        send_msg( 1, $result['user_id'], t( "На флот '%s' во время перелета к звезде %s напали!", array( $names['name'], $result['sname'] ) ), 5, $result['event_time'] );

        db_query( "UPDATE fleets SET place_type = 7, place_id = ".$result['arg2'].", arg1 = ".$trit['arg1'].", arg2 = ".$trit['arg2']." WHERE id = ".$result['ship_id'] );
        db_query( "UPDATE ships SET place_type = 7, place_id = ".$result['arg2'].", arg1 = ".$trit['arg1'].", arg2 = ".$trit['arg2']." WHERE fleet_id = ".$result['ship_id'] );

        if( $trit['fleet_id'] ) {
          StartWar( 1, $trit['fleet_id'], 1, $result['ship_id'], $result['event_time'] );      
        } else {
          StartWar( 0, $trit['id'], 1, $result['ship_id'], $result['event_time'] );      
        }
      } elseif( isset( $inter['id'] ) ) {
        send_msg( 1, $result['user_id'], t( "Ваш флот '%s' во время перелета к звезде %s перехвачен!", array( $names['name'], $result['sname'] ) ), 5, $result['event_time'] );

        if( $corsar ) {
          if( $inter['interupt'] == 7 || $inter['interupt'] == 8 ) {
            send_msg( 8, $inter['user_id'], t( "Гиперперехватчик перехватил флот '%s' (Corsar) во время перелета к звезде %s", array( $names['name'], $result['sname'] ) ), 5, $result['event_time'] );
          } else {
            send_msg( 1, $inter['user_id'], t( "Гиперперехватчик перехватил флот '%s' (Corsar) во время перелета к звезде %s", array( $names['name'], $result['sname'] ) ), 5, $result['event_time'] );
          }
        } else {
          if( $inter['interupt'] == 7 || $inter['interupt'] == 8 ) {
            send_msg( 8, $inter['user_id'], t( "Гиперперехватчик перехватил флот '%s' (%s) во время перелета к звезде %s", array( $names['name'], $names['login'], $result['sname'] ) ), 5, $result['event_time'] );
          } else {
            send_msg( 1, $inter['user_id'], t( "Гиперперехватчик перехватил флот '%s' (%s) во время перелета к звезде %s", array( $names['name'], $names['login'], $result['sname'] ) ), 5, $result['event_time'] );
          }
        }

        db_query( "UPDATE fleets SET place_type = 5, place_id = ".$result['arg2'].", arg1 = ".$inter['arg1'].", arg2 = ".$inter['arg2']." WHERE id = ".$result['ship_id'] );      db_query( "UPDATE ships SET place_type = 7, place_id = ".$result['arg2'].", arg1 = ".$inter['arg1'].", arg2 = ".$inter['arg2']." WHERE fleet_id = ".$result['ship_id'] );

        db_query( "INSERT INTO space_events ( event_type,              ship_id,                event_time, timer,              user_id,             arg1,             arg2 )
                                     VALUES (        102, {$result['ship_id']}, '{$result['event_time']}',     0, {$result['user_id']}, {$inter['arg1']}, {$inter['arg2']} )" );

      } else {
        send_msg( 1, $result['user_id'], t( "Перелет флота '%s' к звезде %s завершен успешно.", array( $names['name'], $result['sname'] ) ), 6, $result['event_time'] );

        db_query( "UPDATE fleets SET place_type = 7, place_id = ".$result['arg2'].", arg1 = $gx, arg2 = $gy WHERE id = ".$result['ship_id'] );
        db_query( "UPDATE ships SET place_type = 7, place_id = ".$result['arg2'].", arg1 = $gx, arg2 = $gy WHERE fleet_id = ".$result['ship_id'] );
      }
    } else {
      $names = db_fetch_row( "SELECT s.name, s.object_id, u.login FROM ships s INNER JOIN users u ON u.id = s.user_id WHERE s.id = ".$result['ship_id'] );

      if( $names['object_id'] != 9310 && $names['object_id'] != 9355 && $ta == 1 && isset( $trit['id'] ) ) {
        send_msg( 1, $result['user_id'], t( "На корабль '%s' во время перелета к звезде %s напали!", array( $names['name'], $result['sname'] ) ), 6, $result['event_time'] );

        db_query( "UPDATE ships SET place_type = 7, place_id = ".$result['arg2'].", arg1 = ".$trit['arg1'].", arg2 = ".$trit['arg2']." WHERE id = ".$result['ship_id'] );

        if( $trit['fleet_id'] ) {
          StartWar( 1, $trit['fleet_id'], 0, $result['ship_id'], $result['event_time'] );      
        } else {
          StartWar( 0, $trit['id'], 0, $result['ship_id'], $result['event_time'] );      
        }
      } elseif( $names['object_id'] != 9310 && $names['object_id'] != 9355 && isset( $inter['id'] ) ) {
        send_msg( 1, $result['user_id'], t( "Ваш корабль '%s' во время перелета к звезде %s перехвачен!", array( $names['name'], $result['sname'] ) ), 6, $result['event_time'] );

        if( $corsar ) {
          send_msg( 1, $inter['user_id'], t( "Гиперперехватчик перехватил корабль '%s' (%s) во время перелета к звезде %s", array( $names['name'], t( 'Corsar' ), $result['sname'] ) ), 5, $result['event_time'] );
        } else {
          send_msg( 1, $inter['user_id'], t( "Гиперперехватчик перехватил корабль '%s' (%s) во время перелета к звезде %s", array( $names['name'], $names['login'], $result['sname'] ) ), 5, $result['event_time'] );
        }

        db_query( "UPDATE ships SET place_type = 5, place_id = ".$result['arg2'].", arg1 = ".$inter['arg1'].", arg2 = ".$inter['arg2']." WHERE id = ".$result['ship_id'] );

        db_query( "INSERT INTO space_events ( event_type,              ship_id,                event_time, timer,              user_id,             arg1,             arg2 )
                                     VALUES (          2, {$result['ship_id']}, '{$result['event_time']}',     0, {$result['user_id']}, {$inter['arg1']}, {$inter['arg2']} )" );

      } else {
        send_msg( 1, $result['user_id'], "Перелет корабля '{$names['name']}' к звезде {$result['sname']} завершен успешно.", 6, $result['event_time'] );
        db_query( "UPDATE ships SET place_type = 7, place_id = ".$result['arg2'].", arg1 = $gx, arg2 = $gy WHERE id = ".$result['ship_id'] );
      }
    }
  }
}

function space_move( $event_id ) {
  $result = db_fetch_row( "SELECT se.user_id, se.event_time, se.ship_id, se.event_type, se.arg1, se.arg2, u.aliance
                             FROM space_events se
                       INNER JOIN users u ON u.id = se.user_id
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  if( $result['event_type'] >= 100 ) {
    $corsar = db_fetch_val( "SELECT MIN( st.corsar ) corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.fleet_id = ".$result['ship_id'], 'corsar' );
  } else {
    $corsar = db_fetch_val( "SELECT st.corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = ".$result['ship_id'], 'corsar' );
  }

  if( $corsar == '' ) {
    $corsar = '0';
  }

  $s_guard = db_fetch_array( "SELECT s.id, s.guard
                                FROM ships s
                          INNER JOIN users u ON u.id = s.user_id
                           LEFT JOIN foe fe ON fe.user_id = s.user_id AND fe.foe_id = {$result['user_id']}
                           LEFT JOIN friend fr ON fr.user_id = s.user_id AND fr.friend_id = {$result['user_id']}
                               WHERE s.arg1={$result['arg1']} AND s.arg2={$result['arg2']} AND
                                     s.fleet_id is null AND (
                                       ( s.guard = 1 ) OR
                                       ( $corsar = 1 AND s.guard > 1 ) OR
                                       ( s.guard = 2 AND fe.user_id is not null ) OR
                                       ( s.guard = 3 AND fr.user_id is null ) OR
                                       ( s.guard = 4 AND u.aliance != {$result['aliance']} )
                                     ) AND s.place_type = 8 AND s.user_id != {$result['user_id']}" );

  $f_guard = db_fetch_array( "SELECT f.id, f.guard
                                FROM fleets f
                          INNER JOIN users u ON u.id = f.user_id
                           LEFT JOIN foe fe ON fe.user_id = f.user_id AND fe.foe_id = {$result['user_id']}
                           LEFT JOIN friend fr ON fr.user_id = f.user_id AND fr.friend_id = {$result['user_id']}
                               WHERE f.arg1={$result['arg1']} AND f.arg2={$result['arg2']} AND (
                                       ( f.guard = 1 ) OR
                                       ( $corsar = 1 AND f.guard > 1 ) OR
                                       ( f.guard = 2 AND fe.user_id is not null ) OR
                                       ( f.guard = 3 AND fr.user_id is null ) OR
                                       ( f.guard = 4 AND u.aliance != {$result['aliance']} )
                                     ) AND f.place_type = 8 AND f.user_id != {$result['user_id']}" );

  if( $result['event_type'] >= 100 ) {
    db_query( "UPDATE fleets SET place_id = 0, place_type = 8, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE id = ".$result['ship_id'] );
    db_query( "UPDATE ships SET place_id = 0, place_type = 8, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE fleet_id = ".$result['ship_id'] );

    $names = db_fetch_row( "SELECT f.name FROM fleets f WHERE f.id = ".$result['ship_id'] );
    if( count( $s_guard ) > 0 || count( $f_guard ) > 0 ) {
      send_msg( 1, $result['user_id'], t( "Флот '%s' атаковали в точке гиперпространства %d:%d.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 6, $result['event_time'] );

      foreach( $s_guard as $ship ) {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }
      }
      foreach( $f_guard as $fleet ) {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 1, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    } else {
      send_msg( 1, $result['user_id'], t( "Перелет флота '%s' к точке гиперпространства %d:%d завершен успешно.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 6, $result['event_time'] );
    }
  } else {
    db_query( "UPDATE ships SET place_id = 0, place_type = 8, arg1 = ".$result['arg1'].", arg2 = ".$result['arg2']." WHERE id = ".$result['ship_id'] );

    $names = db_fetch_row( "SELECT s.name FROM ships s WHERE s.id = ".$result['ship_id'] );
    if( count( $s_guard ) > 0 || count( $f_guard ) > 0 ) {
      send_msg( 1, $result['user_id'], t( "Корабль '%s' атаковали в точке гиперпространства %d:%d.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 5, $result['event_time'] );

      foreach( $s_guard as $ship ) {
        if( $ship['guard'] == 4 ) {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 0, $ship['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }

      foreach( $f_guard as $fleet ) {
        if( $fleet['guard'] == 4 ) {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 8 );
        } else {
          StartWar( 1, $fleet['id'], 0, $result['ship_id'], $result['event_time'], 1 );
        }
      }
    } else {
      send_msg( 1, $result['user_id'], t( "Перелет корабля '%s' к точке гиперпространства %d:%d завершен успешно.", array( $names['name'], $result['arg1'], $result['arg2'] ) ), 6, $result['event_time'] );
    }
  }
}

function space_spy( $event_id ) {
  $result = db_fetch_row( "SELECT se.event_time, se.ship_id, se.event_type, se.arg1, s.name, s.user_id
                             FROM space_events se
                       INNER JOIN ships s ON s.id = se.ship_id
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  $names = db_fetch_row( "SELECT p.name pname, s.name sname
                               FROM planets p
                         INNER JOIN stars s ON s.id = p.star_id
                              WHERE p.id = ".$result['arg1'] );

  $planet = db_fetch_row( "SELECT COUNT(*) pbcnt, AVG( pb.level ) pblev, SUM( pb.shield ) pbshld, SUM( b.warehouse ) pbwcnt, SUM( b.atack ) pbatack
                             FROM planets_buildings pb
                       INNER JOIN buildings b ON b.id = pb.object_id
                            WHERE pb.planet_id = ".$result['arg1'] );

  $orbit = db_fetch_row( "SELECT COUNT(*) obcnt, AVG( ob.level ) oblev, SUM( ob.shield ) obshld, SUM( b.warehouse ) obwcnt, SUM( b.atack ) obatack
                            FROM orbits_buildings ob
                      INNER JOIN buildings b ON b.id = ob.object_id
                           WHERE ob.planet_id = ".$result['arg1'] );

  $pbuild = db_fetch_array( "SELECT count(pb.id) cnt, o.name
                               FROM planets_buildings pb
                         INNER JOIN objects o ON o.id = pb.object_id
                              WHERE pb.planet_id = {$result['arg1']}
                           GROUP BY pb.object_id" );

  if( $planet['pbatack'] > 0 ) {
    $planet_weap = db_fetch_array( "SELECT o.name, COUNT(*) pbcnt, AVG( pb.level ) pblev, SUM( b.atack ) pbatack
                                      FROM planets_buildings pb
                                INNER JOIN objects o ON o.id = pb.object_id
                                INNER JOIN buildings b ON b.id = pb.object_id AND b.atack > 0
                                     WHERE pb.planet_id = ".$result['arg1']." GROUP BY o.id" );
  }

  if( $orbit['obatack'] > 0 ) {
    $orbit_weap = db_fetch_array( "SELECT o.name, COUNT(*) pbcnt, AVG( ob.level ) pblev, SUM( b.atack ) pbatack
                                     FROM orbits_buildings ob
                               INNER JOIN objects o ON o.id = ob.object_id
                               INNER JOIN buildings b ON b.id = ob.object_id AND b.atack > 0
                                    WHERE ob.planet_id = ".$result['arg1']." GROUP BY o.id" );
  }

  $ware_max = db_fetch_array( 'SELECT o.name, w.object_cnt
                                 FROM warehouse w
                           INNER JOIN objects o ON o.id = w.object_id
                                WHERE w.place_type = 1 AND w.place_id = '.$result['arg1'].'
                             ORDER BY w.object_cnt desc LIMIT 0,10' );

  $ware_min = db_fetch_array( 'SELECT o.name, w.object_cnt
                                 FROM warehouse w
                           INNER JOIN objects o ON o.id = w.object_id
                                WHERE w.place_type = 1 AND w.place_id = '.$result['arg1'].'
                             ORDER BY w.object_cnt LIMIT 0,10' );

  $pships = db_fetch_array( 'SELECT o.name, COUNT(*) scnt
                               FROM ships s
                         INNER JOIN objects o ON o.id = s.object_id
                              WHERE s.place_type = 1 AND s.place_id = '.$result['arg1'].'
                           GROUP BY s.object_id' );

  $oships = db_fetch_array( 'SELECT o.name, COUNT(*) scnt
                               FROM ships s
                         INNER JOIN objects o ON o.id = s.object_id
                              WHERE s.place_type = 0 AND s.place_id = '.$result['arg1'].'
                           GROUP BY s.object_id' );

  $obuild = db_fetch_array( "SELECT count(ob.id) cnt, o.name
                               FROM orbits_buildings ob
                         INNER JOIN objects o ON o.id = ob.object_id
                              WHERE ob.planet_id = {$result['arg1']}
                           GROUP BY ob.object_id" );

  $report = t( "Отчет разведывательной операции корабля %s с планеты %s звезды %s

 На планете обнаружено построек: %d
   Средний уровень построек: %d
   Общая сумма щитов: %d
   Общий склад: %d
   Общая сила орудий: %d", array( $result['name'], $names['pname'], $names['sname'], $planet['pbcnt'], $planet['pblev'], $planet['pbshld'], $planet['pbwcnt'], $planet['pbatack'] ) );

  $report .= t( "\n Постройки на планете\n" );
  foreach( $pbuild as $item ) {
    $report .= '   '.$item['name']."\t".$item['cnt']."\n";
  }

  if( $planet['pbatack'] > 0 && count( $planet_weap ) ) {
    $report .= t( "\nСостав оборонительного комплекса планеты:\n" );
    foreach( $planet_weap as $item ) {
      $report .= t( "%s(%d), средний уровень:%d, сила атаки:%d\n", array( $item['name'], $item['pbcnt'], $item['pblev'], $item['pbatack'] ) ) ;
    }
  }

  $report .= t( "\n На орбите обнаружено построек: %d
   Средний уровень построек: %d
   Общая сумма щитов: %d
   Общий склад: %d
   Общая сила орудий: %d", array( $orbit['obcnt'], $orbit['oblev'], $orbit['obshld'], $orbit['obwcnt'], $orbit['obatack'] ) );

  $report .= t( "\n Постройки на орбите\n" );
  foreach( $obuild as $item ) {
    $report .= '   '.$item['name']."\t".$item['cnt']."\n";
  }

  if( $orbit['obatack'] > 0 && count( $orbit_weap ) ) {
    $report .= t( "\nСостав оборонительного комплекса орбиты:\n" );
    foreach( $orbit_weap as $item ) {
      $report .= t( "%s(%d), средний уровень:%d, сила атаки:%d\n" ,array( $item['name'], $item['pbcnt'], $item['pblev'], $item['pbatack'] ) );
    }
  }

  $report .= t( "\nБольше всего на планете:\n" );
  foreach( $ware_max as $item ) {
    $report .= $item['object_cnt']."\t".$item['name']."\n";
  }

  $report .= t( "\nМеньше всего на планете:\n" );
  foreach( $ware_min as $item ) {
    $report .= $item['object_cnt']."\t".$item['name']."\n";
  }

  $report .= t( "\nФлот дислоцирующийся на планете:\n" );
  foreach( $pships as $item ) {
    $report .= $item['scnt']."\t".$item['name']."\n";
  }

  $report .= t( "\nФлот дислоцирующийся на орбите:\n" );
  foreach( $oships as $item ) {
    $report .= $item['scnt']."\t".$item['name']."\n";
  }

  send_msg( 1, $result['user_id'], $report, 18, $result['event_time'] );

  db_query( "DELETE FROM ships WHERE id = ".$result['ship_id'] );
}

function space_gate( $event_id ) {
  $result = db_fetch_row( "SELECT se.user_id, se.event_time, se.ship_id, se.event_type, se.arg1, se.arg2
                             FROM space_events se WHERE se.id = $event_id" );

  if( $result['event_type'] == 7 ) {
    $events = db_fetch_array( "SELECT se.id, se.ship_id, se.event_time, se.arg1, se.arg2,
                                      p.star_id, s.name sname, p.name, p.planet_pos, p.rad, p.orb
                                 FROM space_events se
                            LEFT JOIN planets p ON p.id = se.arg1
                            LEFT JOIN stars s ON s.id = p.star_id
                                WHERE se.user_id = {$result['user_id']} AND se.event_type = 7 AND ( se.arg2 = $event_id OR se.id = $event_id)" );

    if( count( $events ) == 2 ) {
      db_query( "UPDATE planets
                    SET star_id = {$events[1]['star_id']},
                        planet_pos = {$events[1]['planet_pos']},
                        rad = {$events[1]['rad']},
                        orb = {$events[1]['orb']}
                  WHERE id = {$events[0]['arg1']}" );

      db_query( "UPDATE planets
                    SET star_id = {$events[0]['star_id']},
                        planet_pos = {$events[0]['planet_pos']},
                        rad = {$events[0]['rad']},
                        orb = {$events[0]['orb']}
                  WHERE id = {$events[1]['arg1']}" );

      db_query( "DELETE FROM space_events WHERE id IN ( {$events[0]['id']}, {$events[1]['id']} )" );

      user_report( $events[0]['star_id'], $result['user_id'], 5, t( "Астрономы наблюдали, как планета %s в системе %s исчезла, а на ее месте появилась другая, явление похоже на работу корабля Гипер Врата.", array( $events[0]['name'], $events[0]['sname'] ) ) );
      user_report( $events[1]['star_id'], $result['user_id'], 5, t( "Астрономы наблюдали, как планета %s в системе %s исчезла, а на ее месте появилась другая, явление похоже на работу корабля Гипер Врата.", array( $events[1]['name'], $events[1]['sname'] ) ) );

      send_msg( 1, $result['user_id'], t( "Открытие гипер врат осуществилось. Планета '%s' и планета '%s' перемещены.", array( $events[0]['name'], $events[1]['name'] ) ), 6, $result['event_time'] );
    }

    if( count( $events ) == 1 ) {
      db_query( "DELETE FROM space_events WHERE id = {$events[0]['id']}" );
      send_msg( 1, $result['user_id'], t( "Гипер врата на планете '%s' закрыты.", array( $events[0]['name'] ) ), 6, $result['event_time'] );
    }
  }
}

function space_sabotage( $event_id ) {

  $result = db_fetch_row( "SELECT se.event_time, se.ship_id, se.event_type, se.arg1, s.name, s.user_id
                             FROM space_events se
                       INNER JOIN ships s ON s.id = se.ship_id
                            WHERE se.id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  space_spy( $event_id );

  $names = db_fetch_row( "SELECT p.name pname, s.name sname, p.user_id puser, d.user_id duser
                               FROM planets p
                         INNER JOIN stars s ON s.id = p.star_id
                          LEFT JOIN defence d ON d.place_id = p.id AND d.place_type = 1
                              WHERE p.id = ".$result['arg1'] );

  $builds = db_fetch_row( "SELECT pb.id, o.name, pb.x, pb.y, pb.level
                             FROM planets_buildings pb
                       INNER JOIN objects o ON o.id = pb.object_id
                            WHERE pb.object_id != 26 AND pb.planet_id = {$result['arg1']}
                         ORDER BY rand()
                            LIMIT 0,1" );

  if( isset( $builds['id'] ) && is_numeric( $builds['id'] ) ) {
    $event = db_fetch_val( "SELECT id FROM planet_events WHERE x = {$builds['x']} AND y = {$builds['y']} AND planet_id = {$result['arg1']}" );
    if( $event ) {
      db_query( "DELETE FROM planet_events WHERE id = $event" );
      db_query( "DELETE FROM planets_disp WHERE event_id = $event" );
      db_query( "DELETE FROM planets_make WHERE event_id = $event" );
      db_query( "DELETE FROM planets_mines WHERE event_id = $event" );
      db_query( "UPDATE robots SET status = 0 WHERE build_type = 1 AND build_id = ".$builds['id'] );
    }

    $build_map = array_map( 'trim', explode( "\n", trim( db_fetch_val( "SELECT bld FROM planets_maps WHERE id = {$result['arg1']}", 'bld' ) ) ) );
    $build_map[ $builds['y'] ]{ $builds['x'] } = '0';
    db_query( "UPDATE planets_maps SET bld = '".join( "\n", $build_map )."' WHERE id = {$result['arg1']}" );

    db_query( "DELETE FROM planets_buildings WHERE id = ".$builds['id'] );

    $report = t( 'Отчет Разведки.

Наши спец.службы на корабле "%s" - осуществили акт саботажа на вражеской планете %s звезды %s в результате их удачных действий было уничтожена постройка %s %d уровня по координатам %d:%d. Ее деятельность прекращена полностью.', array( $result['name'], $names['pname'], $names['sname'], $builds['name'], $builds['level'], $builds['x'], $builds['y'] ) );

    send_msg( 1, $result['user_id'], $report, 18, $result['event_time'] );

    $report = t( 'Отчет контр разведки

Сов.Секретно

Спец службы иностранных государств проводят политику ослабления власти нашего правительства и деятельности нашего государственного аппарата. На вашей планете %s звезды %s при поддержке спец служб иностранного государства, осуществлен акт саботажа. В результате умышленых действий вашими рабочими разрушено строение %s %d уровня - необходимо принять меры по восстановлению его работы. Агенты влияния прибыли на корабле "%s".', array( $names['pname'], $names['sname'], $builds['name'], $builds['level'], $result['name'] ) );

    if( $names['puser'] ) {
      send_msg( 1, $names['puser'], $report, 18, $result['event_time'] );
    }

    if( $names['duser'] ) {
      send_msg( 1, $names['duser'], $report, 18, $result['event_time'] );
    }
  } else {
    $report = t( 'Саботаж кораблем %s провалился, на планете %s звезды %s подходящих построек не обнаружено.', array( $result['name'], $names['pname'], $names['sname'] ) );
    send_msg( 1, $result['user_id'], $report, 18, $result['event_time'] );
  }
}

function space_harvest( $event_id ) {
  $result = db_fetch_row( "SELECT se.user_id, se.event_time, se.ship_id, se.event_type
                             FROM space_events se
                            WHERE se.id = $event_id" );

  db_query( "DELETE FROM space_events WHERE id = $event_id" );

  if( !$result['ship_id'] ) {
    return;
  }

  if( $result['event_type'] >= 100 ) {
    $coords = db_fetch_row( "SELECT f.id, f.name, f.place_type, f.place_id, IFNULL( f.arg1, 0 ) arg1, IFNULL( f.arg2, 0 ) arg2 FROM fleets f WHERE f.id = ".$result['ship_id'] );

    $ships = db_fetch_array( "SELECT s.id FROM ships s WHERE s.fleet_id = ".$result['ship_id'] );

    send_msg( 1, $result['user_id'], t( "Сбор ресурсов флотом %s завершен.", array( $coords['name'] ) ), 5, $result['event_time'] );
  } else {
    $coords = db_fetch_row( "SELECT s.id, s.name, s.place_type, s.place_id, IFNULL( s.arg1, 0 ) arg1, IFNULL( s.arg2, 0 ) arg2 FROM ships s WHERE s.id = ".$result['ship_id'] );

    $ships[] = array( 'id' => $result['ship_id'] );

    send_msg( 1, $result['user_id'], t( "Сбор ресурсов кораблем %s завершен.", array( $coords['name'] ) ), 5, $result['event_time'] );
  }

  if( !isset( $coords['id'] ) ) {
    return;
  }

  if( $coords['place_type'] == 7 || $coords['place_type'] == 8 ) {
    $trash = db_fetch_array( "SELECT t.object_id, t.object_cnt, o.mass
                                FROM trash t
                          INNER JOIN objects o ON o.id = t.object_id
                               WHERE t.place_type = {$coords['place_type']} AND t.place_id = {$coords['place_id']} AND
                                     t.arg1 = {$coords['arg1']} AND t.arg2 = {$coords['arg2']}" );
  } else {
    $trash = db_fetch_array( "SELECT t.object_id, t.object_cnt, o.mass
                                FROM trash t
                          INNER JOIN objects o ON o.id = t.object_id
                               WHERE t.place_type = {$coords['place_type']} AND t.place_id = {$coords['place_id']}" );
  }

  foreach( $ships as $shid ) {
    $cargo = get_cargo( $shid['id'], true );

    while( $cargo > 0 && count( $trash ) > 0 ) {
      $t_key = array_rand( $trash );
      $item = $trash[ $t_key ];

      if( $cargo >= $item['mass'] ) {
        add_warehouse_item( 2, $shid['id'], $item['object_id'], 1 );

        $cargo -= $item['mass'];

        if( $item['object_cnt'] > 1 ) {
          $trash[ $t_key ]['object_cnt'] -= 1;
        } else {
          unset( $trash[ $t_key ] );
        }
      } else {
        break;
      }
    }
  }

  if( $coords['place_type'] == 7 || $coords['place_type'] == 8 ) {
    db_query( "DELETE FROM trash
                     WHERE place_type = {$coords['place_type']} AND place_id = {$coords['place_id']} AND
                           arg1 = {$coords['arg1']} AND arg2 = {$coords['arg2']}" );
  } else {
    db_query( "DELETE FROM trash
                     WHERE place_type = {$coords['place_type']} AND place_id = {$coords['place_id']}" );
  }

  foreach( $trash as $item ) {
    db_query( "INSERT INTO trash (              place_type,              place_id,              arg1,              arg2,            object_id,           object_cnt  )
                          VALUES ( {$coords['place_type']}, {$coords['place_id']}, {$coords['arg1']}, {$coords['arg2']}, {$item['object_id']}, {$item['object_cnt']} )
               ON DUPLICATE KEY UPDATE object_cnt = object_cnt + ".$item['object_cnt'] );
  }
}

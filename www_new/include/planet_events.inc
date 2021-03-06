<?php

function planet_event_all() {
  global $user;

  $microtime_start = microtime(true);

  do {
    $repeat = false;
    if( is_object( $user ) && isset( $user->uid ) > 0 ) {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, event_type, user_id FROM planet_events WHERE user_id = {$user->uid} AND event_time <= NOW()" );
    } else {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, event_type, user_id FROM planet_events WHERE event_time <= NOW() LIMIT 0,500" );
    }

    foreach( $events as $item ) {

      if( microtime(true) - $microtime_start > 2 ) {
        return;
      }

      db_start();

      setChar( 'level', 1, $item['user_id'] );

      // 1-build, 2-mine, 3-dispence, 4-upgrade, 5-make, 6-copy, 7-research
      switch( $item['event_type'] ) {
        case 1:
          build_event( $item['id'] );
        break;
        case 2:
          if( mine_event( $item['id'] ) ) {
            $repeat = true;
          }
        break;
        case 3:
          disp_event( $item['id'] );
        break;
        case 4:
          upgrade_event( $item['id'] );
        break;
        case 5:
          if( make_event( $item['id'] ) ) {
            $repeat = true;
          }
        break;
        case 6:
        case 7:
          lab_event( $item['id'] );
        break;
      }

      db_end();
    }
  } while( $repeat );
}

function build_event( $event_id ) {
  $buildings = db_fetch_row( "SELECT pe.id, pe.x, pe.y, pe.object_id, b.map_char, o.name, pe.event_time, pe.planet_id,
                                     pe.user_id, b.shield, b.atack, p.name pname, s.name sname, u2.event_id uq_id
                                FROM planet_events pe
                          INNER JOIN buildings b ON b.place_type = 1 AND b.id = pe.object_id
                          INNER JOIN objects o ON pe.object_id = o.id
                          INNER JOIN planets p ON p.id = pe.planet_id
                          INNER JOIN stars s ON s.id = p.star_id
                           LEFT JOIN users_quests uq ON uq.user_id = pe.user_id
                           LEFT JOIN u2u_quests u2 ON u2.event_id = uq.id AND u2.arg0 = pe.planet_id
                               WHERE pe.id = $event_id" );

  if( isset( $buildings['id'] ) && $buildings['id'] ) {

    db_query( "DELETE FROM planet_events WHERE id=$event_id" );
    $planet_id = $buildings['planet_id'];

    $build_map = array_map( 'trim', explode( "\n", trim( db_fetch_val( "SELECT bld FROM planets_maps WHERE id = $planet_id", 'bld' ) ) ) );
  
    if( $build_map[ $buildings['y'] ]{ $buildings['x'] } == 'B' ) {
      $build_map[ $buildings['y'] ]{ $buildings['x'] } = $buildings[ 'map_char' ];
      if( $buildings['object_id'] == 2000 ) {

        $found_map = array_map( 'trim', explode( "\n", trim( db_fetch_val( "SELECT fnd FROM planets_maps WHERE id = $planet_id", 'fnd' ) ) ) );
        $found_map[ $buildings['y'] ]{ $buildings['x'] } = intval( $found_map[ $buildings['y'] ]{ $buildings['x'] } ) + 1;
        db_query( "UPDATE planets_maps SET fnd = '".join( "\n", $found_map )."' WHERE id = $planet_id" );

        levelUp( 19, $buildings['user_id'] );
      } else {
        if( $buildings['shield'] > 0 ) {
          $shield = $buildings['shield'] + ( $buildings['shield'] / 4 * get_book_level( 20, $buildings['user_id'] ) );
        } else {
          $shield = 0;
        }
        db_query( "INSERT IGNORE INTO planets_buildings (planet_id, object_id, x, y, shield) 
                        VALUES( $planet_id, {$buildings['object_id']}, {$buildings['x']}, {$buildings['y']}, $shield )" );
      }
    }
  
    switch( $buildings['object_id'] ) {
      case 34:
        levelUp( 4, $buildings['user_id'] );
        break;

      case 24:
        levelUp( 5, $buildings['user_id'] );
        break;

      case 23:
        levelUp( 10, $buildings['user_id'] );
        levelUp( 13, $buildings['user_id'] );
        break;

      case 33:
        levelUp( 17, $buildings['user_id'] );
        break;

      case 39:
        levelUp( 20, $buildings['user_id'] );
        break;
    }

    if( $buildings['uq_id'] ) {
      send_msg( 1, $buildings['user_id'], t( "������������� ������� '%s' �� ����������� (%d:%d) ��������� �������.", array( $buildings['name'], $buildings['x'], $buildings['y'] ) ), 2, $buildings['event_time'] );
    } else {
      send_msg( 1, $buildings['user_id'], t( "������������� ������� '%s' � ������� %s �� ������� %s (%d:%d) ��������� �������.", array( $buildings['name'], $buildings['sname'], $buildings['pname'], $buildings['x'], $buildings['y'] ) ), 2, $buildings['event_time'] );
    }

    db_query( "UPDATE planets_maps SET bld = '".join( "\n", $build_map )."' WHERE id = $planet_id" );

    if( $buildings['shield'] > 0 || $buildings['atack'] > 0 ) {
      $def = db_fetch_val( "SELECT status FROM defence WHERE place_type = 1 AND place_id = $planet_id", 'status' );
      if( $def === null ) {

        $defender = true;
        $def_planet = db_fetch_row( "SELECT p.planet_user, UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(p.planet_time) planet_time, u.login
                               FROM planets p
                         INNER JOIN users u ON u.id = p.planet_user
                              WHERE p.id = ".$planet_id );

        if( $def_planet['planet_user'] != '' && $def_planet['planet_user'] != $buildings['user_id'] ) {
          if( $def_planet['planet_time'] < 259200 ) {
            $defender = false;
          }
        }

        if( $defender ) {
          db_query( "INSERT IGNORE INTO defence (   place_id, place_type, status,                 user_id )
                                  VALUES ( $planet_id,          1,      1, {$buildings['user_id']} )" );
          if( !$buildings['uq_id'] ) {
            send_msg( 1, $buildings['user_id'], t( "� ������� %s �� ������� %s ���������� ��������� ����� �������.", array( $buildings['sname'], $buildings['pname'] ) ), 2, $buildings['event_time'] );
          } else {
            send_msg( 1, $buildings['user_id'], t( "�� ������� ���������� ��������� ����� �������." ), 2, $buildings['event_time'] );
          }
        }
      }
    }
  }
}

function upgrade_event( $event_id ) {
  $buildings = db_fetch_row( "SELECT pe.id eid, pb.id bid, pb.level, o.name, pe.x, pe.y, pe.event_time, pe.user_id, b.shield, pb.planet_id, p.name pname,
                                     s.name sname, u2.event_id uq_id
                                FROM planet_events pe
                          INNER JOIN planets_buildings pb ON pb.x = pe.x AND pb.y = pe.y AND pb.planet_id = pe.planet_id AND pb.object_id = pe.object_id
                          INNER JOIN objects o ON o.id = pe.object_id
                          INNER JOIN buildings b ON b.id = pb.object_id
                          INNER JOIN planets p ON p.id = pe.planet_id
                          INNER JOIN stars s ON s.id = p.star_id
                           LEFT JOIN users_quests uq ON uq.user_id = pe.user_id
                           LEFT JOIN u2u_quests u2 ON u2.event_id = uq.id AND u2.arg0 = pe.planet_id
                               WHERE pe.id = $event_id" );

  if( isset( $buildings['eid'] ) && $buildings['eid'] ) {
    db_query( "DELETE FROM planet_events WHERE id=$event_id" );

    if( $buildings['level'] < 10 ) {

      if( !$buildings['uq_id'] ) {
        send_msg( 1, $buildings['user_id'], t( "������������������ ������� <font color=\"#FFFF00\">'%s'</font> � ������� %s �� ������� <font color=\"#FFFF00\">%s (%d:%d)</font> ��������� �������.", array( $buildings['name'], $buildings['sname'], $buildings['pname'], $buildings['x'], $buildings['y'] ) ), 2, $buildings['event_time'] );
      } else {
        send_msg( 1, $buildings['user_id'], t( "������������������ ������� <font color=\"#FFFF00\">'%s'</font> �� ����������� (%s:%s)</font> ��������� �������.", array( $buildings['name'], $buildings['x'], $buildings['y'] ) ), 2, $buildings['event_time'] );
      }

      $level = $buildings['level'] + 1;
      db_query( "UPDATE planets_buildings SET level = $level WHERE id={$buildings['bid']}" );
  
      $cnt = db_fetch_val( "SELECT COUNT(*) cnt FROM war_events WHERE d_type = 2 AND d_object_id = ".$buildings['planet_id'], 'cnt' );
      if( $cnt == 0 ) {

        if( $buildings['shield'] > 0 ) {
          $shield = $buildings['shield'] * $level + ( ( $buildings['shield'] * $level ) / 4 * get_book_level( 20, $buildings['user_id'] ) );
        } else {
          $shield = 0;
        }

        db_query( "UPDATE planets_buildings SET shield = $shield WHERE id={$buildings['bid']}" );
      }
    }
  }
}

function mine_event( $event_id ) {
  $repeat = false;
  $mines = db_fetch_row( "SELECT pe.id, pm.res_id, pm.res_cnt, pm.cycle, pe.object_id, o.name, pe.x, p.name pname, s.name sname,
                                 pe.y, pe.event_time, pe.planet_id, pe.user_id, pe.timer, pb.id build_id, p.cycles
                            FROM planet_events pe
                      INNER JOIN planets_mines pm ON pm.event_id = pe.id
                      INNER JOIN objects o ON o.id = pm.res_id
                      INNER JOIN planets_buildings pb ON pb.x = pe.x AND pb.y = pe.y AND pb.planet_id = pe.planet_id
                      INNER JOIN planets p ON p.id = pe.planet_id
                      INNER JOIN stars s ON s.id = p.star_id
                           WHERE pe.id = $event_id" );

  if( isset( $mines['id'] ) && $mines['id'] ) {
    $planet_id = $mines[ 'planet_id' ];
    $free_place = get_warehouse( $planet_id, 1 );
    if( $free_place > 0 ) {
      add_warehouse_item( 1, $planet_id, $mines['res_id'], $mines['res_cnt'] );
      db_query( "UPDATE users_active SET mine = mine + {$mines['res_cnt']} WHERE id = ".$mines['user_id'] );
    }
  
    if( $mines['cycle'] < 0 ) {
        $rob = db_fetch_row( "SELECT id, usedtime FROM robots WHERE build_type = 1 AND build_id = ".$mines['build_id'] );
  
        if( $rob['usedtime'] > $mines['timer'] && $mines['cycle'] != 0 ) {
          db_query( "UPDATE robots SET usedtime = ".($rob['usedtime'] - $mines['timer'])." WHERE id = ".$rob['id'] );
        } else {
          db_query( "DELETE FROM planets_mines WHERE event_id=$event_id" );
          db_query( "DELETE FROM planet_events WHERE id=$event_id" );

          if( isset( $rob['id'] ) ) {
            db_query( "DELETE FROM robots WHERE id={$rob['id']}" );
          }
          send_msg( 1, $mines['user_id'], t( "� ������� %s �� ������� <font color=\"#00FF00\">%s (%d:%d)</font> ���������� ������ ������.", array( $mines['sname'], $mines['pname'], $mines['x'], $mines['y'] ) ), 3, $mines['event_time'] );
        }
  
        db_query( "UPDATE planet_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
        if( $mines['cycles'] >= 0 ) {
          db_query( "UPDATE planets SET cycles = cycles - 1 WHERE id = $planet_id" );
        }
        $repeat = true;
    } else {
      if( $mines['cycle'] > 1 && $mines['cycles'] != 0 ) {
        db_query( "UPDATE planet_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
        db_query( "UPDATE planets_mines SET cycle = ".( $mines['cycle'] - 1 )." WHERE event_id = $event_id" );

        if( $mines['cycles'] >= 0 ) {
          db_query( "UPDATE planets SET cycles = cycles - 1 WHERE id = $planet_id" );
        }
        $repeat = true;
      } else {
        send_msg( 1, $mines['user_id'], t( "����� ������ ��������� <font color=\"#00FF00\">'%s'</font> � ������� %s �� ������� <font color=\"#00FF00\">%s (%d:%d)</font> ��������� �������.", array( $mines['name'], $mines['sname'], $mines['pname'], $mines['x'], $mines['y'] ) ), 3, $mines['event_time'] );
    
        db_query( "DELETE FROM planets_mines WHERE event_id=$event_id" );
        db_query( "DELETE FROM planet_events WHERE id=$event_id" );
      }
    }

    if( $mines['cycles'] == 0 ) {
      db_query( "UPDATE planets_mines SET res_id = 5032 WHERE event_id = $event_id" );
      db_query( "UPDATE planets_maps SET btm = '-', mdl = '-' WHERE id = $planet_id" );
    }
  } else {
    db_query( "DELETE FROM planets_mines WHERE event_id=$event_id" );
    db_query( "DELETE FROM planet_events WHERE id=$event_id" );
  }

  return $repeat;
}

function disp_event( $event_id ) {
  $disp = db_fetch_row( "SELECT pe.id, pd.res_id, pd.res_cnt, pe.x, pe.y, o.name, pe.event_time, pe.planet_id, pe.user_id, p.name pname, s.name sname
                           FROM planet_events pe
                     INNER JOIN planets_disp pd ON pd.event_id = pe.id
                     INNER JOIN objects o ON o.id = pd.res_id
                     INNER JOIN planets p ON p.id = pe.planet_id
                     INNER JOIN stars s ON s.id = p.star_id
                          WHERE pe.id = $event_id" );

  if( isset( $disp['id'] ) && $disp['id'] ) {
    db_query( "DELETE FROM planet_events WHERE id=$event_id" );

    $planet_id = $disp['planet_id'];
    $prod = db_fetch_array( "SELECT os.res_id, ROUND( ROUND( os.res_cnt * p.res_cnt / o1.min_cnt ) * ( 70 + p.level * 3 ) / 100 ) cnt
                               FROM planets_disp p
                         INNER JOIN objects_sub os ON os.object_id = p.res_id
                         INNER JOIN objects o ON o.id = os.res_id AND o.class IN( 1, 2, 9 )
                         INNER JOIN objects o1 ON o1.id = p.res_id
                              WHERE p.event_id = $event_id" );
  
    foreach( $prod as $prod_item ) {
      if( $prod_item['res_id'] == 1043 ) {
        levelUp( 16, $disp['user_id'] );
      }
      add_warehouse_item( 1, $planet_id, $prod_item['res_id'], $prod_item['cnt'] );
    }
  
    send_msg( 1, $disp['user_id'], t( "����������� ��������� <font color=\"#00FFFF\">'%s'</font> � ������� %s �� ������� <font color=\"#00FFFF\">%s (%d:%d)</font> ��������� �������.", array( $disp['name'], $disp['sname'], $disp['pname'], $disp['x'], $disp['y'] ) ), 4, $disp['event_time'] );
  
    db_query( "DELETE FROM planets_disp WHERE event_id=$event_id" );
  }
}

function make_event( $event_id ) {
  $repeat = false;
  $make = db_fetch_row( "SELECT pe.id, pm.object_id, o.name, pe.x, pe.y, pe.event_time, pe.planet_id,
                                pm.cycle, o.class, p.user_id, pe.user_id, pe.timer, pb.id build_id, p.name pname, s.name sname
                           FROM planet_events pe
                     INNER JOIN planets_make pm ON pm.event_id = pe.id
                     INNER JOIN objects o ON o.id = pm.object_id
                     INNER JOIN planets p ON p.id = pe.planet_id
                     INNER JOIN stars s ON s.id = p.star_id
                     INNER JOIN planets_buildings pb ON pb.x = pe.x AND pb.y = pe.y AND pb.planet_id = pe.planet_id
                          WHERE pe.id = $event_id" );

  if( isset( $make['id'] ) && $make['id'] ) {
    $planet_id = $make['planet_id'];
  
    add_warehouse_item( 1, $planet_id, $make['object_id'], 1 );

    switch( $make['object_id'] ) {
      case 2000:
        levelUp( 18, $make['user_id'] );
        break;

      case 9001:
        levelUp( 27, $make['user_id'] );
        break;
    }

    if( $make['cycle'] > 1 || $make['cycle'] == -1 ) {
  
      $items = db_fetch_array( "SELECT o.id, os.res_cnt, w.object_cnt
                                  FROM objects_sub os
                             LEFT JOIN objects o ON o.id = os.res_id
                             LEFT JOIN warehouse w ON w.object_id = o.id AND w.place_id = $planet_id AND w.place_type = 1
                                 WHERE os.object_id = {$make['object_id']} AND o.class IN ( 1, 2, 9 )" );
      $can_build = true;
      foreach( $items as $item ) {
        if( $item['res_cnt'] > $item['object_cnt'] ) {
          $can_build = false;
        }
      }
  
      if( $can_build ) {
  
        foreach( $items as $item ) {
          sub_warehouse_item( 1, $planet_id, $item['id'], $item['res_cnt'] );
        }
  
        if( $make['cycle'] > 1 ) {
          db_query( "UPDATE planets_make SET cycle = ".($make['cycle'] - 1)." WHERE event_id = $event_id" );
        } else {
          $rob = db_fetch_row( "SELECT id, usedtime FROM robots WHERE build_type = 1 AND build_id = ".$make['build_id'] );
  
          if( $rob['usedtime'] > $make['timer'] ) {
            db_query( "UPDATE robots SET usedtime = ".($rob['usedtime'] - $make['timer'])." WHERE id = ".$rob['id'] );
          } else {
            db_query( "DELETE FROM planets_make WHERE event_id=$event_id" );
            db_query( "DELETE FROM planet_events WHERE id=$event_id" );

            if( isset( $rob['id'] ) ) {
              db_query( "DELETE FROM robots WHERE id={$rob['id']}" );
            }
            send_msg( 1, $make['user_id'], t( "� ������� %s �� ������� <font color=\"#FF00FF\">%s (%d:%d)</font> ���������� ������ ������.", array( $make['sname'], $make['pname'], $make['x'], $make['y'] ) ), 3, $make['event_time'] );
          }
        }
        db_query( "UPDATE planet_events SET event_time = DATE_ADD( event_time, INTERVAL timer SECOND ) WHERE id = $event_id" );
        $repeat = true;
      } else {
        send_msg( 1, $make['user_id'], t( "������������ �������� ��� ������������ ������� <font color=\"#FF0000\">'%s'</font> � ������� %s �� ������� <font color=\"#FF0000\">%s (%d:%d)</font> ���� �������.", array( $make['name'], $make['sname'], $make['pname'], $make['x'], $make['y'] ) ), 3, $make['event_time'] );

        db_query( "DELETE FROM planets_make WHERE event_id=$event_id" );
        db_query( "DELETE FROM planet_events WHERE id=$event_id" );
        $repeat = false;

        if( $make['cycle'] < 0 ) {
          db_query( "UPDATE robots SET status = 0 WHERE build_type = 1 AND build_id = ".$make['build_id'] );
        }
      }
    } else {
      if( $make['user_id'] ) {
        send_msg( 1, $make['user_id'], t( "������������ ������� <font color=\"#FF00FF\">'%s'</font> � ������� %s �� ������� <font color=\"#FF00FF\">%s (%d:%d)</font> ��������� �������.", array( $make['name'], $make['sname'], $make['pname'], $make['x'], $make['y'] ) ), 3, $make['event_time'] );
      }

      db_query( "DELETE FROM planets_make WHERE event_id=$event_id" );
      db_query( "DELETE FROM planet_events WHERE id=$event_id" );
      $repeat = false;
    }
  } else {
    db_query( "DELETE FROM planets_make WHERE event_id=$event_id" );
    db_query( "DELETE FROM planet_events WHERE id=$event_id" );
  }

  return $repeat;
}

function lab_event( $event_id ) {
  $lab = db_fetch_row( "SELECT pe.id, pe.event_type, pe.object_id, pe.x, pe.y, pe.event_time, pe.planet_id, pe.user_id, o.class, o.name, p.name pname, s.name sname
                          FROM planet_events pe
                    INNER JOIN objects o ON o.id = pe.object_id
                    INNER JOIN planets p ON p.id = pe.planet_id
                    INNER JOIN stars s ON s.id = p.star_id
                         WHERE pe.id = $event_id" );

  if( isset( $lab['id'] ) && $lab['id'] ) {
    db_query( "DELETE FROM planet_events WHERE id=$event_id" );

    $planet_id = $lab['planet_id'];
  
    if( $lab['class'] == 2 || $lab['class'] == 9 ) {
      $level = get_book_level( 7, $lab['user_id'] ) * 8;
      $success = rand( 1, 100 );
      if( $success <= $level ) {
        send_msg( 1, $lab['user_id'], t( "������������ ������� '%s' � ����������� � ������� %s �� ������� %s (%d:%d) ��������� �������.", array( $lab['name'], $lab['sname'], $lab['pname'], $lab['x'], $lab['y'] ) ), 19, $lab['event_time'] );
        $item = db_fetch_row( "SELECT o.id, o.class FROM objects o, objects_sub os WHERE os.res_id = o.id AND o.class IN ( 6, 7 ) AND os.object_id = ".$lab['object_id'] );
        add_warehouse_item( 1, $planet_id, $item['id'], 1 );
      } else {
        send_msg( 1, $lab['user_id'], t( "������������ ������� '%s' � ����������� � ������� %s �� ������� %s (%d:%d) ���������.", array( $lab['name'], $lab['sname'], $lab['pname'], $lab['x'], $lab['y'] ) ), 19, $lab['event_time'] );
      }
    } else {
      if( $lab['event_type'] == 6 ) {
        send_msg( 1, $lab['user_id'], t( "����������� '%s' � ����������� � ������� %s �� ������� %s (%d:%d) ��������� �������.", array( $lab['name'], $lab['sname'], $lab['pname'], $lab['x'], $lab['y'] ) ), 19, $lab['event_time'] );
        add_warehouse_item( 1, $planet_id, $lab['object_id'], 2 );
      } else {
        send_msg( 1, $lab['user_id'], t( "���������� '%s' � ����������� � ������� %s �� ������� %s (%d:%d) ��������� �������.", array( $lab['name'], $lab['sname'], $lab['pname'], $lab['x'], $lab['y'] ) ), 19, $lab['event_time'] );
        add_warehouse_item( 1, $planet_id, $lab['object_id'], 1 );
      }
    }
  }
}

<?php

function route_obj_from_event( $ship_id, $event_type ) {
  if( $event_type >= 100 ) {
    return array( 'obj_type' => 1, 'obj_id' => $ship_id );
  }

  return array( 'obj_type' => 0, 'obj_id' => $ship_id );
}

function route_clear( $obj_type, $obj_id ) {
  db_safe( $obj_type );
  db_safe( $obj_id );
  db_query( "DELETE FROM routes WHERE obj_type = $obj_type AND obj_id = $obj_id" );
}

function route_clear_event( $ship_id, $event_type ) {
  $obj = route_obj_from_event( $ship_id, $event_type );
  route_clear( $obj['obj_type'], $obj['obj_id'] );
}

function route_shturman_level( $uid = -1 ) {
  return get_book_level( 38, $uid );
}

function route_max_waypoints( $uid = -1 ) {
  $skill = route_shturman_level( $uid );

  if( $skill <= 0 ) {
    return 1;
  }

  return $skill + 1;
}

function route_trim_waypoints( $waypoints, $uid = -1 ) {
  $max = route_max_waypoints( $uid );

  if( count( $waypoints ) <= $max ) {
    return $waypoints;
  }

  return array_slice( $waypoints, 0, $max );
}

function route_insert( $user_id, $obj_type, $obj_id, $waypoints ) {
  db_safe( $user_id );
  db_safe( $obj_type );
  db_safe( $obj_id );

  $waypoints = route_trim_waypoints( $waypoints, $user_id );

  $seq = 0;
  foreach( $waypoints as $wp ) {
    $dest_type = intval( $wp['dest_type'] );
    $dest_id = intval( $wp['dest_id'] );
    $arg1 = intval( $wp['arg1'] );
    $arg2 = intval( $wp['arg2'] );

    db_query( "INSERT INTO routes ( user_id, obj_type, obj_id, seq, dest_type, dest_id, arg1, arg2 )
                       VALUES ( $user_id, $obj_type, $obj_id, $seq, $dest_type, $dest_id, $arg1, $arg2 )" );
    $seq++;
  }
}

function starmove_resolve_click( $x, $y ) {
  $star = db_fetch_row( "SELECT id, name, x, y FROM stars WHERE x BETWEEN ".($x-3)." AND ".($x+3)." AND y BETWEEN ".($y-3)." AND ".($y+3) );

  if( isset( $star['id'] ) && $star['id'] > 0 ) {
    return array(
      'dest_type' => 7,
      'dest_id' => $star['id'],
      'arg1' => 0,
      'arg2' => 0,
      'x' => $star['x'],
      'y' => $star['y'],
    );
  }

  return array(
    'dest_type' => 8,
    'dest_id' => 0,
    'arg1' => $x,
    'arg2' => $y,
    'x' => $x,
    'y' => $y,
  );
}

function route_waypoint_galaxy_xy( $wp ) {
  if( $wp['dest_type'] == 7 ) {
    $star = db_fetch_row( "SELECT x, y FROM stars WHERE id = ".intval( $wp['dest_id'] ) );
    if( isset( $star['x'] ) ) {
      return array( 'x' => $star['x'], 'y' => $star['y'] );
    }
  }

  return array( 'x' => $wp['arg1'], 'y' => $wp['arg2'] );
}

function route_estimate_total( $sx, $sy, $waypoints, $hyper_cnt, $uid = -1 ) {
  $total = 0;
  $cx = $sx;
  $cy = $sy;

  foreach( $waypoints as $wp ) {
    $xy = route_waypoint_galaxy_xy( $wp );
    $lx = $xy['x'] - $cx;
    $ly = $xy['y'] - $cy;
    $len = round( sqrt( $lx * $lx + $ly * $ly ) );
    $total += hyper_fuel_need( $len, $hyper_cnt, $uid );
    $cx = $xy['x'];
    $cy = $xy['y'];
  }

  return $total;
}

function route_pop_next( $obj_type, $obj_id ) {
  db_safe( $obj_type );
  db_safe( $obj_id );

  $row = db_fetch_row( "SELECT id, dest_type, dest_id, arg1, arg2
                          FROM routes
                         WHERE obj_type = $obj_type AND obj_id = $obj_id
                      ORDER BY seq ASC
                         LIMIT 1" );

  if( !isset( $row['id'] ) || !$row['id'] ) {
    return null;
  }

  db_query( "DELETE FROM routes WHERE id = ".$row['id'] );

  return $row;
}

function route_get_position( $obj_type, $obj_id ) {
  db_safe( $obj_type );
  db_safe( $obj_id );

  if( $obj_type == 1 ) {
    $place = db_fetch_row( "SELECT f.place_id, f.place_type, f.arg1, f.arg2, f.hyper, f.hyper_cnt, f.inwar, f.name, f.user_id
                              FROM fleets f
                             WHERE f.id = $obj_id" );
    $add = 100;
  } else {
    $place = db_fetch_row( "SELECT s.place_id, s.place_type, s.arg1, s.arg2, st.hyper, st.hyper_cnt, s.inwar, s.name, s.user_id
                              FROM ships s
                        INNER JOIN ship_types st ON st.object_id = s.object_id
                             WHERE s.id = $obj_id" );
    $add = 0;
  }

  if( !isset( $place['place_type'] ) ) {
    return null;
  }

  $sx = 0;
  $sy = 0;
  $from_arg1 = 0;
  $from_arg2 = 0;
  $from_type = 0;

  switch( $place['place_type'] ) {
    case 0:
      $planet = get_place_info( $place['place_id'], $place['place_type'] );
      $start = db_fetch_row( "SELECT id, x, y FROM stars WHERE id = ".$planet->place_id );
      $from_arg1 = 0;
      $from_arg2 = $planet->place_id;
      $from_type = $add + 4;
      if( isset( $start['id'] ) ) {
        $sx = $start['x'];
        $sy = $start['y'];
      }
      break;

    case 7:
      $start = db_fetch_row( "SELECT id, x, y FROM stars WHERE id = ".$place['place_id'] );
      $from_arg1 = 0;
      $from_arg2 = $place['place_id'];
      $from_type = $add + 4;
      if( isset( $start['id'] ) ) {
        $sx = $start['x'];
        $sy = $start['y'];
      }
      break;

    case 8:
      $from_arg1 = $place['arg1'];
      $from_arg2 = $place['arg2'];
      $from_type = $add + 5;
      $sx = $place['arg1'];
      $sy = $place['arg2'];
      break;

    default:
      return null;
  }

  return array(
    'sx' => $sx,
    'sy' => $sy,
    'from_arg1' => $from_arg1,
    'from_arg2' => $from_arg2,
    'from_type' => $from_type,
    'add' => $add,
    'hyper' => $place['hyper'],
    'hyper_cnt' => $place['hyper_cnt'],
    'inwar' => $place['inwar'],
    'name' => $place['name'],
    'user_id' => $place['user_id'],
    'place_type' => $place['place_type'],
  );
}

function route_fuel_available( $obj_type, $obj_id ) {
  db_safe( $obj_type );
  db_safe( $obj_id );

  if( $obj_type == 1 ) {
    $fuel = db_fetch_row( "SELECT IFNULL( SUM(w.object_cnt), 0 ) cnt
                             FROM warehouse w
                       INNER JOIN ships s ON s.id = w.place_id AND w.place_type = 2
                            WHERE w.object_id = 1044 AND s.fleet_id = $obj_id" );
  } else {
    $fuel = db_fetch_row( "SELECT IFNULL( object_cnt, 0 ) cnt
                             FROM warehouse
                            WHERE object_id = 1044 AND place_type = 2 AND place_id = $obj_id" );
  }

  return intval( $fuel['cnt'] );
}

function route_debit_fuel( $obj_type, $obj_id, $fuel_need ) {
  if( $fuel_need <= 0 ) {
    return;
  }

  db_safe( $obj_type );
  db_safe( $obj_id );
  db_safe( $fuel_need );

  if( $obj_type == 1 ) {
    $ships = db_fetch_array( "SELECT s.id, w.object_cnt
                                FROM ships s
                           LEFT JOIN warehouse w ON w.place_id = s.id AND w.place_type = 2 AND w.object_id = 1044
                               WHERE s.fleet_id = $obj_id
                            ORDER BY w.object_cnt DESC" );

    $total = $fuel_need;
    foreach( $ships as $item ) {
      if( $total <= 0 ) {
        break;
      }
      if( $total <= $item['object_cnt'] ) {
        sub_warehouse_item( 2, $item['id'], 1044, $total );
        break;
      }
      sub_warehouse_item( 2, $item['id'], 1044, $item['object_cnt'] );
      $total -= $item['object_cnt'];
    }
  } else {
    sub_warehouse_item( 2, $obj_id, 1044, $fuel_need );
  }
}

function route_send_intercept_warnings( $obj_type, $obj_id, $star_id, $obj_name, $user_id, $time ) {
  db_safe( $star_id );
  db_safe( $obj_id );
  db_safe( $user_id );

  $user_login = db_fetch_val( "SELECT login FROM users WHERE id = $user_id", 'login', true );

  $inter = db_fetch_array( "SELECT f.user_id, f.interupt, f.name, s.name sname, im.message
                              FROM fleets f
                         LEFT JOIN interupt_msg im ON im.type = 1 AND im.ship_id = f.id
                        INNER JOIN stars s ON s.id = f.place_id
                             WHERE f.interupt > 0 AND f.place_type = 7 AND f.place_id = $star_id
                            UNION
                            SELECT s.user_id, s.interupt, s.name, st.name sname, im.message
                              FROM ships s
                         LEFT JOIN interupt_msg im ON im.type = 0 AND im.ship_id = s.id
                        INNER JOIN stars st ON st.id = s.place_id
                             WHERE s.fleet_id IS NULL AND s.interupt > 0 AND s.place_type = 7 AND s.place_id = $star_id" );

  if( !count( $inter ) ) {
    return;
  }

  if( $obj_type == 1 ) {
    $corsar = db_fetch_val( "SELECT MIN( st.corsar ) corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.fleet_id = $obj_id", 'corsar' );
  } else {
    $corsar = db_fetch_val( "SELECT st.corsar
                               FROM ships s
                         INNER JOIN ship_types st ON st.object_id = s.object_id
                              WHERE s.id = $obj_id", 'corsar' );
  }

  if( $corsar == 1 ) {
    $user_name = 'corsar';
  } else {
    $user_name = $user_login;
  }

  $intcnt = 0;
  foreach( $inter as $mess ) {
    if( $mess['message'] ) {
      send_msg( 1, $user_id, "<font color=\"#FFFF00\">Сообщение гиперперехватчика - \"{$mess['message']}\"</font>", 6 );
    }

    if( $mess['interupt'] == 1 ) {
      send_msg( 1, $mess['user_id'], "Обнаружено искажение пространства в системе {$mess['sname']} перехватчиком {$mess['name']}. Приближается {$obj_name} ($user_name). Ожидается прибытие через ".time_to_str( $time ), 6 );
    } else {
      send_msg( 1, $mess['user_id'], "Обнаружено искажение пространства в системе {$mess['sname']} перехватчиком {$mess['name']}, возможен гиперперехват. Приближается {$obj_name} ($user_name). Ожидается прибытие через ".time_to_str( $time ), 6 );
      $intcnt++;
    }
  }

  if( $intcnt > 0 ) {
    send_msg( 1, $user_id, "Обнаружено искажение пространства, возможен гиперперехват корабля. Найденых точек перехвата: $intcnt", 6 );
  }
}

function route_launch_hop( $obj_type, $obj_id, $waypoint, $pos ) {
  db_safe( $obj_type );
  db_safe( $obj_id );

  $xy = route_waypoint_galaxy_xy( $waypoint );
  $lx = $xy['x'] - $pos['sx'];
  $ly = $xy['y'] - $pos['sy'];
  $len = round( sqrt( $lx * $lx + $ly * $ly ) );
  $time = get_smove_time( $len * 20, $pos['hyper'], $pos['user_id'] );
  $fuel_need = hyper_fuel_need( $len, $pos['hyper_cnt'], $pos['user_id'] );

  if( $fuel_need > route_fuel_available( $obj_type, $obj_id ) ) {
    return false;
  }

  $add = $pos['add'];
  $from_arg1 = $pos['from_arg1'] ? $pos['from_arg1'] : 0;
  $from_arg2 = $pos['from_arg2'] ? $pos['from_arg2'] : 0;
  $from_type = $pos['from_type'] ? $pos['from_type'] : 0;
  $uid = $pos['user_id'];

  if( $waypoint['dest_type'] == 7 ) {
    $event_type = $add + 4;
    $arg1 = 0;
    $arg2 = intval( $waypoint['dest_id'] );

    if( $from_arg1 == 0 ) {
      db_query( "INSERT INTO hot_way (    id_from,  from_arg1,  from_arg2,     id_to, to_arg1, to_arg2, event_time,  len, user_id )
                              VALUES ( $from_arg2,          0,          0, $arg2,       0,       0,      NOW(), $len, $uid )" );
    } else {
      db_query( "INSERT INTO hot_way ( id_from,  from_arg1,  from_arg2,     id_to, to_arg1, to_arg2, event_time,  len, user_id )
                              VALUES (       8, $from_arg1, $from_arg2, $arg2,       0,       0,      NOW(), $len, $uid )" );
    }

    route_send_intercept_warnings( $obj_type, $obj_id, $arg2, $pos['name'], $uid, $time );
  } else {
    $event_type = $add + 5;
    $arg1 = intval( $waypoint['arg1'] );
    $arg2 = intval( $waypoint['arg2'] );

    if( $from_arg1 == 0 ) {
      db_query( "INSERT INTO hot_way (    id_from,  from_arg1,  from_arg2, id_to, to_arg1, to_arg2, event_time,  len, user_id )
                              VALUES ( $from_arg2,          0,          0,     8, $arg1, $arg2,      NOW(), $len, $uid )" );
    } else {
      db_query( "INSERT INTO hot_way ( id_from,  from_arg1,  from_arg2, id_to, to_arg1, to_arg2, event_time,  len, user_id )
                              VALUES (       8, $from_arg1, $from_arg2,     8, $arg1, $arg2,      NOW(), $len, $uid )" );
    }
  }

  if( $obj_type == 1 ) {
    db_query( "UPDATE fleets SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $obj_id" );
    db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE fleet_id = $obj_id" );
  } else {
    db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 5, place_id = 0 WHERE id = $obj_id" );
  }

  route_debit_fuel( $obj_type, $obj_id, $fuel_need );

  db_query( "INSERT INTO space_events ( event_type, ship_id, event_time, timer, user_id, arg1, arg2, from_arg1, from_arg2, from_type )
                              VALUES ( $event_type, $obj_id, DATE_ADD( NOW(), INTERVAL $time SECOND ), $time, $uid, $arg1, $arg2, $from_arg1, $from_arg2, $from_type )" );

  return true;
}

function route_try_continue( $obj_type, $obj_id, $user_id ) {
  db_safe( $obj_type );
  db_safe( $obj_id );
  db_safe( $user_id );

  $pos = route_get_position( $obj_type, $obj_id );
  if( !$pos || $pos['inwar'] != 0 || $pos['place_type'] == 5 ) {
    return;
  }

  $next = route_pop_next( $obj_type, $obj_id );
  if( !$next ) {
    return;
  }

  $waypoint = array(
    'dest_type' => $next['dest_type'],
    'dest_id' => $next['dest_id'],
    'arg1' => $next['arg1'],
    'arg2' => $next['arg2'],
  );

  if( !route_launch_hop( $obj_type, $obj_id, $waypoint, $pos ) ) {
    send_msg( 1, $user_id, t( "Маршрут прерван: не хватает урана для следующего прыжка." ), 6 );
    route_clear( $obj_type, $obj_id );
  }
}

function route_try_continue_event( $ship_id, $event_type, $user_id ) {
  $obj = route_obj_from_event( $ship_id, $event_type );
  route_try_continue( $obj['obj_type'], $obj['obj_id'], $user_id );
}

function starmove_parse_pts( $pts, $uid = -1 ) {
  $waypoints = array();
  $chunks = explode( ';', $pts );

  foreach( $chunks as $chunk ) {
    $chunk = trim( $chunk );
    if( $chunk == '' ) {
      continue;
    }

    $pair = explode( ',', $chunk );
    if( count( $pair ) < 2 ) {
      continue;
    }

    $x = intval( $pair[0] );
    $y = intval( $pair[1] );

    if( !galaxy_validate_coord( $x, $y ) ) {
      return null;
    }

    $waypoints[] = starmove_resolve_click( $x, $y );
  }

  if( !count( $waypoints ) ) {
    return null;
  }

  return route_trim_waypoints( $waypoints, $uid );
}

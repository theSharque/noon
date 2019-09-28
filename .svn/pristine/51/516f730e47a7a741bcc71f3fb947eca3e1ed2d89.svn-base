<?php

function return_back() {

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                             WHERE s.fleet_id IS NOT NULL AND s.fleet_id NOT IN (SELECT id FROM fleets)" );

  return_sub( $ships, true, 1 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                         LEFT JOIN planets p2 ON p2.id = s.place_id
                             WHERE s.fleet_id IS NULL AND s.place_type IN( 0, 1 ) AND p2.id IS NULL" );
  return_sub( $ships, true, 2 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN planets p ON p.user_id = f.user_id
                          LEFT JOIN planets p2 ON p2.id = f.place_id
                              WHERE f.place_type IN( 0, 1 ) AND p2.id IS NULL" );
  return_sub( $fleets, false, 3 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                         LEFT JOIN space_events se ON se.ship_id = s.id AND se.event_type < 100
                             WHERE s.fleet_id IS NULL AND s.place_type = 5 AND se.id IS NULL" );
  return_sub( $ships, true, 4 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN planets p ON p.user_id = f.user_id
                          LEFT JOIN space_events se ON se.ship_id = f.id AND se.event_type >= 100
                              WHERE f.place_type = 5 AND se.id IS NULL" );
  return_sub( $fleets, false, 5 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN ships s2 ON s2.id = s.place_id
                         LEFT JOIN planets p ON p.user_id = s.user_id
                             WHERE s.fleet_id IS NULL AND s.place_type = 2 AND s2.id IS NULL" );
  return_sub( $ships, true, 6 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN ships s2 ON s2.id = f.place_id
                          LEFT JOIN planets p ON p.user_id = f.user_id
                              WHERE f.place_type = 2 AND s2.id IS NULL" );
  return_sub( $fleets, false, 7 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                         LEFT JOIN orbits_buildings ob ON ob.id = s.place_id
                             WHERE s.fleet_id IS NULL AND s.place_type = 3 AND ob.id IS NULL" );
  return_sub( $ships, true, 8 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN planets p ON p.user_id = f.user_id
                          LEFT JOIN orbits_buildings ob ON ob.id = f.place_id
                              WHERE f.place_type = 3 AND ob.id IS NULL" );
  return_sub( $fleets, false, 9 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                             WHERE s.user_id >= 15 AND s.fleet_id IS NULL AND s.place_type IN( 7, 8 ) AND s.arg1 is null" );
  return_sub( $ships, true, 10 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN planets p ON p.user_id = f.user_id
                              WHERE f.user_id >= 15 AND f.place_type IN( 7, 8 ) AND f.arg1 is null" );
  return_sub( $fleets, false, 11 );

  $ships = db_fetch_array( "SELECT s.id, s.user_id, s.name, p.id pid
                              FROM ships s
                         LEFT JOIN planets p ON p.user_id = s.user_id
                             WHERE s.user_id >= 15 AND s.fleet_id IS NULL AND s.place_type = 7 AND s.place_id NOT IN ( SELECT id FROM stars )" );
  return_sub( $ships, true, 12 );

  $fleets = db_fetch_array( "SELECT f.id, f.user_id, f.name, p.id pid
                               FROM fleets f
                          LEFT JOIN planets p ON p.user_id = f.user_id
                              WHERE f.user_id >= 15 AND f.place_type = 7 AND f.place_type = 7 AND f.place_id NOT IN ( SELECT id FROM stars )" );
  return_sub( $fleets, false, 13 );
}

function return_sub( $items, $is_ships, $num ) {

  if( $is_ships ) {
    foreach( $items as $item ) {
      if( $item['pid'] ) {
        send_msg( 1, $item['user_id'], t( "Ваш корабль %s сбился с курса и подал сигнал СОС-%d. Силы конфедерации возвратили его на орбиту вашей родной планеты.", array( $item['name'], $num ) ), 15 );
        db_query( "UPDATE ships SET fleet_id = null, guard = 0, arg1 = null, arg2 = null, place_type = 0, place_id = {$item['pid']} WHERE id = ".$item['id'] );
      } else {
        db_query( "DELETE FROM ships WHERE id = ".$item['id'] );
      }
    }
  } else {
    foreach( $items as $item ) {
      if( $item['pid'] ) {
        send_msg( 1, $item['user_id'], t( "Ваш флот %s сбился с курса и подал сигнал СОС-%d. Силы конфедерации возвратили его на орбиту вашей родной планеты.", array( $item['name'], $num ) ), 15 );
        db_query( "UPDATE fleets SET guard = 0, arg1 = null, arg2 = null, place_type = 0, place_id = {$item['pid']} WHERE id = ".$item['id'] );
        db_query( "UPDATE ships SET guard = 0, arg1 = null, arg2 = null, place_type = 0, place_id = {$item['pid']} WHERE fleet_id = ".$item['id'] );
      } else {
        db_query( "DELETE FROM fleets WHERE id = ".$item['id'] );
        db_query( "DELETE FROM ships WHERE fleet_id = ".$item['id'] );
      }
    }
  }
}
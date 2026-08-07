<?php
  ini_set( 'display_errors', 0 );
  ini_set( 'log_errors', 1 );
  ini_set( 'error_log', 'err_log.log' );

  header("Cache-Control: no-cache, must-revalidate");
  header("Pragma: no-cache");
  header("Connection: Keep-Alive");

  require_once( "./include/db.inc" );
  require_once( "./include/misc.inc" );

  $row = db_fetch_row( "SELECT id, star_id FROM planets WHERE type = 6" );

  $planet_id = $row['id'];
  $star_id = $row['star_id'];

  if( $planet_id ) {
    $planet_pos = db_fetch_val( "SELECT planet_pos FROM planets WHERE id = $planet_id", 'planet_pos' );

    db_query( "DELETE FROM planets WHERE id = $planet_id" );

    $ship_rows = db_fetch_array( "SELECT s.id
                                    FROM ships s
                                   WHERE s.fleet_id IS NULL AND (
                                           ( s.place_type IN (0,1) AND s.place_id = $planet_id )
                                           OR
                                           ( s.place_type = 3 AND s.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id = $planet_id ) )
                                         )" );
    foreach( $ship_rows as $ship_row ) {
      $pos = system_random_coord();
      db_query( "UPDATE ships s
                    SET s.arg1 = {$pos['x']}, s.arg2 = {$pos['y']}, s.place_type = 7, s.place_id = $star_id
                  WHERE s.id = ".$ship_row['id'] );
    }

    $fleet_rows = db_fetch_array( "SELECT f.id
                                     FROM fleets f
                                    INNER JOIN ships s ON s.fleet_id = f.id
                                    WHERE ( f.place_type IN (0,1) AND f.place_id = $planet_id )
                                       OR ( f.place_type = 3 AND f.place_id IN ( SELECT ob.id FROM orbits_buildings ob WHERE ob.planet_id = $planet_id ) )
                                    GROUP BY f.id" );
    foreach( $fleet_rows as $fleet_row ) {
      $pos = system_random_coord();
      db_query( "UPDATE fleets f
                    SET f.arg1 = {$pos['x']}, f.arg2 = {$pos['y']}, f.place_type = 7
                  WHERE f.id = ".$fleet_row['id'] );
      db_query( "UPDATE ships s
                    SET s.arg1 = {$pos['x']}, s.arg2 = {$pos['y']}, s.place_type = 7, s.place_id = $star_id
                  WHERE s.fleet_id = ".$fleet_row['id'] );
    }

    db_query( "UPDATE ships s, fleets f SET s.arg1=f.arg1, s.arg2=f.arg2
                WHERE s.fleet_id = f.id AND f.place_type = 7" );

    $as_count = mt_rand( 5, 7 );

    $levmap = 'HJKLZXCVBNM';
    $rad = 0;
    for( $i = 0; $i < $as_count; $i++ ) {
      $rad += ( 360 / $as_count ) + mt_rand( 0, 6 ) - 3;
      db_query( "INSERT INTO planets ( type, name,       star_id,            planet_pos,  rad,                     orb,                         cycles  )
                              VALUES ( 5,    'Астероид', $star_id, $planet_pos, $rad, ".system_orbit_radius( $planet_pos ).", 10000   )" );

      $aster_id = mysql_insert_id();

      $name = "Астер.$aster_id";
      db_query( "UPDATE planets SET name = '$name' WHERE id = $aster_id" );

      $mat = $levmap{ mt_rand( 0, strlen( $levmap ) - 1 ) };
      file_put_contents( "./pages/environment/planets/$aster_id.mdl", $mat );

      $mat = $levmap{ mt_rand( 0, strlen( $levmap ) - 1 ) };
      file_put_contents( "./pages/environment/planets/$aster_id.btm", $mat );
      file_put_contents( "./pages/environment/planets/$aster_id.top", '4' );
      file_put_contents( "./pages/environment/planets/$aster_id.fnd", '3' );
      file_put_contents( "./pages/environment/planets/$aster_id.bld", '0' );
  
    }
  }

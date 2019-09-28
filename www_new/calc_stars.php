<?php
  require_once( "./include/db.inc" );
  require_once( "./include/misc.inc" );

  db_query( "DELETE FROM star_pos WHERE id IN( SELECT id FROM stars )" );
  db_query( "INSERT INTO star_pos ( id, x, y ) SELECT id, x, y FROM stars" );

  $need = 0;

  $max = db_fetch_val( "SELECT COUNT(id) cnt FROM star_pos", 'cnt' );

  for( $i=0; $i < 10000 - $max; $i++ ) {
    $min_len = mt_rand( 20, 45 );
    $len = db_fetch_val( "SELECT ROUND( SQRT( POW( s.x, 2 ) + POW( s.y, 2 ) ) ) mlen
                            FROM ( SELECT s1.id, MIN( ROUND( SQRT( POW( s1.x - s2.x, 2 ) + POW( s1.y - s2.y, 2 ) ) ) ) len
                                     FROM star_pos s1, star_pos s2
                                    WHERE s1.id != s2.id
                                 GROUP BY s1.id ) ns
                      INNER JOIN star_pos s ON s.id = ns.id
                           WHERE ns.len > ( $min_len + 5 )
                        ORDER BY SQRT( POW( s.x, 2 ) + POW( s.y, 2 ) )
                           LIMIT 0,1", 'mlen' );
    $cont = true;

    for( $rad = $len - $min_len; $rad < 10000 && $cont; $rad+=5 ) {
      for( $ang = 0; $ang < 360 && $cont; $ang++ ) {
        $nx = round( sin( deg2rad( $ang ) ) * $rad );
        $ny = round( cos( deg2rad( $ang ) ) * $rad );
        $nlen = db_fetch_row( "SELECT MIN( ROUND( SQRT( (x-$nx)*(x-$nx) + (y-$ny)*(y-$ny) ) ) ) len FROM star_pos s" );
        if( $nlen['len'] >= $min_len || $nlen['len'] === null ) {
          $cont = false;
        }
      }
    }

    $time_end = microtime(1);
    $time = $time_end - $time_start;

    db_query( "INSERT INTO star_pos ( x, y ) VALUES ( $nx, $ny )" );
  }

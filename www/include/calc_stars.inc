<?php
  chdir( "/var/www/noon" );

  require_once( "include/db.inc" );
  require_once( "include/misc.inc" );

  require_once( 'include/market.inc' );
  status_quo();

  $microtime_start = microtime(true);

  db_query( "DELETE FROM star_pos WHERE id IN( SELECT id FROM stars )" );
  $need = 10000 - db_fetch_val( 'SELECT count(*) cnt FROM star_pos', 'cnt' );

  if( $need < 10 ) {
    echo "Star generator not need\n";
    return;
  }

  if( $need > 10 ) {
    $need = 100;
  }

  db_query( "INSERT IGNORE INTO star_pos ( id, x, y ) SELECT id, x, y FROM stars" );
  db_query( "OPTIMIZE TABLE star_pos" );

  echo "Star generator start need $need star\n";

  $min_len = 20;
  $len = db_fetch_val( "SELECT ROUND( SQRT( POW( s.x, 2 ) + POW( s.y, 2 ) ) ) mlen
                          FROM ( SELECT s1.id, MIN( ROUND( SQRT( POW( s1.x - s2.x, 2 ) + POW( s1.y - s2.y, 2 ) ) ) ) len
                                   FROM star_pos s1, star_pos s2
                                  WHERE s1.id != s2.id
                               GROUP BY s1.id ) ns
                    INNER JOIN star_pos s ON s.id = ns.id
                         WHERE ns.len > ( $min_len + 5 )
                      ORDER BY SQRT( POW( s.x, 2 ) + POW( s.y, 2 ) )
                         LIMIT 0,1", 'mlen' );

  $nx = 0;
  $ny = 0;
  while( $need > 0 ) {
    $min_len = 20;
    for( $rad = $len - $min_len; $rad < 900 && $need > 0; $rad+=5 ) {
      for( $ang = 0; $ang < 360 && $need > 0; $ang++ ) {
        $nx = round( sin( deg2rad( $ang ) ) * $rad );
        $ny = round( cos( deg2rad( $ang ) ) * $rad );
  
        $nlen = db_fetch_val( "SELECT MIN( ROUND( SQRT( POW( x - $nx, 2 ) + POW( y - $ny, 2 ) ) ) ) len FROM star_pos s", 'len' );
        if( microtime(true) - $microtime_start > 10800 ) {
          echo "Star generator finished\n";
          return;
        }

        if( $nlen >= $min_len || $nlen === null ) {
          if( $nx != 0 && $ny != 0 ) {
            $time = date("H:i:s");
            echo "$time Generated $need star rad:$rad ang:$ang\n";
  
            db_query( "INSERT INTO star_pos ( x, y ) VALUES ( $nx, $ny )" );
            $min_len = mt_rand( 20, 45 );
            $need--;
          }
        }
      }
    }
  }

  echo "Star generator finished\n";

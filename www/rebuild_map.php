<?php

require_once( "./include/db.inc" );
require_once( "./include/misc.inc" );

$planets = db_fetch_array( "SELECT p.id, pm.top
                              FROM planets p
                        INNER JOIN planets_maps pm ON pm.id = p.id
                             WHERE p.type = 5" );

//$planets = array( )
$l=0;

foreach( $planets as $line ) {

  $pid = $line['id'];

//  $content = file( "./pages/environment/planets/$pid.top" );

  $content = array_map( 'trim', explode( "\n", trim( $line['top'] ) ) );

  $map = db_fetch_array( "SELECT pb.x, pb.y, b.map_char
                            FROM planets_buildings pb
                      INNER JOIN buildings b ON b.id = pb.object_id
                           WHERE pb.planet_id = $pid
                        ORDER BY y, x" );

  $dst_map = $out = '';

  $icnt = count( $content );
  for( $i=0; $i < $icnt; $i++ ) {
    $out .= '&hl'.$i.'=';
    $tcnt = strlen( trim( $content[ $i ] ) );

    for( $t=0; $t < $tcnt; $t++ ) {
      $bld = current( $map );
      if( is_numeric( $bld['x'] ) && $bld['x'] == $t &&
          is_numeric( $bld['y'] ) && $bld['y'] == $i ) {
        next( $map );
        $dst_map .= $bld['map_char'];
      } else {
        $dst_map .= '0';
      }
    }
    $dst_map .= "\n";
  }

  echo ( count( $planets ) - $l )."\n";
  $l++;

  $dst_map = trim( $dst_map );

//  file_put_contents( "./pages/environment/planets/$pid.bld", $dst_map );
    db_query( "UPDATE planets_maps SET bld = '$dst_map' WHERE id = $pid" );
}

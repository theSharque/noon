<?php

  require_once( "./include/db.inc" );
  require_once( "./include/misc.inc" );

  $stars = db_fetch_array( "SELECT star_id, planet_pos, count(id) cnt
                              FROM planets
                          GROUP BY star_id, orb
                            HAVING cnt > 1" );

  foreach( $stars as $item ) {
    $asters = db_fetch_array( "SELECT id FROM planets WHERE star_id = {$item['star_id']} AND planet_pos = {$item['planet_pos']}" );

    $ang = 360 / $item['cnt'];
    $pos = 0;
    foreach( $asters as $planet ) {
      db_query( "UPDATE planets SET rad = $pos WHERE id = {$planet['id']}" );
      $pos += $ang;
    }
  }

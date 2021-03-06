<?php

function gen_ship() {

  $max = db_fetch_val( "SELECT count(*) cnt FROM stars", 'cnt' );

  $cnt = db_fetch_val( "SELECT count(*) FROM ships WHERE place_type = 7 AND user_id IS NULL" );

  if( $cnt < round( $max / 4 ) ) {
    $type = db_fetch_val( "SELECT object_id
                             FROM ship_types
                            WHERE object_id NOT IN ( 4002, 4003, 9421, 9424, 9428, 9426, 9430, 9465, 9321, 9268, 9358, 9485 ) AND hyper > 0 AND planet > 0
                         ORDER BY rand()
                            LIMIT 0, 1", 'object_id' );

    $stars = db_fetch_array( "SELECT id, name FROM stars WHERE type != 4" );
    $sr = mt_rand( 1, count( $stars ) );
    $ship = $stars[$sr-1]['id'];
    $star = $stars[$sr-1]['name'];

    do {
      $xr = mt_rand( 1, 684 );
      $yr = mt_rand( 1, 460 );

      $xdiff = 340 - $xr;
      $ydiff = 220 - $yr;
      $len = round( sqrt( $xdiff * $xdiff + $ydiff * $ydiff ) );
    } while ( $len < 25 );

    user_report( $ship, 1, 120, t( "��������� ������������� �������� ������� <font color=\"#00FF00\">� ������� %s �������</font> � ������� ���������, �� �� �������� �� ��������������� �������.", array( $star ) ) );

    db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id, name,      arg1, arg2, fleet_id, shield, inwar, guard) VALUES
                                 ($type,     $ship, 7,   null,    'abandon', $xr,  $yr,  NULL,     0,      0,     0    )" );
  }

  return 1;
}

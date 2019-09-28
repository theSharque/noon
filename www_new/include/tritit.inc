<?php

function gen_tritit() {
  $trits = array( 1 => 9141, 2 => 9146, 3 => 9148 );
  $shield = array( 1 => 5, 2 => 7, 3 => 10 );
  $ships = db_fetch_array( "SELECT s.id stid, ( SELECT MAX( id ) FROM ships sh
                                                  WHERE sh.place_type = 7 AND sh.place_id = s.id AND
                                                        sh.user_id = 3 AND sh.inwar = 0 AND sh.fleet_id is null ) shid
                              FROM stars s" );

  foreach( $ships as $item ) {
    $xr = mt_rand( 1, 684 );
    $yr = mt_rand( 1, 460 );
    $type = mt_rand( 1, 3 );

    if( isset( $item['shid'] ) && is_numeric( $item['shid'] ) ) {
      db_query( "UPDATE ships SET arg1 = $xr, arg2 = $yr WHERE id = ".$item['shid'] );
    } else {

      user_report( $item['stid'], 1, 2, t( "Астрономы обнаружили малый объект <font color=\"#FF0000\">в вашей системе в точке %d:%d. Предположительно, это тритит</font>.", array( $xr, $yr ) ) );

      db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id, name, arg1, arg2, fleet_id, shield, inwar, guard) VALUES
                                   ({$trits[$type]}, {$item['stid']}, 7, 3, 'Тритит', $xr, $yr, NULL, {$shield[$type]}, 0, 1 )" );
    }
  }

  $fleets = db_fetch_array( "SELECT f.id shid FROM fleets f WHERE f.place_type = 7 AND f.user_id = 3 AND f.inwar = 0" );
  foreach( $fleets as $item ) {
    $xr = mt_rand( 1, 684 );
    $yr = mt_rand( 1, 460 );

    db_query( "UPDATE fleets SET arg1 = $xr, arg2 = $yr WHERE id = ".$item['shid'] );
    db_query( "UPDATE ships SET arg1 = $xr, arg2 = $yr WHERE fleet_id = ".$item['shid'] );
   
  }

  return 1;
}

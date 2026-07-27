<?php

require_once './pages/admin/api_common.inc';
admin_require();

$shipId = admin_int( 'ship_id' );
$conservId = admin_int( 'conserv_id' );

if( $shipId > 0 && $conservId > 0 ) {
  $radar = admin_param( 'radar' ) ? 1 : 0;
  $cloak = admin_param( 'cloak' ) ? 1 : 0;
  $remote = admin_param( 'remote' ) ? 1 : 0;
  $agrav = admin_param( 'agrav' ) ? 1 : 0;
  $planet = admin_int( 'planet' );
  $hyper = admin_int( 'hyper' );
  $shield = admin_int( 'shield' );
  $cargo = admin_int( 'cargo' );
  $wPower = admin_int( 'w_power' );
  $wCount = admin_int( 'w_count' );
  $code = admin_param( 'code' );
  admin_esc( $code );
  $planetCnt = admin_int( 'planet_cnt' );
  $hyperCnt = admin_int( 'hyper_cnt' );

  db_query( "UPDATE ship_types SET conserv_id = $conservId, agrav = $agrav, planet = $planet, hyper = $hyper,
                                   shield = $shield, cargo = $cargo, w_power = $wPower, w_count = $wCount,
                                   code = '$code', planet_cnt = $planetCnt,
                                   hyper_cnt = $hyperCnt, radar = $radar, remote = $remote, cloak = $cloak
              WHERE object_id = $shipId" );

  if( mysql_affected_rows() == 0 ) {
    db_query( "UPDATE ship_types SET object_id = $shipId, agrav = $agrav, planet = $planet, hyper = $hyper,
                                     shield = $shield, cargo = $cargo, w_power = $wPower, w_count = $wCount,
                                     code = '$code', planet_cnt = $planetCnt,
                                     hyper_cnt = $hyperCnt, radar = $radar, remote = $remote, cloak = $cloak
                WHERE conserv_id = $conservId" );
    if( mysql_affected_rows() == 0 ) {
      db_query( "INSERT INTO ship_types (object_id, conserv_id, agrav, planet, hyper, shield, cargo,
                                         w_power, w_count, code, planet_cnt, hyper_cnt, radar, remote, cloak)
                      VALUES ( $shipId, $conservId, $agrav, $planet, $hyper, $shield, $cargo,
                               $wPower, $wCount, '$code', $planetCnt,
                               $hyperCnt, $radar, $remote, $cloak )" );
    }
  }
  admin_json( array( 'ok' => true ) );
}

$ships = db_fetch_array( "SELECT s.object_id ship_id, s.conserv_id, o1.name ship_name, o2.name conserv_name,
                                 s.agrav, s.planet, s.hyper, s.shield, s.cargo, s.w_power,
                                 s.w_count, s.code, s.planet_cnt, s.hyper_cnt, s.radar, s.remote, s.cloak
                            FROM ship_types s
                      INNER JOIN objects o1 ON o1.id = s.object_id
                      INNER JOIN objects o2 ON o2.id = s.conserv_id" );
$shipObjs = db_fetch_array( "SELECT o.name, o.id FROM objects o WHERE o.class = 4 ORDER BY o.name" );
$conservObjs = db_fetch_array( "SELECT o.name, o.id FROM objects o WHERE o.class = 9 ORDER BY o.name" );

admin_json( array(
  'ok' => true,
  'ships' => $ships ? $ships : array(),
  'ship_objects' => $shipObjs ? $shipObjs : array(),
  'conserv_objects' => $conservObjs ? $conservObjs : array(),
) );

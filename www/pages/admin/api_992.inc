<?php

require_once './pages/admin/api_common.inc';
admin_require();

$classes = admin_object_classes();
$act = admin_param( 'act' );
$objectId = admin_int( 'object' );

if( $act === 'delete' && $objectId > 0 ) {
  db_query( "DELETE FROM objects WHERE id = $objectId" );
  admin_json( array( 'ok' => true, 'act' => 'delete' ) );
}

$name = admin_param( 'obj_name' );
if( $name !== '' ) {
  admin_esc( $name );
  $minCnt = admin_int( 'min_cnt', 1 );
  $mass = admin_int( 'mass', 1 );
  $class = admin_int( 'class', 0 );
  $price = admin_int( 'price', 0 );
  $cprice = admin_int( 'cprice', 0 );
  $weight = admin_int( 'weight', 0 );
  $makeTime = admin_int( 'make_time', 0 );

  if( $objectId > 0 ) {
    db_query( "UPDATE objects SET
      name = '$name',
      min_cnt = $minCnt,
      mass = $mass,
      class = $class,
      price = $price,
      cprice = $cprice,
      weight = $weight,
      make_time = $makeTime
    WHERE id = $objectId" );
  } else {
    db_query( "INSERT INTO objects ( name, min_cnt, mass, class, price, cprice, weight, make_time )
                    VALUES ( '$name', $minCnt, $mass, $class, $price, $cprice, $weight, $makeTime )" );
    $objectId = mysql_insert_id();
  }
  admin_json( array( 'ok' => true, 'object_id' => $objectId ) );
}

$list = db_fetch_array( "SELECT o.class, o.make_time, o.name, o.id FROM objects o ORDER BY o.class, o.name, o.id" );

$item = null;
$calcMass = null;
if( $objectId > 0 ) {
  $item = db_fetch_row( "SELECT * FROM objects o WHERE o.id = $objectId" );
  $calcMass = db_fetch_row( "SELECT SUM( o.mass * os.res_cnt ) mass
                               FROM objects_sub os
                         INNER JOIN objects o ON os.res_id = o.id AND o.id not in (1026, 1019, 1030)
                              WHERE os.object_id = $objectId" );
}

admin_json( array(
  'ok' => true,
  'classes' => $classes,
  'objects' => $list ? $list : array(),
  'object' => $item,
  'calc_mass' => $calcMass ? $calcMass['mass'] : null,
) );

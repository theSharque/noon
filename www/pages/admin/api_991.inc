<?php

require_once './pages/admin/api_common.inc';
admin_require();

$act = admin_param( 'act' );
$objectId = admin_int( 'object' );

if( $act === 'add' && $objectId > 0 ) {
  $addObj = admin_int( 'add_obj' );
  $count = admin_int( 'count' );
  if( $count > 0 && $addObj > 0 ) {
    db_query( "INSERT INTO objects_sub (object_id, res_id, res_cnt) VALUES ( $objectId, $addObj, $count)" );
  }
  admin_json( array( 'ok' => true, 'act' => 'add' ) );
}

if( $act === 'delete' && $objectId > 0 ) {
  $resId = admin_int( 'res_id' );
  db_query( "DELETE FROM objects_sub WHERE object_id = $objectId AND res_id = $resId" );
  admin_json( array( 'ok' => true, 'act' => 'delete' ) );
}

$list = db_fetch_array( "SELECT o.class, o.mass, o.name, o.id, o.myprice FROM objects o ORDER BY o.class, o.name, o.id" );

$subs = array();
if( $objectId > 0 ) {
  $subs = db_fetch_array( "SELECT o.id res_id, o.name, o.mass, o.myprice, os.res_cnt
                             FROM objects o, objects_sub os
                            WHERE os.object_id = $objectId AND o.id = os.res_id
                         ORDER BY o.class, o.name, o.id" );
}

admin_json( array(
  'ok' => true,
  'objects' => $list ? $list : array(),
  'object_id' => $objectId,
  'subs' => $subs ? $subs : array(),
) );

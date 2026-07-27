<?php

require_once './pages/admin/api_common.inc';
admin_require();

$act = admin_param( 'act' );
$objectId = admin_int( 'object' );

if( $act === 'save' && $objectId > 0 ) {
  $desc = admin_param( 'desc' );
  $desc = str_ireplace( "\r", '', $desc );
  $desc = str_ireplace( '"', "'", $desc );
  admin_esc( $desc );
  db_query( "UPDATE enciclopedia SET `desc` = \"$desc\" WHERE object_id = $objectId" );
  admin_json( array( 'ok' => true, 'act' => 'save' ) );
}

if( $act === 'rebuild_minerals' ) {
  include './pages/admin/enc_rebuild.inc';
  admin_json( array( 'ok' => true, 'act' => 'rebuild_minerals' ) );
}

$list = db_fetch_array( "SELECT o.id, o.class, o.name FROM enciclopedia e, objects o WHERE o.id = e.object_id ORDER BY o.class, o.name" );
$desc = '';
if( $objectId > 0 ) {
  $desc = db_fetch_val( "SELECT e.desc FROM enciclopedia e WHERE e.object_id = $objectId", 'desc' );
}

admin_json( array(
  'ok' => true,
  'objects' => $list ? $list : array(),
  'object_id' => $objectId,
  'desc' => $desc,
  'classes' => admin_object_classes(),
) );

<?php

require_once './pages/admin/api_common.inc';
admin_require();

$fromObj = admin_int( 'from_obj' );
$toObj = admin_int( 'to_obj' );

if( $fromObj > 0 && $toObj > 0 ) {
  db_query( "UPDATE research SET from_object = $fromObj WHERE to_object = $toObj" );
  if( mysql_affected_rows() == 0 ) {
    db_query( "INSERT INTO research (from_object, to_object) VALUES ( $fromObj, $toObj )" );
  }
  admin_json( array( 'ok' => true ) );
}

$links = db_fetch_array( "SELECT r.from_object, r.to_object, o1.name from_name, o2.name to_name
                            FROM research r
                      INNER JOIN objects o1 ON o1.id = r.from_object
                      INNER JOIN objects o2 ON o2.id = r.to_object" );
$layouts = db_fetch_array( "SELECT o.name, o.id FROM objects o WHERE o.class IN( 6, 7 ) ORDER BY o.class, o.name" );

admin_json( array(
  'ok' => true,
  'links' => $links ? $links : array(),
  'layouts' => $layouts ? $layouts : array(),
) );

<?php

require_once './pages/admin/api_common.inc';
admin_require();

$act = admin_param( 'act' );
$level = admin_int( 'level' );

if( $act === 'save' && admin_param( 'page_id' ) !== '' ) {
  $pageId = admin_int( 'page_id' );
  $premium = admin_int( 'premium' );
  $tutorial = admin_param( 'tutorial' );
  $tutorial = str_ireplace( "\r", '', $tutorial );
  admin_esc( $tutorial );
  $lvl = admin_int( 'level' );
  db_query( "UPDATE tutorials SET page_id = $pageId, premium = $premium, tutorial = '$tutorial' WHERE level = $lvl" );
  admin_json( array( 'ok' => true, 'act' => 'save' ) );
}

$list = db_fetch_array( "SELECT t.level, t.page_id, t.premium, t.tutorial FROM tutorials t ORDER BY t.level" );
$current = null;
if( $level > 0 ) {
  foreach( $list as $item ) {
    if( intval( $item['level'] ) === $level ) {
      $current = $item;
      break;
    }
  }
}

admin_json( array(
  'ok' => true,
  'tutorials' => $list ? $list : array(),
  'current' => $current,
) );

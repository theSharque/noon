<?php

require_once './pages/admin/api_common.inc';
require_once './pages/admin/log_labels.inc';
admin_require();

$login = admin_param( 'login' );
if( $login === '' ) {
  admin_json( array( 'ok' => false, 'err' => 'login_required' ) );
}
admin_esc( $login );

$time = admin_param( 'time', '0000-00-00 00:00:00' );
admin_esc( $time );
$filterId = admin_int( 'filter_id', -1 );
$limit = admin_int( 'limit', 100 );
if( $limit < 1 ) $limit = 1;
if( $limit > 500 ) $limit = 500;

$rows = db_fetch_array( "SELECT fl.line, fl.log_time
                           FROM full_log fl
                     INNER JOIN users u ON u.id = fl.uid
                          WHERE u.login = '$login' AND fl.log_time > '$time'
                       ORDER BY fl.log_time
                          LIMIT 0, $limit" );

$entries = array();
if( is_array( $rows ) ) {
  foreach( $rows as $item ) {
    $line = @unserialize( stripslashes( $item['line'] ) );
    if( !is_array( $line ) ) {
      continue;
    }
    $pageId = isset( $line['id'] ) ? intval( $line['id'] ) : 0;
    if( $filterId >= 0 && $pageId !== $filterId ) {
      continue;
    }
    $params = array();
    foreach( $line as $key => $field ) {
      $params[ $key ] = $field;
    }
    $entries[] = array(
      'log_time' => $item['log_time'],
      'page_id' => $pageId,
      'label' => admin_log_label( $pageId ),
      'params' => $params,
    );
  }
}

admin_json( array(
  'ok' => true,
  'login' => $login,
  'time' => $time,
  'entries' => $entries,
) );

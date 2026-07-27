<?php

require_once './pages/admin/api_common.inc';
require_once './pages/admin/log_labels.inc';
admin_require();

$login = admin_param( 'login' );
if( $login === '' ) {
  admin_json( array( 'ok' => false, 'err' => 'login_required' ) );
}
admin_esc( $login );

$act = admin_param( 'act' );

$data = db_fetch_row( "SELECT u.id, u.login, up.id pid, up.login parent, (SELECT group_concat( login ) FROM users WHERE parent_id = u.id) child,
                              a.name aliance, a.level aliance_level, t.name titul, u.last_ip, u.register_date, u.tutorial_time, ua.lastlogin,
                              u.err_login, u.email, u.ssid, u.status, u.level, u.lastlevel,
                              u.money, u.credits, u.ref_link, u.place_id,
                              CASE u.place_type
                                WHEN 0 THEN concat( 'Planet ', p.name )
                                WHEN 1 THEN concat( 'Planet ', p.name )
                                WHEN 2 THEN concat( 'Ship ', s.name )
                                WHEN 3 THEN concat( o.name, ' ', op.name )
                                WHEN 6 THEN concat( 'Fleet ', f.name )
                                ELSE concat( u.place_type, ':', u.place_id )
                              END place
                         FROM users u
                   INNER JOIN users_active ua ON ua.id = u.id
                    LEFT JOIN users up ON up.id = u.parent_id
                    LEFT JOIN aliance a ON a.id = u.aliance
                   INNER JOIN tituls t ON t.id = u.titul
                    LEFT JOIN planets p ON p.id = u.place_id
                    LEFT JOIN ships s ON s.id = u.place_id
                    LEFT JOIN fleets f ON f.id = u.place_id
                    LEFT JOIN orbits_buildings ob ON ob.id = u.place_id
                    LEFT JOIN objects o ON o.id = ob.object_id
                    LEFT JOIN planets op ON op.id = ob.planet_id
                        WHERE u.login = '$login'" );

if( !$data || !isset( $data['id'] ) ) {
  admin_json( array( 'ok' => false, 'err' => 'not_found' ) );
}

$uid = intval( $data['id'] );
$pid = intval( $data['pid'] );
$sid = $data['ssid'];

if( $act === 'kill' ) {
  db_query( "UPDATE users SET status = 0, ssid = 1 WHERE id = $uid" );
  db_query( "DELETE FROM chat WHERE user_id = $uid OR to_user = $uid" );
  admin_json( array( 'ok' => true, 'act' => 'kill' ) );
}

if( $act === 'go_home' ) {
  db_query( "UPDATE users SET place_type = 1, place_id = (SELECT id FROM planets WHERE user_id = $uid) WHERE id = $uid" );
  admin_json( array( 'ok' => true, 'act' => 'go_home' ) );
}

if( $act === 'mute_w' ) {
  db_query( "UPDATE users SET mute = DATE_ADD( NOW(), INTERVAL 7 DAY ) WHERE id = $uid" );
  db_query( "DELETE FROM chat WHERE user_id = $uid" );
  admin_json( array( 'ok' => true, 'act' => 'mute_w' ) );
}

if( $act === 'mute_m' ) {
  db_query( "UPDATE users SET mute = DATE_ADD( NOW(), INTERVAL 1 MONTH ) WHERE id = $uid" );
  db_query( "DELETE FROM chat WHERE user_id = $uid" );
  admin_json( array( 'ok' => true, 'act' => 'mute_m' ) );
}

if( $act === 'enter' ) {
  setcookie( 'chat_sid', $sid );
  setcookie( 'chat_uid', $uid );
  admin_json( array( 'ok' => true, 'act' => 'enter' ) );
}

if( $act === 'pay' ) {
  $sum = admin_int( 'summ' );
  db_query( "INSERT INTO pay_log ( user_id, type, mess ) VALUES ( $uid, 1, 'Success pay MAN of $sum ID:0' )" );
  db_query( "UPDATE users SET donate = donate + $sum, credits = credits + $sum WHERE id = $uid" );
  db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $uid, 1, 'На ваш игровой счет зачислено $sum конфедератов.' )" );
  if( $pid > 0 ) {
    $ref = intval( $sum / 10 );
    db_query( "UPDATE users SET donate = donate + $ref, credits = credits + $ref WHERE id = $pid" );
    db_query( "INSERT INTO users_messages (msg_date, type,to_user,from_user,text) VALUES ( NOW(), 20, $pid, 1, 'На ваш игровой счет зачислено $ref конфедератов, это процент от зачисления одного из ваших рефералов.' )" );
  }
  admin_json( array( 'ok' => true, 'act' => 'pay', 'sum' => $sum ) );
}

if( $act === 'add' ) {
  $planet = db_fetch_val( "SELECT id FROM planets WHERE user_id = $uid", 'id' );
  $objectId = admin_int( 'object' );
  $cnt = admin_int( 'cnt', 1 );
  add_warehouse_item( 0, $planet, $objectId, $cnt );
  admin_json( array( 'ok' => true, 'act' => 'add' ) );
}

$children = array();
if( $data['child'] ) {
  $children = array_values( array_filter( explode( ',', $data['child'] ) ) );
}

$pay = db_fetch_array( "SELECT pl.log_time, pl.mess FROM pay_log pl WHERE pl.user_id = $uid AND pl.type = 1 ORDER BY pl.log_time DESC LIMIT 0,30" );
$bay = db_fetch_array( "SELECT bl.log_time, bl.log_text FROM bay_log bl WHERE bl.user_id = $uid ORDER BY bl.log_time DESC LIMIT 0,30" );
$trade = db_fetch_array( "SELECT tl.trade_time, ub.login bay_login, us.login sell_login, o.name oname, tl.object_cnt, tl.log_sum
                            FROM trade_log tl
                       LEFT JOIN users ub ON ub.id = tl.bayer_id
                       LEFT JOIN users us ON us.id = tl.seller_id
                      INNER JOIN objects o ON o.id = tl.object_id
                           WHERE tl.bayer_id = $uid OR tl.seller_id = $uid
                        ORDER BY tl.trade_time DESC LIMIT 0,50" );
$planets = db_fetch_array( "SELECT p.name,
                                   CASE d.place_type WHEN 0 THEN 'Orbit' WHEN 1 THEN 'Planet' WHEN 3 THEN 'Confederate' END type,
                                   CASE d.status WHEN 0 THEN 'Можно всем' WHEN 1 THEN 'Атаковать всех' WHEN 2 THEN 'Атаковать врагов' WHEN 3 THEN 'Атаковать не друзей' END level
                              FROM defence d
                        INNER JOIN planets p ON p.id = d.place_id
                             WHERE d.user_id = $uid" );
$ships = db_fetch_array( "SELECT s.id, s.name, s.inwar, tp.name oname,
                                 CASE s.place_type
                                   WHEN 0 THEN concat( 'Orbit ', p.name )
                                   WHEN 1 THEN concat( 'Planet ', p.name )
                                   WHEN 2 THEN concat( 'Ship ', ss.name )
                                   WHEN 3 THEN concat( o.name, ' ', op.name )
                                   WHEN 7 THEN concat( 'Star ', st.name )
                                   WHEN 8 THEN concat( 'Hyper ', s.arg1, ':', s.arg2 )
                                   ELSE concat( s.place_type, ':', s.place_id )
                                 END place
                            FROM ships s
                      INNER JOIN objects tp ON tp.id = s.object_id
                       LEFT JOIN planets p ON p.id = s.place_id
                       LEFT JOIN ships ss ON ss.id = s.place_id
                       LEFT JOIN orbits_buildings ob ON ob.id = s.place_id
                       LEFT JOIN objects o ON o.id = ob.object_id
                       LEFT JOIN planets op ON op.id = ob.planet_id
                       LEFT JOIN stars st ON st.id = s.place_id
                           WHERE s.fleet_id is null AND s.user_id = $uid" );
$fleets = db_fetch_array( "SELECT f.id, f.name, f.inwar, f.w_count, f.w_power,
                                  CASE f.place_type
                                    WHEN 0 THEN concat( 'Orbit ', p.name )
                                    WHEN 1 THEN concat( 'Planet ', p.name )
                                    WHEN 2 THEN concat( 'Ship ', ss.name )
                                    WHEN 3 THEN concat( o.name, ' ', op.name )
                                    WHEN 7 THEN concat( 'Star ', st.name, ' ', f.arg1, ':', f.arg2 )
                                    WHEN 8 THEN concat( 'Hyper ', f.arg1, ':', f.arg2 )
                                    ELSE concat( f.place_type, ':', f.place_id )
                                  END place
                             FROM fleets f
                        LEFT JOIN planets p ON p.id = f.place_id
                        LEFT JOIN ships ss ON ss.id = f.place_id
                        LEFT JOIN orbits_buildings ob ON ob.id = f.place_id
                        LEFT JOIN objects o ON o.id = ob.object_id
                        LEFT JOIN planets op ON op.id = ob.planet_id
                        LEFT JOIN stars st ON st.id = f.place_id
                            WHERE f.user_id = $uid" );

$objects = db_fetch_array( "SELECT o.class, o.name, o.id FROM objects o ORDER BY o.class, o.name" );

admin_json( array(
  'ok' => true,
  'profile' => $data,
  'children' => $children,
  'pay' => $pay ? $pay : array(),
  'bay' => $bay ? $bay : array(),
  'trade' => $trade ? $trade : array(),
  'planets' => $planets ? $planets : array(),
  'ships' => $ships ? $ships : array(),
  'fleets' => $fleets ? $fleets : array(),
  'objects' => $objects ? $objects : array(),
) );

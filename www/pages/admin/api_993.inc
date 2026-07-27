<?php

require_once './pages/admin/api_common.inc';
admin_require();

$section = admin_param( 'section', 'all' );

$out = array( 'ok' => true );

if( $section === 'all' || $section === 'total' ) {
  $out['total'] = db_fetch_array( "SELECT sum(money) credit, sum(credits) confederate FROM users u WHERE u.id > 16 AND u.status = 1" );
}
if( $section === 'all' || $section === 'ingame' ) {
  $out['ingame'] = db_fetch_array( "SELECT sum(u.money) credit, sum(u.credits) confederate
                                      FROM users u
                                INNER JOIN users_active ua ON ua.id = u.id
                                     WHERE u.id > 16 AND u.status = 1 AND DATE_ADD( ua.lastlogin, INTERVAL 14 DAY ) > NOW()" );
}
if( $section === 'all' || $section === 'bay_log' ) {
  $out['bay_log'] = db_fetch_array( "SELECT LEFT(log_time, 10) log_date, sum(IF(conf=1,summ,0)) confederats, round( sum(IF(conf=1,summ,0)) * 0.15, 2 ) real_money, sum(IF(conf=0,summ,0)) credits FROM bay_log bl WHERE bl.user_id > 15 GROUP BY log_date ORDER BY id DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'last_conf_trade' ) {
  $out['last_conf_trade'] = db_fetch_array( "SELECT bl.log_time log_time, u.login user, bl.log_text text, IF(bl.conf=1,bl.summ,0) confederats, IF(bl.conf=0,bl.summ,0) credits
                                               FROM bay_log bl
                                         INNER JOIN users u ON u.id = bl.user_id
                                              WHERE bl.user_id > 15 AND bl.conf = 1
                                           ORDER BY bl.id DESC
                                              LIMIT 0,30" );
}
if( $section === 'all' || $section === 'history' ) {
  $out['history'] = db_fetch_array( "SELECT logdate ld, credits cr, confederates cnf, confederates_all acnf, users, online, stars FROM history_log ORDER BY id DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'by_credits' ) {
  $out['by_credits'] = db_fetch_array( "SELECT login, money, credits FROM users u WHERE u.status = 1 ORDER BY money DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'by_conf' ) {
  $out['by_conf'] = db_fetch_array( "SELECT login, money, credits FROM users u WHERE u.status = 1 ORDER BY credits DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'registrant' ) {
  $out['registrant'] = db_fetch_array( "SELECT SUBSTR( register_date, 1, 10 ) Reg, COUNT( id ) cnt, SUM( IF( level < 7, 1, 0 ) ) low, SUM( IF( level >= 7, 1, 0 ) ) high, SUM( IF( level >= 42, 1, 0 ) ) fin FROM users u WHERE u.id > 15 AND u.status = 1 GROUP BY Reg ORDER BY Reg DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'last_fin' ) {
  $out['last_fin'] = db_fetch_array( "SELECT SUBSTR( register_date, 1, 10 ) Reg, SUBSTR( tutorial_time, 1, 10 ) Tutor, login, level, ref_link FROM users u WHERE level >= 42 AND u.id > 15 AND u.status = 1 ORDER BY tutorial_time DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'last_high' ) {
  $out['last_high'] = db_fetch_array( "SELECT register_date Reg, login, level, ref_link FROM users u WHERE level >= 7 AND u.id > 15 AND u.status = 1 ORDER BY register_date DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'last_low' ) {
  $out['last_low'] = db_fetch_array( "SELECT register_date Reg, login, level, ref_link FROM users u WHERE level < 7 AND u.id > 15 AND u.status = 1 ORDER BY register_date DESC LIMIT 0,20" );
}
if( $section === 'all' || $section === 'donators' ) {
  $out['donators'] = db_fetch_array( "SELECT pl.log_time, u.login, pl.mess, u.ref_link
                                        FROM pay_log pl
                                  INNER JOIN users u ON u.id = pl.user_id
                                       WHERE pl.type = 1
                                    ORDER BY pl.id DESC
                                       LIMIT 0,30" );
}

admin_json( $out );

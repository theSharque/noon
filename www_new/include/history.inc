<?php

function make_log() {
  $online = db_fetch_val( "SELECT count( u.id ) cnt
                             FROM users u
                       INNER JOIN users_active ua ON ua.id = u.id
                            WHERE u.status = 1 AND UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(ua.lastlogin) <= 60", 'cnt' );

  $data = db_fetch_row( "SELECT count( u.id ) ids, sum( u.money ) credit, sum( u.credits ) confederate
                           FROM users u
                     INNER JOIN users_active ua ON ua.id = u.id
                          WHERE u.id > 16 AND u.status = 1 AND DATE_ADD( ua.lastlogin, INTERVAL 14 DAY ) > NOW()" );

  $data2 = db_fetch_row( "SELECT count( u.id ) ids, sum( u.money ) credit, sum( u.credits ) confederate
                            FROM users u
                      INNER JOIN users_active ua ON ua.id = u.id
                           WHERE u.id > 16 AND u.status = 1" );

  $stars = db_fetch_val( "SELECT count(*) ids FROM stars", 'ids' );

  db_query( "INSERT INTO history_log ( credits, credits_all, confederates, confederates_all, users, users_all, online, stars )
                  VALUES ( '{$data['credit']}', '{$data2['credit']}', {$data['confederate']}, {$data2['confederate']}, {$data['ids']}, {$data2['ids']}, $online, $stars )" );

  return 1;
}
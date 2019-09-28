<?php

  require_once( "./include/misc.inc" );
  require_once( "./include/db.inc" );

  $uid = 24582;
  $sum = 132;

  $result = db_fetch_row( "SELECT u.level, u.lastlevel, t.premium, u.parent_id, u.meta_in, u.login, u.relid, substr( u.register_date, 1, 10 ) reg_date
                             FROM users u
                       INNER JOIN tutorials t ON t.level = u.lastlevel
                            WHERE u.id = $uid" );



        $real_sum = round( $sum * 0.15, 2 );

        $url = 'http://inetrek.com/s2s/statistic.php?type=json&partner=sharque&key=b6f0963638abc2d60cd84696a03a6562';
        $data = "[{\"uid\":$uid,\"login\":\"{$result['login']}\",\"relid\":{$result['relid']},\"date_reg\":\"{$result['reg_date']}\",\"status_order\":\"active\",\"pay\":\"$real_sum\",\"date_pay\":\"".date('Y-m-d')."\"}]";

        $options = array(
          'http' => array(
            'method'  => 'POST',
            'header' => 'Content-Type: application/x-www-form-urlencoded'.PHP_EOL,
            'content' => 'data='.$data,
          ),
        );

        $context  = stream_context_create( $options );

print_r( $url );
print_r( $options );
        $answ = file_get_contents( $url, false, $context );
print_r( $answ );

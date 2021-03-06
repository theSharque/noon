<?php

function status_quo() {
  $arr = db_fetch_array( "SELECT DISTINCT m.object_id id, m.sell_cnt, m.buy_cnt, round( o.myprice + o.myprice / 10, 2 ) myprice
                            FROM market m
                      INNER JOIN objects o ON o.id = m.object_id" );

  foreach( $arr as $item ) {
    db_query( "INSERT INTO trade_in ( ob_id, object_id, object_cnt, price )
                    VALUES ( 26, {$item['id']}, {$item['buy_cnt']}, {$item['myprice']} )
   ON DUPLICATE KEY UPDATE object_cnt = {$item['buy_cnt']}, price = {$item['myprice']}" );

    db_query( "INSERT INTO trade_out ( ob_id, object_id, object_cnt, price )
                    VALUES ( 26, {$item['id']}, {$item['sell_cnt']}, {$item['myprice']} )
   ON DUPLICATE KEY UPDATE object_cnt = {$item['sell_cnt']}, price = {$item['myprice']}" );
  }

  correct_price();

  echo "Market refresh\n";
}

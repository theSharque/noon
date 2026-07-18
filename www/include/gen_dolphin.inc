<?php

function gen_dolphin() {
  $deals = db_fetch_array( "SELECT a.object_id, pi.star_id tid, ti.object_cnt tic, ti.price tip,
                                                pu.star_id tud, tu.object_cnt tuc, tu.price tup
                              FROM ( SELECT ti.object_id, MAX( ti.price ) tip, MIN( tu.price ) tup
                                       FROM trade_in ti
                                 INNER JOIN trade_out tu ON ti.object_id = tu.object_id
                                 INNER JOIN objects o ON o.id = ti.object_id
                                      WHERE o.class IN ( 1, 2, 5, 7, 8 )
                                   GROUP BY ti.object_id
                                     HAVING MAX( ti.price ) > MIN( tu.price ) ) a
                        INNER JOIN trade_in ti ON ti.object_id = a.object_id AND ti.price = a.tip
                        INNER JOIN orbits_buildings obi ON obi.id = ti.ob_id
                        INNER JOIN planets pi ON pi.id = obi.planet_id AND pi.star_id NOT IN (SELECT arg4 FROM users_quests WHERE type = 10 AND status > 0)
                        INNER JOIN trade_out tu ON tu.object_id = a.object_id AND tu.price = a.tup
                        INNER JOIN orbits_buildings obu ON obu.id = tu.ob_id
                        INNER JOIN planets pu ON pu.id = obu.planet_id AND pu.star_id NOT IN (SELECT arg5 FROM users_quests WHERE type = 10 AND status > 0)" );

  $income = 0;
  foreach( $deals as $item ) {
    $count = ( $item['tic'] < $item['tuc'] ) ? $item['tic'] : $item['tuc'];
    $count = ( $count > 100000 ) ? 100000 : $count;
    $diff = $item['tip'] - $item['tup'];
    if( $income < $count * $diff ) {
      $bprice = $item['tip'];
      $sprice = $item['tup'];
      $income = $count * $diff;
      $t_count = $count;
      $object = $item['object_id'];
      $from = $item['tid'];
      $to = $item['tud'];
    }
  }

  if( $income >= 100 ) {
    db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id,  name,     arg1, arg2, fleet_id, shield, inwar, guard ) VALUES
                                 (9227,      $from,             7,       6, 'Dolphin',  100,  100,     NULL,   1200,     0,     0 )" );
    $sh1 = mysql_insert_id();
    add_warehouse_item( 2, $sh1, 9209, 5 );
    add_warehouse_item( 2, $sh1, 9210, 5 );

    db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id,  name,     arg1, arg2, fleet_id, shield, inwar, guard ) VALUES
                                 (9227,      $to,               7,       6, 'Dolphin',  100,  100,     NULL,   1200,     0,     0 )" );
    $sh2 = mysql_insert_id();
    add_warehouse_item( 2, $sh2, 9209, 5 );
    add_warehouse_item( 2, $sh2, 9210, 5 );

    // args: 0 - object, 1 - count, 2 - b-price, 3 - s-price, 4,5 - stars, 6,7 - ships
    db_query( "INSERT INTO users_quests ( user_id, status, type,    arg0,     arg1,    arg2,    arg3,  arg4, arg5, arg6, arg7, arg8 )
                                 VALUES (       6,      4,   10, $object, $t_count, $bprice, $sprice, $from,  $to, $sh1, $sh2, 1    )" );
  }

  return 1;
}

function gen_dropper() {
  $deals = db_fetch_array( "SELECT a.object_id, pi.star_id tid, ti.object_cnt tic, ti.price tip,
                                                pu.star_id tud, tu.object_cnt tuc, tu.price tup
                              FROM ( SELECT ti.object_id, MAX( ti.price ) tip, MIN( tu.price ) tup
                                       FROM trade_in ti
                                 INNER JOIN trade_out tu ON ti.object_id = tu.object_id
                                 INNER JOIN objects o ON o.id = ti.object_id
                                      WHERE o.class IN ( 1, 2, 5, 7, 8 )
                                   GROUP BY ti.object_id
                                     HAVING MAX( ti.price ) > MIN( tu.price ) ) a
                        INNER JOIN trade_in ti ON ti.object_id = a.object_id AND ti.price = a.tip
                        INNER JOIN orbits_buildings obi ON obi.id = ti.ob_id
                        INNER JOIN planets pi ON pi.id = obi.planet_id
                        INNER JOIN trade_out tu ON tu.object_id = a.object_id AND tu.price = a.tup
                        INNER JOIN orbits_buildings obu ON obu.id = tu.ob_id
                        INNER JOIN planets pu ON pu.id = obu.planet_id
                             WHERE ti.object_cnt < 100000 OR tu.object_cnt < 100000" );

  $favorite = 1000;
  foreach( $deals as $item ) {
    $count = ( $item['tic'] < $item['tuc'] ) ? $item['tic'] : $item['tuc'];
    $count = ( $count > 100 ) ? 100 : $count;
    $diff = $item['tip'] - $item['tup'];
    if( $count * $diff > 0 && $favorite > $count ) {
      $bprice = $item['tip'];
      $sprice = $item['tup'];
      $favorite = $count;
      $t_count = $count;
      $object = $item['object_id'];
      $from = $item['tid'];
      $to = $item['tud'];
    }
  }

  if( count( $deals ) && $favorite >= 1 ) {
    db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id,  name,     arg1, arg2, fleet_id, shield, inwar, guard ) VALUES
                                 (9010,      $from,             7,       6, 'Droper',  100,  100,     NULL,     270,     0,     0 )" );
    $sh1 = mysql_insert_id();
    add_warehouse_item( 2, $sh1, 9209, 5 );
    add_warehouse_item( 2, $sh1, 1044, 2000 );
    add_warehouse_item( 2, $sh1, 1019, 4000 );

    db_query( "INSERT INTO ships (object_id, place_id, place_type, user_id,  name,     arg1, arg2, fleet_id, shield, inwar, guard ) VALUES
                                 (9010,      $to,               7,       6, 'Droper',  100,  100,     NULL,     270,     0,     0 )" );
    $sh2 = mysql_insert_id();
    add_warehouse_item( 2, $sh2, 9209, 5 );
    add_warehouse_item( 2, $sh2, 1044, 2000 );
    add_warehouse_item( 2, $sh2, 1019, 4000 );

    // args: 0 - object, 1 - count, 2 - b-price, 3 - s-price, 4,5 - stars, 6,7 - ships
    db_query( "INSERT INTO users_quests ( user_id, status, type,    arg0,     arg1,    arg2,    arg3,  arg4, arg5, arg6, arg7, arg8 )
                                 VALUES (       6,      4,   10, $object, $t_count, $bprice, $sprice, $from,  $to, $sh1, $sh2, 2    )" );
  }

  return 1;
}

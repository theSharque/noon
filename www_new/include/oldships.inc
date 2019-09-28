<?php

  function oldships() {
    $ships = db_fetch_array( "SELECT u.id uid, s.id sid, s.name, u.place_type uplace_type, u.place_id uplace_id, p.id pid, st.conserv_id
                                FROM users u
                          INNER JOIN planets p ON p.user_id = u.id
                          INNER JOIN users_active ua ON ua.id = u.id
                          INNER JOIN ships s ON s.user_id = u.id
                          INNER JOIN ship_types st ON st.object_id = s.object_id
                               WHERE ua.lastlogin < DATE_SUB( NOW(), INTERVAL 30 DAY ) LIMIT 0,1000" );

    foreach( $ships as $ship ) {
      send_msg( 1, $ship['uid'], t( "Ваш корабль %s давно находится без движения, команда не отвечает на позывные. Силы конфедерации возвратили его на торговую станцию вашей родной планеты. Товар из трюма был выгружен на станцию, корабль законсервирован.", array( $ship['name'] ) ), 15 );

      if( $ship['uplace_type'] == 6 && $ship['uplace_id'] == $ship['sid'] ) {
        db_query( "UPDATE users SET place_type = 1, place_id = {$ship['pid']} WHERE id = {$ship['sid']}" );
      }


      db_query( "UPDATE ships s
             INNER JOIN ships s2 ON s2.id = s.place_id
                    SET s.place_type = s2.place_type,
                        s.place_id = s2.place_id,
                        s.arg1 = s2.arg1,
                        s.arg2 = s2.arg2
                  WHERE s.user_id != {$ship['uid']} AND s.place_type = 2 AND s2.id = {$ship['sid']}" );

      db_query( "UPDATE fleets f
             INNER JOIN ships s2 ON s2.id = f.place_id
                    SET f.place_type = s2.place_type,
                        f.place_id = s2.place_id,
                        f.arg1 = s2.arg1,
                        f.arg2 = s2.arg2
                  WHERE f.user_id != {$ship['uid']} AND f.place_type = 2 AND s2.id = {$ship['sid']}" );

      $items = db_fetch_array( "SELECT w.object_id, w.object_cnt
                                  FROM warehouse w
                                 WHERE w.place_type = 2 AND w.place_id = {$ship['sid']}" );

      foreach( $items as $ware ) {
        sub_warehouse_item( 2, $ship['sid'], $ware['object_id'], $ware['object_cnt'] );
        add_warehouse_item( 0, $ship['pid'], $ware['object_id'], $ware['object_cnt'] );
      }

      add_warehouse_item( 0, $ship['pid'], $ship['conserv_id'], 1 );

      db_query( "DELETE FROM ships WHERE id = {$ship['sid']}" );
    }

    return 1;
  }

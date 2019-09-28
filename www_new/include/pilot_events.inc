<?php

require_once( "include/ship_lib.inc" );

function pilot_event_all() {
  global $user;

  $microtime_start = microtime(true);

  do {
    $repeat = false;
    if( is_object( $user ) && isset( $user->uid ) > 0 ) {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, ship_id, isfleet, programm, step, user_id, event_time FROM pilot_events WHERE status = 1 AND user_id = {$user->uid} AND event_time <= NOW()" );
    } else {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, ship_id, isfleet, programm, step, user_id, event_time FROM pilot_events WHERE status = 1 AND event_time <= NOW() LIMIT 0,500" );
    }

    foreach( $events as $event ) {
      $step = $event['step'];

      if( microtime(true) - $microtime_start > 2 ) {
        return;
      }

      $commands = explode( ';', $event['programm'] );

      if( $step > count( $commands ) || !isset( $commands[$step] ) || !$commands[$step] ) {
        break;
      }

      list( $command, $arg1, $arg2 ) = array_pad( explode( ' ', $commands[$step] ), 3, 0 );

      if( wait( $event['ship_id'], $event['isfleet'] ) ) {
        switch( trim( $command ) ) {
          case 'land':
            $ret = land( $event['ship_id'], $event['isfleet'] );
            break;

          case 'takeoff':
            $ret = takeoff( $event['ship_id'], $event['isfleet'] );
            break;

          case 'dock':
            $ret = dock_station( $event['ship_id'], $event['isfleet'] );
            break;

          case 'undock':
            $ret = undock_station( $event['ship_id'], $event['isfleet'] );
            break;
  
          case 'load':
            switch( $arg1 ) {
              case 'all':
                $ret = load_all( $event['ship_id'], $event['isfleet'], $arg1, $arg2 );
                break;

              case 'full':
                $ret = load_full( $event['ship_id'], $event['isfleet'], $arg1, $arg2 );
                break;

              default:
                $ret = load_ware( $event['ship_id'], $event['isfleet'], $arg1, $arg2 );
                break;
            }
            break;
  
          case 'unload':
            if( $arg1 == 'all' ) {
              $ret = unload_all( $event['ship_id'], $event['isfleet'], $arg2, $arg2 );
            } else {
              $ret = unload_ware( $event['ship_id'], $event['isfleet'], $arg1, $arg2 );
            }
            break;
  
          case 'space':
            $ret = space( $event['ship_id'], $event['isfleet'], $arg1 );
            break;
  
          case 'hyper':
            $ret = hyper( $event['ship_id'], $event['isfleet'], $arg1 );
            break;

          case 'repeat':
            db_query( "UPDATE pilot_events SET step = 0 WHERE id = {$event['id']}" );
            $step = 0;
            $ret = false;
            continue;
        }

        if( !$ret ) {
          if( $event['isfleet'] ) {
            $name = db_fetch_val( "SELECT name FROM fleets WHERE id = {$event['ship_id']}", 'name' );
            send_msg( 1, $event['user_id'], t( "Не могу выполнить команду %s. Пилот флота %s", array( $command, $name ) ), 2, $event['event_time'] );
          } else {
            $name = db_fetch_val( "SELECT name FROM ships WHERE id = {$event['ship_id']}", 'name' );
            send_msg( 1, $event['user_id'], t( "Не могу выполнить команду %s. Пилот корабля %s", array( $command, $name ) ), 2, $event['event_time'] );
          }

          db_query( "UPDATE pilot_events SET event_time = DATE_ADD( NOW(), INTERVAL 60 SECOND ) WHERE id = {$event['id']}" );
        } else {
          if( $event['isfleet'] ) {
            $name = db_fetch_val( "SELECT name FROM fleets WHERE id = {$event['ship_id']}", 'name' );
            send_msg( 1, $event['user_id'], t( "Успешно выполнил %s. Пилот флота %s", array( $command, $name ) ), 2, $event['event_time'] );
          } else {
            $name = db_fetch_val( "SELECT name FROM ships WHERE id = {$event['ship_id']}", 'name' );
            send_msg( 1, $event['user_id'], t( "Успешно выполнил %s. Пилот корабля %s", array( $command, $name ) ), 2, $event['event_time'] );
          }

          db_query( "UPDATE pilot_events SET step = step + 1, event_time = DATE_ADD( NOW(), INTERVAL 3 SECOND ) WHERE id = {$event['id']}" );
        }
      } else {
        db_query( "UPDATE pilot_events SET event_time = DATE_ADD( NOW(), INTERVAL 10 SECOND ) WHERE id = {$event['id']}" );
      }
    }
  } while( $repeat );
}

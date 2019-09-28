<?php

function market_event_all() {
  global $user;

  $microtime_start = microtime(true);

  $repeat = false;

  do {
    if( is_object( $user ) && isset( $user->uid ) > 0 ) {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, user_id, summ, DATE_ADD( bay_date, INTERVAL 12 DAY ) event_time FROM market_events WHERE user_id = {$user->uid} AND bay_date <= DATE_SUB( NOW(), INTERVAL 14 DAY )" );
    } else {
      $events = db_fetch_array( "SELECT SQL_NO_CACHE id, user_id, summ, DATE_ADD( bay_date, INTERVAL 12 DAY ) event_time FROM market_events WHERE bay_date <= DATE_SUB( NOW(), INTERVAL 14 DAY ) LIMIT 0,500" );
    }

    foreach( $events as $item ) {

      if( microtime(true) - $microtime_start > 2 ) {
        return;
      }

      return_money( $item );
    }
  } while( $repeat );
}

function return_money( $event ) {
  db_query( "DELETE FROM market_events WHERE id={$event['id']}" );

  $back = ( $event['summ'] / 200 ) * get_book_level( 29, $event['user_id'] );
  $summ = number_format( $back, 2, '.', '' );

  if( $summ > 0 ) {
    db_query( "UPDATE users SET money = money + '$summ' WHERE id = ".$event['user_id'] );
    send_msg( 1, $event['user_id'], t( "Вы успешно осуществили биржевую операцию на сумму %s, учитывая ваш уровень маклера биржа выплачивает вам вознаграждение %s.", array( $event['summ'], $summ ) ), 2, $event['event_time'] );
  }
}

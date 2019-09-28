<?php

function books_event_all() {

  $microtime_start = microtime(true);

  $uids = db_fetch_array( "SELECT DISTINCT t.user_id FROM books_teach t WHERE t.end_time < NOW()" );

  foreach( $uids as $item ) {
    if( microtime(true) - $microtime_start > 2 ) {
      debug_it( 'Break in char events !' );
      return;
    }

    setChar( 'level', 1, $item['user_id'] );

    books_event( $item['user_id'] );
  }
}

function books_event( $uid ) {
  $learned = db_fetch_row( "SELECT t.book_id, t.id, b.name, t.end_time
                              FROM books_teach t, books b
                             WHERE b.id = t.book_id AND t.user_id = $uid AND t.end_time < NOW()" );

  if( isset( $learned['id'] ) && $learned['id'] ) {
    $old_book = db_fetch_row( "SELECT ub.level FROM users_books ub WHERE ub.book_id = ".$learned['book_id']." AND ub.user_id = $uid" );

    if( $learned['book_id'] == 20 ) {
      $lvl = get_book_level( 20, $uid );

      db_query( "UPDATE planets_buildings pb, defence d
                    SET pb.shield = 1000 * pb.level + ( 250 * pb.level * $lvl )
                  WHERE pb.planet_id = d.place_id AND d.place_type = 1 AND d.user_id = $uid AND pb.shield > 0" );
    }

    if( $old_book['level'] ) {
      db_query( "UPDATE users_books ub SET ub.level = ".($old_book['level'] + 1)." WHERE ub.book_id = ".$learned['book_id']." AND ub.user_id = $uid" );
    } else {
      db_query( "INSERT INTO users_books (user_id, book_id, level) VALUES( $uid, {$learned['book_id']}, 1 )" );
    }
    send_msg( 1, $uid, t( "Изучение науки '%s' завершено успешно.\n<u><a target='main' href='page.php?id=1%%26sp=2'>Перейти к обучению</a></u>", array( $learned['name'] ) ), 1, $learned['end_time'] );
    db_query( "DELETE FROM books_teach WHERE id={$learned['id']}" );
  }
}

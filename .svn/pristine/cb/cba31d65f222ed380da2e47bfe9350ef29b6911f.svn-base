<?php

  include( 'db.inc' );

  db_query( "DELETE FROM message WHERE status = 1 AND send_date < DATE_SUB( NOW(), INTERVAL 3 HOUR )" );
  db_query( "DELETE FROM ingame WHERE old < DATE_SUB( NOW(), INTERVAL 7 DAY )" );
  db_query( "OPTIMIZE TABLE games, gcm, ingame, message, photos, users, victims" );

  $dead = db_fetch_array( "SELECT u.id, u.login
                              FROM users u
                        INNER JOIN games g ON g.id = u.game_id
                             WHERE g.status = 2 AND ( u.ping_date IS NULL OR u.ping_date < DATE_SUB( NOW(), INTERVAL 60 MINUTE ) )" );
  foreach( $dead as $item ) {
    killPlayer( $item['id'], 3 );
  }

  $users = db_fetch_array( "SELECT u.id
                              FROM users u
                        INNER JOIN games g ON g.id = u.game_id
                             WHERE u.ping_date IS NULL OR ( g.status = 2 AND u.ping_date < DATE_SUB( NOW(), INTERVAL 5 MINUTE ) )" );
  foreach( $users as $item ) {
    sendMessage( $item['id'], 0, 6, 0, "" );
  }

  $games = db_fetch_array( "SELECT g.id, count( u.id ) users
                              FROM games g
                         LEFT JOIN users u ON u.game_id = g.id
                             WHERE g.status = 1 AND g.start_type = 1 AND g.start_date < DATE_SUB( NOW(), INTERVAL g.start_count HOUR )" );

  foreach( $games as $game ) {
    if( isset( $game['id'] ) ) {
      switch( $game['users'] ) {
        case 0:
          db_query( "DELETE FROM games WHERE id = {$game['id']}" );
          db_query( "DELETE FROM victims WHERE game_id = {$game['id']}" );
          break;

        case 1:
          db_query( "DELETE FROM games WHERE id = {$game['id']}" );
          db_query( "DELETE FROM victims WHERE game_id = {$game['id']}" );
          $player = db_fetch_row( "SELECT id FROM users WHERE game_id = {$game['id']}" );
          sendMessage( $player['id'], 0, 4, 0, "" );
          break;

        default:
          startGame( $game['id'] );
          break;
      }
    }
  }

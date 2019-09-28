<?php

  include( 'db.inc' );
  global $user;

  if( auth() ) {
    $rid = $_GET['u'];
    $type = $_GET['t'];
    $arg1 = isset( $_GET['a'] ) ? $_GET['a'] : "";
    $arg2 = isset( $_GET['a2'] ) ? $_GET['a2'] : "";

    db_safe( $rid );
    db_safe( $type );
    db_safe( $arg1 );
    db_safe( $arg2 );

// debug_it( $type." ".$rid." ".$arg1." ".$arg2 );

    $send = false;
    switch( $type ) {
      case 1: // Approve my photo
        $arg1 = $user['id'];
        $arg2 = db_fetch_val( "SELECT p.file
                                 FROM photos p
                           INNER JOIN users u ON u.photo_id = p.id
                                WHERE p.status = 1 AND u.id = {$user['id']}", 'file' );
        $send = true;
        break;

      case 2: // Approve answer
        $photo = db_fetch_row( "SELECT user_id, id FROM photos WHERE file = '$arg2'" );

        if( $photo['user_id'] ) {
          db_query( "DELETE FROM photos WHERE status IN( 0, 2 ) AND user_id = {$photo['user_id']}" );
          db_query( "UPDATE photos SET status = ".( $arg1 * 2 )." WHERE status = 1 AND id = {$photo['id']}" );
          db_query( "DELETE FROM photos WHERE status = 1 AND user_id = {$photo['user_id']}" );

          if( $arg1 == 1 && $photo['id'] ) {
            db_query( "UPDATE users SET photo_id = {$photo['id']} WHERE id = {$photo['user_id']}" );
          }

          $rid = $photo['user_id'];
          $send = true;
        }
        break;

      case 3: // Invite to game
        $test = db_fetch_val( "SELECT u.game_id FROM users u WHERE u.id = $rid", 'game_id' );

        if( $test == 0 ) {
          $arg1 = $user['game_id'];
          $arg2 = "";
          $send = true;
        }

        if( $test == $arg1 ) {
          $arg1 = $user['id'];
          $arg2 = $user['photo_url'];
          $send = true;
        }
        break;

      case 4: // Leave or close game
        $test = db_fetch_row( "SELECT u.game_id, g.admin_id, g.status
                                 FROM users u
                           INNER JOIN games g ON g.id = u.game_id
                                WHERE u.id = {$user['id']}" );

        if( $test['admin_id'] == $user['id'] && $test['status'] == 1 ) {
          $rid = array();

          $all = db_fetch_array( "SELECT u.id
                                    FROM users u
                              INNER JOIN games g ON g.id = u.game_id
                                   WHERE g.admin_id != {$user['id']} AND u.game_id = {$test['game_id']}" );

          foreach( $all as $id ) {
            $rid[] = $id;
          }

          db_query( "UPDATE users u SET game_id = 0 WHERE game_id = {$test['game_id']}" );
          db_query( "DELETE FROM games WHERE id = {$test['game_id']}" );

          if( count( $all ) ) {
            $send = true;
            $arg1 = 1;
          }
        } else {
          if( $test['status'] == 1 ) {
            $rid = $test['admin_id'];
            $arg2 = $user['login'];
            db_query( "UPDATE users u SET game_id = 0 WHERE id = {$user['id']}" );
            $send = true;
          } else {
            killPlayer( $user['id'], 3 );
            db_query( "UPDATE users u SET game_id = 0 WHERE id = {$user['id']}" );
          }
        }
        break;

      case 5: // Invite answer
        $game = db_fetch_row( "SELECT g.id, g.game_type, g.start_type, g.start_count, u.location, count( u2.id ) in_game, g.status, g.victims_count,
                                      g.admin_id
                                 FROM games g
                           INNER JOIN users u ON u.id = g.admin_id
                           INNER JOIN users u2 ON u2.game_id = g.id
                                WHERE g.id = $arg2
                             GROUP BY g.id" );

        if( $arg1 == 1 && $game['id'] ) {

          $from = explode( ':', $game['location'] );
          if( distance( $from[0], $from[1], $user['location'][0], $user['location'][1] ) < 100000 ) {
            if( $game['status'] == 2 || ( $game['start_type'] == 0 && $game['start_count'] && $game['in_game'] >= $game['start_count'] ) ) {
              sendMessage( $user['id'], 0, 7, 1, "" );
            } else {
              if( $game['game_type'] == 0 && $user['games'] < 5 ) {
                sendMessage( $user['id'], 0, 7, 3, "" );
              } else {
                db_query( "UPDATE users u SET game_id = {$game['id']} WHERE id = {$user['id']}" );

                sendMessage( $game['admin_id'], 0, 10, $game['id'], "" );
//                startGame( $game['id'] );
              }
            }
          } else {
            sendMessage( $user['id'], 0, 7, 0, "" );
          }
        }
        break;

      case 6: // ping user
        db_query( "UPDATE users SET ping_date = NOW(), location = '$arg2' WHERE id = {$user['id']}" );

        if( $user['game_status'] == 2 ) {
          $game = explode( ':', $user['game_loc'] );
          if( distance( $game[0], $game[1], $user['location'][0], $user['location'][1] ) > 200000 ) {
            killPlayer( $user['id'], 3 );
          }
        }
        break;

      case 7:
        switch( $arg1 ) {
          case 4:
            $send = true;
            break;

          case 7:
            $test = db_fetch_val( "SELECT game_id FROM users WHERE id = $rid", 'game_id' );
            if( $test == $user['game_id'] && $user['game_status'] == 1 && $user['game_admin'] == $user['id'] ) {
              db_query( "UPDATE users u SET die = 0, game_id = 0 WHERE id = $rid" );
              $send = true;
            }
            break;
        }
        break;
    
      case 8: // kill message
        $victim = db_fetch_row( "SELECT victim_id FROM victims WHERE hunter_id = {$user['id']} AND ans = '$arg2'" );
        if( $victim ) {
          killPlayer( $victim['victim_id'], 4 );
        }
        break;

      case 10:
        $game = db_fetch_row( "SELECT g.id, g.admin_id, count( u.id ) cnt
                                 FROM games g
                           INNER JOIN users u ON u.game_id = g.id
                                WHERE g.id = {$user['game_id']}" );
        if( $game['id'] == $user['game_id'] && $game['admin_id'] == $user['id'] && $game['cnt'] >= 2 ) {
          startGame( $game['id'] );
        }
        break;
    }

    if( $send ) {
      if( is_array( $rid ) ) {
        foreach( $rid as $uid ) {
          sendMessage( $uid, $user['id'], $type, $arg1, $arg2 );
        }
      } else {
        sendMessage( $rid, $user['id'], $type, $arg1, $arg2 );
      }
    }

    printOut( "err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }

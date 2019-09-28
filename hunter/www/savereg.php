<?php

  include( 'db.inc' );
  global $user;

  if( auth() && isset( $_GET['r'] ) ) {
    $gcm = $_GET['r'];
    db_safe( $gcm );

    db_query( "INSERT gcm ( user_id, gcm_id ) VALUES ( {$user[id]}, '$gcm' )
               ON DUPLICATE KEY UPDATE gcm_id = '$gcm'" );

    if( $gcm != 'null' ) {


      $messages = db_fetch_array( "SELECT m.type
                                     FROM message m
                                    WHERE m.user_id = {$user['id']} AND m.status = 1" );

      foreach( $messages as $item ) {
        $sender = curl_init();

        curl_setopt( $sender, CURLOPT_URL,"https://android.googleapis.com/gcm/send" );
        curl_setopt( $sender, CURLOPT_HTTPHEADER, array( 'Authorization:key=AIzaSyBEDM3xgIVBUmcHScCVpBwytG41ScR6ddc' ) );
        curl_setopt( $sender, CURLOPT_POST, 1 );
        curl_setopt( $sender, CURLOPT_CONNECTTIMEOUT ,3 );
        curl_setopt( $sender, CURLOPT_TIMEOUT, 20 );
        curl_setopt( $sender, CURLOPT_RETURNTRANSFER, true );
        curl_setopt( $sender, CURLOPT_POSTFIELDS, "registration_id=$gcm&collapse_key=MsgIncome&delay_while_idle=0&time_to_live=1800" );

        $server_output = curl_exec ( $sender );

// debug_it( $server_output );

        curl_close( $sender );
      }
    }

    printOut( "err=0&eof" );
  } else {
    printOut( "err=1&eof" );
  }
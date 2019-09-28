<?php

function resender() {
  db_query( "DELETE FROM city_ads WHERE log_date < DATE_SUB( now() , INTERVAL 3 HOUR )" );
  $messages = db_fetch_array( "SELECT id, order_id, ca_prx, ca_click_id, data FROM city_ads ORDER BY log_date" );

  foreach( $messages as $msg ) {

    $url = "https://cityads.ru/service/postback?order_id={$msg['order_id']}&prx={$msg['ca_prx']}&click_id={$msg['ca_click_id']}".$msg['data'];

    try {
      $ch = curl_init();
      curl_setopt( $ch, CURLOPT_URL, $url );
      curl_setopt( $ch, CURLOPT_HEADER, false );
      curl_setopt( $ch, CURLOPT_FOLLOWLOCATION, false );
      curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
      curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false );
      curl_setopt( $ch, CURLOPT_SSL_VERIFYHOST, false );
  
      $response = curl_exec( $ch );
      $xml = new SimpleXMLElement( $response );
      $code = strval( $xml->code );
    } catch(Exception $e){
    }

    if( $code == 'OK' ) {
      db_query( "DELETE FROM city_ads WHERE id = {$msg['id']}" );
    }
  }

  return 1;
}

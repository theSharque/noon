<?php

function noon_public_base_url() {
  $raw = getenv( 'PUBLIC_BASE_URL' );
  if( $raw === false || $raw === '' ) {
    return 'https://21noon.com';
  }
  return rtrim( $raw, '/' );
}

function send_resend_email( $to, $subject, $text ) {
  $apiKey = getenv( 'RESEND_API_KEY' );
  if( !$apiKey ) {
    error_log( '[email] RESEND_API_KEY not set; skipping send to ' . $to );
    return false;
  }

  $from = getenv( 'EMAIL_FROM' );
  if( $from === false || $from === '' ) {
    $from = '21noon <support@21noon.com>';
  }

  $html = nl2br( htmlspecialchars( $text, ENT_QUOTES, 'UTF-8' ) );
  $payload = json_encode( array(
    'from' => $from,
    'to' => array( $to ),
    'subject' => $subject,
    'text' => $text,
    'html' => $html,
  ) );

  $context = stream_context_create( array(
    'http' => array(
      'method' => 'POST',
      'header' => "Authorization: Bearer $apiKey\r\nContent-Type: application/json\r\n",
      'content' => $payload,
      'timeout' => 30,
      'ignore_errors' => true,
    ),
  ) );

  $response = @file_get_contents( 'https://api.resend.com/emails', false, $context );
  if( $response === false ) {
    error_log( '[email] Resend request failed for ' . $to );
    return false;
  }

  $httpCode = 0;
  if( isset( $http_response_header[0] ) && preg_match( '/\s(\d{3})\s/', $http_response_header[0], $m ) ) {
    $httpCode = (int)$m[1];
  }

  if( $httpCode < 200 || $httpCode >= 300 ) {
    error_log( '[email] Resend error ' . $httpCode . ' ' . $response );
    return false;
  }

  return true;
}

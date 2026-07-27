<?php

function admin_not_found() {
  if( !headers_sent() ) {
    http_response_code( 404 );
    header( 'Content-Type: text/html; charset=UTF-8' );
  }
  echo '<!DOCTYPE html><html><head><title>404</title></head><body></body></html>';
  exit;
}

function admin_require() {
  global $user;
  if( !is_object( $user ) || !isset( $user->admin ) || intval( $user->admin ) != 2 ) {
    admin_not_found();
  }
}

function admin_json( $data ) {
  if( !headers_sent() ) {
    header( 'Content-Type: application/json; charset=UTF-8' );
  }
  echo json_encode( $data, JSON_UNESCAPED_UNICODE );
  exit;
}

function admin_param( $name, $default = '' ) {
  if( isset( $_POST[ $name ] ) ) {
    return $_POST[ $name ];
  }
  if( isset( $_GET[ $name ] ) ) {
    return $_GET[ $name ];
  }
  return $default;
}

function admin_int( $name, $default = 0 ) {
  return intval( admin_param( $name, $default ) );
}

function admin_esc( $value ) {
  db_safe( $value );
  return $value;
}

function admin_object_classes() {
  return array(
    0 => 'system object',
    1 => 'resource',
    2 => 'product',
    3 => 'planet buildings',
    4 => 'ships',
    5 => 'minerals',
    6 => 'layouts',
    7 => 'model',
    8 => 'orbit buildings',
    9 => 'conserv ship',
  );
}

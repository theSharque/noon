<?php

function admin_gate_not_found() {
  http_response_code( 404 );
  header( 'Content-Type: text/html; charset=UTF-8' );
  echo '<!DOCTYPE html><html><head><title>404</title></head><body></body></html>';
  exit;
}

require_once './include/boot.inc';
bootup();

if( !authorization() ) {
  admin_gate_not_found();
}

global $user;

if( !is_object( $user ) || !isset( $user->admin ) || intval( $user->admin ) != 2 ) {
  admin_gate_not_found();
}

$base = __DIR__ . '/admin';
$uri = isset( $_SERVER['REQUEST_URI'] ) ? $_SERVER['REQUEST_URI'] : '/admin/';
$path = parse_url( $uri, PHP_URL_PATH );
$rel = preg_replace( '#^/admin/?#', '', $path );

if( $rel !== '' && $rel !== false && strpos( $rel, 'assets/' ) === 0 ) {
  $file = $base . '/' . $rel;
  $realBase = realpath( $base );
  $realFile = realpath( $file );
  if( $realBase && $realFile && strpos( $realFile, $realBase ) === 0 && is_file( $realFile ) ) {
    $ext = strtolower( pathinfo( $realFile, PATHINFO_EXTENSION ) );
    $types = array(
      'js' => 'application/javascript',
      'css' => 'text/css',
      'svg' => 'image/svg+xml',
      'png' => 'image/png',
      'woff2' => 'font/woff2',
      'woff' => 'font/woff',
    );
    if( isset( $types[ $ext ] ) ) {
      header( 'Content-Type: ' . $types[ $ext ] . '; charset=UTF-8' );
    }
    readfile( $realFile );
    exit;
  }
  admin_gate_not_found();
}

$index = $base . '/index.html';
if( !is_file( $index ) ) {
  admin_gate_not_found();
}

header( 'Content-Type: text/html; charset=UTF-8' );
readfile( $index );

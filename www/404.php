<?php

  if( substr( $_SERVER['REQUEST_URI'], 0, 6 ) == '/forum' ) {
    header( "HTTP/1.1 301 Moved Permanently", true, 301 );
    header( "Location: http://info.21noon.com".substr( $_SERVER['REQUEST_URI'], 6 ) );
    exit;
  } else {
    header("Status: 404 Not Found");
    exit;
  }

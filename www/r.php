<?php
  if( isset( $_SERVER['HTTP_REFERER'] ) && substr( $_SERVER['HTTP_REFERER'], 0, 17 ) == 'http://21noon.com' ) {
    header( 'Location: '.$_GET['u'] );
  }

<?php
  if( isset( $_SERVER['HTTP_REFERER'] ) && ( substr( $_SERVER['HTTP_REFERER'], 0, 18 ) == 'http://file-up.net' || substr( $_SERVER['HTTP_REFERER'], 0, 22 ) == 'http://www.file-up.net' ) ) {
    header( 'Location: '.$_GET['u'] );
  }

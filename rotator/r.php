<?php
  if( isset( $_SERVER['HTTP_REFERER'] ) && substr( $_SERVER['HTTP_REFERER'], 0, 16 ) == 'http://clixer.ru' ) {
    header( 'Location: '.$_GET['u'] );
  }

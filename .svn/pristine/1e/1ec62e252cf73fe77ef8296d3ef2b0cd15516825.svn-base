<?php

  include "./include/misc.inc";
  include "./include/db.inc";
  include "./pages/register/gensystem.page";

  $uid = $_GET['uid'];
  if( $uid && is_numeric( $uid ) ) {

    echo $uid;

    db_query( "UPDATE users SET status = 1 WHERE id = ".$uid );
    GenerateSystem( $uid );
  }

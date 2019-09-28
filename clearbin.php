<?php

  $slave = mysql_connect( ':/run/mysqld/mysqld2.sock', 'root', 'gjhnhtnm23' );
  $status = mysql_fetch_assoc( mysql_query( "SHOW SLAVE STATUS" ) );
  mysql_close( $slave );

  if( $status['Master_Log_File'] == $status['Relay_Master_Log_File'] ) {
    $master = mysql_connect( ':/run/mysqld/mysqld.sock', 'root', 'gjhnhtnm23' );
    mysql_query( "FLUSH LOGS" );
    sleep( 5 );
    mysql_query( "PURGE BINARY LOGS TO '{$status['Relay_Master_Log_File']}'" );
    mysql_close( $master );
  }

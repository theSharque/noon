<?php

function cloner() {
  db_query( "UPDATE bot_analyze SET size = size - 1" );
  db_query( "DELETE FROM bot_analyze WHERE size = 0" );

  return 1;
}

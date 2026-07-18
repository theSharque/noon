<?php

function planet_move() {
  db_query( "UPDATE planets SET rad = ( rad + ( 9 - planet_pos ) ) % 360" );

  return 1;
}

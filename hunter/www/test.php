<?php

function wps_pin_checksum( $pin ) {
  $accum = 0;

  while ($pin) {
    $accum += 3 * ($pin % 10);
    $pin = (int)($pin / 10);
    $accum += $pin % 10;
    $pin = (int)($pin / 10);
  }

  return (10 - accum % 10) % 10;
}
<?php

  require_once( "./include/boot.inc" );
  bootup();

  $title = 'Платеж удался - Полдень 21 века';
  $main_content = "<h2>Платеж завершен успешно.</h2><br><a href='javascript:top.window.close()'>Вы можете закрыть это окно браузера.</a>";
  include "./templates/big.inc";

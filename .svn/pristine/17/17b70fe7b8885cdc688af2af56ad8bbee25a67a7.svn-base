<?php

  $t = __FILE__;
  echo $t;

  $shm_key = ftok("/var/www/noon/data/www/21noon.com/test2.php", 't');
  $shm_id = shmop_open($shm_key, "c", 0644, 100);

  $shm_data = shmop_write($shm_id, "Test 2", 0);

  echo $shm_data;

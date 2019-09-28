<?php

function hallupdate() {
  db_query( "TRUNCATE TABLE halloffame" );

  db_query( "INSERT INTO halloffame
             SELECT u.id, u.login, ua.abandon top_a, ua.pirate top_p, ua.mine top_m, IFNULL( SUM( st.w_sum ), 0 ) top_f, ua.char_level top_t, ua.quest top_q, ua.trade top_r, ua.ships top_s
               FROM users u
         INNER JOIN users_active ua ON ua.id = u.id
          LEFT JOIN ships s ON s.user_id = u.id
          LEFT JOIN ship_types st ON st.object_id = s.object_id
              WHERE u.id > 16
           GROUP BY u.id" );

  return 1;
}
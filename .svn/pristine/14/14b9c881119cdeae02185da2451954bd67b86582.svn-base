<?php

function gen_quest() {
  $type = db_fetch_row( "SELECT qt.type, count(uq.id) cur_cnt, qt.cnt max_cnt, qt.name, qt.desc, qt.status, qt.arg0, qt.arg1, qt.arg2, qt.arg3, qt.arg4, qt.arg5, qt.arg6, qt.arg7, qt.arg8, qt.arg9
                           FROM quest_types qt
                      LEFT JOIN users_quests uq ON ( uq.type = qt.type OR ( qt.type = 13 AND uq.type = 14 ) ) AND uq.user_id IS NULL AND uq.status > 0
                       GROUP BY qt.type
                         HAVING cur_cnt < max_cnt
                       ORDER BY rand()
                          LIMIT 0,1" );

  if( isset( $type['type'] ) ) {
    $sql = ( "INSERT INTO users_quests ( status, type, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 )
               VALUES ( {$type['status']}, {$type['type']}, {$type['arg0']}, {$type['arg1']}, {$type['arg2']}, {$type['arg3']},
                        {$type['arg4']}, {$type['arg5']}, {$type['arg6']}, {$type['arg7']}, {$type['arg8']}, {$type['arg9']} )" );

    $seed = mt_rand();
    $sql = str_replace( '%seed%', $seed, $sql );
    db_query( $sql );
  }

  return 1;
}

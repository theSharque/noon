<?php

function optimize() {
  require_once( "include/user_clear.inc" );
  require_once( "include/return.inc" );

  return_back();
  kill_users();
  
  $db_test = db_init();
  $h = @fopen( 'locks/events.dat', 'x' );
  if( $db_test && $h ) {

    require_once( "include/cleaner.inc" );

    free_user_messages();
    free_chat();
    free_ships();
    free_quest();
    free_premium();
    free_war();
    free_stars();
    free_defence();
    free_trash();
    free_robot();

//    db_query( "DELETE FROM users WHERE lastlogin < DATE_SUB( now() , INTERVAL 24 HOUR ) AND status = 2" );
    db_query( "UPDATE users
                  SET status = 5
                WHERE id IN ( SELECT id
                                FROM users_active
                               WHERE lastlogin < DATE_SUB( now(), INTERVAL 24 HOUR ) AND status = 2 )" );

    db_query( "DELETE FROM users WHERE status = 5 AND register_date < DATE_SUB( now(), INTERVAL 72 HOUR )" );
    db_query( "DELETE FROM users_active WHERE id NOT IN ( SELECT id FROM users )" );

    db_query( "ALTER TABLE `antibot` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `books` ORDER BY `name`" );
    db_query( "ALTER TABLE `books_teach` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `buildings` ORDER BY `req_id`" );
    db_query( "ALTER TABLE `chat` ORDER BY `msgtime`" );
    db_query( "ALTER TABLE `cron` ORDER BY `period`" );
    db_query( "ALTER TABLE `defence` ORDER BY `place_id`" );
    db_query( "ALTER TABLE `enciclopedia` ORDER BY `object_id`" );
    db_query( "ALTER TABLE `fleets` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `foe` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `friend` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `info_page` ORDER BY `id` desc" );
    db_query( "ALTER TABLE `objects` ORDER BY `name`" );
    db_query( "ALTER TABLE `objects_sub` ORDER BY `object_id`" );
    db_query( "ALTER TABLE `orbits_buildings` ORDER BY `planet_id`" );
    db_query( "ALTER TABLE `orbit_events` ORDER BY `planet_id`" );
    db_query( "ALTER TABLE `planets` ORDER BY `star_id`, `planet_pos`" );
    db_query( "ALTER TABLE `planets_active` ORDER BY `id`" );
    db_query( "ALTER TABLE `planet_events` ORDER BY `planet_id`" );
    db_query( "ALTER TABLE `quest_types` ORDER BY `type`" );
    db_query( "ALTER TABLE `research` ORDER BY `from_object`" );
    db_query( "ALTER TABLE `robots` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `ship_types` ORDER BY `tactik`" );
    db_query( "ALTER TABLE `sintez` ORDER BY `res_id`" );
    db_query( "ALTER TABLE `space_events` ORDER BY `event_time`" );
    db_query( "ALTER TABLE `stars` ORDER BY `name`" );
    db_query( "ALTER TABLE `star_pos` ORDER BY `id`" );
    db_query( "ALTER TABLE `trade_in` ORDER BY `ob_id`, `object_id`" );
    db_query( "ALTER TABLE `trade_out` ORDER BY `ob_id`, `object_id`" );
    db_query( "ALTER TABLE `tutorials` ORDER BY `level`" );
    db_query( "ALTER TABLE `users` ORDER BY `login`" );
    db_query( "ALTER TABLE `users_active` ORDER BY `id`" );
    db_query( "ALTER TABLE `users_books` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `users_imp` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `users_messages` ORDER BY `to_user`, `msg_date` DESC" );
    db_query( "ALTER TABLE `users_msg_settings` ORDER BY `user_id`, `type`" );
    db_query( "ALTER TABLE `users_premium` ORDER BY `user_id`" );
    db_query( "ALTER TABLE `users_quests` ORDER BY `user_id`, `type`" );
    db_query( "ALTER TABLE `users_report` ORDER BY `user_id`, `msg_date` DESC" );

    db_query( "OPTIMIZE TABLE 2pay_log, 2pay_pays, aliance, aliance_in, antibot, bay_log, books, books_teach, bot_in, bot_out,
                              buildings, chat, cron, defence, enciclopedia, fleets, foe, friend, hints, history_log, implants,
                              info_page, market, market_events, medals_type, missile_types, objects, objects_sub, orbits_buildings,
                              orbits_make, orbits_mines, orbit_events, pay_log, place_name, planets, planets_active, planets_buildings,
                              planets_disp, planets_make, planets_mines, planet_events, planet_types, promo, quest_types, research,
                              robots, ships, ships_war, ship_types, sintez, space_events, stars, tituls, trade_in, trade_log,
                              trade_out, tutorials, u2u_quests, u2u_types, users, users_active, users_books, users_imp, users_medal,
                              users_messages, users_msg_settings, users_premium, users_quests, users_report, variables, warehouse,
                              warequest, war_events, war_log, war_online, war_test, war_places, planets_maps, orbits_map" );

    db_query( "ANALYZE TABLE 2pay_log, 2pay_pays, aliance, aliance_in, antibot, bay_log, books, books_teach, bot_in, bot_out,
                             buildings, chat, cron, defence, enciclopedia, fleets, foe, friend, hints, history_log, implants,
                             info_page, market, market_events, medals_type, missile_types, objects, objects_sub, orbits_buildings,
                             orbits_make, orbits_mines, orbit_events, pay_log, place_name, planets, planets_active, planets_buildings,
                             planets_disp, planets_make, planets_mines, planet_events, planet_types, promo, quest_types, research,
                             robots, ships, ships_war, ship_types, sintez, space_events, stars, tituls, trade_in, trade_log,
                             trade_out, tutorials, u2u_quests, u2u_types, users, users_active, users_books, users_imp, users_medal,
                             users_messages, users_msg_settings, users_premium, users_quests, users_report, variables, warehouse,
                             warequest, war_events, war_log, war_online, war_test, war_places, planets_maps, orbits_map" );

    db_query( "FLUSH QUERY CACHE" );

    fclose( $h );
    @unlink( 'locks/events.dat' );
    return 1;
  } else {
    if( file_exists( 'locks/events.dat' ) && @filemtime( 'locks/events.dat' ) + 350 < time() ) {
      @unlink( 'locks/events.dat' );
    }
  }

  return 0;
}

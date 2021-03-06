<?php

function make_prize() {
//  $prize = array( 9189, 9190, 9191, 9192, 9193, 9194 ); // 2010-2011
  $prize = array( 9315, 9316, 9317, 9318, 9319, 9320 ); // 2011-2012
//  $prize = array( 9382, 9383, 9384, 9385, 9386, 9387 ); // 2012-2013

//  $planets = array( array( 'id' => 21222, 'user_id' => 16 ) );

  $planets = db_fetch_array( "SELECT id, user_id FROM planets WHERE user_id IS NOT NULL" );

  $sys_text = t( '�������� !!! ������������ ������������������� ������ � ������ �������� �������. �������� ������ ������ ���������� ��� ��� ��� � ������� ����. ������ ������������� ������� ����������.' );
  $dm_text = t( "������, ��� ��� �����, ������� ���� ��� ���� ����������, ��� ���� � ������, ���� ������� - �� ����� � �� ����� ��� � ����, �� ������� ����� ������ ���������, ��� ����� ��� �������� �������. ���������� ������� � ������ ��� ����������, �� ������ �� ���� �� ���������.\n\nPS:������� ����� �� �������, ����������� ������� �� �������, ������� �� ���� ����������.\n��� �����." );

  debug_it( count( $planets ) );

  foreach( $planets as $item ) {
    $object = $prize[ mt_rand( 0, 5 ) ];
    db_query( "INSERT INTO warehouse ( place_type, place_id, object_id, object_cnt ) VALUES ( 0, {$item['id']}, $object, 1 )" );
    db_query( "INSERT INTO users_messages (msg_date, type, to_user, from_user, text ) VALUES ( NOW(), 20, {$item['user_id']}, 1, '$sys_text' )" );
    db_query( "INSERT INTO users_messages (msg_date, type, to_user, from_user, text ) VALUES ( NOW(), 20, {$item['user_id']}, 2, '$dm_text' )" );
  }

  debug_it( t( "��� ������� ������\n\n��� �����." ) );

  return 1;
}

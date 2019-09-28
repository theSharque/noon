<?php

function rotator_banner_list( $form, &$form_state ) {

  global $user;
  // Build the sortable table header.
  $header = array(
    'title' => array( 'data' => t('Title'), 'field' => 'b.title', 'sort' => 'asc' ),
    'sizeformat' => array( 'data' => t('Banner format'), 'field' => 'b.sizeformat' ),
    'url' => array( 'data' => t('Url'), 'field' => 'b.url' ),
    'vurl' => array( 'data' => t('Visible URL'), 'field' => 'b.vurl' ),
    'banner' => array( 'data' => t('Banner'), 'field' => 'b.filename' ),
    'user' => array( 'data' => t('User'), 'field' => 'u.name' ),
    'approve' => t( 'Approve' ),
    'decline' => t( 'Decline' ),
  );

  $query = db_select('banners', 'b');
  $query->innerJoin( 'users', 'u', 'u.uid = b.user_id' );

  $query->fields( 'b', array( 'id', 'title', 'sizeformat', 'url', 'vurl', 'filename', 'text', 'approved', 'click_cnt', 'shown', 'clicked' ) );
  $query->fields( 'u', array( 'name' ) )
    ->condition( 'b.approved', 0, '=' )
    ->extend('TableSort')
    ->orderByHeader( $header );

  $banners = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $banners as $id => $item ) {
    switch( $item->sizeformat ) {

      case '468x60' :
      case '100x100' :
        $bsrc = "<img src=http://clixer.ru/banners/".$item->filename.".dat>";
        break;

      case '200x76' :
      case 'top line' :
        $bsrc = $item->text;
        break;

      case '204x104' :
        $bsrc = "<div style='width:204px;height=104px'><img style='float:left;' src=http://clixer.ru/banners/".$item->filename.".dat>".$item->text.'</div>';
        break;
    }

    $options[$id] = array(
      'title' => l( $item->title, "banner/$id/view" ),
      'sizeformat' => $item->sizeformat,
      'url' => l( $item->url, $item->url, array( 'attributes' => array( 'target' => '_blank' ) ) ),
      'vurl' => $item->vurl,
      'banner' => $bsrc,
      'user' => $item->name,
      'approve' => l( t('Approve'), "banner_moderate/banners/$id/approve" ),
      'decline' => l( t('Decline'), "banner_moderate/banners/$id/decline" ),
    );
  }

  //Build the tableselect.
  $form['banners'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No content available.'),
  );

  return $form;
}

function rotator_approve_banner( $form, &$form_state, $id ) {

  $data = db_select( 'banners', 'b' )
    ->fields( 'b', array( 'title', 'user_id' ) )
    ->condition('id', $id, '=' )
    ->execute()
    ->fetchAssoc();
  $recv = user_load( $data['user_id'] );
  drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'ban_mod_ok', 'name' => $data['title'] ) );

  db_update('banners')
    ->fields( array( 'approved' => 1 ) )
    ->condition('id', $id, '=' )
    ->execute();

  drupal_goto( 'banner_moderate/banners' );
}

function rotator_decline_banner( $form, &$form_state, $id ) {

  $data = db_select( 'banners', 'b' )
    ->fields( 'b', array( 'title', 'user_id' ) )
    ->condition('id', $id, '=' )
    ->execute()
    ->fetchAssoc();
  $recv = user_load( $data['user_id'] );
  drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'ban_mod_err', 'name' => $data['title'] ) );

  db_update('banners')
    ->fields( array( 'approved' => 2 ) )
    ->condition('id', $id, '=' )
    ->execute();

  drupal_goto( 'banner_moderate/banners' );
}

function rotator_company_list( $form, &$form_state ) {
  global $user;

  // Build the sortable table header.
  $header = array(
    'title' => array( 'data' => t('Title'), 'field' => 'bc.title', 'sort' => 'asc' ),
    'url' => array( 'data' => t('URL'), 'field' => 'bc.url' ),
    'sizeformat' => array( 'data' => t('Banner size'), 'field' => 'bc.sizeformat' ),
    'code' => t('Code'),
    'approve' => t('Approve'),
    'decline' => t('Decline'),
  );

  $company = db_select('banner_company', 'bc')
    ->fields( 'bc', array( 'id', 'user_id', 'title', 'url', 'sizeformat', 'status', 'shown', 'clicked' ) )
    ->condition('status', 0, '=' )
    ->extend('TableSort')
    ->orderByHeader( $header )
    ->execute()
    ->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $company as $id => $item ) {
    $options[$id] = array(
      'title' => $item->title,
      'url' => l( $item->url, $item->url, array( 'attributes' => array( 'target' => '_blank' ) ) ),
      'sizeformat' => $item->sizeformat,
      'code' => md5( $item->user_id.$id ),
      'approve' => l( t('Approve'), "banner_moderate/companies/$id/approve" ),
      'decline' => l( t('Decline'), "banner_moderate/companies/$id/decline" ),
    );
  }

  //Build the tableselect.
  $form['banners'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No content available.'),
  );

  return $form;
}

function rotator_approve_compaign( $form, &$form_state, $id ) {

  $data = db_select( 'banner_company', 'bc' )
    ->fields( 'bc', array( 'title', 'user_id', 'sizeformat' ) )
    ->condition('id', $id, '=' )
    ->execute()
    ->fetchAssoc();

  $code = md5( $data['user_id'].$id );

  $src = '<div id='.$code.'></div><script charset="windows-1251" type="text/javascript" src="http://clixer.ru/d.php?c='.$code.'"></script>';

  $recv = user_load( $data['user_id'] );
  drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_mod_ok', 'name' => $data['title'], 'code' => $src ) );

  db_update('banner_company')
    ->fields( array( 'status' => 1 ) )
    ->condition('id', $id, '=' )
    ->execute();

  drupal_goto( 'banner_moderate/companies' );
}

function rotator_decline_compaign( $form, &$form_state, $id ) {

  $data = db_select( 'banner_company', 'bc' )
    ->fields( 'bc', array( 'title', 'user_id' ) )
    ->condition('id', $id, '=' )
    ->execute()
    ->fetchAssoc();
  $recv = user_load( $data['user_id'] );
  drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_mod_err', 'name' => $data['title'] ) );

  db_update('banner_company')
    ->fields( array( 'status' => 2 ) )
    ->condition('id', $id, '=' )
    ->execute();

  drupal_goto( 'banner_moderate/companies' );
}

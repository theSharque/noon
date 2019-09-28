<?php

function rotator_admin_banner_list( $form, &$form_state ) {

  global $user;

  // Build the sortable table header.
  $header = array(
    'user' => array('data' => t('User'), 'field' => 'u.name', 'sort' => 'asc'),
    'title' => array('data' => t('Title'), 'field' => 'b.title' ),
    'url' => array( 'data' => t('URL'), 'field' => 'b.url' ),
    'sizeformat' => array( 'data' => t('Banner size'), 'field' => 'b.sizeformat' ),
    'filename' => array('data' => t('File'), 'field' => 'fm.filename'),
    'click_cnt' => array('data' => t('Count'), 'field' => 'b.click_cnt'),
    'shown' => array('data' => t('Shown'), 'field' => 'b.shown'),
    'clicked' => array('data' => t('Clicked'), 'field' => 'b.clicked'),
    'ctr' => array('data' => t('CTR'), 'field' => 'ctr'),
    'approved' => array('data' => t('Approved'), 'field' => 'b.approved'),
  );

  $query = db_select( 'banners', 'b' );
  $query->innerJoin( 'users', 'u', 'u.uid = b.user_id' );
  $query->leftJoin( 'file_managed', 'fm', 'fm.fid = b.file_id' );
  $query->fields( 'b', array( 'id', 'title', 'url', 'sizeformat', 'file_id', 'approved', 'click_cnt', 'shown', 'clicked' ) );
  $query->fields( 'u', array( 'name' ) );
  $query->fields( 'fm', array( 'filename' ) );
  $query->addExpression( 'round( ( b.clicked / b.shown ) * 100, 2 )', 'ctr' );
  $query->extend('TableSort')
    ->orderByHeader( $header );

  $banners = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $banners as $id => $item ) {
    $options[$id] = array(
      'user' => $item->name,
      'title' => l( $item->title, "banner/$id/edit" ),
      'url' => l( $item->url, 'http://'.$item->url, array( 'attributes' => array( 'target' => '_blank' ) ) ),
      'sizeformat' => $item->sizeformat,
      'filename' => $item->filename,
      'click_cnt' => $item->click_cnt.' '.l( 'add', "banner/$id/add_count" ),
      'shown' => $item->shown,
      'clicked' => $item->clicked,
      'ctr' => $item->ctr.'%',
    );

    switch( $item->approved ) {
      case 1:
        $options[$id]['approved'] = t('Approved');
        break;
      case 2:
        $options[$id]['approved'] = t('Declined');
        break;

      default:
        $options[$id]['approved'] = t('Waiting');
        break;
    }
  }

  //Build the tableselect.
  $form['banners'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No content available.'),
  );

  $form['close'] = array(
    '#type' => 'submit',
    '#value' => t( 'Decline' ),
  );

  return $form;
}

function rotator_admin_banner_list_submit( $form, &$form_state ) {

  global $user;

  $ids = array();

  foreach( $form_state['values']['banners'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;

      $data = db_select( 'banners', 'b' )
        ->fields( 'b', array( 'title', 'user_id' ) )
        ->condition('id', $id, '=' )
        ->execute()
        ->fetchAssoc();
      $recv = user_load( $data['user_id'] );
      drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'ban_close', 'name' => $data['title'] ) );
    }
  }

  if( count( $ids ) ) {
    db_update('banners')
      ->fields( array(
          'approved' => 0,
        )
      )
      ->condition('id', $ids, 'IN' )
      ->execute();  
  }
}

function rotator_admin_company_list( $form, &$form_state ) {
  global $user;

  // Build the sortable table header.
  $header = array(
    'user' => array('data' => t('User'), 'field' => 'u.name', 'sort' => 'asc'),
    'title' => array( 'data' => t('Title'), 'field' => 'bc.title' ),
    'shown' => array( 'data' => t('Shown'), 'field' => 'bc.shown' ),
    'clicked' => array( 'data' => t('Clicked'), 'field' => 'bc.clicked' ),
    'ctr' => array('data' => t('CTR'), 'field' => 'ctr'),
    'commission' => array('data' => t('Commission'), 'field' => 'bc.commission'),
    'url' => array( 'data' => t('URL'), 'field' => 'bc.url' ),
    'sizeformat' => array( 'data' => t('Banner size'), 'field' => 'bc.sizeformat' ),
    'code' => t('Code'),
    'status' => array( 'data' => t('Status'), 'field' => 'bc.status' ),
  );

  $query = db_select('banner_company', 'bc');
  $query->innerJoin( 'users', 'u', 'u.uid = bc.user_id' );
  $query->fields( 'u', array( 'name' ) );
  $query->fields( 'bc', array( 'id', 'title', 'url', 'sizeformat', 'status', 'shown', 'clicked', 'commission' ) );
  $query->addExpression( 'round( ( bc.clicked / bc.shown ) * 100, 2 )', 'ctr' );
  $query->extend('TableSort')
    ->orderByHeader( $header );

  $company = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $company as $id => $item ) {
    $options[$id] = array(
      'user' => $item->name,
      'title' => l( $item->title, "company/$id/edit" ),
      'shown' => $item->shown,
      'clicked' => $item->clicked,
      'ctr' => $item->ctr.'%',
      'commission' => l( ( round( 1 - $item->commission, 2 ) * 100 ).'%', "banner_admin/$id/commission" ),
      'url' => l( $item->url, 'http://'.$item->url, array( 'attributes' => array( 'target' => '_blank' ) ) ),
      'sizeformat' => $item->sizeformat,
      'code' => ( $item->status == 1 ) ? l( 'Get code', "company/$id/code" ) : 'No code',
    );

    switch( $item->status ) {
      case 1:
        $options[$id]['status'] = t('Approved');
        break;
      case 2:
        $options[$id]['status'] = t('Declined');
        break;

      default:
        $options[$id]['status'] = t('Waiting');
        break;
    }
  }

  //Build the tableselect.
  $form['companys'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No content available.'),
  );

  $form['close'] = array(
    '#type' => 'submit',
    '#value' => t( 'Decline' ),
  );

  return $form;
}

function rotator_admin_company_list_submit( $form, &$form_state ) {

  global $user;

  $ids = array();

  foreach( $form_state['values']['companys'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;

      $data = db_select( 'banner_company', 'bc' )
        ->fields( 'bc', array( 'title', 'user_id' ) )
        ->condition('id', $id, '=' )
        ->execute()
        ->fetchAssoc();
      $recv = user_load( $data['user_id'] );
      drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_close', 'name' => $data['title'] ) );
    }
  }

  if( count( $ids ) ) {
    db_update('banner_company')
      ->fields( array(
          'status' => 0,
        )
      )
      ->condition('id', $ids, 'IN' )
      ->execute();  
  }
}

function rotator_admin_click_stat( $form, &$form_state ) {
  global $user;

  $query = db_select('banner_balance', 'bb')
    ->fields( 'bb', array( 'balance' ) )
    ->condition( 'bb.user_id', 1, '=' );
  $sys_balance = $query->execute()->fetchAssoc();

  $query = db_select('banner_balance', 'bb')
    ->condition( 'bb.user_id', 1, '!=' );
  $query->addExpression( 'SUM(balance)', 'balance' );
  $user_balance = $query->execute()->fetchAssoc();

  $query = db_select('banners', 'b')
    ->condition( 'b.user_id', 1, '=' );
  $query->addExpression( 'SUM(click_cnt)', 'click_cnt' );
  $system_banner = $query->execute()->fetchAssoc();

  $query = db_select('banners', 'b')
    ->condition( 'b.user_id', 1, '!=' );
  $query->addExpression( 'SUM(click_cnt)', 'click_cnt' );
  $user_banner = $query->execute()->fetchAssoc();

  $query = db_select('banner_log', 'bl')
    ->where( 'logdate > DATE_SUB( NOW(), INTERVAL 1 DAY )' );
  $query->addExpression( "SUM( IF( type = 'click', 1, 0 ) )", 'click_cnt' );
  $query->addExpression( "SUM( IF( type = 'view', 1, 0 ) )", 'view_cnt' );
  $today = $query->execute()->fetchAssoc();

  $form = array();

  $form['system'] = array(
    '#type' => 'item',
    '#title' => t( 'In system' ),
    '#markup' => $sys_balance['balance'],
  );

  $form['sys_banner'] = array(
    '#type' => 'item',
    '#title' => t( 'In system banner' ),
    '#markup' => $system_banner['click_cnt'],
  );

  $form['user'] = array(
    '#type' => 'item',
    '#title' => t( 'In user accounts' ),
    '#markup' => $user_balance['balance'],
  );

  $form['banner'] = array(
    '#type' => 'item',
    '#title' => t( 'In users banner' ),
    '#markup' => $user_banner['click_cnt'],
  );

  $form['total'] = array(
    '#type' => 'item',
    '#title' => t( 'Total in system' ),
    '#markup' => $sys_balance['balance'] + $user_balance['balance'] + $user_banner['click_cnt'] + $system_banner['click_cnt'],
  );

  $form['views'] = array(
    '#type' => 'item',
    '#title' => t( 'Views in last 24 hours' ),
    '#markup' => $today['view_cnt'],
  );

  $form['clicks'] = array(
    '#type' => 'item',
    '#title' => t( 'Clicks in last 24 hours' ),
    '#markup' => $today['click_cnt'],
  );

  return $form;
}

function rotator_admin_company_commission( $form, &$form_state, $company_id ) {

  global $user;

  $company = db_select('banner_company', 'bc')
    ->fields( 'bc', array( 'title', 'commission', 'user_id' ) )
    ->condition('id', $company_id, '=' )
    ->execute()
    ->fetchAssoc();

  $form['id'] = array(
    '#type' => 'value',
    '#value' => $company_id,
  );

  $form['user_id'] = array(
    '#type' => 'value',
    '#value' => $company['user_id'],
  );

  $form['msg_name'] = array(
    '#type' => 'value',
    '#value' => $company['title'],
  );

  $form['title'] = array(
    '#type' => 'item',
    '#title' => t( 'Title' ),
    '#markup' => $company['title'],
  );

  $form['commission'] = array(
    '#type' => 'textfield',
    '#title' => t( 'New commission in percent' ),
    '#default_value' => round( 1 - $company['commission'], 2 ) * 100,
    '#required' => true,
  );

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t( 'Save' ),
  );

  return $form;
}

function rotator_admin_company_commission_validate( $form, &$form_state ) {

  if( intval( $form_state['values']['commission'] ) <= 0 ) {
    form_set_error( 'error', t( 'Commission must be more than 0%' ) );
  }

  if( intval( $form_state['values']['commission'] ) > 40 ) {
    form_set_error( 'error', t( 'Commission must be less than 40%' ) );
  }
}

function rotator_admin_company_commission_submit( $form, &$form_state ) {

  $comm = number_format( round( 1 - ( $form_state['values']['commission'] / 100 ), 2 ), 2, '.', '' );
  db_update( 'banner_company' )
    ->fields( array(
        'commission' => $comm,
      )
    )
    ->condition('id', $form_state['values']['id'], '=' )
    ->execute();  

  $recv = user_load( $form_state['values']['user_id'] );
  drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'com_change', 'name' => $form_state['values']['msg_name'], 'comm' => $form_state['values']['commission'].'%' ) );

  $form_state['redirect'] = 'banner_admin/companies';
}

function rotator_admin_promo( $form, &$form_state ) {

  // Build the sortable table header.
  $header = array(
    'code' => array( 'data' => t('Code'), 'field' => 'bp.code' ),
    'percent' => array( 'data' => t('Percent'), 'field' => 'bp.percent' ),
    'comment' => array( 'data' => t('Comment'), 'field' => 'bp.comment' ),
  );

  $query = db_select( 'banner_promo', 'bp' );
  $query->fields( 'bp', array( 'id', 'code', 'percent', 'comment' ) );
  $query->extend('TableSort')
    ->orderByHeader( $header );

  $promo = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $promo as $id => $item ) {
    $options[$id] = array(
      'code' => $item->code,
      'percent' => $item->percent.'%',
      'comment' => $item->comment,
    );
  }

  $form['promos'] = array(
    '#type' => 'markup',
    '#markup' => theme_table(
      array(
        'header' => $header,
        'rows' => $options,
        'attributes' => array(),
        'sticky' => true,
        'caption' => '',
        'colgroups' => array(),
        'empty' => t("Table has no row!"),
      )
    ).theme('pager'),
  );

  $form['code'] = array(
    '#type' => 'textfield',
    '#title' => t( 'New promo code' ),
    '#default_value' => substr( md5( mt_rand( 0, 999999 ) ), 0, 16 ),
    '#required' => true,
  );

  $form['commission'] = array(
    '#type' => 'textfield',
    '#title' => t( 'New commission in percent' ),
    '#default_value' => '40',
    '#required' => true,
  );

  $form['comment'] = array(
    '#type' => 'textfield',
    '#title' => t( 'Enter any comment for this promo code' ),
    '#required' => true,
  );

  $form['close'] = array(
    '#type' => 'submit',
    '#value' => t( 'Generate' ),
  );

  return $form;
}

function rotator_admin_promo_validate( $form, &$form_state ) {

  if( intval( $form_state['values']['commission'] ) <= 0 ) {
    form_set_error( 'error', t( 'Commission must be more than 0%' ) );
  }

  if( intval( $form_state['values']['commission'] ) > 40 ) {
    form_set_error( 'error', t( 'Commission must be less than 40%' ) );
  }
}

function rotator_admin_promo_submit( $form, &$form_state ) {

  $comm = number_format( round( 1 - ( $form_state['values']['commission'] / 100 ), 2 ), 2, '.', '' );
  db_insert( 'banner_promo' )
    ->fields( array(
        'code' => $form_state['values']['code'],
        'percent' => $form_state['values']['commission'],
        'comment' => $form_state['values']['comment'],
      )
    )
    ->execute();  

  $form_state['redirect'] = 'banner_admin/promo';
}

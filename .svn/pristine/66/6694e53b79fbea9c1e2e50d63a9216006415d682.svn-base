<?php

function rotator_compaign( $form, &$form_state ) {

  global $user;

  require_once( "rotator.inc" );

  // Build the sortable table header.
  $header = array(
    'title' => array( 'data' => t('Title'), 'field' => 'bc.title', 'sort' => 'asc' ),
    'shown' => array( 'data' => t('Shown'), 'field' => 'bc.shown' ),
    'clicked' => array( 'data' => t('Clicked'), 'field' => 'bc.clicked' ),
    'ctr' => array('data' => t('CTR'), 'field' => 'ctr'),
    'commission' => array('data' => t('Commission'), 'field' => 'bc.commission'),
    'url' => array( 'data' => t('URL'), 'field' => 'bc.url' ),
    'sizeformat' => array( 'data' => t('Banner size'), 'field' => 'bc.sizeformat' ),
    'code' => t('Code'),
    'status' => array( 'data' => t('Status'), 'field' => 'bc.status' ),
  );

  $query = db_select('banner_company', 'bc')
    ->fields( 'bc', array( 'id', 'title', 'url', 'sizeformat', 'status', 'shown', 'clicked', 'commission' ) );
  $query->addExpression( 'round( ( bc.clicked / bc.shown ) * 100, 2 )', 'ctr' );
  $query->condition('user_id', $user->uid, '=' );
  $company = $query->extend('TableSort')
    ->orderByHeader( $header )
    ->execute()
    ->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $company as $id => $item ) {
    $options[$id] = array(
      'title' => l( $item->title, "company/$id/edit" ),
      'shown' => l( $item->shown, "company/$id/view_log" ),
      'clicked' => l( $item->clicked, "company/$id/click_log" ),
      'ctr' => $item->ctr.'%',
      'commission' => ( round( 1 - $item->commission, 2 ) * 100 ).'%',
      'url' => l( $item->url, 'http://'.$item->url ),
      'sizeformat' => $item->sizeformat,
      'code' => ( $item->status == 1 ) ? l( 'Get code', "company/$id/code" ) : 'No code',
    );

    switch( $item->status ) {
      case 0:
        $options[$id]['status'] = t('Waiting');
        break;
      case 1:
        $options[$id]['status'] = t('Approved');
        break;
      case 2:
        $options[$id]['status'] = t('Declined');
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

  $form['delete'] = array(
    '#type' => 'submit',
    '#value' => t( 'Delete' ),
  );

  return $form;
}

function rotator_compaign_submit( $form, &$form_state ) {

  global $user;

  $ids = array();

  foreach( $form_state['values']['banners'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;
    }
  }

  if( count( $ids ) ) {
    db_delete('banner_company')
      ->condition('user_id', $user->uid, '=' )
      ->condition('id', $ids, 'IN' )
      ->execute();  
  }
}

function rotator_compaign_edit( $form, &$form_state, $company_id = null ) {

  global $user;

  require_once( "rotator.inc" );

  $diff_size = array(
    '468x60' => '468x60',
    '100x100' => '100x100',
    '200x76' => t( 'Text 200x76' ),
    '610x76' => t( 'Text long block 200x76x3' ),
    '200x238' => t( 'Text high block 200x76x3' ),
    '200x400' => t( 'Text highest block 200x76x5' ),
    '224x104' => t( 'Tiaser 224x104' ),
    'top line' => t( 'top line' ),
  );

  $colors = array(
    0 => t( 'White' ),
    1 => t( 'Black' ),
  );

  $themes = array();

  $form['faq'] = array(
    '#markup' => l( t('Read instruction'), 'kak_dobavit_ploshadky', array( 'attributes' => array( 'target' => '_blank' ) ) ),
  );

  if( $company_id !== null ) {
    $company = db_select('banner_company', 'bc')
      ->fields( 'bc', array( 'title', 'url', 'sizeformat', 'color' ) )
      ->condition( db_or()
        ->condition( 'user_id', $user->uid, '=' )
        ->condition( intval( user_access( 'rotator admin' ) ), 1, '=' )
      )
      ->condition('id', $company_id, '=' )
      ->execute()
      ->fetchAssoc();

    $query = db_select('banner_c_theme', 'bct')
      ->fields( 'bct', array( 'theme_id' ) )
      ->condition('company_id', $company_id, '=' )
      ->execute()
      ->fetchAllAssoc( 'theme_id' );

    foreach( $query as $key => $nop ) {
      $themes[] = $key;
    }

    $form['id'] = array(
      '#type' => 'value',
      '#value' => $company_id,
    );
  }

  $form['title'] = array(
    '#type' => 'textfield',
    '#title' => t( 'Compaign title' ),
    '#default_value' => isset( $company['title'] ) ? $company['title'] : '',
    '#required' => true,
  );

  $form['url'] = array(
    '#type' => 'textfield',
    '#title' => t( 'Site URL' ),
    '#default_value' => isset( $company['url'] ) ? $company['url'] : '',
    '#required' => true,
  );

  $form['themes'] = array(
    '#type' => 'checkboxes',
    '#title' => t( 'Company theme' ),
    '#options' => $banner_themes,
    '#default_value' => $themes,
  );

  $form['sizeformat'] = array(
    '#type' => 'select',
    '#title' => t( 'Size of banner' ),
    '#required' => true,
    '#default_value' => isset( $company['sizeformat'] ) ? $company['sizeformat'] : null,
    '#options' => $diff_size,
  );

  $form['color'] = array(
    '#type' => 'select',
    '#title' => t( 'Color of text banner' ),
    '#required' => true,
    '#default_value' => isset( $company['color'] ) ? $company['color'] : 0,
    '#options' => $colors,
  );

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t( 'Save' ),
  );

  return $form;
}

function rotator_compaign_edit_submit( $form, &$form_state ) {

  global $user;

  if( substr( $form_state['values']['url'], 0, 7 ) == 'http://' ) {
    $url = substr( $form_state['values']['url'], 7 );
  } else {
    $url = $form_state['values']['url'];
  }

  $comm = 0.6;
  $fields = user_load( $user->uid );
  if( isset( $fields->field_promo['und'][0]['value'] ) ) {
    $promo = $fields->field_promo['und'][0]['value'];

    $percent = db_select( 'banner_promo', 'bp' )
      ->fields( 'bp', array( 'percent' ) )
      ->condition( 'code', $promo, '=' )
      ->execute()
      ->fetchAssoc();

    if( $percent['percent'] ) {
      $comm = number_format( round( 1 - ( $percent['percent'] / 100 ), 2 ), 2, '.', '' );
    }
  }

  if( isset( $form_state['values']['id'] ) ) {
    db_update('banner_company')
      ->fields( array(
        'title' => $form_state['values']['title'],
        'url' => $url,
        'sizeformat' => $form_state['values']['sizeformat'],
        'color' => $form_state['values']['color'],
        'user_id' => $user->uid,
        'status' => 0,
        )
      )
      ->condition( 'id', $form_state['values']['id'], '=' )
      ->execute();  

    db_delete( 'banner_c_theme' )
      ->condition('company_id', $form_state['values']['id'], '=' )
      ->execute();

    $id = $form_state['values']['id'];
  } else {
    $id = db_insert('banner_company')
      ->fields( array(
        'title' => $form_state['values']['title'],
        'url' => $url,
        'sizeformat' => $form_state['values']['sizeformat'],
        'color' => $form_state['values']['color'],
        'user_id' => $user->uid,
        'commission' => $comm,
        )
      )
      ->execute();

    $query = db_select('users', 'u');
    $query->innerJoin( 'users_roles', 'ur', 'ur.uid = u.uid' );
    $query->fields( 'u', array( 'uid', 'mail', 'language' ) )
      ->condition( 'ur.rid', 4, '=' );
    $mails = $query->execute()->fetchAllAssoc( 'uid' );

    foreach( $mails as $item ) {
      drupal_mail( 'rotator', date( 'His' ), $item->mail, $item->language, array( 'type' => 'new_site', 'name' => $user->name, 'title' => $form_state['values']['title'], 'url' => $url ) );
    }
  }

  foreach( $form_state['values']['themes'] as $key => $item ) {
    if( $key == $item ) {
      db_insert('banner_c_theme')
        ->fields( array( 'company_id', 'theme_id' ) )
        ->values( array( $id, $key ) )
        ->execute();  
    }
  }

  $form_state['redirect'] = 'company';
}

function rotator_compaign_code( $form, &$form_state, $company_id = null ) {

  global $user;

  $company = db_select('banner_company', 'bc')
    ->fields( 'bc', array( 'sizeformat' ) )
    ->condition('user_id', $user->uid, '=' )
    ->condition('id', $company_id, '=' )
    ->condition('status', 1, '=' )
    ->execute()
    ->fetchAssoc();

  $code = md5( $user->uid.$company_id );

  $form['code'] = array(
    '#type' => 'textarea',
    '#title' => t( 'Code for site' ),
    '#resizable' => false,
    '#value' => '<div id='.$code.'></div><script charset="windows-1251" type="text/javascript" src="http://clixer.ru/d.php?c='.$code.'"></script>',
    '#attributes' => array( 'readonly' => array( 'readonly' ), 'onclick' => array( 'JavaScript:this.focus();this.select();' ) ),
    '#description' => 'Copy this code to you site.',
  );

  db_query( "INSERT IGNORE INTO banner_hash ( md5, company_id, user_id ) VALUES ( '$code', $company_id, {$user->uid} )" )
    ->execute();  

  return $form;
}

function rotator_compaign_log( $form, &$form_state, $type, $id ) {
  global $user;

  if( isset( $_COOKIE['log_settings'] ) ) {
    $settings = ( unserialize( $_COOKIE['log_settings'] ) );

    $from = $settings['from'];
    $to = $settings['to'];
    $grp = $settings['grp'];
    $isdate = $settings['isdate'];
    $iscomp = $settings['iscomp'];
    $iscountry = $settings['iscountry'];
    $isip = $settings['isip'];
  } else {
    $from = array( 'year' => date( 'Y' ), 'month' => date( 'n' ), 'day' => date( 'd' ) );
    $to = array( 'year' => date( 'Y' ), 'month' => date( 'n' ), 'day' => date( 'd' ) );
    $grp = 0;
    $isdate = true;
    $iscomp = true;
    $iscountry = false;
    $isip = false;
  }

  // Build the sortable table header.
  $header = array();
  if( $isdate ) {
    $header['date'] = array('data' => t('Date'), 'field' => 'logdate', 'sort' => 'desc');
  }

  if( $iscomp ) {
    $header['banner'] = array( 'data' => t('Banner'), 'field' => 'bc.url' );
  }

  if( $iscountry ) {
    $header['country'] = array( 'data' => t('Country'), 'field' => 'name' );
  }

  if( $isip ) {
    $header['ip'] = array('data' => t('IP'), 'field' => 'bl.client_ip');
  }

  $header['count'] = array( 'data' => t('Count'), 'field' => 'cnt' );

  $from_str = date( "Y-m-d", mktime( 0, 0, 0, $from['month'], $from['day'], $from['year'] ) ).' 00:00:00';
  $to_str = date( "Y-m-d", mktime( 0, 0, 0, $to['month'], $to['day'], $to['year'] ) ).' 23:59:59';

  $query = db_select('banner_log', 'bl');
  $query->innerJoin( 'banner_company', 'bc', 'bc.id = bl.company_id' );
  $query->innerJoin( 'banners', 'b', 'b.id = bl.banner_id' );
  $query->leftJoin( 'banner_country', 'bco', 'bco.id = bl.country' );

  if( $iscomp ) {
    $query->fields( 'b', array( 'url' ) );
  }

  if( $iscountry ) {
    $query->fields( 'bco', array( 'name' ) );
  }

  if( $isip ) {
    $query->fields( 'bl', array( 'client_ip' ) );
  }

  if( $isdate ) {
    $query->addExpression( 'max( bl.logdate )', 'logdate' );
  }

  $query->addExpression( 'max( bl.id )', 'id' );
  $query->addExpression( 'count( bl.id )', 'cnt' );

  $query->condition( db_or()
          ->condition( 'bc.user_id', $user->uid, '=' )
          ->condition( intval( user_access( 'rotator admin' ) ), 1, '=' )
  );

  $query->condition( 'bl.logdate', $from_str, '>=' );
  $query->condition( 'bl.logdate', $to_str, '<' );

  if( $type == 1 ) {
    $query->condition( 'bl.type', 'view', '=' );
  } else {
    $query->condition( 'bl.type', 'click', '=' );
  }

  $query->condition( 'bl.company_id', $id, '=' );

  if( $iscomp ) {
    $query->groupBy( 'b.url' );
  }

  if( $iscountry ) {
    $query->groupBy( 'bco.name' );
  }

  if( $isip ) {
    $query->groupBy( 'bl.client_ip' );
  }

  if( $isdate ) {
    switch( $grp ) {
      case 0 : // detail
        $query->groupBy( 'bl.logdate' );
        break;

      case 1 : // day
        $query->groupBy( 'substr( bl.logdate, 1, 10 )' );
        break;

      case 2 : // month
        $query->groupBy( 'substr( bl.logdate, 1, 7 )' );
        break;

      case 3 : // year
        $query->groupBy( 'substr( bl.logdate, 1, 4 )' );
        break;
    }
  }

  $log = $query
    ->extend('TableSort')
    ->extend('PagerDefault')->limit(25)
    ->orderByHeader( $header )
    ->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $log as $id => $item ) {
    if( $isdate ) {
      $options[$id]['date'] = $item->logdate;
    }

    if( $iscomp ) {
      $options[$id]['banner'] = $item->url;
    }

    if( $iscountry ) {
      $options[$id]['country'] = $item->name;
    }

    if( $isip ) {
      $options[$id]['ip'] = $item->client_ip;
    }

    $options[$id]['count'] = $item->cnt;
  }

  $form['from'] = array(
    '#type' => 'date',
    '#title' => t('Date from'),
    '#default_value' => $from,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['to'] = array(
    '#type' => 'date',
    '#title' => t('Date to'),
    '#default_value' => $to,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['grp'] = array(
    '#type' => 'select',
    '#title' => t('Precission'),
    '#options' => array( 0 => t( 'All' ), 1 => t( 'Day' ), 2 => t( 'Month' ), 3 => t( 'Year' ) ),
    '#default_value' => $grp,
  );

  $form['isdate'] = array(
    '#type' => 'checkbox',
    '#title' => t( 'Show date' ),
    '#default_value' => $isdate,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['iscomp'] = array(
    '#type' => 'checkbox',
    '#title' => t( 'Show banner' ),
    '#default_value' => $iscomp,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['iscountry'] = array(
    '#type' => 'checkbox',
    '#title' => t( 'Show country' ),
    '#default_value' => $iscountry,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['isip'] = array(
    '#type' => 'checkbox',
    '#title' => t( 'Show IP' ),
    '#default_value' => $isip,
    '#prefix' => '<div style="display:inline-block;">',
    '#suffix' => '</div>',
  );

  $form['update'] = array(
    '#type' => 'submit',
    '#value' => t( 'Update' ),
  );

  $form['banners'] = array(
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

  return $form;
}

function rotator_compaign_log_submit( $form, &$form_state ) {
  setcookie( 'log_settings', serialize( array(
    'from' => $form_state['values']['from'],
    'to' => $form_state['values']['to'],
    'grp' => $form_state['values']['grp'],
    'isdate' => $form_state['values']['isdate'],
    'iscomp' => $form_state['values']['iscomp'],
    'iscountry' => $form_state['values']['iscountry'],
    'isip' => $form_state['values']['isip'],
  ) ) );
}

<?php

function rotator_manager( $form, &$form_state ) {

  global $user;

  // Build the sortable table header.
  $header = array(
    'title' => array('data' => t('Title'), 'field' => 'b.title', 'sort' => 'asc'),
    'url' => array( 'data' => t('URL'), 'field' => 'b.url' ),
    'sizeformat' => array( 'data' => t('Banner size'), 'field' => 'b.sizeformat' ),
    'scenario' => array('data' => t('Scenario'), 'field' => 'sc.name'),
    'click_cnt' => array('data' => t('Count'), 'field' => 'b.click_cnt'),
    'shown' => array('data' => t('Shown'), 'field' => 'b.shown'),
    'clicked' => array('data' => t('Clicked'), 'field' => 'b.clicked'),
    'ctr' => array('data' => t('CTR'), 'field' => 'ctr'),
    'approved' => array('data' => t('Approved'), 'field' => 'b.approved'),
  );

  $query = db_select('banners', 'b');
  $query->leftJoin( 'banner_scenaries', 'bs', 'bs.id = b.scenario' );
  $query->fields( 'b', array( 'id', 'title', 'url', 'sizeformat', 'file_id', 'approved', 'click_cnt', 'shown', 'clicked' ) );
  $query->fields( 'bs', array( 'name' ) );
  $query->addExpression( 'round( ( b.clicked / b.shown ) * 100, 2 )', 'ctr' );
  $query->condition( 'b.user_id', $user->uid, '=' )
    ->extend('TableSort')
    ->orderByHeader( $header );

  $banners = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $banners as $id => $item ) {
    $options[$id] = array(
      'title' => l( $item->title, "banner/$id/edit" ),
      'url' => l( $item->url, 'http://'.$item->url, array( 'attributes' => array( 'target' => '_blank' ) ) ),
      'sizeformat' => $item->sizeformat,
      'scenario' => $item->name,
      'click_cnt' => $item->click_cnt.' '.l( 'add', "banner/$id/add_count" ),
      'shown' => l( $item->shown, "banner/$id/view_log" ),
      'ctr' => $item->ctr.'%',
      'clicked' => l( $item->clicked, "banner/$id/click_log" ),
    );

    switch( $item->approved ) {
      case 1:
        $options[$id]['approved'] = l( '<img src=/play.png> '.t('Approved'), "banner/$id/pause", array( 'html' => true ) );
        break;
      case 2:
        $options[$id]['approved'] = t('Declined');
        break;
      case 3:
        $options[$id]['approved'] = l( '<img src=/pause.png> '.t('Approved'), "banner/$id/resume", array( 'html' => true ) );
        break;

      default:
        $options[$id]['approved'] = t('Waiting');
        break;
    }
  }

  $balance = db_select('banner_balance', 'bb')
    ->fields( 'bb', array( 'balance' ) )
    ->condition('user_id', $user->uid, '=' )
    ->execute()
    ->fetchAssoc();

  $form['counter'] = array(
    '#type' => 'item',
    '#title' => t( 'Available clicks count' ),
    '#markup' => $balance['balance'],
  );

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

function rotator_manager_submit( $form, &$form_state ) {

  global $user;

  $ids = array();

  foreach( $form_state['values']['banners'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;
    }
  }

  if( count( $ids ) ) {
    $banners = db_select('banners', 'b')
      ->fields( 'b', array( 'id', 'file_id', 'filename', 'click_cnt' ) )
      ->condition('user_id', $user->uid, '=' )
      ->condition('id', $ids, 'IN' )
      ->execute()
      ->fetchAllAssoc( 'id' );

    $cnt = 0;
    foreach( $banners as $id => $item ) {
      $cnt += $item->click_cnt;
      if( $item->file_id ) {
        $file = file_load( $item->file_id );
        file_delete( $file, true );
      }
    }

    db_query( 'UPDATE banner_balance
                  SET balance = balance + :cnt
                WHERE user_id = :uid',
      array( ':cnt' => $cnt, ':uid' => $user->uid )
    );

    db_delete('banners')
      ->condition('user_id', $user->uid, '=' )
      ->condition('id', $ids, 'IN' )
      ->execute();  
  }
}

function rotator_manager_edit( $form, &$form_state, $banner_id = null ) {

  global $user;

  require_once( "rotator.inc" );

  $diff_size = array(
    '468x60' => '468x60',
    '100x100' => '100x100',
    '200x76' => t( 'Text 200x76' ),
    '224x104' => t( 'Tiaser 224x104' ),
    'top line' => t( 'top line' ),
  );

  $scenaries = db_select( 'banner_scenaries', 'bs' )
    ->fields( 'bs', array( 'id', 'user_id', 'name' ) )
    ->condition( db_or()
      ->condition( 'user_id', $user->uid, '=' )
      ->condition( intval( user_access( 'rotator admin' ) ), 1, '=' )
    )
    ->execute()
    ->fetchAllAssoc( 'id' );

  $scens = array( 0 => t( 'Everywhere' ) );
  foreach( $scenaries as $item ) {
    $scens[$item->id] = $item->name;
  }

  if( $banner_id !== null ) {
    $banner = db_select('banners', 'b')
      ->fields( 'b', array( 'title', 'scenario', 'url', 'vurl', 'sizeformat', 'file_id', 'filename', 'text', 'approved', 'click_max' ) )
      ->condition( db_or()
        ->condition( 'user_id', $user->uid, '=' )
        ->condition( intval( user_access( 'rotator admin' ) ), 1, '=' )
      )
      ->condition('id', $banner_id, '=' )
      ->execute()
      ->fetchAssoc();

    $form['id'] = array(
      '#type' => 'value',
      '#value' => $banner_id,
    );

    $form['old_url'] = array(
      '#type' => 'value',
      '#value' => $banner['url'],
    );

    $form['old_vurl'] = array(
      '#type' => 'value',
      '#value' => $banner['vurl'],
    );

    $form['old_title'] = array(
      '#type' => 'value',
      '#value' => $banner['title'],
    );

    $form['old_text'] = array(
      '#type' => 'value',
      '#value' => $banner['text'],
    );
  }

  $form['faq'] = array(
    '#markup' => l( t('Read instruction'), 'kak_zapustit_reklamy', array( 'attributes' => array( 'target' => '_blank' ) ) ),
  );

  if( $banner_id === null ) {

    $form['sizeformat'] = array(
      '#type' => 'select',
      '#title' => t( 'Size of banner' ),
      '#required' => true,
      '#options' => $diff_size,
    );

    $form['scenario'] = array(
      '#type' => 'select',
      '#title' => t( 'Scenario of banner' ),
      '#required' => false,
      '#options' => $scens,
    );

    $form['title'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Banner title' ),
      '#required' => true,
    );

    $form['url'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Site URL' ),
      '#required' => true,
    );

    $form['vurl'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Visible URL' ),
      '#required' => true,
    );

    $form['text'] = array(
      '#type' => 'textfield',
      '#size' => 80,
      '#maxlength' => 80,
      '#title' => t( 'Banner text' ),
      '#required' => false,
    );

    $form['image'] = array(
      '#title' => t( 'Image' ),
      '#type' => 'managed_file',
      '#description' => t('The uploaded image will be displayed on this page using the image style choosen below. Maximum size of file is 262144 bytes.'),
      '#required' => false,
      '#upload_validators' => array(
        'file_validate_extensions' => array( 'jpg png gif' ),
        'file_validate_is_image',
        'file_validate_size' => array( 262144 ),
      ),
      '#upload_location' => 'private://user_'.$user->uid,
    );

    if( !empty( $form_state['values']['sizeformat'] ) ) {

      if( substr( $form_state['values']['url'], 0, 7 ) == 'http://' ) {
        $url = substr( $form_state['values']['url'], 7 );
      } else {
        $url = $form_state['values']['url'];
      }

      $tmp_file = file_load( $form_state['values']['image'] );

      if( is_object( $tmp_file ) ) {
        $filename = substr( $tmp_file->uri, 10 ).'" "temp';
      } else {
        $filename = '';
      }

      $form['update'] = array(
        '#type' => 'button',
        '#value' => t( 'Update preview' ),
        '#ajax' => array(
          'callback' => 'ajax_replce_banner',
          'wrapper' => 'banner_preview',
        ),
      );

      $form['banner'] = array(
        '#type' => 'item',
        '#title' => t( 'preview' ),
        '#prefix' => '<div id="banner_preview">',
        '#markup' => rotator_render_banner( $form_state['values']['sizeformat'], $url, 0, $filename, $form_state['values']['title'], $form_state['values']['text'], $form_state['values']['vurl'] ),
        '#suffix' => '</div>',
      );
    } else {
      $form['update'] = array(
        '#type' => 'button',
        '#value' => t( 'Update preview' ),
        '#ajax' => array(
          'callback' => 'ajax_replce_banner',
          'wrapper' => 'banner_preview',
        ),
      );

      $form['banner'] = array(
        '#type' => 'item',
        '#title' => t( 'preview' ),
        '#prefix' => '<div id="banner_preview">',
        '#markup' => t('Select size of banner'),
        '#suffix' => '</div>',
      );
    }

    $form['click_max'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Maximum click per 24h' ),
      '#description' => t( 'Enter 0 for unlimited' ),
      '#default_value' => isset( $form_state['values']['click_max'] ) ? $form_state['values']['click_max'] : 0,
    );
  } else {
    $form['size'] = array(
      '#type' => 'item',
      '#title' => t( 'Size of banner' ),
      '#markup' => $banner['sizeformat'],
    );

    $form['sizeformat'] = array(
      '#type' => 'value',
      '#value' => $banner['sizeformat'],
    );

    $form['scenario'] = array(
      '#type' => 'select',
      '#title' => t( 'Scenario of banner' ),
      '#required' => false,
      '#options' => $scens,
      '#default_value' => $banner['scenario'],
    );

    $form['title'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Banner title' ),
      '#default_value' => isset( $form_state['values']['title'] ) ? $form_state['values']['title'] : $banner['title'],
      '#required' => true,
    );

    $form['url'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Site URL' ),
      '#default_value' => isset( $form_state['values']['url'] ) ? $form_state['values']['url'] : $banner['url'],
      '#required' => true,
    );

    $form['vurl'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Visible URL' ),
      '#default_value' => isset( $form_state['values']['vurl'] ) ? $form_state['values']['vurl'] : $banner['vurl'],
      '#required' => true,
    );

    $form['text'] = array(
      '#type' => 'textfield',
      '#size' => 80,
      '#maxlength' => 80,
      '#title' => t( 'Banner text' ),
      '#default_value' => isset( $form_state['values']['text'] ) ? $form_state['values']['text'] : $banner['text'],
      '#required' => false,
    );

    $form['update'] = array(
      '#type' => 'button',
      '#value' => t( 'Update preview' ),
      '#ajax' => array(
        'callback' => 'ajax_replce_banner',
        'wrapper' => 'banner_preview',
      ),
    );

    $form['banner'] = array(
      '#type' => 'item',
      '#title' => t( 'preview' ),
      '#prefix' => '<div id="banner_preview">',
      '#markup' => rotator_render_banner(
        $banner['sizeformat'],
        isset( $form_state['values']['url'] ) ? $form_state['values']['url'] : $banner['url'],
        0,
        $banner['filename'],
        isset( $form_state['values']['title'] ) ? $form_state['values']['title'] : $banner['title'],
        isset( $form_state['values']['text'] ) ? $form_state['values']['text'] : $banner['text'],
        isset( $form_state['values']['vurl'] ) ? $form_state['values']['vurl'] : $banner['vurl'] ),
      '#suffix' => '</div>',
    );

    $form['click_max'] = array(
      '#type' => 'textfield',
      '#title' => t( 'Maximum click per 24h' ),
      '#description' => t( 'Enter 0 for unlimited' ),
      '#default_value' => isset( $form_state['values']['click_max'] ) ? $form_state['values']['click_max'] : $banner['click_max'],
    );
  }

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t('Save'),
  );

  return $form;
}

function ajax_replce_banner( $form, $form_state ) {
  return $form['banner'];
}

function rotator_manager_edit_validate( $form, &$form_state ) {
  if( !isset( $form_state['values']['id'] ) ) {

    switch( $form_state['values']['sizeformat'] ) {

      case '100x100' :
        $file = file_load( $form_state['values']['image'] );
        if( is_object( $file ) ) {
          $image = image_get_info( $file->uri );
          if( $image['width'] != 100 || $image['height'] != 100 ) {
            form_set_error('error', t('Image size must be exact 100x100.'));
          }
        } else {
          form_set_error('error', t('Upload image.'));
        }
        break;

      case '468x60' :
        $file = file_load( $form_state['values']['image'] );
        if( is_object( $file ) ) {
          $image = image_get_info( $file->uri );
          if( $image['width'] != 468 || $image['height'] != 60 ) {
            form_set_error('error', t('Image size must be exact 468x60.'));
          }
        } else {
          form_set_error('error', t('Upload image.'));
        }
        break;

      case '200x76' :
      case 'top line' :
        if( strlen( $form_state['values']['text'] ) == 0 ) {
          form_set_error('error', t('Enter text for banner.'));
        }
        break;

      case '224x104' :
        $file = file_load( $form_state['values']['image'] );
        if( is_object( $file ) ) {
          $image = image_get_info( $file->uri );
          if( $image['width'] != 100 || $image['height'] != 100 ) {
            form_set_error('error', t('Image size must be exact 100x100.'));
          }
        } else {
          form_set_error('error', t('Upload image.'));
        }

        if( strlen( $form_state['values']['text'] ) == 0 ) {
          form_set_error('error', t('Enter text for banner.'));
        }
        break;
    }
  }
}

function rotator_manager_edit_submit( $form, &$form_state ) {

  global $user;

  if( substr( $form_state['values']['url'], 0, 7 ) == 'http://' ) {
    $url = substr( $form_state['values']['url'], 7 );
  } else {
    $url = $form_state['values']['url'];
  }

  if( isset( $form_state['values']['id'] ) ) {
    if( $form_state['values']['url'] != $form_state['values']['old_url'] ||
        $form_state['values']['vurl'] != $form_state['values']['old_vurl'] ||
        $form_state['values']['text'] != $form_state['values']['old_text'] ||
        $form_state['values']['title'] != $form_state['values']['old_title'] ) {

      $approve = 0;
    } else {
      $approve = 1;
    }

    db_update('banners')
      ->fields( array(
          'scenario' => $form_state['values']['scenario'],
          'title' => $form_state['values']['title'],
          'url' => $url,
          'vurl' => $form_state['values']['vurl'],
          'text' => $form_state['values']['text'],
          'approved' => $approve,
          'click_max' => $form_state['values']['click_max'],
        )
      )
      ->condition('id', $form_state['values']['id'], '=' )
      ->execute();  
  } else {
    if( $form_state['values']['image'] ) {
      // Load the file via file.fid.
      $file = file_load( $form_state['values']['image'] );

      // Change status to permanent.
      $file->status = FILE_STATUS_PERMANENT;

      // Save.
      file_save($file);

      $hashname = md5( $file->fid.$file->filesize.$file->timestamp );
      $ret = file_move( $file, 'private://'.$hashname.'.dat', FILE_EXISTS_ERROR );
    } else {
      $hashname = '';
    }

    db_insert('banners')
      ->fields( array(
          'scenario' => $form_state['values']['scenario'],
          'title' => $form_state['values']['title'],
          'url' => $url,
          'vurl' => $form_state['values']['vurl'],
          'sizeformat' => $form_state['values']['sizeformat'],
          'file_id' => $form_state['values']['image'],
          'filename' => $hashname,
          'text' => $form_state['values']['text'],
          'user_id' => $user->uid,
          'approved' => 0,
          'click_max' => $form_state['values']['click_max'],
        )
      )
      ->execute();  
  }

  if( !isset( $form_state['values']['id'] ) || $approve == 0 ) {
    $query = db_select('users', 'u');
    $query->innerJoin( 'users_roles', 'ur', 'ur.uid = u.uid' );
    $query->fields( 'u', array( 'uid', 'mail', 'language' ) )
      ->condition( 'ur.rid', 4, '=' );
    $mails = $query->execute()->fetchAllAssoc( 'uid' );

    foreach( $mails as $item ) {
      drupal_mail( 'rotator', date( 'His' ), $item->mail, $item->language, array( 'type' => 'new_banner', 'name' => $user->name, 'title' => $form_state['values']['title'], 'url' => $url ) );
    }
  }

  $form_state['redirect'] = 'banner';
}

function rotator_manager_counter( $form, &$form_state, $banner_id ) {

  global $user;

  $banner = db_select('banners', 'b')
    ->fields( 'b', array( 'title', 'url', 'vurl', 'sizeformat', 'file_id', 'filename', 'text' ) )
    ->condition('user_id', $user->uid, '=' )
    ->condition('id', $banner_id, '=' )
    ->execute()
    ->fetchAssoc();

  $form['id'] = array(
    '#type' => 'value',
    '#value' => $banner_id,
  );

  $form['title'] = array(
    '#type' => 'item',
    '#title' => t( 'Title' ),
    '#markup' => $banner['title'],
  );

  $form['url'] = array(
    '#type' => 'item',
    '#title' => t( 'URL' ),
    '#markup' => $banner['url'],
  );

  $form['sizeformat'] = array(
    '#type' => 'item',
    '#title' => t( 'Size of banner' ),
    '#markup' => $banner['sizeformat'],
  );

  $form['banner'] = array(
    '#markup' => rotator_render_banner( $banner['sizeformat'], $banner['url'], 0, $banner['filename'], $banner['title'], $banner['text'], $banner['vurl'] ),
  );

  $balance = db_select('banner_balance', 'bb')
    ->fields( 'bb', array( 'balance' ) )
    ->condition('user_id', $user->uid, '=' )
    ->execute()
    ->fetchAssoc();

  $form['counter'] = array(
    '#type' => 'item',
    '#title' => t( 'Available clicks count' ),
    '#markup' => intval( $balance['balance'] ).'<br>',
  );

  $form['max_count'] = array(
    '#type' => 'value',
    '#value' => intval( $balance['balance'] ),
  );

  $form['set_count'] = array(
    '#type' => 'textfield',
    '#title' => t( 'Count of clicks to transfer' ),
    '#required' => true,
  );

  $form['add'] = array(
    '#type' => 'submit',
    '#value' => t( 'Add' ),
  );

  return $form;
}

function rotator_manager_counter_validate( $form, &$form_state ) {

  if( intval( $form_state['values']['set_count'] ) <= 0 ) {
    form_set_error( 'error', t( 'Count must be more 0.' ) );
  }

  if( intval( $form_state['values']['set_count'] ) > intval( $form_state['values']['max_count'] ) ) {
    form_set_error( 'error', t( 'Count must be less or equal %max.', array( '%max' => $form_state['values']['max_count'] ) ) );
  }
}

function rotator_manager_counter_submit( $form, &$form_state ) {

  global $user;

  db_query( 'UPDATE banner_balance SET balance = balance - :cnt WHERE user_id = :uid', array( ':cnt' => $form_state['values']['set_count'], ':uid' => $user->uid ) );
  db_query( 'UPDATE banners SET click_cnt = click_cnt + :cnt WHERE id = :bid', array( ':cnt' => $form_state['values']['set_count'], ':bid' => $form_state['values']['id'] ) );

  $form_state['redirect'] = 'banner';
}

function rotator_scenaries( $form, &$form_state ) {
  global $user;

  // Build the sortable table header.
  $header = array(
    'name' => array( 'data' => t('Name'), 'field' => 'bs.name', 'sort' => 'asc'),
    'banners' => array( 'data' => t('Banners'), 'field' => 'bcnt' ),
  );

  $query = db_select( 'banner_scenaries', 'bs' );
  $query->leftJoin( 'banners', 'b', 'b.scenario = bs.id' );
  $query->fields( 'bs', array( 'id', 'name' ) );
  $query->addExpression( 'COUNT( b.id )', 'bcnt' );
  $query->condition( 'bs.user_id', $user->uid, '=' )
    ->groupBy('bs.id')
    ->extend('TableSort')
    ->orderByHeader( $header );

  $scenaries = $query->execute()->fetchAllAssoc( 'id' );

  $options = array();

  foreach( $scenaries as $id => $item ) {
    $options[$id] = array(
      'name' => l( $item->name, "banner/$id/scenario_edit" ),
      'banners' => $item->bcnt,
    );
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

function rotator_scenaries_submit( $form, &$form_state ) {
  global $user;

  $ids = array();

  foreach( $form_state['values']['banners'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;
    }
  }

  if( count( $ids ) ) {
    db_delete('banner_scenaries')
      ->condition('user_id', $user->uid, '=' )
      ->condition('id', $ids, 'IN' )
      ->execute();  
  }
}

function rotator_scenario_edit( $form, &$form_state, $scenario_id = null ) {

  global $user;

  $themes = array();

  require_once( "rotator.inc" );

  if( $scenario_id !== null ) {

    $scenario = db_select('banner_scenaries', 'bs')
      ->fields( 'bs', array( 'name' ) )
      ->condition('user_id', $user->uid, '=' )
      ->condition('id', $scenario_id, '=' )
      ->execute()
      ->fetchAssoc();

    $query = db_select('banner_s_theme', 'bst')
      ->fields( 'bst', array( 'theme_id' ) )
      ->condition('scenario_id', $scenario_id, '=' )
      ->execute()
      ->fetchAllAssoc( 'theme_id' );

    foreach( $query as $key => $nop ) {
      $themes[] = $key;
    }

    $form['id'] = array(
      '#type' => 'value',
      '#value' => $scenario_id,
    );
  }

  $form['faq'] = array(
    '#markup' => l( t('Read instruction'), 'kak_zapustit_reklamy', array( 'attributes' => array( 'target' => '_blank' ) ) ),
  );

  $form['name'] = array(
    '#type' => 'textfield',
    '#title' => t( 'Scenario name' ),
    '#default_value' => isset( $scenario['name'] ) ? $scenario['name'] : null,
    '#required' => true,
  );

  $form['themes'] = array(
    '#type' => 'checkboxes',
    '#title' => t( 'Site theme' ),
    '#options' => $banner_themes,
    '#default_value' => $themes,
  );

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t( 'Save' ),
  );

  return $form;
}

function rotator_scenario_edit_submit( $form, &$form_state ) {
  global $user;

  if( isset( $form_state['values']['id'] ) ) {

    db_update('banner_scenaries')
      ->fields( array(
          'name' => $form_state['values']['name'],
        )
      )
      ->condition('id', $form_state['values']['id'], '=' )
      ->execute();  

    db_delete( 'banner_s_theme' )
      ->condition('scenario_id', $form_state['values']['id'], '=' )
      ->execute();

    $id = $form_state['values']['id'];
  } else {
    $id = db_insert('banner_scenaries')
      ->fields( array(
          'name' => $form_state['values']['name'],
          'user_id' => $user->uid,
        )
      )
      ->execute();  
  }

  foreach( $form_state['values']['themes'] as $key => $item ) {
    if( $key == $item ) {
      db_insert('banner_s_theme')
        ->fields( array( 'scenario_id', 'theme_id' ) )
        ->values( array( $id, $key ) )
        ->execute();  
    }
  }

  $form_state['redirect'] = 'banner/scenaries';
}

function rotator_log( $form, &$form_state, $type, $id ) {
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
    $header['company'] = array( 'data' => t('Company'), 'field' => 'url' );
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
    $query->fields( 'bc', array( 'url' ) );
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
          ->condition( 'b.user_id', $user->uid, '=' )
          ->condition( intval( user_access( 'rotator admin' ) ), 1, '=' )
  );

  $query->condition( 'bl.logdate', $from_str, '>=' );
  $query->condition( 'bl.logdate', $to_str, '<' );

  if( $type == 1 ) {
    $query->condition( 'bl.type', 'view', '=' );
  } else {
    $query->condition( 'bl.type', 'click', '=' );
  }

  $query->condition( 'bl.banner_id', $id, '=' );

  if( $iscomp ) {
    $query->groupBy( 'bc.url' );
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
      $options[$id]['company'] = $item->url;
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
    '#title' => t( 'Show company' ),
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
    '#prefix' => '<div style="display:block;">',
    '#suffix' => '</div>',
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

function rotator_log_submit( $form, &$form_state ) {
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

function rotator_pause( $form, &$form_state, $id ) {
  global $user;

  db_update('banners')
    ->fields( array( 'approved' => 3 ) )
    ->condition('id', $id, '=' )
    ->condition('user_id', $user->uid, '=' )
    ->condition('approved', 1, '=' )
    ->execute();

  drupal_goto( 'banner' );
}

function rotator_resume( $form, &$form_state, $id ) {
  global $user;

  db_update('banners')
    ->fields( array( 'approved' => 1 ) )
    ->condition('id', $id, '=' )
    ->condition('user_id', $user->uid, '=' )
    ->condition('approved', 3, '=' )
    ->execute();

  drupal_goto( 'banner' );
}

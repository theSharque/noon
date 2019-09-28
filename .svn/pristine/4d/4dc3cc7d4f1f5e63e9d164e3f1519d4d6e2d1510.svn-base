<?php

function auction_admin_page( $form, &$form_state ) {

  global $user;

  // Build the sortable table header.
  $header = array(
    'status' => array('data' => t('Status'), 'field' => 'a.status', 'sort' => 'asc'),
    'start_date' => array( 'data' => t('Start date'), 'field' => 'a.start_date' ),
    'end_date' => array( 'data' => t('End date'), 'field' => 'a.end_date' ),
    'name' => array( 'data' => t('Name'), 'field' => 'a.name' ),
    'price' => array( 'data' => t('Price'), 'field' => 'a.price' ),
    'win_name' => array( 'data' => t('Winner'), 'field' => 'u.name' ),
  );

  $query = db_select('auction', 'a');
  $query->leftJoin( 'users', 'u', 'a.winner = u.uid' );
  $query->fields( 'a', array( 'aid', 'status', 'start_date', 'end_date', 'name', 'price', 'winner' ) );
  $query->fields( 'u', array( 'name' ) );
  $query->extend('TableSort')->orderByHeader( $header );

  $auctions = $query->execute()->fetchAllAssoc( 'aid' );

  $options = array();

  foreach( $auctions as $id => $item ) {
    $options[$id] = array(
      'status' => $item->status,
      'start_date' => $item->start_date,
      'end_date' => $item->end_date,
      'name' => l( $item->name, "auction/$id/edit" ),
      'price' => $item->price,
      'win_name' => l( $item->u_name, 'user/'.$item->winner ),
    );

    switch( $item->status ) {

      case 0:
        $options[$id]['status'] = t('Deleted');
        break;

      case 1:
        $options[$id]['status'] = t('Active');
        break;
    }
  }

  //Build the tableselect.
  $form['auctions'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No content available.'),
  );

  $form['close'] = array(
    '#type' => 'submit',
    '#value' => t( 'Close' ),
  );

  $form['open'] = array(
    '#type' => 'submit',
    '#value' => t( 'Open' ),
  );

  return $form;
}

function auction_admin_page_submit( $form, &$form_state ) {
  $ids = array();

  foreach( $form_state['values']['auctions'] as $id ) {
    if( $id != 0 ) {
      $ids[] = $id;
    }
  }

  if( count( $ids ) ) {

    if( $form_state['values']['op'] == $form_state['values']['close'] ) {
      $status = 0;
    } else {
      $status = 1;
    }

    db_update('auction')
      ->fields( array(
          'status' => $status,
        )
      )
      ->condition( 'aid', $ids, 'IN' )
      ->execute();  
  }
}

function auction_edit( $form, &$form_state, $id = null ) {

  global $user;

  if( $id ) {
    $query = db_select( 'auction', 'a' );
    $query->fields( 'a', array( 'aid', 'name', 'full_text', 'img0', 'img1', 'img2', 'img3', 'img4', 'start_date', 'main_time', 'add_step', 'price', 'stepup' ) );
    $query->condition( 'a.aid', $id, '=' );
    $auction = $query->execute()->fetchAssoc();

    $form['id'] = array(
      '#type' => 'value',
      '#value' => $id,
    );

    for( $i = 0; $i < 5; $i++ ) {
      if( $auction['img'.$i] ) {
        $file = file_load( $auction['img'.$i] );
        $file->status = 0;
        file_save($file);
      }
    }
  }

  $form['name'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 128,
    '#title' => t( 'Auction name' ),
    '#default_value' => $id ? $auction['name'] : null,
    '#required' => true,
  );

  $form['full_text'] = array(
    '#type' => 'textarea',
    '#title' => t('Enter description of this lot.'),
    '#default_value' => $id ? $auction['full_text'] : null,
    '#rows' => 7,
    '#required' => true,
  );

  $form['main_time'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 9,
    '#title' => t( 'Main time in hours' ),
    '#default_value' => $id ? $auction['main_time'] : null,
    '#required' => true,
  );

  $form['add_step'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 9,
    '#title' => t( 'Time added after each last bet in minutes' ),
    '#default_value' => $id ? $auction['add_step'] : null,
    '#required' => true,
  );

  $form['price'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 9,
    '#title' => t( 'Start price (usaly equal one step)' ),
    '#default_value' => $id ? $auction['price'] : null,
    '#required' => true,
  );

  $form['stepup'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 9,
    '#title' => t( 'Step price for each bid' ),
    '#default_value' => $id ? $auction['stepup'] : null,
    '#required' => true,
  );

  $form['start_date'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 19,
    '#title' => t('Start date of auction with this lot. In format YYYY-MM-DD HH:MM:SS'),
    '#default_value' => $id ? $auction['start_date'] : null,
    '#required' => true,
  );

  $form['img0'] = array(
    '#title' => t( 'Image' ),
    '#type' => 'managed_file',
    '#default_value' => $id ? $auction['img0'] : null,
    '#required' => false,
    '#upload_location' => 'public://',
  );

  $form['img1'] = array(
    '#title' => t( 'Image' ),
    '#type' => 'managed_file',
    '#default_value' => $id ? $auction['img1'] : null,
    '#required' => false,
    '#upload_location' => 'public://',
  );

  $form['img2'] = array(
    '#title' => t( 'Image' ),
    '#type' => 'managed_file',
    '#default_value' => $id ? $auction['img2'] : null,
    '#required' => false,
    '#upload_location' => 'public://',
  );

  $form['img3'] = array(
    '#title' => t( 'Image' ),
    '#type' => 'managed_file',
    '#default_value' => $id ? $auction['img3'] : null,
    '#required' => false,
    '#upload_location' => 'public://',
  );

  $form['img4'] = array(
    '#title' => t( 'Image' ),
    '#type' => 'managed_file',
    '#default_value' => $id ? $auction['img4'] : null,
    '#required' => false,
    '#upload_location' => 'public://',
  );

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t( 'Save' ),
  );

  return $form;
}

function auction_edit_submit( $form, &$form_state ) {

  global $user;

  for( $i = 0; $i < 5; $i++ ) {
    if( $form_state['values']['img'.$i] ) {
      $file = file_load( $form_state['values']['img'.$i] );
      $file->status = FILE_STATUS_PERMANENT;
      file_save($file);
    }
  }

  if( $form_state['values']['id'] != null ) {
    db_update('auction')
      ->fields( array(
          'name' => $form_state['values']['name'],
          'full_text' => $form_state['values']['full_text'],
          'start_date' => $form_state['values']['start_date'],
          'main_time' => $form_state['values']['main_time'],
          'add_step' => $form_state['values']['add_step'],
          'stepup' => $form_state['values']['stepup'],
          'price' => $form_state['values']['price'],
          'img0' => $form_state['values']['img0'],
          'img1' => $form_state['values']['img1'],
          'img2' => $form_state['values']['img2'],
          'img3' => $form_state['values']['img3'],
          'img4' => $form_state['values']['img4'],
        )
      )
      ->condition('aid', $form_state['values']['id'], '=' )
      ->execute();  
  } else {
    db_insert('auction')
      ->fields( array(
          'name' => $form_state['values']['name'],
          'full_text' => $form_state['values']['full_text'],
          'start_date' => $form_state['values']['start_date'],
          'main_time' => $form_state['values']['main_time'],
          'add_step' => $form_state['values']['add_step'],
          'stepup' => $form_state['values']['stepup'],
          'price' => $form_state['values']['price'],
          'img0' => $form_state['values']['img0'],
          'img1' => $form_state['values']['img1'],
          'img2' => $form_state['values']['img2'],
          'img3' => $form_state['values']['img3'],
          'img4' => $form_state['values']['img4'],
        )
      )
      ->execute();  
  }

  $form_state['redirect'] = 'auction';
}

function auction_page( $form, &$form_state ) {

  global $user;

  $query = db_select( 'auction', 'a' );
  $query->fields( 'a', array( 'aid', 'name', 'full_text', 'img0', 'img1', 'img2', 'img3', 'img4', 'start_date', 'end_date', 'main_time', 'winner', 'price' ) );
  $query->addExpression( 'UNIX_TIMESTAMP( DATE_ADD( start_date, INTERVAL main_time HOUR ) ) - UNIX_TIMESTAMP( NOW() )', 'est_time' );
  $query->addExpression( 'UNIX_TIMESTAMP( end_date ) - UNIX_TIMESTAMP( NOW() )', 'end_time' );
  $query->addExpression( 'UNIX_TIMESTAMP( start_date ) - UNIX_TIMESTAMP( NOW() )', 'before_time' );
  $query->addExpression( 'IF( NOW() > start_date, 1, 0 )', 'active' );
  $query->condition( 'a.status', 1, '=' );
  $query->orderBy( 'start_date', 'ASC' );
  $auction = $query->execute()->fetchAssoc();

  $query = db_select( 'users_money', 'um' );
  $query->fields( 'um', array( 'money', 'published' ) );
  $query->condition( 'um.uid', $user->uid, '=' );
  $money = $query->execute()->fetchAssoc();

  $form['id'] = array(
    '#type' => 'value',
    '#value' => $auction['aid'],
  );

  drupal_set_title( $auction['name'] );

  $thumbs = '<div id="thumbs"><ul class="thumbs noscript">';
  for( $i = 0; $i < 5; $i++ ) {
    if( $auction['img'.$i] > 0 ) {
      $mini = image_style_url( 'mini', file_load( $auction['img'.$i] )->uri );
      $large = image_style_url( 'large', file_load( $auction['img'.$i] )->uri );
      $thumbs .= '        <li>
            <a class="thumb" name="optionalCustomIdentifier" href="'.$large.'">
                <img src="'.$mini.'" alt="your image title again for graceful degradation" />
            </a>
        </li>';

    }
  }
  $thumbs .= '</ul></div>';

  $form['images'] = array(
    '#type' => 'item',
    '#markup' => '<div id="slideshow"></div><div id="pics">'.$thumbs.'</div>',
  );

  $form['text'] = array(
    '#type' => 'item',
    '#markup' => $auction['full_text'],
  );

  if( $auction['active'] == 0 ) {
    $form['start_date'] = array(
      '#type' => 'item',
      '#title' => t('Start date'),
      '#markup' => $auction['start_date'],
    );
  }

  if( !$money['published'] ) {
    $form['share'] = array(
      '#type' => 'item',
      '#title' => t( 'Before first bid you need to click like and share!' ),
      '#markup' => "<div id='vk_clean'><div id='vk_btn' class='vk_clean'></div></div>",
    );

    $vk_title = $auction['name'];
    $vk_desc = t( "Price: !price$", array( '!price' => $auction['price'] ) );

    drupal_add_js( "VK.Widgets.Like( 'vk_btn', {
      type: 'full',
      pageUrl: 'http://up-it.org/lot',
      pageTitle: '$vk_title',
      width: 200,
      pageDescription: '$vk_desc',
      pageImage: '".image_style_url( 'large', file_load( $auction['img0'] )->uri )."',
      verb: 1
      },
      {$auction['aid']}
    );

    VK.Observer.subscribe( 'widgets.like.shared', function( likeCount ) {
      jQuery.ajax({
        url: '/bidder',
        success: function(s,x){
          jQuery.ajax({
            url: '',
            context: document.body,
            success: function(s,x){
              jQuery(this).html(s);
            }
          });
        }
      });
    });", array( 'type' => 'inline', 'scope' => 'footer' ) );
  }

  $form['price'] = array(
    '#type' => 'item',
    '#title' => t('Current price'),
    '#markup' => $auction['price'].'$',
    '#prefix' => '<div id="bid_refresh">',
  );

  if( $auction['active'] == 0 ) {
    $form['countdown'] = array(
      '#type' => 'item',
      '#title' => t('Auction start countdown'),
      '#markup' => '<div id="jquery-countdown-timer"></div><div id="last_winner"></div>',
    );

    if( $money['money'] < $auction['price'] ) {
      $form['bid'] = array(
        '#type' => 'button',
        '#value' => t( 'Add money to account' ),
      );
    } else {
      $form['bid'] = array(
        '#type' => 'button',
        '#value' => t( 'Make bid !summ$', array( '!summ' => $auction['price'] ) ),
        '#disabled' => true,
        '#ajax' => array(
          'callback' => 'ajax_bid_refresh',
          'wrapper' => 'bid_refresh',
        ),
      );
    }

    drupal_add_js( 'jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) + '.$auction['before_time'].' } } );', 'inline' );
  } else {
    if( $auction['winner'] ) {
      if( $auction['winner'] == $user->uid ) {
        $wdiv = '<div id="win_green">'.t('You are in winner.').'</div>';
      } else {
        $wuser = user_load( $auction['winner'] );

        $name = '';
        foreach( explode( ' ', $wuser->name ) as $part ) {
          $name .= str_pad( substr( $part, 0, 2 ), strlen( $part ), '*' ).' ';
        }

        $wdiv = '<div id="win_red">'.t('Winner is %name.', array( '%name' => $name ) ).'</div>';
      }
    } else {
      $wdiv = '<div id="win_green">'.t('Nobody - make a bid!').'</div>';
    }

    if( $auction['est_time'] > 0 || $auction['end_time'] > 0 ) {
      if( $auction['est_time'] > $auction['end_time'] ) {
        $form['js'] = array(
          '#markup' => '<script>jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) + '.$auction['est_time'].' } } );</script>',
        );

      } else {
        $form['js'] = array(
          '#markup' => '<script>jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) + '.$auction['end_time'].' } } );</script>',
        );
      }

      $form['countdown'] = array(
        '#type' => 'item',
        '#title' => t('Auction end countdown, main time'),
        '#markup' => '<div id="jquery-countdown-timer"></div>'.$wdiv,
      );

      if( $money['money'] < $auction['price'] ) {
        $form['bid'] = array(
          '#type' => 'button',
          '#value' => t( 'Add money to account' ),
        );
      } else {
        $form['bid'] = array(
          '#type' => 'button',
          '#value' => t( 'Make bid !summ$', array( '!summ' => $auction['price'] ) ),
          '#disabled' => !$money['published'] || $auction['winner'] == $user->uid || ( $auction['est_time'] <= 0 && $auction['end_time'] <= 0 ),
          '#ajax' => array(
            'callback' => 'ajax_bid_make',
            'wrapper' => 'bid_refresh',
          ),
        );
      }
    } else {
      $form['end_date'] = array(
        '#type' => 'item',
        '#title' => t('End date'),
        '#markup' => $auction['end_date'],
      );

      $form['js'] = array(
        '#markup' => '<script>jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) } } );</script>',
      );
    }
  }

  $form['update'] = array(
    '#type' => 'button',
    '#value' => t( 'Update' ),
    '#disabled' => ( $auction['est_time'] <= 0 && $auction['end_time'] <= 0 ),
    '#ajax' => array(
      'callback' => 'ajax_bid_refresh',
      'wrapper' => 'bid_refresh',
    ),
    '#suffix' => '</div>',
  );

  $attach = array();
  $path_counter = drupal_get_path('module', 'jquery_countdown_timer');
  $path_my = drupal_get_path( 'module', 'auction' );

  $attach['js'] = array(
    $path_my.'/jquery.galleriffic.js' => array (
      'type' => 'file',
      'scope' => 'header',
    ),

    $path_my.'/auction.js' => array (
      'type' => 'file',
      'scope' => 'header',
    ),

    $path_counter.'/js/jquery_countdown_timer.js' => array (
      'type' => 'file',
      'scope' => 'header',
    ),

    $path_counter.'/js/jquery_countdown_timer_init.js' => array (
      'type' => 'file',
      'scope' => 'header',
    ),
  );

  $attach['css'] = array(
    $path_counter.'/css/jquery_countdown_timer.css',
    $path_my.'/auction.css',
  );

  $form['#attached'] = $attach;

  return $form;
}

function ajax_bid_make( $form, &$form_state ) {
  global $user;

  $query = db_select('auction', 'a');
  $query->fields( 'a', array( 'aid', 'name', 'full_text', 'img0', 'img1', 'img2', 'img3', 'img4', 'start_date', 'main_time', 'winner', 'price', 'stepup' ) );
  $query->addExpression( 'UNIX_TIMESTAMP( DATE_ADD( start_date, INTERVAL main_time HOUR ) ) - UNIX_TIMESTAMP( NOW() )', 'est_time' );
  $query->addExpression( 'UNIX_TIMESTAMP( end_date ) - UNIX_TIMESTAMP( NOW() )', 'end_time' );
  $query->addExpression( 'IF( NOW() > start_date, 1, 0 )', 'active' );
  $query->condition( 'a.aid', $form_state['values']['id'], '=' );
  $auction = $query->execute()->fetchAssoc();

  $query = db_select( 'users_money', 'um' );
  $query->fields( 'um', array( 'money' ) );
  $query->condition( 'um.uid', $user->uid, '=' );
  $money = $query->execute()->fetchAssoc();

  $ret = array(
    'js' => $form['js'],
    'price' => $form['price'],
    'countdown' => $form['countdown'],
    'bid' => $form['bid'],
    'update' => $form['update'],
  );

  if( $money['money'] >= $auction['price'] && $auction['winner'] != $user->uid && $auction['active'] && ( $auction['est_time'] > 0 || $auction['end_time'] > 0 ) ) {
    db_query( 'UPDATE {users_money}
                  SET money = money - :price
                WHERE uid = :uid',
      array( ':price' => $auction['price'], ':uid' => $user->uid ) );

    db_query( 'UPDATE {auction}
                  SET winner = :uid,
                      price = price + stepup,
                      end_date = DATE_ADD( NOW(), INTERVAL add_step MINUTE )
                WHERE aid = :aid',
      array( ':uid' => $user->uid, ':aid' => $form_state['values']['id'] )
    );

    db_insert('bid_log')
      ->fields( array(
          'aid' => $form_state['values']['id'],
          'uid' => $user->uid,
          'summ' => $auction['price'],
        )
      )
      ->execute();  

    $query = db_select('auction', 'a');
    $query->fields( 'a', array( 'aid', 'name', 'full_text', 'img0', 'img1', 'img2', 'img3', 'img4', 'start_date', 'main_time', 'winner', 'price', 'stepup' ) );
    $query->addExpression( 'UNIX_TIMESTAMP( DATE_ADD( start_date, INTERVAL main_time HOUR ) ) - UNIX_TIMESTAMP( NOW() )', 'est_time' );
    $query->addExpression( 'UNIX_TIMESTAMP( end_date ) - UNIX_TIMESTAMP( NOW() )', 'end_time' );
    $query->addExpression( 'IF( NOW() > start_date, 1, 0 )', 'active' );
    $query->condition( 'a.aid', $form_state['values']['id'], '=' );
    $auction = $query->execute()->fetchAssoc();

    $ret['price']['#markup'] = $auction['price'].'$';

    $wdiv = '<div id="win_green">'.t('You are in winner.').'</div>';
    $ret['countdown']['#markup'] = '<div id="jquery-countdown-timer"></div>'.$wdiv;

    $ret['bid']['#disabled'] = true;
    $ret['bid']['#attributes']['disabled'] = 'disabled';
    $ret['bid']['#value'] = t( 'Make bid !summ$', array( '!summ' => $auction['price'] ) );

    if( $auction['est_time'] > $auction['end_time'] ) {
      $ret['js']['#markup'] = '<script>jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) + '.$auction['est_time'].' } } );</script>';
    } else {
      $ret['js']['#markup'] = '<script>jQuery.extend( Drupal.settings, { "jquery_countdown_timer" : { "jquery_countdown_timer_date" : Math.floor( new Date() / 1000 ) + '.$auction['end_time'].' } } );</script>';
    }
  }

  return $ret;
}

function ajax_bid_refresh( $form, &$form_state ) {
  $ret = array(
    'js' => $form['js'],
    'price' => $form['price'],
    'countdown' => $form['countdown'],
    'bid' => $form['bid'],
    'update' => $form['update'],
  );

  return $ret;
}

function auction_bidder() {
  global $user;

  db_merge('users_money')
    ->key( array('uid' => $user->uid ) )
    ->fields( array(
        'published' => true,
      )
    )
    ->execute();  

  return 'Ok';
}

function auction_pay( $form, &$form_state ) {
}

<?php

function webmoney_in( $form, &$form_state ) {

  global $user;

  $id = db_insert('banner_in')
    ->fields( array(
        'user_id' => $user->uid,
        'ip' => getenv("REMOTE_ADDR"),
      )
    )
    ->execute();  

  $form['#action'] = 'https://merchant.webmoney.ru/lmi/payment.asp';

  $form['webmoney'] = array(
    '#markup' => '
<input type="text" name="LMI_PAYMENT_AMOUNT">WMR
<input type="hidden" name="LMI_PAYMENT_DESC" value="Payment for clicks on clixer.ru">
<input type="hidden" name="LMI_PAYEE_PURSE" value="R328732918854">
<input type="hidden" name="USER_ID" value="'.$user->uid.'">
<input type="hidden" name="LMI_PAYMENT_NO" value="'.$id.'">',
  );

  $form['transfer'] = array(
    '#type' => 'submit',
    '#value' => t( 'Transfer' ),
  );

  return $form;
}

function webmoney_result() {

  $LMI_SECRET_KEY = 'a2630081966c3b2051231309f1e227be';
  $LMI_PAYEE_PURSE = 'R328732918854';

  $out = '';

  if( isset( $_POST['LMI_PREREQUEST'] ) && $_POST['LMI_PREREQUEST'] == 1 ) {
    if( isset( $_POST['LMI_PAYMENT_NO'] ) &&
        isset( $_POST['LMI_PAYEE_PURSE'] ) && $_POST['LMI_PAYEE_PURSE'] == $LMI_PAYEE_PURSE &&
        isset( $_POST['LMI_PAYER_WM'] ) &&
        isset( $_POST['LMI_PAYER_PURSE'] ) &&
        isset( $_POST['USER_ID'] ) &&
        isset( $_POST['LMI_PAYMENT_AMOUNT'] ) ) {

      db_update('banner_in')
      ->fields( array(
          'summ' => $_POST['LMI_PAYMENT_AMOUNT'],
          'wmid' => $_POST['LMI_PAYER_WM'],
          'zid' => $_POST['LMI_PAYER_PURSE'],
          'status' => 1,
        )
      )
      ->condition( 'id', $_POST['LMI_PAYMENT_NO'], '=' )
      ->condition( 'user_id', $_POST['USER_ID'], '=' )
      ->execute();

      $out = 'YES';
    } else {
      if( isset( $_POST['LMI_PAYMENT_NO'] ) ) {
        db_update('banner_in')
        ->fields( array(
            'summ' => $_POST['LMI_PAYMENT_AMOUNT'],
            'wmid' => $_POST['LMI_PAYER_WM'],
            'zid' => $_POST['LMI_PAYER_PURSE'],
            'status' => -1,
          )
        )
        ->condition( 'id', $_POST['LMI_PAYMENT_NO'], '=' )
        ->condition( 'user_id', $_POST['USER_ID'], '=' )
        ->execute();
      }

      $out = 'NO';
      watchdog( 'webmoney', 'Wrong predata' );
    }
  } else {
    if( isset( $_POST['LMI_PAYMENT_NO'] ) &&
        isset( $_POST['LMI_PAYEE_PURSE'] ) && $_POST['LMI_PAYEE_PURSE'] == $LMI_PAYEE_PURSE &&
        isset( $_POST['LMI_PAYER_WM'] ) &&
        isset( $_POST['LMI_PAYER_PURSE'] ) &&
        isset( $_POST['LMI_SYS_INVS_NO'] ) &&
        isset( $_POST['LMI_SYS_TRANS_NO'] ) &&
        isset( $_POST['LMI_HASH'] ) &&
        isset( $_POST['LMI_SYS_TRANS_DATE'] ) &&
        isset( $_POST['USER_ID'] ) &&
        isset( $_POST['LMI_PAYMENT_AMOUNT'] ) ) {

      $chkstring = $_POST['LMI_PAYEE_PURSE'].$_POST['LMI_PAYMENT_AMOUNT'].$_POST['LMI_PAYMENT_NO'].$_POST['LMI_MODE'].$_POST['LMI_SYS_INVS_NO'].$_POST['LMI_SYS_TRANS_NO'].$_POST['LMI_SYS_TRANS_DATE'].$LMI_SECRET_KEY.$_POST['LMI_PAYER_PURSE'].$_POST['LMI_PAYER_WM'];
      $md5sum = strtoupper( md5( $chkstring ) );

      if( $_POST['LMI_HASH'] == $md5sum ) {
        $id = db_insert('banner_in')
          ->fields( array(
              'parent_id' => $_POST['LMI_PAYMENT_NO'],
              'user_id' => $_POST['USER_ID'],
              'ip' => getenv("REMOTE_ADDR"),
              'summ' => $_POST['LMI_PAYMENT_AMOUNT'],
              'wmid' => $_POST['LMI_PAYER_WM'],
              'zid' => $_POST['LMI_PAYER_PURSE'],
              'wm_sys_no' => $_POST['LMI_SYS_TRANS_NO'],
              'wm_invis_no' => $_POST['LMI_SYS_INVS_NO'],
              'wm_date' => $_POST['LMI_SYS_TRANS_DATE'],
              'status' => 2,
            )
          )
          ->execute();

        $clicks = round( $_POST['LMI_PAYMENT_AMOUNT'] / 2, 2 );
        db_query( 'UPDATE banner_balance
                      SET balance = balance + :cnt
                    WHERE user_id = :uid', array( ':cnt' => $clicks, ':uid' => $_POST['USER_ID'] ) );

        db_query( 'UPDATE banner_balance
                      SET balance = balance - :cnt
                    WHERE user_id = 1', array( ':cnt' => $clicks ) );

      } else {
        $id = db_insert('banner_in')
          ->fields( array(
              'parent_id' => $_POST['LMI_PAYMENT_NO'],
              'user_id' => $_POST['USER_ID'],
              'ip' => getenv("REMOTE_ADDR"),
              'summ' => $_POST['LMI_PAYMENT_AMOUNT'],
              'wmid' => $_POST['LMI_PAYER_WM'],
              'zid' => $_POST['LMI_PAYER_PURSE'],
              'wm_sys_no' => $_POST['LMI_SYS_TRANS_NO'],
              'wm_invis_no' => $_POST['LMI_SYS_INVS_NO'],
              'wm_date' => $_POST['LMI_SYS_TRANS_DATE'],
              'status' => -2,
            )
          )
          ->execute();

        watchdog( 'webmoney', 'Hash wrong' );
      }
    }
  }

  return $out;
}

function webmoney_success() {

  global $user;

  $deal = db_select( 'banner_in', 'bi' )
    ->fields( 'bi', array( 'summ' ) )
    ->condition('user_id', $user->uid, '=' )
    ->condition('id', $_POST['LMI_PAYMENT_NO'], '=' )
    ->execute()
    ->fetchAssoc();

  $summ = $deal['summ'];
  $clicks = round( $summ / 2, 2 );

  $form['message'] = array(
    '#markup' => t( 'You successfuly transfer !summ WMR to your account. Now you have additional !click clicks', array( '!summ' => $summ, '!click' => $clicks ) ),
  );

  return $form;
}

function webmoney_fail() {
  $form['message'] = array(
    '#markup' => t( 'During transfer error occured. Please try again later.' ),
  );

  return $form;
}

function webmoney_out( $form, &$form_state ) {

  global $user;

  $form['message'] = array(
    '#markup' => t( 'We make transfer only after moderation.' ),
  );

  $form['wmid'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 80,
    '#title' => t( 'Enter your wmid' ),
    '#required' => true,
  );

  $form['zid'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 80,
    '#title' => t( 'Enter your webmoney wallet' ),
    '#required' => true,
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

  $form['max_clicks'] = array(
    '#type' => 'value',
    '#value' => intval( $balance['balance'] ),
  );

  $form['clicks'] = array(
    '#type' => 'textfield',
    '#size' => 80,
    '#maxlength' => 80,
    '#title' => t( 'Enter count of clicks you wish to transfer into money' ),
    '#description' => t( 'Minimum transfer clicks 50' ),
    '#required' => true,
  );

  $form['transfer'] = array(
    '#type' => 'submit',
    '#value' => t( 'Transfer' ),
  );

  return $form;
}

function webmoney_out_validate( $form, &$form_state ) {
  if( intval( $form_state['values']['clicks'] ) <= 50 ) {
    form_set_error( 'error', t( 'Count must be more 50.' ) );
  }

  if( intval( $form_state['values']['clicks'] ) > intval( $form_state['values']['max_clicks'] ) ) {
    form_set_error( 'error', t( 'Count must be less or equal %max.', array( '%max' => $form_state['values']['max_clicks'] ) ) );
  }
}

function webmoney_out_submit( $form, &$form_state ) {

  global $user;

  db_insert('banner_out')
    ->fields( array(
        'user_id' => $user->uid,
        'ip' => getenv("REMOTE_ADDR"),
        'wmid' => $form_state['values']['wmid'],
        'zid' => $form_state['values']['zid'],
        'clicks' => $form_state['values']['clicks'],
      )
    )
    ->execute();

  db_query( 'UPDATE banner_balance
                SET balance = balance - :cnt
              WHERE user_id = :uid', array( ':cnt' => $form_state['values']['clicks'], ':uid' => $user->uid ) );

  db_query( 'UPDATE banner_balance
                SET balance = balance + :cnt
              WHERE user_id = 1', array( ':cnt' => $form_state['values']['clicks'] ) );
}

function webmoney_log( $form, &$form_state ) {

  global $user;

  // Build the sortable table header.
  $header = array(
    'id' => array( 'data' => t('Transaction number'), 'field' => 'b.id' ),
    'wmid' => array( 'data' => t('WMID'), 'field' => 'bi.wmid' ),
    'zid' => array( 'data' => t('Wallet'), 'field' => 'bi.zid' ),
    'summ' => array( 'data' => t('Summ'), 'field' => 'bi.summ' ),
    'ip' => array( 'data' => t('IP'), 'field' => 'bi.ip' ),
    'date_in' => array( 'data' => t('User date'), 'field' => 'bi.date_in', 'sort' => 'desc' ),
    'wm_date' => array( 'data' => t('Moderate date'), 'field' => 'bi.wm_date' ),
    'status' => array( 'data' => t('Status'), 'field' => 'bi.status' ),
  );

  $query = db_select( 'banner_in', 'bi' );
  $query->fields( 'bi', array( 'id', 'wmid', 'zid', 'summ', 'ip', 'date_in', 'wm_date', 'status' ) );
  $query->condition( 'bi.user_id', $user->uid, '=' );
  $query->condition( 'bi.status', array( 2, -1, -2 ), 'IN' )
    ->extend('TableSort')
    ->orderByHeader( $header );
  $log = $query->execute()->fetchAllAssoc( 'id' );

  $in_log = array();
  foreach( $log as $id => $item ) {
    $in_log[$id] = array(
      'id' => $id,
      'wmid' => $item->wmid,
      'zid' => $item->zid,
      'summ' => $item->summ,
      'ip' => $item->ip,
      'date_in' => $item->date_in,
      'wm_date' => $item->wm_date,
    );

    switch( $item->status ) {
      case 2:
        $in_log[$id]['status'] = t('Ok');
        break;
      case -1:
        $in_log[$id]['status'] = t('Error 1');
        break;
      case -2:
        $in_log[$id]['status'] = t('Error 2');
        break;
    }
  }

  $form['in_title'] = array(
    '#type' => 'item',
    '#title' => t( 'Charge transaction log' ),
  );

  //Build the tableselect.
  $form['trans_in'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $in_log,
    '#empty' => t('No content available.'),
  );

  // Build the sortable table header.
  $header = array(
    'id' => array( 'data' => t('Transaction number'), 'field' => 'b.id' ),
    'wmid' => array( 'data' => t('WMID'), 'field' => 'bo.wmid' ),
    'zid' => array( 'data' => t('Wallet'), 'field' => 'bo.zid' ),
    'clicks' => array( 'data' => t('Summ'), 'field' => 'bo.clicks' ),
    'ip' => array( 'data' => t('IP'), 'field' => 'bo.ip' ),
    'date_out' => array( 'data' => t('User date'), 'field' => 'bo.date_out', 'sort' => 'desc' ),
    'real_date' => array( 'data' => t('Moderate date'), 'field' => 'bo.real_date' ),
    'status' => array( 'data' => t('Status'), 'field' => 'bo.status' ),
  );

  $query = db_select( 'banner_out', 'bo' );
  $query->fields( 'bo', array( 'id', 'wmid', 'zid', 'clicks', 'ip', 'date_out', 'real_date', 'status', 'err_text' ) );
  $query->condition( 'bo.user_id', $user->uid, '=' );
  $query->condition( 'bo.status', array( 0, 1, -1 ), 'IN' )
    ->extend('TableSort')
    ->orderByHeader( $header );
  $log = $query->execute()->fetchAllAssoc( 'id' );

  $out_log = array();
  foreach( $log as $id => $item ) {
    $out_log[$id] = array(
      'id' => $id,
      'wmid' => $item->wmid,
      'zid' => $item->zid,
      'clicks' => $item->clicks,
      'ip' => $item->ip,
      'date_out' => $item->date_out,
      'real_date' => $item->real_date,
    );

    switch( $item->status ) {

      case 0:
        $out_log[$id]['status'] = t('Premoderate');
        break;

      case 1:
        $out_log[$id]['status'] = t('Ok');
        break;

      case -1:
        $out_log[$id]['status'] = t('Error').'<br>'.$item->err_text;
        break;
    }
  }

  $form['out_title'] = array(
    '#type' => 'item',
    '#title' => t( 'Withdraw transaction log' ),
  );

  //Build the tableselect.
  $form['trans_out'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $out_log,
    '#empty' => t('No content available.'),
  );

  return $form;
}

function webmoney_moderate( $form, &$form_state ) {
  global $user;

  // Build the sortable table header.
  $header = array(
    'id' => array( 'data' => t('Transaction number'), 'field' => 'b.id' ),
    'wmid' => array( 'data' => t('WMID'), 'field' => 'bo.wmid' ),
    'zid' => array( 'data' => t('Wallet'), 'field' => 'bo.zid' ),
    'clicks' => array( 'data' => t('Summ'), 'field' => 'bo.clicks' ),
    'ip' => array( 'data' => t('IP'), 'field' => 'bo.ip' ),
    'date_out' => array( 'data' => t('User date'), 'field' => 'bo.date_out', 'sort' => 'desc' ),
    'real_date' => array( 'data' => t('Moderate date'), 'field' => 'bo.real_date' ),
    'status' => array( 'data' => t('Status'), 'field' => 'bo.status' ),
  );

  $query = db_select( 'banner_out', 'bo' );
  $query->fields( 'bo', array( 'id', 'wmid', 'zid', 'clicks', 'ip', 'date_out', 'real_date', 'status' ) );
  $query->condition( 'bo.status', array( 0, 1, -1 ), 'IN' )
    ->extend('TableSort')
    ->orderByHeader( $header );
  $log = $query->execute()->fetchAllAssoc( 'id' );

  $out_log = array();
  foreach( $log as $id => $item ) {
    $out_log[$id] = array(
      'id' => $id,
      'wmid' => $item->wmid,
      'zid' => $item->zid,
      'clicks' => $item->clicks,
      'ip' => $item->ip,
      'date_out' => $item->date_out,
      'real_date' => $item->real_date,
    );

    switch( $item->status ) {
      case 0:
        $out_log[$id]['status'] = l( t('Premoderate'), "webmoney/$id/edit" );
        break;
      case 1:
        $out_log[$id]['status'] = t('Ok');
        break;
      case -1:
        $out_log[$id]['status'] = t('Error');
        break;
    }
  }

  $form['out_title'] = array(
    '#type' => 'item',
    '#title' => t( 'Withdraw transaction log' ),
  );

  //Build the tableselect.
  $form['trans_out'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $out_log,
    '#empty' => t('No content available.'),
  );

  return $form;
}

function webmoney_edit( $form, &$form_state, $id ) {
  $form = array();

  $query = db_select('banner_out', 'bo');
  $query->innerJoin( 'banner_balance', 'bb', 'bb.user_id = bo.user_id' );
  $query->innerJoin( 'users', 'u', 'u.uid = bo.user_id' );
  $query->fields( 'bo', array( 'wmid', 'zid', 'date_out', 'clicks', 'user_id' ) );
  $query->fields( 'bb', array( 'balance' ) );
  $query->fields( 'u', array( 'name', 'mail' ) )
    ->condition( 'bo.id', $id, '=' );

  $info = $query->execute()->fetchAssoc();

  $form['id'] = array(
    '#type' => 'value',
    '#value' => $id,
  );

  $form['user_id'] = array(
    '#type' => 'value',
    '#value' => $info['user_id'],
  );

  $form['clicks'] = array(
    '#type' => 'value',
    '#value' => $info['clicks'],
  );

  $form['date_out'] = array(
    '#type' => 'value',
    '#value' => $info['date_out'],
  );

  $wmr = $info['clicks'] * 2;

  $form['user'] = array(
    '#type' => 'item',
    '#title' => t( 'User %name with e-mail %email', array( '%name' => $info['name'], '%email' => $info['mail'] ) ),
    '#markup' => t( 'WMID: !wmid<br>WALLET: !zid<br><br>Transfer WMR: !clicks<br>Current user balance: !balance', array( '!wmid' => $info['wmid'], '!zid' => $info['zid'], '!balance' => $info['balance'], '!clicks' => $wmr ) ),
  );

  $form['transfered'] = array(
    '#type' => 'checkbox',
    '#title' => t( 'Transfer approved' ),
    '#description' => t( 'Set this flag only AFTER complette fund transfer.' ),
  );

  $form['answer'] = array(
    '#type' => 'textarea',
    '#title' => t('Enter description of approve or decline.'),
    '#required' => true,
  );

  $form['save'] = array(
    '#type' => 'submit',
    '#value' => t( 'Save' ),
  );

  return $form;
}

function webmoney_edit_submit( $form, &$form_state ) {

  global $user;

  db_update('banner_out')
    ->fields( array(
        'broker_id' => $user->uid,
        'err_text' => $form_state['values']['answer'],
        'real_date' => date( 'Y-m-d H:i:s' ),
        'status' => $form_state['values']['transfered'] ? 1 : -1,
      )
    )
    ->condition( 'id', $form_state['values']['id'], '=' )
    ->execute();

  $wmr = $form_state['values']['clicks'] * 2;

  if( !$form_state['values']['transfered'] ) {

    $recv = user_load( $form_state['values']['user_id'] );
    drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'money_err', 'date' => $form_state['values']['date_out'], 'summ' => $wmr, 'reason' => $form_state['values']['answer'] ) );

    db_query( 'UPDATE banner_balance
                  SET balance = balance + :cnt
                WHERE user_id = :uid', array( ':cnt' => $form_state['values']['clicks'], ':uid' => $form_state['values']['user_id'] ) );

    db_query( 'UPDATE banner_balance
                  SET balance = balance - :cnt
                WHERE user_id = 1', array( ':cnt' => $form_state['values']['clicks'] ) );
  } else {
    $recv = user_load( $form_state['values']['user_id'] );
    drupal_mail( 'rotator', date( 'His' ), $recv->mail, $recv->language, array( 'type' => 'money_ok', 'date' => $form_state['values']['date_out'], 'summ' => $wmr ) );
  }

  $form_state['redirect'] = 'webmoney/moderate';
}
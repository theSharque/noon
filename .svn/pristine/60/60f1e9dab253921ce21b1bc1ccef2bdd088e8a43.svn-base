<?php
/**
 * @file
 * Status page.
 */

/**
 * Page callback for payment method commerce_interkassa.
 *
 * @param int $order
 *   Commerce order.
 *
 * @return bool
 *   Check returned data.
 */
function commerce_interkassa_payment_status($order) {
  $request_data = $_POST;
  commerce_interkassa_add_log('Order number @order_number request data: @request_data', array(
    '@order_number' => $order->order_id,
    '@request_data' => print_r($request_data, 1),
  ));

  if ($request_data['ik_payment_state'] == 'success') {
    if ($order) {
      $order_wrapper = entity_metadata_wrapper('commerce_order', $order);
      $amount        = $order_wrapper->commerce_order_total->amount->value();
      $currency_code = $order_wrapper->commerce_order_total->currency_code->value();
      $settings      = commerce_payment_method_instance_load('commerce_interkassa|commerce_payment_commerce_interkassa');

      $sing_hash_str = $settings['settings']['shop_id'] . ':' .
        commerce_currency_amount_to_decimal($amount, $currency_code) . ':' .
        $order->order_id . ':' .
        $request_data['ik_paysystem_alias'] . ':' .
        $request_data['ik_baggage_fields'] . ':' .
        $request_data['ik_payment_state'] . ':' .
        $request_data['ik_trans_id'] . ':' .
        $request_data['ik_currency_exch'] . ':' .
        $request_data['ik_fees_payer'] . ':' .
        $settings['settings']['secret_key'];

      $sign_hash = strtoupper(md5($sing_hash_str));
      if ($request_data['ik_sign_hash'] === $sign_hash) {
        if ($order->status !== 'completed') {
          commerce_interkassa_create_transaction($order);
          return t('Payment the order number @order_number is complited', array('@order_number' => $order->order_id));
        }
      }
      else {
        drupal_set_message(t('If the error persists then, contact your site administrator.'), 'warning');
        return t('Payment the order number @order_number is fail', array('@order_number' => $order->order_id));
      }
    }
  }
  return t('Payment failed.');
}

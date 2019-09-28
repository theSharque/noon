<?php

  require_once( "./include/boot.inc" );
  bootup();

  global $user;

  if( authorization() ) {
    do_events();

    if( isset( $_POST['amount'] ) && is_numeric( $_POST['amount'] ) ) {

      $amount = intval( $_POST['amount'] );

      db_query( "INSERT INTO pay_log ( user_id, mess ) VALUES ( {$user->uid}, 'Start pay of $amount' )" );
      $log_id = mysql_insert_id();

      $xml = file_get_contents( "http://www.interkassa.com/lib/paysystems.currencies.export.php?format=xml&shop_id=0F1495D5-FF97-A645-149C-E02C00C224BF&key=9vvHKIH1vtYEZC7b&amount=$amount" );

      $xml_parser = xml_parser_create();
      xml_parse_into_struct( $xml_parser, $xml, $parsed );

      $options = array();
      $tab1 = 0;
      $tab2 = 0;

      foreach( $parsed as $item ) {
        if( $item['type'] == 'complete' && isset( $item['attributes']['AMOUNT'] ) ) {
          $preopt[ $item['attributes']['ALIAS'] ] = array( $item['attributes']['AMOUNT'], mb_convert_encoding( $item['attributes']['CURRENCYNAME'], 'CP1251', 'UTF-8' ), mb_convert_encoding( $item['value'], 'CP1251', 'UTF-8' ) );

          if( strlen( $item['attributes']['AMOUNT'] ) > $tab1 ) {
            $tab1 = strlen( $item['attributes']['AMOUNT'] );
          }
          
          if( strlen( mb_convert_encoding( $item['attributes']['CURRENCYNAME'], 'CP1251', 'UTF-8' ) ) > $tab2 ) {
            $tab2 = strlen( mb_convert_encoding( $item['attributes']['CURRENCYNAME'], 'CP1251', 'UTF-8' ) );
          }
        }
      }

      foreach( $preopt as $key => $item ) {
        $options[ $key ] = str_replace( '#', '&nbsp;', str_pad( $item[0], $tab1 + 1, '#' ).str_pad( $item[1], $tab2 + 1, '#' ).$item[2] );
      }

      krsort( $options );
    } else {
      $amount = 0;
    }
?>
<html>
<head>
<style>
html, body {
  font-family: Arial, Tahoma, Verdana;
  font-weight: bold;
  font-size: 12px;
}

select.table-select {
  font-family: Consolas,'Lucida Console','DejaVu Sans Mono', monospace;
  font-size: 14px;
}

select.table-select option {
  font-family: Consolas,'Lucida Console','DejaVu Sans Mono', monospace;
  font-size: 14px;
}

</style>
</head>
<body bgcolor="#000000" text="#00FF00">
<br><br><br><br><br><br><br>
<table align=center width=1000 border=0>
<form method="post">
<tr><td colspan=2 align=center>Спасибо за поддержку проекта</td></tr>
<tr><td><label for="amount">Введите сумму в конфедератах</label></td>
<td><input type='text' name='amount' value='<?php echo $amount; ?>'>
<input type='submit' value='Расчитать'></td></tr>
</form>
<?php if( isset( $options ) && is_array( $options ) && count( $options ) ) { ?>
  <form name="payment" target="_blank" action="https://www.interkassa.com/lib/payment.php" method="post" enctype="application/x-www-form-urlencoded" accept-charset="cp1251">
  <input type="hidden" name="ik_shop_id" value="0F1495D5-FF97-A645-149C-E02C00C224BF">
  <input type="hidden" name="ik_payment_amount" value="<?php echo $amount; ?>">
  <input type="hidden" name="ik_payment_id" value="<?php echo $log_id; ?>">
  <input type="hidden" name="ik_baggage_fields" value="<?php echo $user->uid; ?>">
  <input type="hidden" name="ik_payment_desc" value="Покупка <?php echo $amount; ?> конфедерат для <?php echo $user->login ?>">

  <tr><td><label for="ik_paysystem_alias">Выберите валюту и тип платежа</label></td>
  <td><select name="ik_paysystem_alias" class="table-select">
  <?php foreach( $options as $key => $item ) { echo "<option value='$key'>$item</option>"; } ?>
  </select>
  <input type="submit" name="process" value="Оплатить"></td></tr>
  </form>
</table>
<?php } ?>
</body>
</html>
<?php } ?>

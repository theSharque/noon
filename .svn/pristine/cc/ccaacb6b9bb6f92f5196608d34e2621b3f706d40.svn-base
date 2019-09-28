<?php

  require_once( "db.inc" );

  $fid = $_GET['fid'];

  $optim = substr( $fid, 0, 2 );

  if( isset( $_GET['GT'] ) ) {
    db_query( "UPDATE files SET galery = {$_GET['GT']} WHERE fid = '$fid'" );
    header( 'Location: show_me_all.php' );
    exit;
  }

  $data = db_fetch_row( "SELECT referer FROM files WHERE fid = '$fid'" );

  echo "Referer: {$data['referer']}";

  echo "<form action='/64c1b22dfd5dcf20fd20130131154433.php'><img src='/big/$optim/$fid'>";

  echo "<input type='hidden' name='fid' value='$fid'>";

  echo '<br><select id="GT" name="GT" style="width: 140px;">';

  require_once( "galname.inc" );
  foreach( $gt_names as $key => $gt ) {
    echo "                <option value='$key'>$gt</option>";
  }

  echo '</select>';

  echo '<input type="submit" value="Обновить" class="upload">';

  echo '<br><br><a href="7169470b6c2dc1fbd88f3ef757c8b119.php?fid='.$fid.'">Delete</a>';

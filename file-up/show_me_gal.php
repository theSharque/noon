<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
</head>
<body>
<?php

  require_once( "db.inc" );
  require_once( "galname.inc" );

  $res = db_fetch_array( "SELECT fid, galery, referer FROM files WHERE galery > 0 ORDER BY date_upload desc LIMIT 0,180" );

  echo '<table>';
  $col=0;
  
  foreach( $res as $item ) {
    if( $col == 0 ) {
      echo '<tr>';
    }

    $orig = substr( $item['fid'], 0, 2 );
    $fid = $item['fid'];
    $referer = substr( $item['referer'], 0, 30 );

    if( $item['galery'] == 0 ) {
      echo "<td><a href='64c1b22dfd5dcf20fd20130131154433.php?fid=$fid'><img width=180 src='small/$orig/$fid'></a><br><a href='7169470b6c2dc1fbd88f3ef757c8b119.php?fid=$fid'>Delete</a><br>$referer</td>";
    } else {
      echo "<td>{$gt_names[$item['galery']]}<br><a href='64c1b22dfd5dcf20fd20130131154433.php?fid=$fid'><img style='border:1px red solid; padding:2px;' width=180 src='small/$orig/$fid'></a><br><a href='7169470b6c2dc1fbd88f3ef757c8b119.php?fid=$fid'>Delete</a><br>$referer</td>";
    }

    if( $col++ == 5 ) {
      $col = 0;
      echo '</tr>';
    }
  }

  echo '</table>';
?>
</body>
</html>
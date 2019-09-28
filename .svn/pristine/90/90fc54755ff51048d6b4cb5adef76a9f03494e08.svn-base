<?php

  function show_tutorial( $id = 0 ) {
    global $user;

    if( $user->level > 42 ) {
      return;
    }

    if( $id == 0 ) {
      $id = $_GET['id'];
      db_safe( $id );
    }
    if( is_numeric( $id ) ) {
      $anticache = filesize( "swf/tutorial.jpg" );
?>
<div id="FlashDiv" style="z-index: 1000; position: absolute; top: 0; left: 0;">
  <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" id="tutorial" width="1000" height="500">
    <param name="movie" value="swf/tutorial.jpg?<?php print $anticache; ?>" />
    <param name="quality" value="low" />
    <param name="wmode" value="transparent" />
    <param name="flashvars" VALUE="pgid=<?php print $id; ?>">
    <embed src="swf/tutorial.jpg?<?php print $anticache; ?>" quality="low" wmode="transparent" width="1000" height="500" swLiveConnect=true id="tutorial" name="tutorial" type="application/x-shockwave-flash" flashvars="pgid=<?php print $id; ?>"/>
  </object>
</div>
<?php
    }
  }

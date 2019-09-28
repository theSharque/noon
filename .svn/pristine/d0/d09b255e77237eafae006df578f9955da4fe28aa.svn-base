<?php

/*
  xdebug_start_trace('debug/page_'.$_GET['id'].'_'.mt_rand(100000,999999));

  if( xdebug_time_index() > 1 ) {
    xdebug_stop_trace();
    unlink( $fdebug );

    $in_trace = false;
  } else {
    $in_trace = true;
  }
*/

  require_once( "./include/boot.inc" );
  $sape_link = false;
  bootup();
  
  header("Cache-Control: no-cache, must-revalidate");
  header("Pragma: no-cache");
  header("Connection: Keep-Alive");

  if( authorization() ) {
    global $user;
    $uid = ( is_object( $user ) && isset( $user->uid ) ) ? intval( $user->uid ) : 0;

    if( !$uid ) {
      header( "Location: index.php" );

      return;
    }

    if( isset( $_GET['id'] ) && is_numeric( $_GET['id'] ) ) {
      $page_id = $_GET['id'];
    } else {
      $page_id = '404';
    }

    if( isset( $user->full_log ) && $user->full_log ) {
      $log_line = serialize( $_GET );
      db_query( "INSERT INTO full_log ( uid, line ) VALUES ( {$user->uid}, '$log_line' )" );
    }

    switch( $page_id ) {
      case 0:
        include './pages/topmenu.page';
        break;

      case 62731:
        $title = 'Условия оплаты космической онлайн стратегии Полдень 21 века';
        $main_content = file_get_contents('texts/billing.page');
        include "./templates/big.inc";
        break;
      case 83910:
        include './pages/2pay.page';
        break;
      case 83911:
        include './pages/2pay_new.page';
        break;

      case 83692:
        include './pages/precalc.page';
        break;

      case 83693:
        include './pages/precalc2.page';
        break;

      case 9234:

debug_it( $_POST );

        break;

      case 1:
//        do_events();
//        authorization();
        $sp = isset( $_GET["sp"] ) ? $_GET["sp"] : '';
        if( isset( $_GET['msgto'] ) && $_GET['msgto'] ) {
          render_page( 'booklist', "sn={$user->login}&uid={$user->uid}&sp=$sp&msgto=".decode_in( $_GET['msgto'] ), "100%" );
        } else {
          render_page( 'booklist', "sn={$user->login}&uid={$user->uid}&sp=$sp", "100%" );
        }
        show_tutorial( 1 );
        break;
      case 11:
        include './pages/character/questload.page';
        break;
      case 12:
        include './pages/character/questdesc.page';
        break;

      case 122:
//        do_events();
//        authorization();
        include './pages/character/booklearn.page';
        break;
      case 123:
        include './pages/character/bookdesc.page';
        break;
      case 124:
        if( lock_me() ) {
          include './pages/character/bookteach.page';
          unlock_me();
        }
        break;
      case 125:
//        do_events();
//        authorization();
        include './pages/character/messages.page';
        break;
      case 126:
        include './pages/character/readmsg.page';
        break;
      case 127:
        if( lock_me() ) {
          include './pages/character/deletemsg.page';
          unlock_me();
        }
        break;
      case 128:
        include './pages/character/checkto.page';
        break;
      case 129:
        if( lock_me() ) {
          include './pages/character/sendmessage.page';
          unlock_me();
        }
        break;
      case 13:
        include './pages/character/userinfo.page';
        break;
      case 131:
        include './pages/character/getobjects.page';
        break;
      case 132:
        include './pages/character/objectinfo.page';
        break;
      case 133:
        if( lock_me() ) {
          include './pages/character/objorder.page';
          unlock_me();
        }
        break;
      case 134:
        include './pages/character/defence.page';
        break;

      case 14:
        include './pages/gettutor.page';
        break;
      case 15:
        include './pages/reminder.page';
        break;
      case 16:
        if( lock_me() ) {
          include './pages/character/queststart.page';
          unlock_me();
        }
        break;
      case 161:
        if( lock_me() ) {
          include './pages/character/questdel.page';
          unlock_me();
        }
        break;
      case 17:
        include './pages/character/queststop.page';
        break;
      case 18:
//        do_events();
//        authorization();

        $login = urldecode( isset( $_GET['login'] ) ? $_GET['login'] : '' );
        $login = decode_in( $login );

        render_page( 'about', 'login='.$login, "100%" );
        break;
      case 181:
        include './pages/character/medalinfo.page';
        break;
      case 182:
        include './pages/character/medalparam.page';
        break;
      case 183:
        include './pages/character/medalorder.page';
        break;
      case 19:
        include './pages/character/getinfo.page';
        break;
      case 191:
        include './pages/character/setrelation.page';
        break;
      case 192:
        include './pages/character/setpremium.page';
        break;
      case 193:
        include './pages/character/ignore.page';
        break;
      case 151:
        include './pages/character/relation.page';
        break;

      case 2:
        include './pages/environment/place.page';
        show_tutorial( 2 );
        break;
      case 21:
//        do_events( false );
//        authorization();
        include './pages/environment/planetmap.page';
        break;

      case 22:
//        do_events( false );
//        authorization();
        include './pages/environment/orbitmap.page';
        break;
      case 221:
        include './pages/environment/orbitinfo.page';
        break;
      case 222:
        include './pages/environment/orbituse.page';
        break;
      case 225:
//        do_events();
//        authorization();
        include './pages/environment/dockme.page';
        break;

      case 23:
        include './pages/environment/station.page';
        break;
      case 231:
//        do_events();
//        authorization();
        include './pages/environment/tradeinfo.page';
        break;
      case 232:
        include './pages/environment/tradesave.page';
        break;
      case 233:
//        do_events();
//        authorization();
        include './pages/environment/goods.page';
        break;

      case 240:
//        do_events();
//        authorization();
        include './pages/environment/gettimer.page';
        break;

      case 25:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/environment/startbuild.page';
          unlock_me();
        }
        break;
      case 26:
//        do_events();
//        authorization();
        include './pages/environment/panelinfo.page';
        break;
      case 261:
        if( lock_me() ) {
          include './pages/environment/stopthat.page';
          include './pages/environment/destroy.page';
          unlock_me();
        }
        break;
      case 27:
//        do_events();
//        authorization();
        include './pages/environment/paneluse.page';
        break;
      case 282:
        include './pages/environment/shiplist.page';
        break;
      case 283:
        include './pages/environment/defence.page';
        break;

      case 286:
        include './pages/environment/listacad.page';
        break;
      case 287:
        include './pages/environment/setacad.page';
        break;

      case 28:
        include './pages/environment/listbuild.page';
        break;
      case 29:
//        do_events();
//        authorization();
        include './pages/environment/listres.page';
        break;
      case 210:
        include './pages/environment/listmines.page';
        break;
      case 211:
        if( lock_me() ) {
          include './pages/environment/startmine.page';
          unlock_me();
        }
        break;
      case 271:
//        do_events();
//        authorization();
        include './pages/environment/listdisp.page';
        break;
      case 272:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/environment/startdisp.page';
          unlock_me();
        }
        break;
      case 273:
//        do_events();
//        authorization();
        include './pages/environment/panelupgrade.page';
        break;
      case 274:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/environment/startupgrade.page';
          unlock_me();
        }
        break;
      case 275:
//        do_events();
//        authorization();
        include './pages/environment/listmake.page';
        break;
      case 276:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/environment/startmake.page';
          unlock_me();
        }
        break;
      case 277:
        if( lock_me() ) {
          include './pages/environment/stopthat.page';
          unlock_me();
        }
        break;
      case 278:
//        do_events();
//        authorization();
        include './pages/environment/listcomp.page';
        break;
      case 279:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/environment/startcomp.page';
          unlock_me();
        }
        break;
      case 280:
        include './pages/environment/listlab.page';
        break;

      case 281:
        if( lock_me() ) {
          include './pages/environment/startlab.page';
          unlock_me();
        }
        break;

      case 284:
        include './pages/environment/listsintez.page';
        break;

      case 285:
        if( lock_me() ) {
          include './pages/environment/startsintez.page';
          unlock_me();
        }
        break;

      case 3:
//        do_events();
//        authorization();
        $vars = '';
        if( $user->fid != '0' ) {
          $vars = $user->fid;
        } else {
          switch($user->real_type) {
            case 2 : $vars = 'S'.$user->real_id;break;
            case 6 : $vars = 'F'.$user->real_id;break;
          };
        }
        render_page( 'ships', "ls=$vars", "100%" );
        show_tutorial( 3 );
        break;
      case 31:
//        do_events();
//        authorization();
        include './pages/ships/shipslist.page';
        break;
      case 3131:
//        do_events();
//        authorization();
        include './pages/ships/shipstest.page';
        break;
      case 311:
//        do_events();
//        authorization();
        include './pages/ships/placelist.page';
        break;
      case 32:
        do_events();
        authorization();
        include './pages/ships/orderslist.page';
        break;
      case 321:
//        do_events();
//        authorization();
        include './pages/ships/itemslist.page';
        break;
      case 33:
        do_events();
        authorization();
        if( lock_me() ) {
          include './pages/ships/makeorder.page';
          unlock_me();
        }
        break;
      case 331:
        do_events();
        authorization();
        if( lock_me() ) {
          include './pages/ships/makeatack.page';
          unlock_me();
        }
        break;
      case 34:
        include './pages/ships/fleet.page';
        break;
      case 35:
        if( lock_me() ) {
          include './pages/ships/makefleet.page';
          unlock_me();
        }
        break;
      case 351:
        if( lock_me() ) {
          include './pages/ships/fleetatack.page';
          unlock_me();
        }
        break;
      case 352:
        include './pages/ships/fleetlist.page';
        break;
      case 353:
        if( lock_me() ) {
          include './pages/ships/fleetoff.page';
          unlock_me();
        }
        break;
      case 354:
        include './pages/ships/fleetorder.page';
        break;
      case 355:
        include './pages/ships/fleetset.page';
        break;
      case 36:
        include './pages/ships/getinfo.page';
        break;
      case 37:
//        do_events();
//        authorization();
        include './pages/ships/getplanets.page';
        break;
      case 371:
//        do_events();
//        authorization();
        include './pages/ships/getstars.page';
        break;
      case 372:
        include './pages/ships/starcoord.page';
        break;
      case 373:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/ships/starmove.page';
          unlock_me();
        }
        break;
      case 374:
//        do_events();
//        authorization();
        include './pages/ships/getmessage.page';
        break;
      case 38:
//        do_events();
//        authorization();
        include './pages/ships/getcoord.page';
        break;
      case 39:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/ships/movecoord.page';
          unlock_me();
        }
        break;
      case 391:
        include './pages/ships/deconverce.page';
        break;

      case 4:
//        do_events();
//        authorization();
        $vars = isset( $_GET['shid'] ) ? $_GET['shid'] : '';
        db_safe( $vars );
        render_page( 'warehouse', "shid=$vars", '100%' );
        show_tutorial( 4 );
        break;
      case 41:
//        do_events();
//        authorization();
        include './pages/warehouse/shipslist.page';
        break;
      case 42:
//        do_events();
//        authorization();
        include './pages/warehouse/shipitems.page';
        break;
      case 43:
//        do_events();
//        authorization();
        include './pages/warehouse/siloslist.page';
        break;
      case 44:
//        do_events();
//        authorization();
        include './pages/warehouse/siloitems.page';
        break;
      case 45:
        if( lock_me() ) {
          include './pages/warehouse/moveitem.page';
          unlock_me();
        }
        break;
      case 46:
//        do_events();
//        authorization();
        include './pages/warehouse/filterlist.page';
        break;
      case 47:
        if( lock_me() ) {
          include './pages/warehouse/movemult.page';
          unlock_me();
        }
        break;

      case 5:
//        do_events();
//        authorization();
        render_page( 'trade', "sn={$user->login}&uid={$user->uid}", '100%' );
        show_tutorial( 5 );
        break;
      case 51:
        include './pages/trade/shipslist.page';
        break;
      case 52:
//        do_events();
//        authorization();
        include './pages/trade/itemslist.page';
        break;
      case 53:
        if( lock_me() ) {
          include './pages/trade/bayitems.page';
          unlock_me();
        }
        break;
      case 54:
        if( lock_me() ) {
          include './pages/trade/sellitems.page';
          unlock_me();
        }
        break;
      case 55:
        include './pages/trade/shipsbay.page';
        break;
      case 56:
        include './pages/trade/shipssell.page';
        break;
      case 57:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/trade/itemsbay.page';
          unlock_me();
        }
        break;
      case 58:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/trade/itemssell.page';
          unlock_me();
        }
        break;
      case 59:
        include './pages/trade/remember.page';
        break;
      case 63:
//        do_events();
//        authorization();
        include './pages/trade/tradelist.page';
        break;
      case 65:
        include './pages/trade/pricelist.page';
        break;
      case 651:
        include './pages/trade/priceinfo.page';
        break;
      case 652:
//        do_events();
//        authorization();
        if( lock_me() ) {
          include './pages/trade/bayitem.page';
          unlock_me();
        }
        break;

      case 6:
//        do_events();
//        authorization();

        $itm = isset( $_GET['itm'] ) ?  $_GET['itm'] : 0;
        if( levelUp( 6, $user->uid ) ) {
/*
          $codeQs = file_get_contents( 'http://core.1lead.ru/hash.set.php?hash=87dec1f8ba5dac6acb6ed0a86e9c8a1d&actid='.$user->uid );
          $attach = '<img id="payChecker" src="http://core.1lead.ru/check/'.$codeQs.'"><img src="http://r.planbmedia.com/accept/offer_526.gif" />';
*/
          $attach = '';
          render_page( 'misc', 'itm='.urldecode( $itm ), '100%', $attach );
        } else {
          render_page( 'misc', 'itm='.urldecode( $itm ), '100%' );
        }
        show_tutorial( 6 );
        break;
      case 61:
        include './pages/misc/itemslist.page';
        break;
      case 62:
        include './pages/misc/iteminfo.page';
        break;
      case 64:
        include './pages/misc/robotslist.page';
        break;

      case 641:
        include './pages/misc/questfield.page';
        break;
      case 642:
        include './pages/misc/questlist.page';
        break;
      case 643:
        include './pages/misc/questadd.page';
        break;
      case 644:
        include './pages/misc/questload.page';
        break;
      case 645:
        include './pages/misc/questvalid.page';
        break;

      case 66:
        include './pages/misc/settings.page';
        break;
      case 67:
        include './pages/misc/savesettings.page';
        break;
      case 674:
        include './pages/misc/killuser.page';
        break;

      case 671:
        include './pages/misc/topload.page';
        break;

      case 672:
        include './pages/misc/top100.page';
        break;

      case 673:
        include './pages/misc/hintsave.page';
        break;

      case 68:
        include './pages/misc/aliancelist.page';
        break;
      case 681:
        include './pages/misc/alianceinfo.page';
        break;
      case 682:
        include './pages/misc/alianceorder.page';
        break;
      case 69:
        include './pages/misc/userslist.page';
        break;
      case 691:
        include './pages/misc/usersinfo.page';
        break;
      case 692:
        include './pages/misc/usersorder.page';
        break;

      case 7:
        include './pages/exit.page';
        break;

      case 8:
        include './pages/gethint.page';
        break;

      case 9:
        include './pages/chat/main.page';
        break;
      case 91:
        include './pages/chat/read.page';
        break;
      case 92:
        include './pages/chat/write.page';
        break;
      case 93:
        include './pages/chat/get.page';
        break;
      case 94:
        include './pages/chat/put.page';
        break;
      case 95:
        include './pages/chat/users.page';
        break;

      case 990:
        if( $user->admin == 2 ) {
          include './pages/admin/main.page';
        }
        break;
      case 980:
        if( $user->admin == 2 ) {
          include './pages/admin/userdetail.page';
        }
        break;
      case 991:
        if( $user->admin == 2 ) {
          include './pages/admin/subedit.page';
        }
        break;
      case 992:
        if( $user->admin == 2 ) {
          include './pages/admin/objedit.page';
        }
        break;
      case 993:
        if( $user->admin == 2 ) {
          include './pages/admin/stat.page';
        }
        break;
      case 994:
        if( $user->admin == 2 ) {
          include './pages/admin/encedit.page';
        }
        break;
      case 995:
        if( $user->admin == 2 ) {
          include './pages/admin/pricer.page';
          include './pages/admin/main.page';
        }
        break;
      case 996:
        if( $user->admin == 2 ) {
          include './pages/admin/research.page';
        }
        break;
      case 997:
        if( $user->admin == 2 ) {
          include './pages/admin/ships.page';
        }
        break;
      case 998:
        if( $user->admin == 2 ) {
          include './pages/admin/tutedit.page';
        }
        break;
      case 999:
        if( $user->admin == 2 ) {
          include './pages/admin/logread.page';
        }
        break;

      default :
//        do_events();
//        authorization();
        print <<<EOF
<HTML>
<HEAD>
<TITLE>Noon</TITLE>
</HEAD>
<FRAMESET id="noon" rows="22,505,*" border=0 frameborder=no framespacing=0>
  <FRAME src="page.php?id=0" name=topmenu scrolling=no noresize TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>
  <FRAME src="page.php?id=1" name=main scrolling=auto noresize TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>
  <FRAME src="page.php?id=9" name=chat scrolling=no noresize TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>
</FRAMESET>
</HTML>
EOF;
        break;
    }  
  } else {
    header( "Location: index.php" );
  }

/*
  if( $in_trace ) {
    $fdebug = xdebug_get_tracefile_name();
    xdebug_stop_trace();

    if( xdebug_time_index() < 3 ) {
      unlink( $fdebug );
    } else {
      rename( $fdebug, $fdebug.'.slow' );
    }
  }
*/

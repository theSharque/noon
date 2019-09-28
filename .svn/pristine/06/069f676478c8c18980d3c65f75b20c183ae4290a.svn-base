package {
	import flash.display.MovieClip;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
    import flash.display.StageAlign; 
    import flash.display.StageScaleMode;

	public class read3 extends MovieClip {
		private var chatTimer:Timer=new Timer(5000);
		private var cid:uint = 0;
		private var user_hash:String = "first";
		private var nopLoader:URLLoader = new URLLoader();
		private var oldWidth:int;

		private var msgMain:String = '';
		private var msgPriv:String = '';
		private var msgSys:String = '';
		private var iActive:int = 0;

		public function read3() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler);

			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			nopLoader.addEventListener(Event.COMPLETE, chatUpdate);
			var rnd:String = String( int( Math.random() * 10000 ) );
			nopLoader.load(new URLRequest( "reader.php?id=93&cid="+cid+"&uh="+user_hash+"&rnd="+rnd));

			chatTimer.addEventListener(TimerEvent.TIMER, chatCheck);

			btnUp.addEventListener(MouseEvent.CLICK, frameUp);
			btnDown.addEventListener(MouseEvent.CLICK, frameDown);
			resizeHandler( null );
			
			btnMain.addEventListener(MouseEvent.CLICK, clickMain);
			btnPriv.addEventListener(MouseEvent.CLICK, clickPriv);
			btnSys.addEventListener(MouseEvent.CLICK, clickSys);
		}

		private function clickMain( e:MouseEvent ) {
			iActive = 0;
			bgMain.gotoAndStop( 1 );
			dtChat.htmlText = msgMain;
			dtChat.setSelection( 0, 0 );
			sbChat.update();
			if( sbChat.enabled == false ) {
				sbChat.visible = false;
			} else {
				sbChat.visible = true;
			}
		}

		private function clickSys( e:MouseEvent ) {
			iActive = 1;
			bgSys.gotoAndStop( 1 );
			dtChat.htmlText = msgSys;
			dtChat.setSelection( 0, 0 );
			sbChat.update();
			if( sbChat.enabled == false ) {
				sbChat.visible = false;
			} else {
				sbChat.visible = true;
			}
		}

		private function clickPriv( e:MouseEvent ) {
			iActive = 2;
			bgPriv.gotoAndStop( 1 );
			dtChat.htmlText = msgPriv;
			dtChat.setSelection( 0, 0 );
			sbChat.update();
			if( sbChat.enabled == false ) {
				sbChat.visible = false;
			} else {
				sbChat.visible = true;
			}
		}

		private function chatUpdate( event:Event ) {
			var tmpChat:String;
			var tmpMon:Array;
			if( nopLoader.data.err == 0 ) {
				cid = nopLoader.data.id;

				if( nopLoader.data.msgm != '' ) {
					tmpChat = nopLoader.data.msgm + msgMain;
					tmpMon = tmpChat.split( "<br>", 60 );
					msgMain = tmpMon.join( "<br>" );
					if( iActive != 0 ){
						bgMain.gotoAndPlay( 1 );
					}
				}

				if( nopLoader.data.msgs != '' ) {
					tmpChat = nopLoader.data.msgs + msgSys;
					tmpMon = tmpChat.split( "<br>", 60 );
					msgSys = tmpMon.join( "<br>" );
					if( iActive != 1 ) {
						bgSys.gotoAndPlay( 1 );
					}
				}

				if( nopLoader.data.msgp != '' ) {
					tmpChat = nopLoader.data.msgp + msgPriv;
					tmpMon = tmpChat.split( "<br>", 60 );
					msgPriv = tmpMon.join( "<br>" );
/*					if( iActive != 2 ) {
						bgPriv.gotoAndPlay( 1 );
					}
*/
				}

				switch( iActive ) {
					case 0:
						dtChat.htmlText = msgMain;
						break;
					case 1:
						dtChat.htmlText = msgSys;
						break;
					case 2:
						dtChat.htmlText = msgPriv;
						break;
				}
				dtChat.setSelection( 0, 0 );
				sbChat.update();
				if( sbChat.enabled == false ) {
					sbChat.visible = false;
				} else {
					sbChat.visible = true;
				}

				if( nopLoader.data.users != undefined ) {
					dtUsers.htmlText = nopLoader.data.users;
					dtUsers.setSelection( 0, 0 );
					user_hash = nopLoader.data.uh;
					sbUsers.update();
					if( sbUsers.enabled == false ) {
						sbUsers.visible = false;
					} else {
						sbUsers.visible = true;
					}
				}
			}
			chatTimer.reset();
			chatTimer.start();
		}

		private function chatCheck( e:TimerEvent ) {
			var rnd:String = String( int( Math.random() * 10000 ) );
			chatTimer.stop();

			nopLoader.load(new URLRequest( "reader.php?id=93&cid="+cid+"&uh="+user_hash+"&rnd="+rnd));

			chatTimer.reset();
			chatTimer.start();
		}

		private function resizeHandler( event:Event ) {
			if( oldWidth != int( stage.stageWidth ) ) {
				btnUp.x = stage.stageWidth - 320;
				btnDown.x = stage.stageWidth - 380;

				bgUsers.x = stage.stageWidth - bgUsers.width - 20;
				dtUsers.x = bgUsers.x + 18;
				sbUsers.x = dtUsers.x + dtUsers.width + 2;
				sbUsers.scrollTarget = dtUsers;

				bgChat.width = stage.stageWidth - bgUsers.width - 20;
				mvLight.x = bgChat.width - 11;
				dtChat.width = bgChat.width - 87;
				sbChat.x = dtChat.x + dtChat.width + 2;
				sbChat.scrollTarget = dtChat;
				
				oldWidth = int( stage.stageWidth )
			}
		}

		private function frameUp( e:MouseEvent ) {
			navigateToURL( new URLRequest('javascript:a();b();function a(){parent.parent.document.getElementById("noon").rows="23,*,525"};function b(){parent.document.getElementById("chat").rows="500,25"};'), "_self" );
		}

		private function frameDown( e:MouseEvent ) {
			navigateToURL( new URLRequest('javascript:a();b();function a(){parent.parent.document.getElementById("noon").rows="23,505,*"};function b(){parent.document.getElementById("chat").rows="*,25"}'), "_self" );
		}
	}
}
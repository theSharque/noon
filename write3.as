package {
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
    import flash.display.StageAlign; 
    import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class write3 extends MovieClip {
		private var nopLoader:URLLoader = new URLLoader();
		private var nick:String = root.loaderInfo.parameters.nick;
		
		public function write3() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler);

			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			nopLoader.addEventListener(Event.COMPLETE, nopClear);
			btnSend.addEventListener(MouseEvent.CLICK, clickSend);
			itChat.addEventListener(KeyboardEvent.KEY_UP, clickEnter);
			
			if( nick ) {
				itChat.text = nick + ": ";
				nick = '';
			}

			resizeHandler( null );
		}

		private function resizeHandler( event:Event ) {
			btnSend.x = stage.stageWidth - 200;
			itChat.width = stage.stageWidth - 208;
			bgChat.width = stage.stageWidth - 202;
		}

		private function clickEnter( e:KeyboardEvent ) {
			if( e.keyCode == Keyboard.ENTER ) {
				sendText();
			} 
		}

		private function clickSend( e:MouseEvent ) {
			sendText();
		}

		private function sendText() {
			var str:String = escape( itChat.text );
			var pat:RegExp = /\+/gi;
			str = str.replace( pat, "%u002B" );
			nopLoader.load(new URLRequest( "page.php?id=94&text="+str ) );
		}

		private function nopClear( event:Event ) {
			itChat.text = '';
		}
	}
}
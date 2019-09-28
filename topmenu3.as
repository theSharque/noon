package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;

	public class topmenu3 extends MovieClip {
		private var mailTimer:Timer=new Timer(15000);
		private var mailId:uint = 0;
		private var nopLoader:URLLoader = new URLLoader();

		private var playList:Array = [{url:"music/1.mp3",lab:"The Arrival"},
									  {url:"music/2.mp3",lab:"Remember me"},
									  {url:"music/3.mp3",lab:"Changeling"},
									  {url:"music/4.mp3",lab:"At War With Me"},
									  {url:"music/5.mp3",lab:"Empty Room"},
									  {url:"music/6.mp3",lab:"Why"},
									  {url:"music/7.mp3",lab:"Revelations"},
									  {url:"music/8.mp3",lab:"The Forgotten"},
									  {url:"music/9.mp3",lab:"I'll Find A Way"},
									  {url:"music/01.mp3",lab:"Starlight 1"},
									  {url:"music/02.mp3",lab:"Starlight 2"},
									  {url:"http://scfire-mtc-aa01.stream.aol.com/stream/1003",lab:"di.fm: Trance Radio"},
									  {url:"http://u12b.di.fm/di_ambient",lab:"di.fm: ambient"},
									  {url:"http://scfire-dtc-aa01.stream.aol.com/stream/1035",lab:"di.fm: Chillout"},
									  {url:"http://u12.di.fm/di_chilloutdreams",lab:"di.fm: Chillout Dreams"},
									  {url:"http://u12.di.fm/di_chiptunes",lab:"di.fm: Chiptunes"},
									  {url:"http://u12.di.fm/di_oldschoolelectronica",lab:"di.fm: Classic Electronica"},
									  {url:"http://u12.di.fm/di_classictrance",lab:"di.fm: Classic Trance"},
									  {url:"http://u16.di.fm/di_classicvocaltrance",lab:"di.fm: Classic Vocal Trance"},
									  {url:"http://u16.di.fm/di_djmixes",lab:"di.fm: DJ Mixes"},
									  {url:"http://scfire-ntc-aa01.stream.aol.com/stream/1025",lab:"di.fm: Electro House"},
									  {url:"http://u12.di.fm/di_funkyhouse",lab:"di.fm: Funky House"},
									  {url:"http://u12.di.fm/di_futuresynthpop",lab:"di.fm: Future Synthpop"},
									  {url:"http://scfire-ntc-aa01.stream.aol.com/stream/1008",lab:"di.fm: Goa-Psy Trance"},
									  {url:"http://u12.di.fm/di_hardcore",lab:"di.fm: Hardcore"},
									  {url:"http://u12.di.fm/di_hardstyle",lab:"di.fm: Hardstyle"},
									  {url:"http://scfire-ntc-aa01.stream.aol.com/stream/1009",lab:"di.fm: Lounge"},
									  {url:"http://u17.di.fm/di_minimal",lab:"di.fm: Minimal"},
									  {url:"http://u12.di.fm/di_oldschoolacid",lab:"di.fm: Oldschool Acid"},
									  {url:"http://u16.di.fm/di_oldschoolhouse",lab:"di.fm: Oldschool House"},
									  {url:"http://scfire-dtc-aa01.stream.aol.com/stream/1026",lab:"di.fm: Progressive"},
									  {url:"http://u12.di.fm/di_psychill",lab:"di.fm: Psychill"},
									  {url:"http://u16.di.fm/di_soulfulhouse",lab:"di.fm: Soulful House"},
									  {url:"http://u16.di.fm/di_spacemusic",lab:"di.fm: Space Dreams"},
									  {url:"http://u12b.di.fm/di_techhouse",lab:"di.fm: Tech House"},
									  {url:"http://u12.di.fm/di_techno",lab:"di.fm: Techno"},
									  {url:"http://scfire-mtc-aa01.stream.aol.com/stream/1003",lab:"di.fm: Trance"},
									  {url:"http://u12.di.fm/di_ukgarage",lab:"di.fm: UK Garage"},
									  {url:"http://scfire-ntc-aa01.stream.aol.com/stream/1065",lab:"di.fm: Vocal Trance"} ];
		private var iPos:uint;
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var schanel:SoundChannel;

		private var music:Sound;
		private var msVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.mv ) / 100, 0 );
		private var mchanel:SoundChannel;
		private var isPlay:Boolean = (root.loaderInfo.parameters.mv < 10);
		private var position:Number = 0;
		private var dtping:Date;

		public function topmenu3() {
			iPos = int( Math.random() * 8 );
			mail.gotoAndStop( 1 );
			btnChar.addEventListener(MouseEvent.CLICK, clkChar);
			btnPlace.addEventListener(MouseEvent.CLICK, clkPlace);
			btnShip.addEventListener(MouseEvent.CLICK, clkShip);
			btnWare.addEventListener(MouseEvent.CLICK, clkWare);
			btnTrade.addEventListener(MouseEvent.CLICK, clkTrade);
			btnMisc.addEventListener(MouseEvent.CLICK, clkMisc);
			btnForum.addEventListener(MouseEvent.CLICK, clkForum);
			btnExit.addEventListener(MouseEvent.CLICK, clkExit);
			btnPlayerOn.addEventListener(MouseEvent.CLICK, clkPlayer);
			btnPlayerOff.addEventListener(MouseEvent.CLICK, clkPlayer);
			btnPlayerNext.addEventListener(MouseEvent.CLICK, clkNext);
			mail.btnMail.addEventListener(MouseEvent.CLICK, clkMail);

			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			nopLoader.addEventListener(Event.COMPLETE, mailUpdate);
			nopLoader.load(new URLRequest( "page.php?id=15&li=0" ));
			
			mailTimer.addEventListener(TimerEvent.TIMER, mailCheck);
			mailTimer.start();
			clkPlayer();
		}

		private function mailCheck(e:TimerEvent) {
			dtping = new Date();
			nopLoader.load(new URLRequest( "page.php?id=15&li="+mailId+"&p="+dtping.valueOf() ) );
		}

		private function mailUpdate(event:Event) {
			dtping = new Date();
			dtPing.text = String( dtping.valueOf() - nopLoader.data.png );

			if( dtping.valueOf() - nopLoader.data.png <= 1000 ) {
				dtPing.textColor = 0x00FF00;
			} else
				if( dtping.valueOf() - nopLoader.data.png >  1000 &&
					dtping.valueOf() - nopLoader.data.png <= 3000 ) {
				dtPing.textColor = 0xFFFF00;
			} else
				if( dtping.valueOf() - nopLoader.data.png >  3000 ) {
				dtPing.textColor = 0xFF0000;
			}

			if( int( nopLoader.data.err ) == 0 ) {
				mailId = nopLoader.data.id;
				mail.gotoAndPlay( 1 );
			} else {
				mail.gotoAndStop( 1 );
			}

			if( nopLoader.data.sv ) {
				stVolume.volume = ( nopLoader.data.sv / 100 );
				schanel.soundTransform = stVolume;
			}

			if( nopLoader.data.mv ) {
				msVolume.volume = ( nopLoader.data.mv / 100 );
				mchanel.soundTransform = msVolume;
			}
		}

		public function clkChar(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=1"), "main" );
		}

		public function clkPlace(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=2"), "main" );
		}

		public function clkShip(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=3"), "main" );
		}

		public function clkWare(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=4"), "main" );
		}

		public function clkTrade(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=5"), "main" );
		}

		public function clkMisc(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=6"), "main" );
		}

		public function clkForum(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("/info/index.php"), "_blank" );
		}

		public function clkExit(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=7"), "_top" );
		}

		public function clkMail(e:MouseEvent) {
			var snd:Sound = new bleep();
			schanel = snd.play();
			schanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=1&sp=1"), "main" );
		}

		public function clkNext(e:MouseEvent = null) {
			mchanel.removeEventListener( Event.SOUND_COMPLETE, soundComplete );
			if( (iPos+1) < playList.length ) {
				iPos++;
			} else {
				iPos=0;
			}
			
			try {
				mchanel.stop();
				music.close();
			} catch(error) {
				mchanel.stop();
			}

			music = new Sound();
			music.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			music.load(new URLRequest(playList[iPos].url));
			mchanel = music.play();
			mchanel.soundTransform = msVolume;
			mchanel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}

		public function clkPlayer(e:MouseEvent = null) {
			if( isPlay ) {
				btnPlayerOn.visible = true;
				btnPlayerOff.visible = false;
				isPlay = false;

				position = mchanel.position;
				try {
					mchanel.stop();
					music.close();
				} catch(error) {
					mchanel.stop();
				}
			} else {
				btnPlayerOn.visible = false;
				btnPlayerOff.visible = true;
				isPlay = true;
				if( position == 0 ) {
					music = new Sound();
					music.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					music.load(new URLRequest(playList[iPos].url));
					mchanel = music.play();
					mchanel.soundTransform = msVolume;
					mchanel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
					position = 0;
				} else {
					mchanel = music.play( position );
					mchanel.soundTransform = msVolume;
					mchanel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
				} 
			}
		}

		public function soundComplete( e:Event ) {
			mchanel.removeEventListener( Event.SOUND_COMPLETE, soundComplete );
			if( (iPos+1) < playList.length ) {
				iPos++;
			} else {
				iPos=0;
			}
			
			try {
				mchanel.stop();
				music.close();
			} catch(error) {
				mchanel.stop();
			}

			music = new Sound();
			music.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			music.load(new URLRequest(playList[iPos].url));
			mchanel = music.play();
			mchanel.soundTransform = msVolume;
			mchanel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		}

		public function ioErrorHandler( e:IOErrorEvent ) {
			soundComplete( e );
		}
	}
}
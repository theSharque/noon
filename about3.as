package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.filters.*;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	import flash.display.Loader;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;

	public class about3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var sLogin:String = root.loaderInfo.parameters.login
		private var chanel:SoundChannel;
		private var iLoader:URLLoader = new URLLoader();
		private var nopLoader:URLLoader = new URLLoader();
		private var mLoader:URLLoader = new URLLoader();
		private var charTester:URLLoader = new URLLoader();
		private var mDp:DataProvider = new DataProvider();
		private var aDp:DataProvider = new DataProvider();
		private var medalLoader:Loader = new Loader();

		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();

		private var sTween:Tween;
		private var dgFill = new Array();

		public function about3() {
			myFormat.color=0xFFFFFF;
			myFormat.font="Verdana";
			myFormat.size=12;

			myHeadFormat.color=0xBFBFFF;
			myHeadFormat.font="Verdana";
			myHeadFormat.size=12;
			myHeadFormat.bold=true;

			medalDesc.btnOk.addEventListener( MouseEvent.CLICK, clickOk );
			medalDesc.btnCancel.addEventListener( MouseEvent.CLICK, clickCancel );
			medalDesc.visible = false;
			medalDesc.alpha = 0;

			iLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, infoLoaded );
			nopLoader.addEventListener(Event.COMPLETE, infoRefresh );
			charTester.dataFormat=URLLoaderDataFormat.VARIABLES;
			charTester.addEventListener(Event.COMPLETE, checkedName);

			mLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			mLoader.addEventListener(Event.COMPLETE, medalInfo );

			dgMedals.setRendererStyle( "textFormat", myFormat );
			dgMedals.setStyle( "headerTextFormat", myHeadFormat );
			dgMedals.addColumn( "Наименование" );
			dgMedals.dataProvider=mDp;
			dgMedals.setStyle("cellRenderer",AlternatingRowColors);
			dgMedals.addEventListener( Event.CHANGE, medalChange );

			cbMedals.dataProvider=aDp;
			cbMedals.addEventListener( Event.CHANGE, medalChoose );

			btnFoe.addEventListener(MouseEvent.CLICK, setFoe);
			btnNeutral.addEventListener(MouseEvent.CLICK, setNeutral);
			btnFriend.addEventListener(MouseEvent.CLICK, setFriend);
			btnSend.addEventListener(MouseEvent.CLICK, sendMessage);
			btnPremium.addEventListener(MouseEvent.CLICK, setPremium);
			dtLogin.addEventListener(Event.CHANGE, checkName);

			btnIgnoreOn.addEventListener(MouseEvent.CLICK, ignorOn);
			btnIgnoreOn.visible = false;
			btnIgnoreOff.addEventListener(MouseEvent.CLICK, ignorOff);
			btnIgnoreOff.visible = false;

			dtLogin.text = sLogin;
			sLogin = escape( dtLogin.text );
			var pat:RegExp = /\+/gi;
			sLogin = sLogin.replace( pat, "%u002B" );
			iLoader.load(new URLRequest("page.php?id=19&login="+sLogin ));

			btnRemove.addEventListener(MouseEvent.CLICK, medalRemove);
			btnRemove.visible = false;
			btnMedal.addEventListener(MouseEvent.CLICK, showDesc);
			btnMedal.visible = false;
		}

		public function checkName( event:Event ) {
//			charTester.load(new URLRequest("d:\nop.txt"));
			charTester.load(new URLRequest( "page.php?id=128&user="+escape( dtLogin.text )));
		}

		public function checkedName( event:Event ) {
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			if( charTester.data.err != 0 ) {
				btnRemove.visible = false;
				btnMedal.visible = false;
				dtMedals.text = '';
				dtScroll.visible = false; 
				mvMedal.visible = false;
				inGlow.color = 0xFF0000;
				dtOnline.htmlText = '';
				dtReg.htmlText = '';
				dtStar.htmlText = '';
				dtWar.htmlText = '';
				dtAliance.htmlText = '';
				dtTitul.htmlText = '';
				dtStatus.htmlText = '';
				dtLevel.htmlText = '';
				dtShips.htmlText = '';
				dtPower.htmlText = '';
				dtRelationship.htmlText = '';
				dtMedals.htmlText = '';

				btnIgnoreOn.visible = false;
				btnIgnoreOff.visible = false;
			} else {
				iLoader.load(new URLRequest("page.php?id=19&login="+escape( dtLogin.text )));
			}

			bgLogin.filters = [inGlow, outGlow];
		}

		public function setPremium( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=192&premium="+dtPremium.text+"&login="+escape( dtLogin.text )));
			dtPremium.text = '0';
		}

		public function sendMessage( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			navigateToURL( new URLRequest("page.php?id=1&msgto="+escape( dtLogin.text )), "main" );
		}

		public function setFoe( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=191&rel=foe&login="+escape( dtLogin.text )));
		}

		public function setFriend( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=191&rel=friend&login="+escape( dtLogin.text )));
		}

		public function setNeutral( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=191&rel=neutral&login="+escape( dtLogin.text )));
		}

		public function ignorOn( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=193&ign=1&login="+escape( dtLogin.text )));
		}

		public function ignorOff( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			nopLoader.load(new URLRequest("page.php?id=193&ign=0&login="+escape( dtLogin.text )));
		}

		public function infoRefresh( event:Event ) {
			iLoader.load(new URLRequest("page.php?id=19&login="+escape( dtLogin.text )));
		}

		public function infoLoaded( event:Event ) {
			var i:uint;

			if( iLoader.data.err == 0 ) {
				dtOnline.htmlText = iLoader.data.online;
				dtReg.htmlText = iLoader.data.reg;
				dtStar.htmlText = iLoader.data.star;
				dtWar.htmlText = iLoader.data.war;
				dtAliance.htmlText = iLoader.data.aliance;
				dtTitul.htmlText = iLoader.data.titul;
				dtStatus.htmlText = iLoader.data.status;
				dtLevel.htmlText = iLoader.data.level;
				dtShips.htmlText = iLoader.data.ships;
				dtPower.htmlText = iLoader.data.power;
				dtRelationship.htmlText = iLoader.data.relation;
				dtMedals.htmlText = iLoader.data.clons;

				if( iLoader.data.ignore == 1 ) {
					btnIgnoreOff.visible = true;
					btnIgnoreOn.visible = false;
				} else {
					btnIgnoreOff.visible = false;
					btnIgnoreOn.visible = true;
				}

				mDp.removeAll();
				if (iLoader.data.mcnt>0) {
					for (i=0; i<iLoader.data.mcnt; i++) {
						dgFill = new Array();
						dgFill["Наименование"] = iLoader.data["mn"+i];
						dgFill["bgColor"] = iLoader.data["mc"+i];
						mDp.addItem(dgFill);
					}
				}

				aDp.removeAll();
				if (iLoader.data.acnt>0) {
					dgFill = new Array();
					dgFill["data"]=0;
					dgFill["label"]="Выберите медаль";
					aDp.addItem(dgFill);
					for (i=0; i<iLoader.data.acnt; i++) {
						dgFill = new Array();
						dgFill["data"]=iLoader.data["aid"+i];
						dgFill["label"]=iLoader.data["an"+i];
						aDp.addItem(dgFill);
					}
					cbMedals.textField.setStyle( "textFormat", myHeadFormat );
					cbMedals.dropdown.setRendererStyle( "textFormat", myFormat );
					cbMedals.rowCount = 12;
				}
			}
		}

		private function medalChange( event:Event ) {
			cbMedals.selectedIndex = -1;
			btnRemove.visible = false;
			btnMedal.visible = false;
			dtMedals.text = '';
			dtScroll.visible = false; 
			mvMedal.visible = false;
			mLoader.load(new URLRequest("page.php?id=181&mid="+iLoader.data["mid"+dgMedals.selectedIndex]));
		}

		private function medalChoose( event:Event ) {
			dgMedals.selectedIndex = -1;
			btnRemove.visible = false;
			btnMedal.visible = false;
			dtMedals.text = '';
			dtScroll.visible = false; 
			mvMedal.visible = false;
			mLoader.load(new URLRequest("page.php?id=182&mid="+cbMedals.selectedItem.data));
		}

		private function medalInfo( event:Event ) {
			var medalURL:URLRequest;

			if( mLoader.data.btnr == 1 ) {
				btnRemove.visible = true;
			}

			if( mLoader.data.btnm == 1 ) {
				btnMedal.visible = true;
			}

			dtMedals.text = mLoader.data.txt;
			dtScroll.update();
			if (dtScroll.enabled == false) {
				dtScroll.visible = false; 
			} else {
				dtScroll.visible = true;
			}
			dtFine.text = mLoader.data.fine;
			medalURL = new URLRequest("img/medals/"+mLoader.data.pic+".png");
			medalLoader.load( medalURL );
			mvMedal.addChild( medalLoader );
			mvMedal.visible = true;
		}

		public function showDesc( e:MouseEvent ) {
			medalDesc.visible = true;
			medalDesc.dtMedalDesc.text = '';
			sTween = new Tween( medalDesc, "alpha", Strong.easeOut, medalDesc.alpha, 1, 1, true );
		}

		public function clickCancel( e:MouseEvent ) {
			sTween = new Tween( medalDesc, "alpha", Strong.easeOut, medalDesc.alpha, 0, 1, true );
			sTween.addEventListener( TweenEvent.MOTION_FINISH, pUnvisible );
		}

		public function pUnvisible( event:Event ) {
			medalDesc.visible = false;
		}

		public function clickOk( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			clickCancel( e );
			nopLoader.load(new URLRequest("page.php?id=183&ord=2&login="+escape( dtLogin.text )+"&txt="+escape( medalDesc.dtMedalDesc.text )+"&mid="+cbMedals.selectedItem.data));
		}

		public function medalRemove( e:MouseEvent ) {
			nopLoader.load(new URLRequest("page.php?id=183&ord=1&mid="+iLoader.data["mid"+dgMedals.selectedIndex]));
		}
	}
}
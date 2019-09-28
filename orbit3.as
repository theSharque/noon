package {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextFormat;
	import fl.controls.DataGrid;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.data.DataProvider;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import fl.transitions.TweenEvent;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class orbit3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform(Number(root.loaderInfo.parameters.sv) / 100,0);
		private var chanel:SoundChannel;

		private var iMapLen:uint = 0;
		private var giX:int = -1;
		private var oldX:int = -1;
		private var fMagnify:Number = 0;
		private var bDrag:Boolean = false;

		private var iTween:Tween;
		private var uTween:Tween;
		private var aTween:Tween;
		private var bldTween:Tween;
		private var sTween:Tween;
		private var bTween:Tween;

		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();

		private var nopLoader:URLLoader = new URLLoader();
		private var mapLoader:URLLoader = new URLLoader();

		private var iLoader:URLLoader = new URLLoader();

		private var uLoader:URLLoader = new URLLoader();
		private var cbDp:DataProvider = new DataProvider();
		private var dgDp:DataProvider = new DataProvider();
		private var dgLoader:URLLoader = new URLLoader();
		private var sClickUrl:String;
		private var iUseMax:int;

		private var aLoader:URLLoader = new URLLoader();
		private var adgDp:DataProvider = new DataProvider();

		private var planetURL:URLRequest = new URLRequest("images/p" + root.loaderInfo.parameters.pid + ".png");
		private var planetLoader:Loader = new Loader();

		private var iClosed:Boolean = false;

		private var hintTimer:Timer = new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function orbit3() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			nopLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			hinter.visible = false;
			hinter.mvTimer.visible = false;
			hinter.startDrag( true );

			root.addEventListener( MouseEvent.MOUSE_OVER, startHint );
			hintTimer.addEventListener(TimerEvent.TIMER, loadHint);
			hLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			hLoader.addEventListener(Event.COMPLETE, hintLoaded);
			root.addEventListener( MouseEvent.MOUSE_OUT, hideHint );

			planetLoader.load( planetURL );
			mvPlanet.addChild( planetLoader );

			myFormat.color = 0xFFFFFF;
			myFormat.font = "Verdana";
			myFormat.size = 12;

			myHeadFormat.color = 0xBFBFFF;
			myHeadFormat.font = "Verdana";
			myHeadFormat.size = 12;
			myHeadFormat.bold = true;

			pSure.btnDestroy.addEventListener(MouseEvent.CLICK, clickDestroy);
			pSure.btnCancel.addEventListener(MouseEvent.CLICK, hideSure);
			pSure.visible = false;
			pSure.alpha = 0;

			btnOpenClose.addEventListener(MouseEvent.CLICK, PageOpenClose);

			pInfo.btnHead.addEventListener(MouseEvent.CLICK, PageInfoUp);
			pInfo.btnDestroy.addEventListener(MouseEvent.CLICK, showSure);

			pUse.btnHead.addEventListener(MouseEvent.CLICK, PageUseUp);
			pUse.cbItems.rowCount = 18;
			pUse.cbItems.dataProvider = cbDp;
			pUse.dgItems.dataProvider = dgDp;
			pUse.cbItems.addEventListener( Event.CHANGE, uItemsChange );
			pUse.dgItems.setRendererStyle( "textFormat", myFormat );
			pUse.dgItems.setStyle( "headerTextFormat", myHeadFormat );
			pUse.dgItems.setStyle("cellRenderer",AlternatingRowColors);
			pUse.btnStart.addEventListener(MouseEvent.CLICK, clickStart);
			pUse.btnStop.addEventListener(MouseEvent.CLICK, clickStart);
			frame_fg.btnStop.addEventListener(MouseEvent.CLICK, clickStart);
			frame_fg.btnUse.addEventListener(MouseEvent.CLICK, clickStart);
			pUse.btnRobot.addEventListener(MouseEvent.CLICK, clickRobot);
			pUse.counter.dtCount.addEventListener( Event.CHANGE, uCountChange );
			pUse.counter.btnMin.addEventListener( MouseEvent.CLICK, cntSetMin );
			pUse.counter.btnMinus.addEventListener( MouseEvent.CLICK, cntSetMinus );
			pUse.counter.btnPlus.addEventListener( MouseEvent.CLICK, cntSetPlus );
			pUse.counter.btnMax.addEventListener( MouseEvent.CLICK, cntSetMax );

			pUpgrade.btnHead.addEventListener(MouseEvent.CLICK, PageUpgradeUp);
			pUpgrade.dgItems.dataProvider = adgDp;
			pUpgrade.dgItems.setRendererStyle( "textFormat", myFormat );
			pUpgrade.dgItems.setStyle( "headerTextFormat", myHeadFormat );
			pUpgrade.dgItems.setStyle("cellRenderer",AlternatingRowColors);
			pUpgrade.btnUpgrade.addEventListener(MouseEvent.CLICK, clickUpgrade);
			frame_fg.btnUpgrade.addEventListener(MouseEvent.CLICK, clickUpgrade);

			mapLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			mapLoader.addEventListener(Event.COMPLETE, mapRender);
			//mapLoader.load(new URLRequest("d:\page22.txt"));
			mapLoader.load(new URLRequest("page.php?id=22"));

			map.addEventListener(MouseEvent.MOUSE_DOWN, mapStart);
			map.addEventListener(MouseEvent.MOUSE_UP, mapStop);
			root.addEventListener(MouseEvent.MOUSE_UP, mapStop);

			//map.addEventListener(MouseEvent.ROLL_OUT, mapStop);

			iLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, infoRender);

			uLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			uLoader.addEventListener(Event.COMPLETE, useRender);
			dgLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			dgLoader.addEventListener(Event.COMPLETE, dgRender);

			aLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			aLoader.addEventListener(Event.COMPLETE, upgradeRender);
		}

		private function startHint( e:MouseEvent ) {
			if (e.relatedObject != null) {
				var point:Point = new Point(mouseX,mouseY);
				var objects:Array = stage.getObjectsUnderPoint(point);
				hintName = objects[objects.length - 1].name;
				hintTimer.stop();
				hintTimer.reset();
				hintTimer.start();
				if (mouseX < 700) {
					hinter.dtHint.x = 16;
					hinter.bgHint.x = 16;
				} else {
					hinter.dtHint.x = -300;
					hinter.bgHint.x = -300;
				}
				if (mouseY < 60) {
					hinter.dtHint.y = 4;
					hinter.bgHint.y = 64;
				} else {
					hinter.dtHint.y = -64;
					hinter.bgHint.y = -4;
				}
			}
		}

		private function loadHint( e:TimerEvent ) {
			hintTimer.stop();
			var point:Point = new Point(mouseX,mouseY);
			var objects:Array = stage.getObjectsUnderPoint(point);

			if (bDrag == false && hintName == objects[objects.length - 1].name) {
				setChildIndex( hinter, hinter.parent.numChildren - 1 );
				hinter.bgHint.visible = false;
				hinter.dtHint.text = '';
				hinter.x = mouseX;
				hinter.y = mouseY;
				hinter.startDrag( true );
				hinter.visible = true;
				hinter.mvTimer.visible = true;
				hLoader.load( new URLRequest( "page.php?id=8&asc=orbit_"+hintName ) );
			} else {
				hinter.visible = false;
			}
		}

		private function hintLoaded( event:Event ) {
			if (hLoader.data.err == 0) {
				hinter.dtHint.htmlText = hLoader.data.hint;
				hinter.mvTimer.visible = false;
				hinter.bgHint.visible = true;
			} else {
				hinter.visible = false;
			}
		}

		private function hideHint( e:MouseEvent ) {
			hintTimer.stop();
			hinter.visible = false;
		}

		public function showSure( e:MouseEvent ) {
			pSure.visible = true;
			sTween = new Tween(pSure,"alpha",Strong.easeOut,pSure.alpha,1,1,true);
		}

		public function hideSure( e:MouseEvent ) {
			sTween = new Tween(pSure,"alpha",Strong.easeOut,pSure.alpha,0,1,true);
			sTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function pUnvisible( event:Event ) {
			pSure.visible = false;
		}

		public function uCountChange( event:Event ) {
			var dtColor:int = 0xCCCCCC;
			if (pUse.counter.dtCount.text != int(pUse.counter.dtCount.text)) {
				dtColor = 0xFF0000;
			}
			if (int(pUse.counter.dtCount.text) < 0 || int(pUse.counter.dtCount.text) > iUseMax) {
				dtColor = 0xFF0000;
			}

			pUse.counter.dtCount.textColor = dtColor;
		}

		public function cntSetMin( event:Event ) {
			pUse.counter.dtCount.text = "1";
			uCountChange( event );
		}

		public function cntSetMinus( event:Event ) {
			if (int(pUse.counter.dtCount.text) > 1) {
				pUse.counter.dtCount.text = String(int(pUse.counter.dtCount.text) - 1);
			}
			uCountChange( event );
		}

		public function cntSetPlus( event:Event ) {
			if (int(pUse.counter.dtCount.text) < iUseMax) {
				pUse.counter.dtCount.text = String(int(pUse.counter.dtCount.text) + 1);
			}
			uCountChange( event );
		}

		public function cntSetMax( event:Event ) {
			if (int(pUse.counter.dtCount.text) < iUseMax) {
				pUse.counter.dtCount.text = String(iUseMax);
			}
			uCountChange( event );
		}

		private function panelsRefresh() {
			pInfo.dtCoord.text = "";
			pInfo.dtTitle.htmlText = "<i>Идет загрузка...</i>";
			pInfo.dtDesc.htmlText = "";
			pInfo.btnDestroy.visible = false;
			pInfo.bgTitle.visible = false;
			pInfo.bgDesc.visible = false;
			//iLoader.load( new URLRequest( "d:\page26.txt" ) );
			iLoader.load( new URLRequest( "page.php?id=221&x="+giX ));

			pUse.dtTitle.htmlText = "<i>Идет загрузка...</i>";
			pUse.bgTitle.visible = false;
			pUse.bgItems.visible = false;
			pUse.dtCbHeader.htmlText = "";
			pUse.dtDgHeader.htmlText = "";
			pUse.cbItems.visible = false;
			pUse.dgItems.visible = false;
			pUse.cbItems.removeAll();
			pUse.dgItems.removeAll();
			pUse.dgItems.removeAllColumns();
			pUse.btnStart.visible = false;
			pUse.btnStop.visible = false;
			frame_fg.btnUse.visible = false;
			frame_fg.btnStop.visible = false;
			pUse.btnRobot.visible = false;
			pUse.counter.visible = false;
			//uLoader.load( new URLRequest( "d:\page27.txt" ) );
			uLoader.load( new URLRequest( "page.php?id=222&x="+giX ));

			pUpgrade.dtTitle.htmlText = "<i>Идет загрузка...</i>";
			pUpgrade.bgDesc.visible = false;
			pUpgrade.bgItems.visible = false;
			pUpgrade.dtLevel.htmlText = "";
			pUpgrade.dtDesc.htmlText = "";
			pUpgrade.dtDgHeader.htmlText = "";
			pUpgrade.dgItems.removeAll();
			pUpgrade.dgItems.removeAllColumns();
			pUpgrade.dgItems.visible = false;
			pUpgrade.btnUpgrade.visible = false;
			frame_fg.btnUpgrade.visible = false;
			//aLoader.load( new URLRequest( "d:\page273.txt" ) );
			aLoader.load( new URLRequest( "page.php?id=273&x="+giX ));
		}

		private function infoRender(event:Event) {
			pInfo.dtCoord.text = giX;
			pInfo.dtTitle.htmlText = iLoader.data.info;
			pInfo.bgTitle.visible = true;
			pInfo.dtDesc.htmlText = iLoader.data.desc;
			pInfo.bgDesc.visible = true;
			if (iLoader.data.destroy != undefined) {
				pInfo.btnDestroy.visible = true;
			}
		}

		private function clickDestroy( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			hideSure( e );

			nopLoader.addEventListener(Event.COMPLETE, afterDestroy);
			//nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=261&x="+giX ));
		}

		private function afterDestroy( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, afterDestroy );
			//mapLoader.load(new URLRequest("d:\page21.txt"));
			mapLoader.load(new URLRequest("page.php?id=22"));
			panelsRefresh();
		}

		private function useRender(event:Event) {
			var i:uint = 0;
			pUse.dtTitle.htmlText = uLoader.data.detail;
			if (uLoader.data.btLabel != undefined) {
				pUse.btnStop.visible = true;
				frame_fg.btnStop.visible = true;
				sClickUrl = unescape(uLoader.data.btOnClick);
			}
			if (uLoader.data.cb_h != undefined) {
				pUse.bgTitle.visible = true;
				pUse.dtCbHeader.htmlText = uLoader.data.cb_h;
				if (uLoader.data.cb_c != undefined && uLoader.data.cb_c > 0) {
					for (i=0; i<uLoader.data.cb_c; i++) {
						var dgFill = new Array();
						dgFill["data"] = uLoader.data["cb_d" + i];
						dgFill["label"] = uLoader.data["cb_l" + i];
						if (iLoader.data["c" + i]) {
							dgFill["bgColor"] = iLoader.data["cb_c" + i];
						}
						cbDp.addItem(dgFill);
					}
					pUse.cbItems.visible = true;
					pUse.cbItems.textField.setStyle( "textFormat", myHeadFormat );
					pUse.cbItems.dropdown.setRendererStyle( "textFormat", myFormat );
					pUse.cbItems.selectedIndex = 0;
					uItemsChange( event );
				}
			}
		}

		private function uItemsChange( event:Event ) {
			dgDp.removeAll();
			pUse.dgItems.removeAllColumns();
			pUse.btnStart.visible = false;
			pUse.btnStop.visible = false;
			frame_fg.btnUse.visible = false;
			frame_fg.btnStop.visible = false;
			pUse.btnRobot.visible = false;
			pUse.bgItems.visible = false;
			pUse.dtDgHeader.htmlText = "<i>Идет загрузка...</i>";
			//dgLoader.load(new URLRequest("d:\page210.txt"));
			dgLoader.load(new URLRequest(pUse.cbItems.selectedItem.data));
		}

		private function dgRender( event:Event ) {
			var i:int;
			var t:int;
			var bldMc:MovieClip;
			if (dgLoader.data.btLabel != undefined) {
				pUse.btnStart.visible = true;
				bldMc = map.buildings.getChildByName(String("b" + giX));
				if (dgLoader.data.hide != 1 && dgLoader.data.nsMax == undefined && bldMc) {
					frame_fg.btnUse.visible = true;
				}
				sClickUrl = unescape(dgLoader.data.btOnClick);

				if (dgLoader.data.btRobot != undefined && dgLoader.data.btRobot > 0) {
					pUse.btnRobot.visible = true;
				}
			}
			if (dgLoader.data.nsMax != undefined) {
				pUse.counter.visible = true;
				pUse.counter.dtCount.text = dgLoader.data.nsVal;
				iUseMax = dgLoader.data.nsMax;
			}
			if (dgLoader.data.dg_h != undefined) {
				pUse.bgItems.visible = true;
				pUse.dtDgHeader.htmlText = dgLoader.data.dg_h;
				if (dgLoader.data.rows > 0) {
					for (t = 0; t < dgLoader.data.cols; t++) {
						pUse.dgItems.addColumn( dgLoader.data["col" + t] );
					}
					for (i = 0; i < dgLoader.data.rows; i++) {
						var dgFill = new Array();
						for (t = 0; t < dgLoader.data.cols; t++) {
							dgFill[dgLoader.data["col" + t]] = dgLoader.data["l" + i + "c" + t];
						}
						if (dgLoader.data["l" + i + "color"] != undefined) {
							dgFill["bgColor"] = dgLoader.data["l" + i + "color"];
						}
						dgDp.addItem(dgFill);
					}
					pUse.dgItems.visible = true;
				}
			}
		}

		public function clickStart( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, afterStart);
			if (pUse.counter.visible) {
				//nopLoader.load(new URLRequest("d:\nop.txt"));
				nopLoader.load(new URLRequest( sClickUrl+pUse.counter.dtCount.text ));
			} else {
				//nopLoader.load(new URLRequest("d:\nop.txt"));
				nopLoader.load(new URLRequest( sClickUrl+"&invis" ));
			}
		}

		public function clickRobot( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, afterStart);
			//nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( sClickUrl+"&robot=1" ));
		}

		private function afterStart( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, afterStart );
			mapRefresh( giX, 0 );
		}

		private function upgradeRender(event:Event) {
			var i:int;
			var t:int;
			pUpgrade.dtTitle.htmlText = aLoader.data.title;
			if (aLoader.data.level) {
				pUpgrade.bgDesc.visible = true;
				pUpgrade.dtLevel.htmlText = aLoader.data.level;
				pUpgrade.dtDesc.htmlText = aLoader.data.desc;
				if (aLoader.data.header) {
					pUpgrade.bgItems.visible = true;
					pUpgrade.dtDgHeader.htmlText = aLoader.data.header;
					pUpgrade.dgItems.removeAll();
					if (aLoader.data.btLabel) {
						pUpgrade.btnUpgrade.visible = true;
						frame_fg.btnUpgrade.visible = true;
					}
					if (aLoader.data.rows > 0) {
						for (t = 0; t < aLoader.data.cols; t++) {
							pUpgrade.dgItems.addColumn( aLoader.data["col" + t] );
						}
						for (i = 0; i < aLoader.data.rows; i++) {
							var dgFill = new Array();
							for (t = 0; t < aLoader.data.cols; t++) {
								dgFill[aLoader.data["col" + t]] = aLoader.data["l" + i + "c" + t];
							}
							if (aLoader.data["l" + i + "color"] != undefined) {
								dgFill["bgColor"] = aLoader.data["l" + i + "color"];
							}
							adgDp.addItem(dgFill);
						}
						pUpgrade.dgItems.visible = true;
					}
				}
			}
		}

		public function clickUpgrade( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, afterStart);
			//nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( aLoader.data.upgOnClick ));
		}

		private function mapStart( e:MouseEvent ) {
			bDrag = true;
			map.startDrag( false );
			frame_fg.visible = false;
			oldX = map.x;
		}

		private function mapStop( e:MouseEvent ) {
			if (bDrag) {
				bDrag = false;

				map.stopDrag();
				var bMove:Boolean = true;
				map.y = 250;
				if (map.x > 400) {
					map.x = 400;
					bMove = true;
				}
				if (map.x + map.width < 1100) {
					map.x =  -  map.width + 1100;
					bMove = true;
				}
				frame_fg.x = map.x + giX * 100;
				frame_fg.visible = true;
				var iLen:int = Math.abs(oldX - map.x);
				if (iLen < 10 && e.type == "mouseUp" && bMove) {
					var bldMc:MovieClip;
					giX = uint( ( map.mouseX + 50 ) / 100 );
					if (giX < 0) {
						giX = 0;
					}
					if (giX >= iMapLen) {
						giX = iMapLen - 1;
					}
					map.frame_bg.x = giX * 100;
					frame_fg.x = map.x + giX * 100;
					panelsRefresh();
				}
			}
		}

		private function mapRender(event:Event) {
			var i:uint = 0;
			var a;
			var hl;
			var chl:String;
			var ch:String;
			var ClassReference:Class;
			var oldMc:MovieClip;
			var circ:Shape = new Shape();
			var mColor:int;

			iMapLen = mapLoader.data.line.length;

			a = mapLoader.data.line;
			if (giX == -1) {
				giX = mapLoader.data.lastx;
				map.x = giX * -100 + 700;
				frame_fg.x = map.x + giX * 100;
				map.frame_bg.x = giX * 100;
				panelsRefresh();
			}
			fMagnify = 300 / iMapLen;
			for (i = 0; i < iMapLen; i++) {
				ch = a.charAt(i);
				if (ch != '0') {
					oldMc = map.buildings.getChildByName(String("b" + i));
					if (oldMc) {
						map.buildings.removeChild( oldMc );
					}
					ClassReference = getDefinitionByName("bld" + ch) as Class;
					var bldChar:MovieClip = new ClassReference();
					bldChar.x = i * 100;
					bldChar.y = 0;
					bldChar.name = String("b" + i);
					map.buildings.addChild( bldChar );

					mColor = 0xFFFFFF;
					if (mapLoader.data["t" + i]) {

						switch ( mapLoader.data[ "c"+i ] ) {
							case '1' :// build
								mColor = 0xFF0000;
								break;
							case '2' :// mine
								mColor = 0x00FF00;
								break;
							case '3' :// dispence
								mColor = 0x00FFFF;
								break;
							case '4' :// upgrade
								mColor = 0xFFFF00;
								break;
							case '5' :// make
								mColor = 0x00FFFF;
								break;
						}

						if (mapLoader.data["s" + i] < 0) {
							mColor = 0xFF00FF;
						}

						oldMc = map.timers.getChildByName(String("t" + i));
						if (! oldMc) {
							var mvTimer:MovieClip = new mTimer();
							var tTimer:pTimer = new pTimer( mapLoader.data[ "t"+i ],
							mapLoader.data[ "l"+i ],
							mapLoader.data[ "s"+i ],
							mvTimer, mColor,
							mapRefresh, i, 0 );
							mvTimer.x = i * 100 - 25;
							mvTimer.y = -75;
							mvTimer.name = String("t" + i);
							mvTimer.alpha = 0.8;
							map.timers.addChild( mvTimer );
							tTimer.reset();
							tTimer.start();
						}

					} else {
						oldMc = map.timers.getChildByName(String("t" + i));
						if (oldMc) {
							map.timers.removeChild( oldMc );
						}
					}
				} else {
					oldMc = map.buildings.getChildByName(String("b" + i));
					if (oldMc) {
						map.buildings.removeChild( oldMc );
					}
					oldMc = map.timers.getChildByName(String("t" + i));
					if (oldMc) {
						map.timers.removeChild( oldMc );
					}
					oldMc = map.planet.getChildByName(String("p" + i));
					if (oldMc) {
						map.planet.removeChild( oldMc );
					}
					var empChar:MovieClip = new jpeg0();
					empChar.x = i * 100;
					empChar.y = 0;
					empChar.name = String("p" + i);
					map.planet.addChild( empChar );
				}
			}
		}

		public function mapRefresh( liX:int, liY:int ) {
			//mapLoader.load(new URLRequest("d:\page21.txt"));
			mapLoader.load(new URLRequest("page.php?id=22"));
			if (giX == liX) {
				panelsRefresh();
			}
		}

		public function PageInfoUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( pInfo, 4 );
			setChildIndex( pUse, 3 );
			setChildIndex( pUpgrade, 2 );
			iTween = new Tween(pInfo,"alpha",Strong.easeOut,pInfo.alpha,1,1,true);
			uTween = new Tween(pUse,"alpha",Strong.easeOut,pUse.alpha,0.5,1,true);
			aTween = new Tween(pUpgrade,"alpha",Strong.easeOut,pUpgrade.alpha,0.5,1,true);
		}

		public function PageUseUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( pUse, 4 );
			setChildIndex( pInfo, 3 );
			setChildIndex( pUpgrade, 2 );
			iTween = new Tween(pUse,"alpha",Strong.easeOut,pUse.alpha,1,1,true);
			uTween = new Tween(pInfo,"alpha",Strong.easeOut,pInfo.alpha,0.5,1,true);
			aTween = new Tween(pUpgrade,"alpha",Strong.easeOut,pUpgrade.alpha,0.5,1,true);
		}

		public function PageUpgradeUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( pUpgrade, 4 );
			setChildIndex( pUse, 3 );
			setChildIndex( pInfo, 2 );
			iTween = new Tween(pUpgrade,"alpha",Strong.easeOut,pUpgrade.alpha,1,1,true);
			uTween = new Tween(pUse,"alpha",Strong.easeOut,pUse.alpha,0.5,1,true);
			aTween = new Tween(pInfo,"alpha",Strong.easeOut,pInfo.alpha,0.5,1,true);
		}

		public function PageOpenClose( e:MouseEvent ) {
			if (iClosed) {
				iTween = new Tween(pUpgrade,"x",Strong.easeOut,pUpgrade.x,0,1,true);
				uTween = new Tween(pUse,"x",Strong.easeOut,pUse.x,0,1,true);
				aTween = new Tween(pInfo,"x",Strong.easeOut,pInfo.x,0,1,true);
				bTween = new Tween(btnOpenClose,"x",Strong.easeOut,btnOpenClose.x,316,1,true);
			} else {
				iTween = new Tween(pUpgrade,"x",Strong.easeOut,pUpgrade.x,-350,1,true);
				uTween = new Tween(pUse,"x",Strong.easeOut,pUse.x,-350,1,true);
				aTween = new Tween(pInfo,"x",Strong.easeOut,pInfo.x,-350,1,true);
				bTween = new Tween(btnOpenClose,"x",Strong.easeOut,btnOpenClose.x,0,1,true);
			}

			iClosed = ! iClosed;
		}
	}
}
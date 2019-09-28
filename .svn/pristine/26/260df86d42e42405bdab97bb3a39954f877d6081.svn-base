package {
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
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
	import flash.geom.Point;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import fl.transitions.TweenEvent;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class planet3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform(Number(root.loaderInfo.parameters.sv) / 100,0);
		private var chanel:SoundChannel;

		private var iMapLight:uint = uint(root.loaderInfo.parameters.ml);
		private var iMapLen:uint = 0;
		private var giX:int = 0;
		private var giY:int = 0;
		private var oldX:int = 0;
		private var oldY:int = 0;
		private var iZoom:int = 1;
		private var gMapWidth:int = 0;
		private var gMapHeight:int = 0;
		private var bDrag:Boolean = false;
		private var bUpgradeable = false;
		private var fxMagnify:Number = 0;
		private var fyMagnify:Number = 0;
		private var bdMiniMap:BitmapData = new BitmapData(300,300,false,0x000000);
		private var bMiniMap:Bitmap = new Bitmap(bdMiniMap);
		private var mTween:Tween;

		private var iTween:Tween;
		private var uTween:Tween;
		private var aTween:Tween;
		private var bldTween:Tween;
		private var sTween:Tween;
		private var mapTween:Tween;
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

		private var iClosed:Boolean = false;

		private var arrPlanet:Array = new Array();
		private var arrTimers:Array = new Array();
		private var arrBuilds:Array = new Array();
		private var arrColors:Array = new Array();
		private var bMapReady:Boolean = true;

		private var hintTimer:Timer = new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function planet3() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			nopLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			hinter.visible = false;
			hinter.mvTimer.visible = false;

			root.addEventListener( MouseEvent.MOUSE_OVER, startHint );
			hintTimer.addEventListener(TimerEvent.TIMER, loadHint);
			hLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			hLoader.addEventListener(Event.COMPLETE, hintLoaded);
			root.addEventListener( MouseEvent.MOUSE_OUT, hideHint );

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
//			mapLoader.load(new URLRequest("d:\page21.txt"));
			mapLoader.load(new URLRequest("page.php?id=21&full=true&ml=" + iMapLight));

			miniMap.addEventListener( MouseEvent.MOUSE_OVER, showMap );
			miniMap.addEventListener( MouseEvent.MOUSE_OUT, hideMap );
			miniMap.theMap.addEventListener(MouseEvent.CLICK, moveMap);
			miniMap.btnShowUpgrade.addEventListener(MouseEvent.CLICK, showUpgrade);
			miniMap.btnHideUpgrade.visible = false;
			miniMap.btnHideUpgrade.addEventListener(MouseEvent.CLICK, hideUpgrade);

			map.addEventListener(MouseEvent.MOUSE_DOWN, mapStart);
			map.addEventListener(MouseEvent.MOUSE_UP, mapStop);
			root.addEventListener(MouseEvent.MOUSE_UP, mapStop);

			//map.addEventListener(MouseEvent.MOUSE_WHEEL, mapZoom);

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
				hinter.visible = true;
				hinter.x = mouseX;
				hinter.y = mouseY;
				hinter.startDrag( true );
				hinter.mvTimer.visible = true;
				hLoader.load( new URLRequest( "page.php?id=8&asc=planet_"+hintName ) );
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
			iLoader.load( new URLRequest( "page.php?id=26&x="+giX+"&y="+giY ));

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
			uLoader.load( new URLRequest( "page.php?id=27&x="+giX+"&y="+giY ));

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
			aLoader.load( new URLRequest( "page.php?id=273&x="+giX+"&y="+giY ));
		}

		private function infoRender(event:Event) {
			pInfo.dtCoord.text = giX + " : " + giY;
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
			nopLoader.load(new URLRequest( "page.php?id=261&x="+giX+"&y="+giY ));
		}

		private function afterDestroy( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, afterDestroy );
			//mapLoader.load(new URLRequest("d:\page21.txt"));
			mapLoader.load(new URLRequest("page.php?id=21&full=false&ml=" + iMapLight));
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
				//bldMc = map.buildings.getChildByName( String( "b"+giX+"x"+giY ) );
				if( dgLoader.data.nsMax == undefined ) {
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
			mapRefresh( giX, giY );
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
			frame_fg.visible = false;
			map.startDrag( false );
			oldX = map.x;
			oldY = map.y;
		}

		private function mapStop( e:MouseEvent ) {
			if (bDrag) {
				bDrag = false;
				map.stopDrag();
				var bMove:Boolean = true;
				if (map.x + map.width < 1000 + 100) {
					map.x =  -  map.width + 1000 + 100;
					bMove = true;
				}
				if (map.y + map.height < 550) {
					map.y =  -  map.height + 550;
					bMove = true;
				}
				if (map.x > 400) {
					map.x = 400;
					bMove = true;
				}
				if (map.y > 80) {
					map.y = 80;
					bMove = true;
				}

				if (giY / 2 == int(giY / 2)) {
					frame_fg.x = map.x + giX * 120;
				} else {
					frame_fg.x = map.x + giX * 120 + 60;
				}
				frame_fg.y = map.y + giY * 60;

				frame_fg.visible = true;
				var iLen:int = Math.sqrt(Math.pow(oldX - map.x,2) + Math.pow(oldY - map.y,2));
				if (iLen < 10 && e.type == "mouseUp" && bMove) {
					var bldMc:MovieClip;

					giX = uint( ( ( map.mouseX + 60 ) - 60 * uint( ( map.mouseY + 30 ) % 120 / 60 ) ) / 120 );
					giY = uint( ( map.mouseY + 30 ) * 2 / 120 );

					if (giX < 0) {
						giX = 0;
					}
					if (giY < 0) {
						giY = 0;
					}
					if (giX >= iMapLen) {
						giX = iMapLen - 1;
					}
					if (giY >= iMapLen) {
						giY = iMapLen - 1;
					}

					if (giY / 2 == int(giY / 2)) {
						map.frame_bg.x = giX * 120;
						frame_fg.x = map.x + giX * 120;
					} else {
						map.frame_bg.x = giX * 120 + 60;
						frame_fg.x = map.x + giX * 120 + 60;
					}
					map.frame_bg.y = giY * 60;
					frame_fg.y = map.y + giY * 60;

					panelsRefresh();
				}
			}
		}

		private function mapZoom( e:MouseEvent ) {
			if (gMapWidth == 0) {
				gMapWidth = map.width;
				gMapHeight = map.height;
			}

			if (e.delta > 0 && iZoom > 1) {
				iZoom--;
			}

			if (e.delta < 0 && iZoom < 4) {
				iZoom++;
			}

			map.x = map.x + ( map.width - gMapWidth / iZoom ) / 2;
			map.y = map.y + ( map.height - gMapHeight / iZoom ) / 2;

			map.width = gMapWidth / iZoom;
			map.height = gMapHeight / iZoom;
		}

		private function moveMap( e:MouseEvent ) {
			frame_fg.visible = true;
			map.y = ( miniMap.mouseY / fyMagnify ) * -60 + 300;
			map.x = ( miniMap.mouseX / fxMagnify ) * -120 + 700;
			if (map.x + map.width < 1000 + 100) {
				map.x =  -  map.width + 1000 + 100;
			}
			if (map.y + map.height < 700) {
				map.y =  -  map.height + 700;
			}
			if (map.x > 400) {
				map.x = 400;
			}
			if (map.y > 80) {
				map.y = 80;
			}

			giY = int(miniMap.mouseY / fyMagnify);
			if (giY / 2 == int(giY / 2)) {
				giX = int(miniMap.mouseX / fxMagnify);
			} else {
				giX = int(miniMap.mouseX / fxMagnify - 0.5 );
			}
			if (giY / 2 == int(giY / 2)) {
				frame_fg.x = map.x + giX * 120;
			} else {
				frame_fg.x = map.x + giX * 120 + 60;
			}
			frame_fg.y = map.y + giY * 60;

			if (giX < 0) {
				giX = 0;
			}
			if (giY < 0) {
				giY = 0;
			}
			if (giX >= iMapLen) {
				giX = iMapLen - 1;
			}
			if (giY >= iMapLen) {
				giY = iMapLen - 1;
			}

			if (giY / 2 == int(giY / 2)) {
				map.frame_bg.x = giX * 120;
				frame_fg.x = map.x + giX * 120;
			} else {
				map.frame_bg.x = giX * 120 + 60;
				frame_fg.x = map.x + giX * 120 + 60;
			}
			map.frame_bg.y = giY * 60;
			frame_fg.y = map.y + giY * 60;

			panelsRefresh();
		}

		private function showMap( e:MouseEvent ) {
			if (miniMap.width < 35) {
				mTween = new Tween(miniMap,"width",Strong.easeOut,34,340,0.5,true);
				mTween = new Tween(miniMap,"height",Strong.easeOut,30,300,0.5,true);
				mTween = new Tween(miniMap,"alpha",Strong.easeOut,0.5,1,1,true);
			}
		}

		private function hideMap( e:MouseEvent ) {
			if (miniMap.mouseX > 340 || miniMap.mouseY > 300 || miniMap.mouseX < 0 || miniMap.mouseY < 0) {
				mTween = new Tween(miniMap,"width",Strong.easeOut,miniMap.width,34,0.5,true);
				mTween = new Tween(miniMap,"height",Strong.easeOut,miniMap.height,30,0.5,true);
				mTween = new Tween(miniMap,"alpha",Strong.easeOut,miniMap.alpha,0.5,1,true);
			}
		}

		public function showUpgrade( e:MouseEvent ) {
			var i:uint = 0;
			var t:uint = 0;
			bUpgradeable = true;
			var circ:Shape = new Shape();

			miniMap.btnHideUpgrade.visible = true;
			miniMap.btnShowUpgrade.visible = false;

			for (t = 0; t < mapLoader.data.num; t++) {
				for (i = 0; i < iMapLen; i++) {
					if (mapLoader.data["v" + i + "x" + t]) {
						circ.graphics.lineStyle( 0, 0xFF0000 );
						arrColors["v" + i + "x" + t] = 0xFF0000;
						if (t / 2 == int(t / 2)) {
							circ.graphics.drawRect( i * fxMagnify + 1, t * fyMagnify + 1, fxMagnify - 2, fyMagnify - 2 );
						} else {
							circ.graphics.drawRect( fxMagnify / 2 + i * fxMagnify + 1, t * fyMagnify + 1, fxMagnify - 2, fyMagnify - 2 );
						}
						bdMiniMap.draw( circ );
						circ.graphics.clear();
					}
				}
			}
		}

		public function hideUpgrade( e:MouseEvent ) {
			miniMap.btnShowUpgrade.visible = true;
			miniMap.btnHideUpgrade.visible = false;

			bUpgradeable = false;
			mapRender( e );
		}

		private function mapRender(event:Event) {
			var i:uint = 0;
			var t:uint = 0;
			var a, tr;
			var hl;
			var chl:String;
			var ch:String;
			var ClassReference:Class;
			var oldMc:MovieClip;
			var circ:Shape = new Shape();

			iMapLen = mapLoader.data.bl0.length;
			fxMagnify = 300 / ( iMapLen + 0.5 );
			fyMagnify = 300 / mapLoader.data.num;

			if( iMapLen == 1 ) {
				miniMap.visible = false;
			}

			if (mapLoader.data.gl0 && bMapReady) {
				bMapReady = false;
				if (giX == 0 && giY == 0) {
					giX = mapLoader.data.lastx;
					giY = mapLoader.data.lasty;
				}
				miniMap.addChild( bMiniMap );
				panelsRefresh();
				for (t = 0; t < mapLoader.data.num; t++) {
					a = mapLoader.data['gl' + t];
					if (mapLoader.data['hl' + t] != undefined) {
						hl = mapLoader.data['hl' + t];
					} else {
						hl = '';
					}
					for (i = 0; i < iMapLen; i++) {
						ch = a.charAt(i);
						if (hl.length >= i) {
							chl = hl.charAt(i);
						} else {
							chl = '0';
						}
						var mColor:int = 0xFF00FF;
						switch ( ch ) {
							case '0' :
								mColor = 0x0066CC;
								break;
							case '1' :
								mColor = 0x663300;
								break;
							case '2' :
								mColor = 0x999999;
								break;
							case '3' :
								mColor = 0xCCCCCC;
								break;
							case '4' :
								mColor = 0xCCCC33;
								break;
							case '5' :
							case '7' :
								mColor = 0x006600;
								break;
							case '6' :
								mColor = 0x009900;
								break;
							case '8' :
								mColor = 0xDDDDDD;
								break;
							case '9' :
								mColor = 0xDD9900;
								break;
							default :
								mColor = 0xFFFFFF;
								break;
						}
						if (iMapLight) {
							switch ( chl ) {
								case '1' :
									mColor = 0x000066;
									break;
								case '2' :
									mColor = 0x000000;
									break;
								default :
									break;
							}
						}
						if (t / 2 == int(t / 2)) {
							if (i == iMapLen - 1) {
								bdMiniMap.fillRect(new Rectangle(i * fxMagnify, t * fyMagnify, fxMagnify + fxMagnify / 2, fyMagnify ), mColor );
							} else {
								bdMiniMap.fillRect(new Rectangle(i * fxMagnify, t * fyMagnify, fxMagnify, fyMagnify ), mColor );
							}
						} else {
							if (i == 0) {
								bdMiniMap.fillRect(new Rectangle( i * fxMagnify, t * fyMagnify, fxMagnify + fxMagnify / 2, fyMagnify ), mColor );
							} else {
								bdMiniMap.fillRect(new Rectangle( fxMagnify / 2 + i * fxMagnify, t * fyMagnify, fxMagnify, fyMagnify ), mColor );
							}
						}
						if (arrPlanet["p" + i + "x" + t] != undefined) {
							oldMc = map.planet.getChildByName(String("p" + i + "x" + t));
							if (oldMc) {
								map.planet.removeChild( oldMc );
							}
						}
						ClassReference = getDefinitionByName("jpeg" + ch) as Class;
						var mapChar:MovieClip = new ClassReference();
						if (t / 2 == int(t / 2)) {
							mapChar.x = i * 120;
						} else {
							mapChar.x = i * 120 + 60;
						}
						mapChar.y = t * 60;
						mapChar.name = String("p" + i + "x" + t);
						arrPlanet["p" + i + "x" + t] = true;
						map.planet.addChild( mapChar );
					}
				}
				if (giY / 2 == int(giY / 2)) {
					map.frame_bg.x = giX * 120;
					map.x = giX * -120 + 700;
				} else {
					map.frame_bg.x = giX * 120 + 60;
					map.x = giX * -120 + 700 + 60;
				}
				map.frame_bg.y = giY * 60;
				map.y = giY * -60 + 240;
				if (map.x + map.width < 1000 + 100) {
					map.x =  -  map.width + 1000 + 100;
				}
				if (map.y + map.height < 550) {
					map.y =  -  map.height + 550;
				}
				if (map.x > 400) {
					map.x = 400;
				}
				if (map.y > 80) {
					map.y = 80;
				}
				if (giY / 2 == int(giY / 2)) {
					frame_fg.x = map.x + giX * 120;
				} else {
					frame_fg.x = map.x + giX * 120 + 60;
				}
				frame_fg.y = map.y + giY * 60;
			}

			for (t = 0; t < mapLoader.data.num; t++) {
				a = mapLoader.data['bl' + t];
				tr = mapLoader.data['tr' + t];
				for (i = 0; i < iMapLen; i++) {
					ch = a.charAt(i);
					if (ch != '0') {
						//oldMc = map.buildings.getChildByName( String( "b"+i+"x"+t ) );
						if (arrBuilds["b" + i + "x" + t] != ch) {
							oldMc = map.buildings.getChildByName(String("b" + i + "x" + t));
							if (oldMc) {
								map.buildings.removeChild( oldMc );
							}
							arrBuilds["b" + i + "x" + t] = undefined;
						}
						if (arrBuilds["b" + i + "x" + t] == undefined) {
							ClassReference = getDefinitionByName("bld" + ch) as Class;
							var bldChar:MovieClip = new ClassReference();
							if (t / 2 == int(t / 2)) {
								bldChar.x = i * 120;
							} else {
								bldChar.x = i * 120 + 60;
							}
							bldChar.y = t * 60;
							bldChar.name = String("b" + i + "x" + t);
							arrBuilds["b" + i + "x" + t] = ch;
							map.buildings.addChild( bldChar );
						}

						switch( ch ) {
							case 'K' :
							case 'M' :
							case 'O' :
								mColor = 0xFFFFFF;
								break;

							default :
								mColor = 0x000000;
								break;
						}

						if (mapLoader.data["t" + i + "x" + t]) {

							switch ( mapLoader.data[ "c"+i+"x"+t ] ) {
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

							if (mapLoader.data["s" + i + "x" + t] < 0) {
								mColor = 0xFF00FF;
							}

							//oldMc = map.timers.getChildByName( String( "t"+i+"x"+t ) );
							if (arrTimers["t" + i + "x" + t] == undefined) {
								var mvTimer:MovieClip = new mTimer();
								var tTimer:pTimer = new pTimer( mapLoader.data[ "t"+i+"x"+t ],
								mapLoader.data[ "l"+i+"x"+t ],
								mapLoader.data[ "s"+i+"x"+t ],
								mvTimer, mColor,
								mapRefresh, i, t );
								if (t / 2 == int(t / 2)) {
									mvTimer.x = i * 120 - 60;
								} else {
									mvTimer.x = i * 120;
								}
								mvTimer.y = t * 60 - 60;
								mvTimer.alpha = 0.8;
								mvTimer.name = String("t" + i + "x" + t);
								arrTimers["t" + i + "x" + t] = true;
								map.timers.addChild( mvTimer );
								tTimer.reset();
								tTimer.start();
							}

						} else {
							if (arrTimers["t" + i + "x" + t] != undefined) {
								oldMc = map.timers.getChildByName(String("t" + i + "x" + t));
								if (oldMc) {
									map.timers.removeChild( oldMc );
								}
								arrTimers["t" + i + "x" + t] = undefined;
							}
						}

						if (bUpgradeable && mapLoader.data["v" + i + "x" + t]) {
							mColor = 0xFF0000;
						}

						if (arrColors["v" + i + "x" + t] != mColor) {
							circ.graphics.lineStyle( 0, mColor );
							if (t / 2 == int(t / 2)) {
								circ.graphics.drawRect( i * fxMagnify + 1, t * fyMagnify + 1, fxMagnify - 2, fyMagnify - 2 );
							} else {
								circ.graphics.drawRect( fxMagnify / 2 + i * fxMagnify + 1, t * fyMagnify + 1, fxMagnify - 2, fyMagnify - 2 );
							}
							bdMiniMap.draw( circ );
							circ.graphics.clear();
							arrColors["v" + i + "x" + t] = mColor;
						}
					} else {
						if (arrBuilds["b" + i + "x" + t] != undefined) {
							oldMc = map.buildings.getChildByName(String("b" + i + "x" + t));
							if (oldMc) {
								map.buildings.removeChild( oldMc );
							}
							arrBuilds["b" + i + "x" + t] = undefined;
						}
						if (arrTimers["t" + i + "x" + t] != undefined) {
							oldMc = map.timers.getChildByName(String("t" + i + "x" + t));
							if (oldMc) {
								map.timers.removeChild( oldMc );
							}
							arrTimers["t" + i + "x" + t] = undefined;
						}
						
						if ( tr.charAt(i) != '0' && arrBuilds["b" + i + "x" + t] == undefined && arrTimers["t" + i + "x" + t] == undefined) {
							ClassReference = getDefinitionByName("fg" + tr.charAt(i)) as Class;
							var treeChar:MovieClip = new ClassReference();
							if (t / 2 == int(t / 2)) {
								treeChar.x = i * 120;
							} else {
								treeChar.x = i * 120 + 60;
							}
							treeChar.y = t * 60;
							treeChar.name = String("b" + i + "x" + t);
							arrBuilds["b" + i + "x" + t] = '.';
							map.buildings.addChild( treeChar );
						}
					}
				}
			}
		}

		public function mapRefresh( liX:int, liY:int ) {
			//mapLoader.load(new URLRequest("d:\page21.txt"));
			mapLoader.load(new URLRequest("page.php?id=21&full=false&ml=" + iMapLight));
			if (giX == liX && giY == liY) {
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
				iTween = new Tween(pUpgrade,"x",Strong.easeOut,pUpgrade.x,1,1,true);
				uTween = new Tween(pUse,"x",Strong.easeOut,pUse.x,0,1,true);
				aTween = new Tween(pInfo,"x",Strong.easeOut,pInfo.x,0,1,true);
				bTween = new Tween(btnOpenClose,"x",Strong.easeOut,btnOpenClose.x,310,1,true);
				mapTween = new Tween(miniMap,"x",Strong.easeOut,miniMap.x,350,1,true);
			} else {
				iTween = new Tween(pUpgrade,"x",Strong.easeOut,pUpgrade.x,-350,1,true);
				uTween = new Tween(pUse,"x",Strong.easeOut,pUse.x,-350,1,true);
				aTween = new Tween(pInfo,"x",Strong.easeOut,pInfo.x,-350,1,true);
				bTween = new Tween(btnOpenClose,"x",Strong.easeOut,btnOpenClose.x,4,1,true);
				mapTween = new Tween(miniMap,"x",Strong.easeOut,miniMap.x,44,1,true);
			}

			iClosed = ! iClosed;
		}
	}
}
package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextFormat;
	import fl.controls.DataGrid;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class warehouse3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var chanel:SoundChannel;
		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();

		private var iMax:uint = 0;
		private var iIndex:int = -1;
		private var iShipIndex:int = -1;
		private var sMove:String = "0";
		private var iCnt:int;
		private var iProgressMax:uint;

		private var pLoader:URLLoader = new URLLoader();
		private var pDp:DataProvider = new DataProvider();

		private var sLoader:URLLoader = new URLLoader();
		private var sDp:DataProvider = new DataProvider();
		private var sDefault:String = root.loaderInfo.parameters.shid;

		private var wLoader:URLLoader = new URLLoader();
		private var wDp:DataProvider = new DataProvider();

		private var siLoader:URLLoader = new URLLoader();
		private var siDp:DataProvider = new DataProvider();

		private var wiLoader:URLLoader = new URLLoader();
		private var wiDp:DataProvider = new DataProvider();

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function warehouse3() {
			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			hinter.visible = false;
			hinter.mvTimer.visible = false;
			hinter.startDrag( true );

			root.addEventListener( MouseEvent.MOUSE_OVER, startHint );
			hintTimer.addEventListener(TimerEvent.TIMER, loadHint);
			hLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			hLoader.addEventListener(Event.COMPLETE, hintLoaded);
			root.addEventListener( MouseEvent.MOUSE_OUT, hideHint );

			myFormat.color=0xFFFFFF;
			myFormat.font="Verdana";
			myFormat.size=12;

			myHeadFormat.color=0xBFBFFF;
			myHeadFormat.font="Verdana";
			myHeadFormat.size=12;
			myHeadFormat.bold=true;
			
			upArrow.gotoAndStop(0);
			upArrow.visible = false;
			downArrow.gotoAndStop(0);
			downArrow.visible = false;
			upArrow.addEventListener( Event.ENTER_FRAME, upStop );
			downArrow.addEventListener( Event.ENTER_FRAME, downStop );

			cbShip.textField.setStyle( "textFormat", myHeadFormat );
			cbShip.dropdown.setRendererStyle( "textFormat", myFormat );
			cbShip.selectedIndex=1;
			cbShip.addEventListener( Event.CHANGE, scbChange );

			cbWare.textField.setStyle( "textFormat", myHeadFormat );
			cbWare.dropdown.setRendererStyle( "textFormat", myFormat );
			cbWare.selectedIndex=1;
			cbWare.addEventListener( Event.CHANGE, wcbChange );
			hider();

			cbPlace.dataProvider=pDp;
			cbPlace.addEventListener( Event.CHANGE, placeChange );

			pLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			pLoader.addEventListener(Event.COMPLETE, placeLoaded);
//			pLoader.load(new URLRequest("d:\page46.txt"));
			pLoader.load(new URLRequest("page.php?id=46"));

			dgShips.setRendererStyle( "textFormat", myFormat );
			dgShips.setStyle( "headerTextFormat", myHeadFormat );
			dgShips.addEventListener( Event.CHANGE, sChange );
			dgShips.addColumn( "Наименование" );
			dgShips.addColumn( "Расположение" );
			dgShips.addColumn( "Объем" );
			dgShips.columns[0].width=120;
			dgShips.columns[1].width=300;
			dgShips.columns[2].width=80;
			dgShips.dataProvider=sDp;
			dgShips.setStyle("cellRenderer",AlternatingRowColors);
			sLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, shipsLoad);

			dgShipItems.setRendererStyle( "textFormat", myFormat );
			dgShipItems.setStyle( "headerTextFormat", myHeadFormat );
			dgShipItems.addEventListener( Event.CHANGE, siChange );
			siLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			siLoader.addEventListener(Event.COMPLETE, sItemsLoad);

			dgWare.setRendererStyle( "textFormat", myFormat );
			dgWare.setStyle( "headerTextFormat", myHeadFormat );
			dgWare.addEventListener( Event.CHANGE, wChange );
			wLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			wLoader.addEventListener(Event.COMPLETE, wareLoad);

			dgWareItems.setRendererStyle( "textFormat", myFormat );
			dgWareItems.setStyle( "headerTextFormat", myHeadFormat );
			dgWareItems.addEventListener( Event.CHANGE, wiChange );
			wiLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			wiLoader.addEventListener(Event.COMPLETE, wItemsLoad);

			btnMove.addEventListener(MouseEvent.CLICK, itemsMove);
			btnMoveAll.addEventListener(MouseEvent.CLICK, itemsMoveAll);
			dtCount.addEventListener( Event.CHANGE, countChange );
		}

		private function startHint( e:MouseEvent ) {
			if( e.relatedObject != null ) {
				var point:Point = new Point(mouseX, mouseY);
				var objects:Array = stage.getObjectsUnderPoint( point );
				hintName = objects[ objects.length - 1 ].name;
				hintTimer.stop();
				hintTimer.reset();
				hintTimer.start();
				if( mouseX < 700 ) {
					hinter.dtHint.x = 16;
					hinter.bgHint.x = 16;
				} else {
					hinter.dtHint.x = -300;
					hinter.bgHint.x = -300;
				}
				if( mouseY < 60 ) {
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
			var point:Point = new Point(mouseX, mouseY);
			var objects:Array = stage.getObjectsUnderPoint( point );

			if( hintName == objects[ objects.length - 1 ].name ) {
				setChildIndex( hinter, hinter.parent.numChildren - 1 );
				hinter.bgHint.visible = false;
				hinter.dtHint.text = '';
				hinter.visible = true;
				hinter.mvTimer.visible = true;
				hLoader.load( new URLRequest( "page.php?id=8&asc=warehouse_"+hintName ) );
			} else {
				hinter.visible = false;
			}
		}

		private function hintLoaded( event:Event ) {
			if( hLoader.data.err == 0 ) {
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

		private function upStop(event:Event) {
			if( upArrow.currentFrame == upArrow.totalFrames ) {
				upArrow.gotoAndStop( 0 );
				upArrow.visible = false;
			}
		}

		private function downStop(event:Event) {
			if( downArrow.currentFrame == downArrow.totalFrames ) {
				downArrow.gotoAndStop( 0 );
				downArrow.visible = false;
			}
		}

		public function placeLoaded(event:Event) {
			var i:uint, iPos:int, iPosData:String;
			iPos = -1;
			if( pLoader.data.lastPlace != '' ) {
				iPosData = pLoader.data.lastPlace;
			}
			if( cbPlace.selectedIndex > 0 ) {
				iPosData = cbPlace.selectedItem.data;
			}
			pDp.removeAll();
			pDp.addItem({"data":'*',"label":'Все'});
			if (pLoader.data.cnt>0) {
				for (i=0; i<pLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["data"]=pLoader.data["id"+i];
					dgFill["label"]=pLoader.data["name"+i];
					if( iPosData == pLoader.data["id"+i] ) {
						iPos = i+1;
					}
					pDp.addItem(dgFill);
				}
				cbPlace.textField.setStyle( "textFormat", myHeadFormat );
				cbPlace.dropdown.setRendererStyle( "textFormat", myFormat );
				cbPlace.rowCount = 11;
				if( iPos >= 0 ) {
					cbPlace.selectedIndex = iPos;
				} else {
					cbPlace.selectedIndex = 0;
				}
				placeChange( event );
			}
		}

		private function placeChange(event:Event) {
//			sLoader.load(new URLRequest("d:\page41.txt"));
			sLoader.load(new URLRequest("page.php?id=41&shid="+sDefault+"&pl="+escape( cbPlace.selectedItem.data )));
		}

		private function shipsLoad(event:Event) {
			var i:uint;
			var iPos:int;
			sDp.removeAll();
			if (sLoader.data.cnt>0) {
				if( sLoader.data.pos ) {
					iPos = sLoader.data.pos;
				} else {
					iPos = 0;
				}
				for (i=0; i<sLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=sLoader.data["name"+i];
					dgFill["Расположение"]=sLoader.data["place"+i];
					dgFill["Объем"]=sLoader.data["cargo"+i];

					if (sLoader.data["c"+i]) {
						dgFill["bgColor"]=sLoader.data["c"+i];
					}
					sDp.addItem(dgFill);
				}

				dgShips.selectedIndex = iPos;
				if( dgShips.selectedIndex + 9 < dgShips.length ) {
					dgShips.scrollToIndex( dgShips.selectedIndex + 9 );
				} else {
					dgShips.scrollToIndex( dgShips.length );
				}
				sChange(event);
			}
		}

		private function sChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( dgShips.selectedItems.length == 1 ) {
				if (cbShip.selectedItem) {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+"&shid="+sLoader.data["id"+dgShips.selectedIndex]));
				} else {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf=0&shid="+sLoader.data["id"+dgShips.selectedIndex]));
				}
//				wLoader.load(new URLRequest("d:\page43.txt"));
				wLoader.load(new URLRequest("page.php?id=43&shid="+sLoader.data["id"+dgShips.selectedIndex]));
			} else {
				var i:int;
				var str:String;
				str = '&scnt=' + dgShips.selectedItems.length;
				for( i = 0; i < dgShips.selectedItems.length; i++ ) {
					str = str + '&sh' + i + '=' + sLoader.data["id"+dgShips.selectedIndices[i]];
				}
				if (cbShip.selectedItem) {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+str));
				} else {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf=0"+str));
				}
//				wLoader.load(new URLRequest("d:\page43.txt"));
				wLoader.load(new URLRequest("page.php?id=43"+str));
			}
		}

		private function scbChange(event:Event) {
//			siLoader.load(new URLRequest("d:\page42.txt"));
			siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+"&shid="+sLoader.data["id"+dgShips.selectedIndex]));
		}

		private function sItemsLoad(event:Event) {
			var i:uint;
			if (siLoader.data.free) {
				dtShipCount.text=siLoader.data.free;
			}
			if (dgWareItems.selectedIndex!=-1) {
				hider();
			}
			siDp.removeAll();
			if (siLoader.data.cnt>0) {
				for (i=0; i<siLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=siLoader.data["n"+i];
					dgFill["Доступно"]=siLoader.data["c"+i];
					dgFill["Масса"]=siLoader.data["m"+i];

					if (siLoader.data["c"+i]) {
						dgFill["bgColor"]=siLoader.data["t"+i];
					}
					siDp.addItem(dgFill);
				}
				if (dgShipItems.columns.length==0) {
					dgShipItems.addColumn( "Наименование" );
					dgShipItems.addColumn( "Доступно" );
					dgShipItems.addColumn( "Масса" );

					dgShipItems.columns[0].width=300;
					dgShipItems.columns[1].width=100;
					dgShipItems.columns[2].width=70;
					dgShipItems.dataProvider=siDp;
					dgShipItems.setStyle("cellRenderer",AlternatingRowColors);
				}
			}
		}

		private function siChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			hider();
			dgWareItems.selectedIndex=-1;
			if (dgShipItems.selectedIndex!=-1) {
				downArrow.visible = true;
				downArrow.gotoAndPlay(0);
				iMax=siLoader.data["c"+dgShipItems.selectedIndex];
				btnMoveAll.visible=true;
				bgCount.visible=true;
				titCount.visible=true;
				dtCount.text="0";
				countChange(event);
			}
		}

		private function wareLoad(event:Event) {
			var i:uint;
			wDp.removeAll();
			if (wLoader.data.cnt>0) {
				for (i=0; i<wLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=wLoader.data["name"+i];
					dgFill["Расположение"]=wLoader.data["place"+i];
					dgFill["Объем"]=wLoader.data["cargo"+i];

					if (wLoader.data["c"+i]) {
						dgFill["bgColor"]=wLoader.data["c"+i];
					}
					wDp.addItem(dgFill);
				}
				if (dgWare.columns.length==0) {
					dgWare.addColumn( "Наименование" );
					dgWare.addColumn( "Расположение" );
					dgWare.addColumn( "Объем" );

					dgWare.columns[0].width=120;
					dgWare.columns[1].width=300;
					dgWare.columns[2].width=80;
					dgWare.dataProvider=wDp;
					dgWare.setStyle("cellRenderer",AlternatingRowColors);
				}
				dgWare.selectedIndex=0;
				wChange(event);
			}
		}

		private function wChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if (cbWare.selectedItem) {
//				wiLoader.load(new URLRequest("d:\page44.txt"));
				wiLoader.load(new URLRequest("page.php?id=44&rf="+cbWare.selectedItem.data+"&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
			} else {
//				wiLoader.load(new URLRequest("d:\page44.txt"));
				wiLoader.load(new URLRequest("page.php?id=44&rf=0&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
			}
		}

		private function wcbChange(event:Event) {
//			wiLoader.load(new URLRequest("d:\page44.txt"));
			wiLoader.load(new URLRequest("page.php?id=44&rf="+cbWare.selectedItem.data+"&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
		}

		private function wItemsLoad(event:Event) {
			var i:uint;
			if (wiLoader.data.free) {
				dtWareCount.text=wiLoader.data.free;
			}
			if (dgWareItems.selectedIndex!=-1) {
				hider();
			}
			wiDp.removeAll();
			if (wiLoader.data.cnt>0) {
				for (i=0; i<wiLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=wiLoader.data["n"+i];
					dgFill["Доступно"]=wiLoader.data["c"+i];
					dgFill["Масса"]=wiLoader.data["m"+i];

					if (wiLoader.data["c"+i]) {
						dgFill["bgColor"]=wiLoader.data["t"+i];
					}
					wiDp.addItem(dgFill);
				}
				if (dgWareItems.columns.length==0) {
					dgWareItems.addColumn( "Наименование" );
					dgWareItems.addColumn( "Доступно" );
					dgWareItems.addColumn( "Масса" );

					dgWareItems.columns[0].width=300;
					dgWareItems.columns[1].width=100;
					dgWareItems.columns[2].width=70;
					dgWareItems.dataProvider=wiDp;
					dgWareItems.setStyle("cellRenderer",AlternatingRowColors);
				}
			}
		}

		private function wiChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			hider();
			dgShipItems.selectedIndex=-1;
			if (dgWareItems.selectedIndex!=-1) {
				upArrow.visible = true;
				upArrow.gotoAndPlay(0);
				iMax=wiLoader.data["c"+dgWareItems.selectedIndex];
				btnMoveAll.visible=true;
				bgCount.visible=true;
				titCount.visible=true;
				dtCount.text="0";
				countChange(event);
			}
		}

		private function hider() {
			btnMove.visible=false;
			btnMoveAll.visible=false;
			dtCount.text="";
			bgCount.visible=false;
			titCount.visible=false;
		}

		public function itemsMove(e:MouseEvent) {
			var i:uint;
			var ships:String;
			var objects:String;
			var iOid:uint;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			iCnt = int(dtCount.text);
			nopLoader.addEventListener(Event.COMPLETE, nopRefresh);

			if( dgShips.selectedItems.length == 1 && ( dgShipItems.selectedItems.length == 1 || dgWareItems.selectedItems.length == 1 ) ) {
				if (dgShipItems.selectedIndex == -1) {
					sMove = "1";
					iOid = wiLoader.data["id"+dgWareItems.selectedIndex];
				} else {
					sMove = "0";
					iOid = siLoader.data["id"+dgShipItems.selectedIndex];
				}

//				nopLoader.load(new URLRequest("d:\page45.txt"));
				nopLoader.load(new URLRequest("page.php?id=45&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&plid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]+"&oid="+iOid+"&ocnt="+iCnt+"&move="+sMove));
			} else {
				if( dgShips.selectedItems.length == 1 ) {
					ships = sLoader.data["id"+dgShips.selectedIndex];
				} else {
					for( i = 0; i < dgShips.selectedItems.length; i++ ) {
						if( ships == null ) {
							ships = sLoader.data["id"+dgShips.selectedIndices[ i ]];
						} else {
							ships = ships + ',' + sLoader.data["id"+dgShips.selectedIndices[ i ]];
						}
					}
				}

				if (dgShipItems.selectedIndex == -1) {
					sMove = "1";
					if( dgWareItems.selectedItems.length == 1 ) {
						objects = wiLoader.data["id"+dgWareItems.selectedIndex];
					} else {
						for( i = 0; i < dgWareItems.selectedItems.length; i++ ) {
							if( objects == null ) {
								objects = wiLoader.data["id"+dgWareItems.selectedIndices[ i ]];
							} else {
								objects = objects + ',' + wiLoader.data["id"+dgWareItems.selectedIndices[ i ]];
							}
						}
					}
				} else {
					sMove = "0";
					if( dgShipItems.selectedItems.length == 1 ) {
						objects = siLoader.data["id"+dgShipItems.selectedIndex];
					} else {
						for( i = 0; i < dgShipItems.selectedItems.length; i++ ) {
							if( objects == null ) {
								objects = siLoader.data["id"+dgShipItems.selectedIndices[ i ]];
							} else {
								objects = objects + ',' + siLoader.data["id"+dgShipItems.selectedIndices[ i ]];
							}
						}
					}
				}

//				nopLoader.load(new URLRequest("d:\page47.txt"));
				nopLoader.load(new URLRequest("page.php?id=47&ships="+ships+"&plid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]+"&objects="+objects+"&ocnt="+iCnt+"&move="+sMove));
			}
		}

		public function itemsMoveAll(e:MouseEvent) {
			var i:uint;
			var ships:String;
			var objects:String;
			var iOid:uint;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			iCnt = -1;
			nopLoader.addEventListener(Event.COMPLETE, nopRefresh);
			if( dgShips.selectedItems.length == 1 && ( dgShipItems.selectedItems.length == 1 || dgWareItems.selectedItems.length == 1 ) ) {
				nopLoader.addEventListener(Event.COMPLETE, nopRefresh);
				if (dgShipItems.selectedIndex == -1) {
					sMove = "1";
					iOid = wiLoader.data["id"+dgWareItems.selectedIndex];
				} else {
					sMove = "0";
					iOid = siLoader.data["id"+dgShipItems.selectedIndex];
				}

//				nopLoader.load(new URLRequest("d:\page45.txt"));
				nopLoader.load(new URLRequest("page.php?id=45&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&plid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]+"&oid="+iOid+"&ocnt=-1&move="+sMove));
			} else {
				if( dgShips.selectedItems.length == 1 ) {
					ships = sLoader.data["id"+dgShips.selectedIndex];
				} else {
					for( i = 0; i < dgShips.selectedItems.length; i++ ) {
						if( ships == null ) {
							ships = sLoader.data["id"+dgShips.selectedIndices[ i ]];
						} else {
							ships = ships + ',' + sLoader.data["id"+dgShips.selectedIndices[ i ]];
						}
					}
				}

				if (dgShipItems.selectedIndex == -1) {
					sMove = "1";
					if( dgWareItems.selectedItems.length == 1 ) {
						objects = wiLoader.data["id"+dgWareItems.selectedIndex];
					} else {
						for( i = 0; i < dgWareItems.selectedItems.length; i++ ) {
							if( objects == null ) {
								objects = wiLoader.data["id"+dgWareItems.selectedIndices[ i ]];
							} else {
								objects = objects + ',' + wiLoader.data["id"+dgWareItems.selectedIndices[ i ]];
							}
						}
					}
				} else {
					sMove = "0";
					if( dgShipItems.selectedItems.length == 1 ) {
						objects = siLoader.data["id"+dgShipItems.selectedIndex];
					} else {
						for( i = 0; i < dgShipItems.selectedItems.length; i++ ) {
							if( objects == null ) {
								objects = siLoader.data["id"+dgShipItems.selectedIndices[ i ]];
							} else {
								objects = objects + ',' + siLoader.data["id"+dgShipItems.selectedIndices[ i ]];
							}
						}
					}
				}

//				nopLoader.load(new URLRequest("d:\page47.txt"));
				nopLoader.load(new URLRequest("page.php?id=47&ships="+ships+"&plid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]+"&objects="+objects+"&ocnt="+iCnt+"&move="+sMove));
			}
		}

		public function nopRefresh(event:Event) {
			event.target.removeEventListener( Event.COMPLETE, nopRefresh );

			if( dgShips.selectedItems.length == 1 ) {
				if (cbShip.selectedItem) {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+"&shid="+sLoader.data["id"+dgShips.selectedIndex]));
				} else {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf=0&shid="+sLoader.data["id"+dgShips.selectedIndex]));
				}
			} else {
				var i:int;
				var str:String;
				str = '&scnt=' + dgShips.selectedItems.length;
				for( i = 0; i < dgShips.selectedItems.length; i++ ) {
					str = str + '&sh' + i + '=' + sLoader.data["id"+dgShips.selectedIndices[i]];
				}
				if (cbShip.selectedItem) {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+str));
				} else {
//					siLoader.load(new URLRequest("d:\page42.txt"));
					siLoader.load(new URLRequest("page.php?id=42&rf=0"+str));
				}
			}
//			siLoader.load(new URLRequest("d:\page42.txt"));
//			siLoader.load(new URLRequest("page.php?id=42&rf="+cbShip.selectedItem.data+"&shid="+sLoader.data["id"+dgShips.selectedIndex]));

			if (cbWare.selectedItem) {
//				wiLoader.load(new URLRequest("d:\page44.txt"));
				wiLoader.load(new URLRequest("page.php?id=44&rf="+cbWare.selectedItem.data+"&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
			} else {
//				wiLoader.load(new URLRequest("d:\page44.txt"));
				wiLoader.load(new URLRequest("page.php?id=44&rf=0&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
			}
//			wiLoader.load(new URLRequest("d:\page44.txt"));
//			wiLoader.load(new URLRequest("page.php?id=44&rf="+cbWare.selectedItem.data+"&shid="+wLoader.data["id"+dgWare.selectedIndex]+"&tid="+wLoader.data["tid"+dgWare.selectedIndex]));
		}

		public function countChange(event:Event) {
			var outGlow:GlowFilter=new GlowFilter(0x0000FF,0.5,5,5,2,1,false,false);
			var cntGlow:GlowFilter=new GlowFilter(0x00FFFF,0.4,10,10,2,3,true,false);
			if (String(int(dtCount.text))!=dtCount.text||dtCount.text==""||dtCount.text=="0") {
				cntGlow.color=0xFF0000;
				btnMove.visible=false;
			} else {
				btnMove.visible=true;
			}
			bgCount.filters=[cntGlow,outGlow];
		}
	}
}
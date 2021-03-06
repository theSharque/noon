﻿package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.*;
	import flash.net.navigateToURL;
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
	import fl.transitions.TweenEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import fl.events.DataGridEvent;

	public class ships3 extends MovieClip {
		private var stVolume:SoundTransform=new SoundTransform(Number(root.loaderInfo.parameters.sv)/100,0);
		private var chanel:SoundChannel;
		private var iConservMax:uint;
		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();
		private var monitor:MovieClip;
		private var rTween:Tween;
		private var needScroll:Boolean=true;
		//private var rotGalaxy:Tween;
		private var bLater:Boolean=false;

		private var place_x:int;
		private var place_y:int;
		private var oldX:int;
		private var oldY:int;
		private var st_circ:MovieClip = new start_circle();
		private var fn_circ:MovieClip = new final_circle();
		private var lin:MovieClip = new traction();

		private var sLoader:URLLoader = new URLLoader();
		private var doRefresh:Boolean=true;
		private var sDp:DataProvider = new DataProvider();
		private var shipsTimer:Timer=new Timer(1000);
		private var shipsStartTime:Number = (new Date()).valueOf();
		private var fireTimer:Timer=new Timer(1000);
		private var dTween:Tween;
		private var bTween:Tween;
		private var shields:Array = new Array();
		private var perc:Array = new Array();
		private var aIds:Array = new Array();

		private var lastShip:String=root.loaderInfo.parameters.ls;
		private var needShip:Boolean=true;
		private var needTimer:Boolean=false;

		private var iNTotal:int=0;
		private var iFTotal:int=0;
		private var iNshield:int=0;
		private var iFshield:int=0;
		private var iNkill:int=0;
		private var iFkill:int=0;
		private var iNcapture:int=0;
		private var iFcapture:int=0;
		private var iNlost:int=0;
		private var iFlost:int=0;

		private var oLoader:URLLoader = new URLLoader();
		private var oDp:DataProvider = new DataProvider();

		private var pLoader:URLLoader = new URLLoader();
		private var pDp:DataProvider = new DataProvider();

		private var iLoader:URLLoader = new URLLoader();
		private var iDp:DataProvider = new DataProvider();

		private var fLoader:URLLoader = new URLLoader();
		private var fDp:DataProvider = new DataProvider();

		private var stDp:DataProvider = new DataProvider();
		private var taDp:DataProvider = new DataProvider();

		private var wLoader:URLLoader = new URLLoader();
		private var wid:String;
		private var side:String;
		private var lastMove:String;
		private var place_hash:String;

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function ships3() {
			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			hinter.visible=false;
			hinter.mvTimer.visible=false;
			hinter.startDrag( true );
			needScroll=true;

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

			dgShips.addEventListener( Event.CHANGE, shipsChange );
			dgShips.setRendererStyle( "textFormat", myFormat );
			dgShips.setStyle( "headerTextFormat", myHeadFormat );
			dgShips.addColumn( "Имя" );
			dgShips.addColumn( "Расположение" );
			dgShips.columns[0].width=120;
			dgShips.columns[1].width=200;
			dgShips.columns[0].sortOptions=null;
			dgShips.dataProvider=sDp;
			dgShips.setStyle("cellRenderer",AlternatingRowColors);
			dgShips.addEventListener( DataGridEvent.HEADER_RELEASE, gdReloader );
			shipsTimer.addEventListener(TimerEvent.TIMER, shipsRefresh);

			cbOrders.dataProvider=oDp;
			cbOrders.addEventListener( Event.CHANGE, ordersChange );
			cbOrders.addEventListener( Event.CLOSE, ordersClose);

			cbPlace.dataProvider=pDp;
			cbPlace.addEventListener( Event.CHANGE, placeChange );

			cbFilter.setStyle( "textFormat", myFormat );
			cbFilter.addEventListener( Event.CHANGE, placeChange );

			btnOrder.addEventListener(MouseEvent.CLICK, clickOrder);
			btnOrder.visible=false;
			btnOrder.filters=null;

			sLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, shipsLoaded);
			doRefresh=true;

			pLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			pLoader.addEventListener(Event.COMPLETE, placeLoaded);
			pLoader.load(new URLRequest("page.php?id=311"));
			//pLoader.load(new URLRequest("d:\page311.txt"));

			oLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			oLoader.addEventListener(Event.COMPLETE, ordersLoaded);

			iLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, itemsLoaded);

			fLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			fLoader.addEventListener(Event.COMPLETE, fleetLoaded);

			wLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			wLoader.addEventListener(Event.COMPLETE, fireRender);
			fireTimer.addEventListener(TimerEvent.TIMER, fireUp);
		}

		public function gdReloader( event:DataGridEvent ) {
			var i:int;

			aIds.length=0;
			if (dgShips.selectedItems.length>0) {
				for (i = 0; i < dgShips.selectedIndices.length; i++) {
					aIds.push( sLoader.data["id"+dgShips.selectedIndices[i]] );
				}
			}

			if (event.columnIndex==0) {
				bLater=true;
				sLoader.load(new URLRequest("page.php?id=31&oth="+cbFilter.selected+"&ord=0&pl="+cbPlace.selectedItem.data));
				//sLoader.load(new URLRequest("d:\page31.txt"));
			} else {
				bLater=true;
				sLoader.load(new URLRequest("page.php?id=31&oth="+cbFilter.selected+"&ord=1&pl="+cbPlace.selectedItem.data));
				// sLoader.load(new URLRequest("d:\page31.txt"));
			}

			event.preventDefault();
		}

		private function startHint( e:MouseEvent ) {
			if (e.relatedObject!=null) {
				var point:Point=new Point(mouseX,mouseY);
				var objects:Array=stage.getObjectsUnderPoint(point);
				hintName=objects[objects.length-1].name;
				hintTimer.stop();
				hintTimer.reset();
				hintTimer.start();
				if (mouseX<700) {
					hinter.dtHint.x=16;
					hinter.bgHint.x=16;
				} else {
					hinter.dtHint.x=-300;
					hinter.bgHint.x=-300;
				}
				if (mouseY<60) {
					hinter.dtHint.y=4;
					hinter.bgHint.y=64;
				} else {
					hinter.dtHint.y=-64;
					hinter.bgHint.y=-4;
				}
			}
		}

		private function loadHint( e:TimerEvent ) {
			hintTimer.stop();
			var point:Point=new Point(mouseX,mouseY);
			var objects:Array=stage.getObjectsUnderPoint(point);

			if (hintName==objects[objects.length-1].name) {
				setChildIndex( hinter, hinter.parent.numChildren - 1 );
				hinter.bgHint.visible=false;
				hinter.dtHint.text='';
				hinter.visible=true;
				hinter.mvTimer.visible=true;
				hLoader.load( new URLRequest( "page.php?id=8&asc=ships_"+hintName ) );
			} else {
				hinter.visible=false;
			}
		}

		private function hintLoaded( event:Event ) {
			if (hLoader.data.err==0) {
				hinter.dtHint.htmlText=hLoader.data.hint;
				hinter.mvTimer.visible=false;
				hinter.bgHint.visible=true;
			} else {
				hinter.visible=false;
			}
		}

		private function hideHint( e:MouseEvent ) {
			hintTimer.stop();
			hinter.visible=false;
		}

		public function placeLoaded(event:Event) {
			var i:uint,iPos:int,iPosData:String;
			iPos=-1;
			if (pLoader.data.lastPlace!='') {
				iPosData=pLoader.data.lastPlace;
			}
			if (pLoader.data.others=='0') {
				cbFilter.selected=false;
			} else {
				cbFilter.selected=true;
			}
			if (cbPlace.selectedIndex>0) {
				iPosData=cbPlace.selectedItem.data;
			}
			pDp.removeAll();
			pDp.addItem({"data":'*',"label":'Все'});
			if (pLoader.data.cnt>0) {
				for (i=0; i<pLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["data"]=pLoader.data["id"+i];
					dgFill["label"]=pLoader.data["name"+i];
					if (iPosData==pLoader.data["id"+i]) {
						iPos=i+1;
					}
					pDp.addItem(dgFill);
				}
			}

			btnOrder.filters=null;

			cbPlace.textField.setStyle( "textFormat", myHeadFormat );
			cbPlace.dropdown.setRendererStyle( "textFormat", myFormat );
			cbPlace.rowCount=19;
			if (iPos>=0) {
				cbPlace.selectedIndex=iPos;
			} else {
				cbPlace.selectedIndex=0;
			}
			placeChange( event );
		}

		private function placeChange(event:Event) {
			var i:int;

			aIds.length=0;
			if (dgShips.selectedItems.length>0) {
				for (i = 0; i < dgShips.selectedIndices.length; i++) {
					aIds.push( sLoader.data["id"+dgShips.selectedIndices[i]] );
				}
			}

			bLater=true;
			sLoader.load(new URLRequest("page.php?id=31&oth="+cbFilter.selected+"&pl="+escape( cbPlace.selectedItem.data )));
			//sLoader.load(new URLRequest("d:\page31.txt"));
		}

		public function shipsLoaded(event:Event) {
			var i:uint;
			var e:TimerEvent;
			shipsStartTime = (new Date()).valueOf();
			bLater=false;
			shipsRefresh( e );

			needTimer=false;
			if (sLoader.data.cnt>0) {
				for (i=0; i<sLoader.data.cnt; i++) {
					if (needShip&&lastShip==sLoader.data["id"+i]) {
						dgShips.selectedIndex=i;
						needShip=false;
					}
					/*
					if(aIds.length == 0 && dgShips.selectedIndex == -1 && lastShip == sLoader.data["id" + i]) {
					dgShips.selectedIndex = i;
					}
					*/
					if (int(sLoader.data["tp"+i])>0) {
						needTimer=true;
					}
				}

				if (aIds.length==0&&dgShips.selectedIndex==-1) {
					dgShips.selectedIndex=0;
				}

				if (needScroll) {
					dgShips.scrollToIndex( dgShips.selectedIndex );
					needScroll=false;
				}
			}


			if (doRefresh) {
				shipsChange(event);
			}

			if (needTimer) {
				shipsTimer.start();
			}
		}

		public function shipsRefresh(e:TimerEvent) {
			var i:uint;
			var iLastPos:int;
			var diff:int=0;
			var currentTime:Number = (new Date()).valueOf();
			var aPos:Array = new Array();

			if (bLater) {
				return;
			}

			if (aIds.length==0) {
				if (dgShips.selectedItems.length>0) {
					for (i = 0; i < dgShips.selectedIndices.length; i++) {
						aIds.push( sLoader.data["id"+dgShips.selectedIndices[i]] );
					}
				}
			}

			if (sLoader.data.cnt>0) {
				sDp.removeAll();
				for (i=0; i<sLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Имя"]=sLoader.data["name"+i];
					dgFill["bgColor"]=sLoader.data["c"+i];
					if (aIds.length==1&&aIds[0]==sLoader.data["id"+i]&&sLoader.data["c"+i]!='0xCC0000') {
						needScroll=true;
						iLastPos=i;
					}

					if (lastShip==sLoader.data["id"+i]&&sLoader.data["c"+i]!='0xCC0000') {
						if (sLoader.data["c"+i]!='0xCC0000') {
							needScroll=true;
						}
						iLastPos=i;
					}

					if (aIds.length>0&&aIds.indexOf(sLoader.data["id"+i])>=0) {
						aPos.push( i );
					}

					if (! isNaN(sLoader.data["tp"+i])) {
						diff = int( ( int( sLoader.data["tp" + i] * 1000 ) - ( currentTime - shipsStartTime ) ) / 1000 );
						if (diff>0) {
							var vD:uint=int(diff/86400);
							diff=diff%86400;
							var vH=int(diff/3600);
							diff=diff%3600;
							var vM=int(diff/60);
							var vS=diff%60;
							var timestring:String="";
							if (vD>0) {
								timestring=vD+".";
							}
							if (vH>=10) {
								timestring+=vH+":";
							} else {
								timestring+="0"+vH+":";
							}

							if (vM>=10) {
								timestring+=vM+":";
							} else {
								timestring+="0"+vM+":";
							}

							if (vS>=10) {
								timestring+=vS;
							} else {
								timestring+="0"+vS;
							}

							dgFill["Расположение"]=timestring+" "+sLoader.data["place"+i];
						} else {
							dgFill["Расположение"]="00:00:00 "+sLoader.data["place"+i];
							if (aIds.length==1&&aIds[0]==sLoader.data["id"+i]&&sLoader.data["c"+i]!='0xCC0000') {
								doRefresh=true;
							} else {
								doRefresh=false;
							}
							pLoader.load(new URLRequest("page.php?id=311"));
							//pLoader.load(new URLRequest("d:\page311.txt"));
							shipsTimer.stop();
						}
					} else {
						dgFill["Расположение"]=sLoader.data["place"+i];
					}
					sDp.addItem(dgFill);
				}

				if (aPos.length>0) {
					dgShips.selectedIndices=aPos;
					aIds.length=0;
					aPos.length=0;
				} else {
					dgShips.selectedIndex=iLastPos;
				}
			}
		}

		public function shipsChange(event:Event) {
			var i:uint;
			var snd:Sound = new beep();
			chanel=snd.play();
			chanel.soundTransform=stVolume;
			oDp.removeAll();
			btnOrder.visible=false;

			if (dgShips.selectedItems.length>1) {
				var btUrl:String="page.php?id=34&cnt="+dgShips.selectedItems.length;
				for (i = 0; i < dgShips.selectedIndices.length; i++) {
					btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
				}
				cbOrders.close();
				cbOrders.visible=false;
				//oLoader.load(new URLRequest("d:\page34.txt"));
				oLoader.load(new URLRequest(btUrl));
			} else {
				lastShip=sLoader.data["id"+dgShips.selectedIndex];
				cbOrders.close();
				cbOrders.visible=false;
				oLoader.load(new URLRequest("page.php?id=32&shid="+lastShip));
				//oLoader.load(new URLRequest("d:\page32.txt"));
				if (monitor) {
					removeChild( monitor );
					monitor=null;
				}
				switch ( lastShip.substr(0, 1) ) {
					case 'A' :
					case 'S' :
					case 'Z' :
						monitor = new ship_info();
						break;
					case 'F' :
						monitor = new fleet_info();
						break;
					case 'C' :
						monitor = new conserv_info();
						iConservMax=sLoader.data["cnt"+dgShips.selectedIndex];
						monitor.dtCount.text='1';
						monitor.btnDeconserv.addEventListener(MouseEvent.CLICK, clickDeconserv);
						monitor.btnDeconservAll.addEventListener(MouseEvent.CLICK, clickDeconservAll);
						break;
				}

				if (monitor) {
					monitor.x=350;
					addChild( monitor );
					monitor.dtInfo.htmlText="Загрузка...";
					if (dgShips.selectedItems.length==1) {
						nopLoader.addEventListener( Event.COMPLETE, nopInfoLoad );
						nopLoader.load(new URLRequest("page.php?id=36&shid="+sLoader.data["id"+dgShips.selectedIndex]));
						//nopLoader.load(new URLRequest("d:\page36.txt"));
					}
				}
			}
		}

		public function nopInfoLoad(event:Event) {
			var picLoader:Loader;

			nopLoader.removeEventListener( Event.COMPLETE, nopInfoLoad );
			monitor.dtInfo.htmlText=nopLoader.data.out;
			if (nopLoader.data.info!=undefined) {
				monitor.dtShips.htmlText=nopLoader.data.info;
			}

			if (nopLoader.data.pic!=undefined) {
				picLoader = new Loader();
				picLoader.load( new URLRequest("img/ships/f" + nopLoader.data.pic + ".png") );
				monitor.mvBack.removeChildAt( 0 );
				monitor.mvBack.addChild( picLoader );
				picLoader.x=320;
				picLoader.y=30;
			}
		}

		public function nopAtackLoad(event:Event) {
			var i:uint;
			var dgFill:Array = new Array();

			nopLoader.removeEventListener( Event.COMPLETE, nopAtackLoad );

			stDp.removeAll();
			for (i=0; i<nopLoader.data.scnt; i++) {
				dgFill = new Array();
				dgFill["Тип"]=nopLoader.data["st"+i];
				dgFill["bgColor"]="0x000000";
				stDp.addItem(dgFill);
			}
			monitor.dgStrateg.selectedIndex=nopLoader.data.scnt-1;

			taDp.removeAll();
			for (i=0; i<nopLoader.data.tcnt; i++) {
				dgFill = new Array();
				dgFill["Тип"]=nopLoader.data["ta"+i];
				dgFill["bgColor"]="0x000000";
				taDp.addItem(dgFill);
			}
			monitor.dgTactic.selectedIndex=nopLoader.data.tcnt-1;

			monitor.btnAtack.visible=true;
		}

		private function ordersLoaded(event:Event) {
			var i:uint;
			oDp.removeAll();
			oDp.addItem({"data":100,"label":'Выберите приказ'});
			if (oLoader.data.cnt>0) {
				for (i=0; i<oLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["data"]=oLoader.data["id"+i];
					dgFill["label"]=oLoader.data["name"+i];
					oDp.addItem(dgFill);
				}
				btnOrder.visible=false;
				btnOrder.filters=null;
				setChildIndex( cbOrders, numChildren - 1 );
				cbOrders.x=342;
				cbOrders.y=60+dgShips.selectedIndex*18-dgShips.verticalScrollPosition;
				cbOrders.width=310;
				cbOrders.textField.setStyle( "textFormat", myHeadFormat );
				cbOrders.dropdown.setRendererStyle( "textFormat", myFormat );
				cbOrders.selectedIndex=0;
				cbOrders.rowCount=12;
				cbOrders.visible=true;
				cbOrders.drawNow();
				cbOrders.open();
			} else {
				cbOrders.visible=false;
			}
		}

		public function fleetLoaded( event:Event ) {
			var i:uint;
			fDp.removeAll();
			if (fLoader.data.ms) {
				monitor.dtMax.text=fLoader.data.ms;
			}
			if (fLoader.data.err==0&&fLoader.data.cnt>0) {
				for (i=0; i<fLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=fLoader.data["n"+i];
					fDp.addItem(dgFill);
				}
				if (monitor.dgShips.columns.length==0) {
					monitor.dgShips.addColumn( "Наименование" );
					monitor.dgShips.dataProvider=fDp;
					monitor.dgShips.setStyle("cellRenderer",AlternatingRowColors);
				}
			}
		}

		public function dgCounter( event:Event ) {
			monitor.dtCount.text=monitor.dgShips.selectedIndices.length;
		}

		public function clickFleetOut( e:MouseEvent ) {
			var i:uint;
			var btUrl:String;
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			btUrl="page.php?id=353&cnt="+monitor.dgShips.selectedItems.length;
			btUrl=btUrl+"&fid="+sLoader.data["id"+dgShips.selectedIndex];
			for (i = 0; i < monitor.dgShips.selectedIndices.length; i++) {
				btUrl=btUrl+"&sh"+i+"="+fLoader.data["id"+monitor.dgShips.selectedIndices[i]];
			}
			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );

			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page35.txt"));
		}

		public function clickFleetStrateg( e:MouseEvent ) {
			var i:uint;
			var btUrl:String;
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			btUrl="page.php?id=355&cnt="+monitor.dgShips.selectedItems.length;
			btUrl=btUrl+"&set="+monitor.dtStep.text;
			for (i = 0; i < monitor.dgShips.selectedIndices.length; i++) {
				btUrl=btUrl+"&sh"+i+"="+fLoader.data["id"+monitor.dgShips.selectedIndices[i]];
			}
			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );

			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page35.txt"));
		}

		public function ordersClose(event:Event) {
			cbOrders.visible=false;
		}

		public function ordersChange(event:Event) {
			var newMonitor:MovieClip;
			var outGlow:GlowFilter=new GlowFilter(0xFF0000,1,8,8,2,1,true,false);

			cbOrders.visible=false;
			cbOrders.x=30;
			cbOrders.y=425;
			cbOrders.width=280;
			cbOrders.dropdown.setRendererStyle( "textFormat", myFormat );
			cbOrders.textField.setStyle( "textFormat", myHeadFormat );
			cbOrders.visible=true;

			fireTimer.stop();

			var id:String=cbOrders.selectedItem.data;// oLoader.data["id"+dgOrders.selectedIndex];
			if (id.indexOf(":")>0) {
				wid=id.substr(id.indexOf(":")+1);
				id=id.substr(0,id.indexOf(":"));
			}

			switch ( int(id) ) {
				case 0 :
				case 44 :
					newMonitor = new make_fleet();
					break;
				case 1 :
				case 22 :
				case 23 :
				case 24 :
				case 34 :
				case 35 :
				case 36 :
				case 37 :
				case 40 :
				case 43 :
					newMonitor = new ship_land();
					break;
				case 2 :
					newMonitor = new ship_flyout();
					break;
				case 3 :
				case 39 :
					newMonitor = new ship_undock();
					break;
				case 4 :
				case 31 :
					newMonitor = new ship_dock();
					break;
				case 7 :
					newMonitor = new disband_fleet();
					newMonitor.dgShips.setRendererStyle( "textFormat", myFormat );
					newMonitor.dgShips.setStyle( "headerTextFormat", myHeadFormat );
					newMonitor.dgShips.addEventListener( Event.CHANGE, dgCounter );
					fLoader.load(new URLRequest("page.php?id=352&shid="+sLoader.data["id"+dgShips.selectedIndex]));
					newMonitor.btnFleetOut.addEventListener( MouseEvent.CLICK, clickFleetOut );
					break;
				case 42 :
					newMonitor = new strateg_fleet();
					newMonitor.dgShips.setRendererStyle( "textFormat", myFormat );
					newMonitor.dgShips.setStyle( "headerTextFormat", myHeadFormat );
					newMonitor.dgShips.addEventListener( Event.CHANGE, dgCounter );
					fLoader.load(new URLRequest("page.php?id=354&shid="+sLoader.data["id"+dgShips.selectedIndex]));
					newMonitor.btnStrateg.addEventListener( MouseEvent.CLICK, clickFleetStrateg );
					break;
				case 8 :
					newMonitor = new system_move();
					nopLoader.addEventListener( Event.COMPLETE, nopPlanetLoaded );
					nopLoader.load(new URLRequest( "page.php?id=37&shid="+sLoader.data["id"+dgShips.selectedIndex] ));
					//nopLoader.load(new URLRequest( "d:\page37.txt" ));
					break;
				case 9 :
					newMonitor = new star_move();
					newMonitor.coords.visible=false;
					newMonitor.coords.alpha=0;
					//rotGalaxy = new Tween( newMonitor.starMap.fgGalaxy, "rotation", Strong.easeOut, 0, 360, 60, true);
					newMonitor.btnShowCoords.addEventListener(MouseEvent.CLICK, showCoords);
					newMonitor.coords.btnSetCoord.addEventListener(MouseEvent.CLICK, hideCoords);
					nopLoader.addEventListener( Event.COMPLETE, nopStarLoaded );
					nopLoader.load(new URLRequest( "page.php?id=371&shid="+sLoader.data["id"+dgShips.selectedIndex] ));
					//nopLoader.load(new URLRequest( "d:\page371.txt" ));
					break;
				case 41 :
					newMonitor = new star_move();
					newMonitor.coords.visible=false;
					newMonitor.coords.alpha=0;
					//rotGalaxy = new Tween( newMonitor.starMap.fgGalaxy, "rotation", Strong.easeOut, 0, 360, 60, true);
					newMonitor.btnShowCoords.addEventListener(MouseEvent.CLICK, showCoords);
					newMonitor.coords.btnSetCoord.addEventListener(MouseEvent.CLICK, hideCoords);
					nopLoader.addEventListener( Event.COMPLETE, nopStarLoadedHome );
					nopLoader.load(new URLRequest( "page.php?id=371&shid="+sLoader.data["id"+dgShips.selectedIndex] ));
					//nopLoader.load(new URLRequest( "d:\page371.txt" ));
					break;
				case 10 :
				case 28 :
				case 30 :
					newMonitor = new ship_items();
					newMonitor.dgItems.setRendererStyle( "textFormat", myFormat );
					newMonitor.dgItems.setStyle( "headerTextFormat", myHeadFormat );
					iLoader.load(new URLRequest("page.php?id=321&shid="+sLoader.data["id"+dgShips.selectedIndex]));
					//iLoader.load(new URLRequest("d:\page321.txt"));
					newMonitor.btnWarehouse.addEventListener(MouseEvent.CLICK, clickWarehouse);
					break;
				case 11 :
					var sName:String=sLoader.data["name"+dgShips.selectedIndex];
					newMonitor = new ship_rename();
					newMonitor.dtGroup.text=sLoader.data["group"+dgShips.selectedIndex];
					if (sName.substr(0,1)=="*") {
						newMonitor.dtName.text=sName.substr(1);
					} else {
						newMonitor.dtName.text=sName;
					}
					newMonitor.btnRename.addEventListener(MouseEvent.CLICK, clickOrder);
					break;
				case 14 :
				case 38 :
					newMonitor = new planet_attack();
					btnOrder.filters=[outGlow];
					break;
				case 16 :
				case 32 :
				case 33 :
				case 49 :
					newMonitor = new ship_attack();
					btnOrder.filters=[outGlow];
					break;
				case 17 :
				case 18 :
				case 51 :
					newMonitor = new fleet_attack();
					btnOrder.filters=[outGlow];
					break;
				case 45 :
					newMonitor = new ship_interupt();
					newMonitor.btnSaveMessage.addEventListener(MouseEvent.CLICK, clickSaveMessage);
					nopLoader.addEventListener( Event.COMPLETE, nopInterruptLoad );
					nopLoader.load(new URLRequest( "page.php?id=374&shid="+sLoader.data["id"+dgShips.selectedIndex] ));
					break;
				case 50 :
					newMonitor = new ship_war();
					nopLoader.addEventListener( Event.COMPLETE, warRender );
					nopLoader.load(new URLRequest("wo.php?id=361&wid="+wid));
					//nopLoader.load(new URLRequest("d:\page361.txt"));
					break;
				case 100 :
					switch ( lastShip.substr(0, 1) ) {
						case 'A' :
						case 'S' :
						case 'Z' :
							newMonitor = new ship_info();
							break;
						case 'F' :
							newMonitor = new fleet_info();
							break;
						case 'C' :
							newMonitor = new conserv_info();
							iConservMax=sLoader.data["cnt"+dgShips.selectedIndex];
							newMonitor.dtCount.text='1';
							newMonitor.btnDeconserv.addEventListener(MouseEvent.CLICK, clickDeconserv);
							newMonitor.btnDeconservAll.addEventListener(MouseEvent.CLICK, clickDeconservAll);
							break;
					}
					break;
			}

			if (newMonitor) {
				switch ( getQualifiedClassName(monitor) ) {

					case "star_move" :
						monitor.starMap.removeEventListener( MouseEvent.MOUSE_DOWN, starStartScroll );
						monitor.starMap.removeEventListener( MouseEvent.MOUSE_UP, starStopScroll );
						monitor.starMap.removeEventListener( MouseEvent.MOUSE_OVER, showDesc );
						monitor.starMap.removeEventListener( MouseEvent.MOUSE_OUT, hideDesc );
						break;

					case "system_move" :
						monitor.removeEventListener( MouseEvent.MOUSE_UP, planetClick );
						break;

					case "ship_war" :
						fireTimer.stop();
						break;
				}

				removeChild( monitor );
				monitor=newMonitor;
				monitor.x=350;
				addChild( monitor );
				if (int(id)==100) {
					monitor.dtInfo.htmlText="Загрузка...";
					if (dgShips.selectedItems.length==1) {
						nopLoader.addEventListener( Event.COMPLETE, nopInfoLoad );
						nopLoader.load(new URLRequest("page.php?id=36&shid="+sLoader.data["id"+dgShips.selectedIndex]));
						//nopLoader.load(new URLRequest("d:\page36.txt"));
					}
				}
			}

			switch ( int( id ) ) {
				case 0 :
				case 1 :
				case 2 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
				case 7 :
				case 12 :
				case 14 :
				case 16 :
				case 17 :
				case 18 :
				case 20 :
				case 21 :
				case 22 :
				case 23 :
				case 24 :
				case 25 :
				case 26 :
				case 27 :
				case 28 :
				case 29 :
				case 30 :
				case 31 :
				case 32 :
				case 33 :
				case 34 :
				case 35 :
				case 36 :
				case 37 :
				case 38 :
				case 39 :
				case 40 :
				case 43 :
				case 44 :
				case 46 :
				case 47 :
				case 48 :
				case 49 :
				case 51 :
					btnOrder.visible=true;
					break;
				default :
					btnOrder.visible=false;
					btnOrder.filters=null;
					break;
			}
		}

		public function clickWarehouse( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			navigateToURL( new URLRequest("page.php?id=4&shid="+sLoader.data["id"+dgShips.selectedIndex]), "main" );
		}

		public function warRender( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, warRender );

			var i:int=0;
			var t:int=0;
			var inLines:int=1;
			var ifLines:int=1;
			var iNcorrect:int=0;
			var iFcorrect:int=0;
			var inShipCnt:int=0;
			var ifShipCnt:int=0;
			var iMaxShip:int=0;
			var iXStart:int=0;
			var iYStart:int=0;
			var sw:int;
			var fMag:Number=1;
			var s:int=0;
			var picLoader:Loader;

			iNTotal=iNshield=iNkill=iNcapture=iNlost=0;
			iFTotal=iFshield=iFkill=iFcapture=iFlost=0;

			side=nopLoader.data.side;
			lastMove=nopLoader.data.lm;
			place_hash=nopLoader.data.ph;

			if (nopLoader.data.ncnt%2==1) {
				inShipCnt=t=i=1;
			} else {
				inShipCnt=t=i=2;
			}

			for (i; i < nopLoader.data.ncnt; i+=t) {
				inLines++;
				t++;
			}

			if (nopLoader.data.fcnt%2==1) {
				ifShipCnt=t=i=1;
			} else {
				ifShipCnt=t=i=2;
			}

			for (i; i < nopLoader.data.fcnt; i+=t) {
				ifLines++;
				t++;
			}

			if (inLines>ifLines) {
				iFcorrect=inLines-ifLines;
				if (inLines>1) {
					fMag = 200 / ( inLines * 200 );
				}
			} else {
				iNcorrect=ifLines-inLines;
				if (ifLines>1) {
					fMag = 200 / ( ifLines * 200 );
				}
			}

			iMaxShip=nopLoader.data.ncnt;
			for (t = 0; t < inLines; t++) {
				if (iMaxShip>=inShipCnt) {
					iYStart = 300 - ( inShipCnt * fMag * 200 ) / 2;
				} else {
					iYStart = 300 - ( iMaxShip * fMag * 200 ) / 2;
				}
				for (i = 0; i < inShipCnt && i < iMaxShip; i++) {
					iNTotal+=Number(nopLoader.data["nc"+s]);
					iNshield+=Number(nopLoader.data["nsh"+s]);

					var nship:MovieClip;
					nship = new ship_back();
					nship.dtType.text=nopLoader.data["nname"+s];
					nship.dtCnt.text=nopLoader.data["nc"+s];

					if (nopLoader.data["npc"+s]) {
						picLoader = new Loader();
						picLoader.load( new URLRequest("img/ships/" + nopLoader.data["npc"+s] + ".png") );
						nship.img.addChild( picLoader );
					}

					nship.width=300*fMag;
					nship.height=200*fMag;
					nship.x=300-t*300*fMag-300*fMag-iNcorrect*300*fMag;
					nship.y=iYStart+i*200*fMag;
					nship.name=nopLoader.data["nid"+s];
					nship.shield.prc.width = 200 - ( ( nopLoader.data["nst"+s] / 200 ) * nopLoader.data["nsh"+s] );
					nship.gotoAndPlay( int( Math.random() * 70 ) );
					monitor.field_ships.addChild( nship );
					perc[nopLoader.data["nid"+s]]=nopLoader.data["nsh"+s];
					shields[nopLoader.data["nid"+s]]=nopLoader.data["nst"+s];
					s++;
				}
				iMaxShip-=inShipCnt;
				inShipCnt++;
			}

			s=0;
			iMaxShip=nopLoader.data.fcnt;
			for (t = 0; t < ifLines; t++) {
				if (iMaxShip>=ifShipCnt) {
					iYStart = 300 - ( ifShipCnt * fMag * 200 ) / 2;
				} else {
					iYStart = 300 - ( iMaxShip * fMag * 200 ) / 2;
				}
				for (i = 0; i < ifShipCnt && i < iMaxShip; i++) {
					iFTotal+=Number(nopLoader.data["fc"+s]);
					iFshield+=Number(nopLoader.data["fsh"+s]);

					var fship:MovieClip;
					fship = new ship_front();
					fship.dtType.text=nopLoader.data["fname"+s];
					fship.dtCnt.text=nopLoader.data["fc"+s];

					if (nopLoader.data["fpc"+s]) {
						picLoader = new Loader();
						picLoader.load( new URLRequest("img/ships/" + nopLoader.data["fpc"+s] + ".png") );
						fship.img.addChild( picLoader );
					}

					fship.width=300*fMag;
					fship.height=200*fMag;
					fship.x=350+t*300*fMag+iFcorrect*300*fMag;
					fship.y=iYStart+i*200*fMag;
					fship.name=nopLoader.data["fid"+s];
					fship.shield.prc.width = 200 - ( ( nopLoader.data["fst"+s] / 200 ) * nopLoader.data["fsh"+s] );
					fship.gotoAndPlay( int( Math.random() * 70 ) );
					monitor.field_ships.addChild( fship );
					perc[nopLoader.data["fid"+s]]=nopLoader.data["fsh"+s];
					shields[nopLoader.data["fid"+s]]=nopLoader.data["fst"+s];
					s++;
				}
				iMaxShip-=ifShipCnt;
				ifShipCnt++;
			}

			renderNews();

			wLoader.load(new URLRequest( "wo.php?id=362&wi="+place_hash+"&lm="+lastMove+"&sd="+side ));
			//wLoader.load(new URLRequest( "d:\page362.txt" ));
		}

		public function fireRender( event:Event ) {
			var i:int;
			var ffx:int,ffy:int,ftx:int,fty:int;
			var iCount:int;
			var line:String;
			var wLine:Array;
			var mcFire:MovieClip;
			var die:Boolean=false;
			var dObj:MovieClip;
			var aObj:MovieClip;

			while ( mcFire = monitor.field_fire.getChildByName( "fire" ) ) {
				monitor.field_fire.removeChild( mcFire );
			}

			if (wLoader.data.err==0&&wLoader.data.cnt>0) {
				lastMove=wLoader.data.lm;
				for (i = 0; i < wLoader.data.cnt; i++) {
					line=wLoader.data['l'+i];
					wLine=line.split(':');

					aObj=monitor.field_ships.getChildByName(wLine[0]);
					ffx=aObj.x;
					ffy=aObj.y;
					ffy+=aObj.height/2;
					if (ffx<330) {
						ffx+=aObj.width;
					}
					if (wLine[2]!='as0'&&wLine[2]!='ds0') {
						dObj=monitor.field_ships.getChildByName(wLine[2]);

						ftx=dObj.x;
						fty=dObj.y;
						fty+=dObj.height/2;
						if (ffx<330) {
							ftx+=dObj.width/3;
						} else {
							ftx+=dObj.width/3*2;
						}
					} else {
						fty=300;
						if (ffx<330) {
							ftx=530;
						} else {
							ftx=130;
						}
					}

					die=false;
					if (wLine[5]==0) {
						ftx += ( Math.random() * 20 ) - 10;
						fty += ( Math.random() * 20 ) - 10;
					} else {
						if (wLine[5]>0) {
							ftx += ( Math.random() * 6 ) - 3;
							fty += ( Math.random() * 6 ) - 3;
							perc[wLine[2]]=perc[wLine[2]]-wLine[5];
							if (wLine[2]!='as0'&&wLine[2]!='ds0') {
								dObj.shield.prc.width = ( 200 / shields[wLine[2]] ) * perc[wLine[2]];
							}

							if (ffx<ftx) {
								iFshield-=wLine[6];
							} else {
								iNshield-=wLine[6];
							}
						} else {
							ftx += ( Math.random() * 6 ) - 3;
							fty += ( Math.random() * 6 ) - 3;
							iCount=int(dObj.dtCnt.text)-1;

							if (iCount==0) {
								die=true;
							} else {
								dObj.dtCnt.text=iCount;
							}

							if (ffx<ftx) {
								iFshield-=wLine[6];
								iFlost+=1;
								iFTotal-=1;
								if (wLine[5]==-1) {
									iNkill+=1;
								} else {
									iNcapture+=1;
								}
							} else {
								iNshield-=wLine[6];
								iNlost+=1;
								iNTotal-=1;
								if (wLine[5]==-1) {
									iFkill+=1;
								} else {
									iFcapture+=1;
								}
							}

						}
					}

					var fObj:MovieClip;

					switch ( int( wLine[4] ) ) {
						case 0 :
							fObj = new fireT1();
							break;
						case 1 :
							fObj = new fireT2();
							break;
						case 2 :
							fObj = new fireT3();
							break;
						case 3 :
							fObj = new fireT4();
							break;
					}

					if (ffy==fty) {
						fty+=2;
					}

					fObj.x=ffx;
					fObj.y=ffy;
					if (int(wLine[4])!=2) {
						fObj.width=Math.abs(ftx-ffx);
						fObj.height=Math.abs(fty-ffy);
						if (ftx<ffx) {
							fObj.scaleX=- fObj.scaleX;
						}
						if (fty<ffy) {
							fObj.scaleY=- fObj.scaleY;
						}
					} else {
						fObj.width=Math.abs(ftx-ffx);
						fObj.height=330;
						if (ftx<ffx) {
							fObj.scaleX=- fObj.scaleX;
						}
					}

					fObj.name="fire";
					monitor.field_fire.addChild( fObj );

					if (die) {
						var bObj:MovieClip = new boom();
						bObj.x=dObj.x;
						bObj.y=dObj.y;
						bObj.height=dObj.height;
						bObj.width=dObj.height;
						monitor.field_ships.addChild( bObj );
						bObj.gotoAndPlay( 1 );

						bTween=new Tween(bObj,"alpha",Strong.easeOut,100,0,1,true);
						dTween=new Tween(dObj,"alpha",Strong.easeOut,100,0,1,true);
					}
				}

				renderNews();

				fireTimer.start();
			} else {
				if (wLoader.data.err==2&&wLoader.data.reload=='true') {
					fireTimer.stop();

					for (i = monitor.field_ships.numChildren-1; i >= 0; i--) {
						monitor.field_ships.removeChildAt( i );
					}
					nopLoader.addEventListener( Event.COMPLETE, warRender );
					nopLoader.load(new URLRequest("wo.php?id=361&wid="+wid));
				} else {
					fireTimer.start();
				}
			}
		}

		public function renderNews() {
			monitor.dtNinfo.htmlText="Всего кораблей: "+iNTotal+"<br>Всего защиты: "+iNshield+"<br>Убито с начала просмотра: "+iNkill+"<br>Захвачено с начала просмотра: "+iNcapture+"<br>Потери с начала просмотра: "+iNlost;
			monitor.dtFinfo.htmlText="Всего кораблей: "+iFTotal+"<br>Всего защиты: "+iFshield+"<br>Убито с начала просмотра: "+iFkill+"<br>Захвачено с начала просмотра: "+iFcapture+"<br>Потери с начала просмотра: "+iFlost;
		}

		public function fireUp( e:TimerEvent ) {
			fireTimer.stop();

			wLoader.load(new URLRequest( "wo.php?id=362&wi="+place_hash+"&lm="+lastMove+"&sd="+side  ));
			//wLoader.load(new URLRequest( "d:\page362.txt" ));
		}

		public function showCoords(e:MouseEvent) {
			monitor.coords.visible=true;
			monitor.coords.dtX.text=place_x;
			monitor.coords.dtY.text=place_y;

			rTween=new Tween(monitor.coords,"alpha",Strong.easeOut,monitor.coords.alpha,1,1,true);
		}

		public function hideCoords( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			place_x=int(monitor.coords.dtX.text);
			place_y=int(monitor.coords.dtY.text);
			nopLoader.addEventListener( Event.COMPLETE, nopStarMove );
			nopLoader.load(new URLRequest( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));

			rTween=new Tween(monitor.coords,"alpha",Strong.easeOut,monitor.coords.alpha,0,1,true);
			rTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function pUnvisible( event:Event ) {
			monitor.coords.visible=false;
		}

		public function clickOrder(e:MouseEvent) {
			var i:uint;
			var btUrl:String;
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			btnOrder.visible=false;
			var id:String=cbOrders.selectedItem.data;
			if (id.indexOf(":")>0) {
				id=id.substr(0,id.indexOf(":"));
			}

			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			switch ( int( id ) ) {
				case 0 :
				case 1 :
				case 2 :
				case 3 :
				case 4 :
				case 5 :
				case 6 :
				case 7 :
				case 12 :
				case 20 :
				case 21 :
				case 22 :
				case 23 :
				case 24 :
				case 25 :
				case 26 :
				case 27 :
				case 28 :
				case 29 :
				case 30 :
				case 31 :
				case 32 :
				case 33 :
				case 34 :
				case 35 :
				case 36 :
				case 37 :
				case 38 :
				case 39 :
				case 40 :
				case 43 :
				case 44 :
				case 46 :
				case 47 :
				case 48 :
					if (dgShips.selectedItems.length>1) {
						btUrl="page.php?id=35&cnt="+dgShips.selectedItems.length;
						for (i = 0; i < dgShips.selectedIndices.length; i++) {
							btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
						}
						nopLoader.load(new URLRequest( btUrl ));
						//nopLoader.load(new URLRequest("d:\page35.txt"));
					} else {
						nopLoader.load(new URLRequest("page.php?id=33&shid=" + sLoader.data["id"+dgShips.selectedIndex] + "&orid=" + escape( cbOrders.selectedItem.data )));//oLoader.data["id"+dgOrders.selectedIndex]
						//nopLoader.load(new URLRequest("d:\page33.txt"));
					}
					break;
				case 8 :
					btUrl="page.php?id=39&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&x="+place_x+"&y="+place_y;
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page39.txt"));
					break;
				case 9 :
				case 41 :
					btUrl="page.php?id=373&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&x="+place_x+"&y="+place_y;
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page373.txt"));
					break;
				case 11 :
					btUrl="page.php?id=33&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&orid=11&nname="+escape(monitor.dtName.text)+"&gname="+escape(monitor.dtGroup.text);
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page33.txt"));
					break;
				case 14 :
				case 16 :
				case 17 :
				case 18 :
				case 49 :
				case 51 :
					if (dgShips.selectedItems.length>1) {
						btUrl="page.php?id=351&cnt="+dgShips.selectedItems.length;
						for (i = 0; i < dgShips.selectedIndices.length; i++) {
							btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
						}
						nopLoader.load(new URLRequest( btUrl ));
						//nopLoader.load(new URLRequest("d:\page35.txt"));
					} else {
						nopLoader.load(new URLRequest("page.php?id=331&shid=" + sLoader.data["id"+dgShips.selectedIndex] + "&orid=" + escape( cbOrders.selectedItem.data )));//oLoader.data["id"+dgOrders.selectedIndex]
						//nopLoader.load(new URLRequest("d:\page33.txt"));
					}
					break;
			}
		}

		public function clickDeconserv(e:MouseEvent) {
			var btUrl:String="page.php?id=391&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&cnt="+int(monitor.dtCount.text)+"&gname="+monitor.dtGroup.text;
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page391.txt"));
		}

		public function clickDeconservAll(e:MouseEvent) {
			var btUrl:String="page.php?id=391&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&cnt="+iConservMax+"&gname="+monitor.dtGroup.text;
			var snd:Sound = new buzz();
			chanel=snd.play();
			chanel.soundTransform=stVolume;

			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page391.txt"));
		}

		public function nopOrderRefresh( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopOrderRefresh );
			if (nopLoader.data.err==0&&nopLoader.data.fid!=undefined) {
				aIds.length=0;
				lastShip=nopLoader.data.fid;
				needShip=true;
			}
			doRefresh=true;
			needScroll=true;
			pLoader.load(new URLRequest("page.php?id=311"));
		}

		public function itemsLoaded( event:Event ) {
			var i:uint;
			iDp.removeAll();
			if (iLoader.data.err==0&&iLoader.data.cnt>0) {
				for (i=0; i<iLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=iLoader.data["n"+i];
					dgFill["Количество"]=iLoader.data["c"+i];
					dgFill["Масса"]=iLoader.data["m"+i];
					dgFill["bgColor"]=iLoader.data["t"+i];
					iDp.addItem(dgFill);
				}
				if (monitor.dgItems.columns.length==0) {
					monitor.dgItems.addColumn( "Наименование" );
					monitor.dgItems.addColumn( "Количество" );
					monitor.dgItems.addColumn( "Масса" );
					monitor.dgItems.columns[0].width=450;
					monitor.dgItems.columns[1].width=100;
					monitor.dgItems.columns[2].width=100;
					monitor.dgItems.dataProvider=iDp;
					monitor.dgItems.setStyle("cellRenderer",AlternatingRowColors);
				}
			}
		}

		public function nopStarLoaded( event:Event ) {
			var i:uint;
			var homeStar:MovieClip = new hs();
			var questStar:MovieClip = new qs();
			lin.stop();

			nopLoader.removeEventListener( Event.COMPLETE, nopStarLoaded );

			monitor.dtDesc.htmlText=nopLoader.data.desc;

			for (i=0; i<nopLoader.data.cnt; i++) {
				var ClassReference:Class=getDefinitionByName("s"+nopLoader.data["st"+i]) as Class;
				var star:MovieClip = new ClassReference();
				star.x=nopLoader.data["sx"+i];
				star.y=nopLoader.data["sy"+i];
				monitor.starMap.bgGalaxy.addChild( star );
				if (nopLoader.data["fr"+i]) {
					var frstar:MovieClip = new frs();
					frstar.x=nopLoader.data["sx"+i];
					frstar.y=nopLoader.data["sy"+i];
					monitor.starMap.addChild( frstar );
				}
				if (nopLoader.data["fo"+i]) {
					var fostar:MovieClip = new fos();
					fostar.x=nopLoader.data["sx"+i];
					fostar.y=nopLoader.data["sy"+i];
					monitor.starMap.addChild( fostar );
				}
				if (nopLoader.data["as"+i]) {
					var alstar:MovieClip = new als();
					alstar.x=nopLoader.data["sx"+i];
					alstar.y=nopLoader.data["sy"+i];
					monitor.starMap.addChild( alstar );
				}
			}

			for (i=0; i<nopLoader.data.ycnt; i++) {
				var y_circ:MovieClip = new ys();
				y_circ.x=nopLoader.data["ysx"+i];
				y_circ.y=nopLoader.data["ysy"+i];
				monitor.starMap.addChild( y_circ );
			}

			st_circ.x=nopLoader.data.shx;
			st_circ.y=nopLoader.data.shy;
			monitor.starMap.addChild( st_circ );

			fn_circ.x=nopLoader.data.shx;
			fn_circ.y=nopLoader.data.shy;
			monitor.starMap.addChild( fn_circ );

			monitor.starMap.x=330-nopLoader.data.shx;
			monitor.starMap.y=250-nopLoader.data.shy;

			lin.x=nopLoader.data.shx;
			lin.y=nopLoader.data.shy;
			lin.width=0;
			lin.height=0;
			monitor.starMap.addChild( lin );

			homeStar.x=nopLoader.data.hstx;
			homeStar.y=nopLoader.data.hsty;
			monitor.starMap.addChild( homeStar );

			if (nopLoader.data.quest=='true') {
				questStar.x=nopLoader.data.qsx;
				questStar.y=nopLoader.data.qsy;
				monitor.starMap.addChild( questStar );
			}

			monitor.starMap.addEventListener( MouseEvent.MOUSE_DOWN, starStartScroll );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_UP, starStopScroll );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_OVER, showDesc );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_OUT, hideDesc );
		}

		public function clickSaveMessage( e:MouseEvent ) {
			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			nopLoader.load(new URLRequest( "page.php?id=33&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&orid=45&msg="+escape( monitor.dtMessage.text ) ) );
		}

		public function nopInterruptLoad( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopInterruptLoad );
			if (nopLoader.data.err==0) {
				monitor.dtMessage.text=nopLoader.data.msg;
			} else {
				monitor.dtMessage.text="";
			}
		}

		public function nopStarLoadedHome( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopStarLoadedHome );
			nopStarLoaded( event );
			place_x=nopLoader.data.hstx;
			place_y=nopLoader.data.hsty;
			monitor.starMap.x=330-nopLoader.data.hstx;
			monitor.starMap.y=250-nopLoader.data.hsty;
			nopLoader.addEventListener( Event.COMPLETE, nopStarMove );
			nopLoader.load(new URLRequest( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));
		}

		public function starStartScroll( e:MouseEvent ) {
			hideDesc( e );
			oldX=int(monitor.starMap.x);
			oldY=int(monitor.starMap.y);
			monitor.starMap.startDrag( false );
		}

		public function starStopScroll( e:MouseEvent ) {
			if (oldX==int(monitor.starMap.x)&&oldY==int(monitor.starMap.y)) {
				place_x=monitor.starMap.mouseX;
				place_y=monitor.starMap.mouseY;
				nopLoader.addEventListener( Event.COMPLETE, nopStarMove );
				nopLoader.load(new URLRequest( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));
				//nopLoader.load(new URLRequest( "d:\page372.txt" ));
			}
			monitor.starMap.stopDrag();
			showDesc( e );
		}

		public function nopStarMove( event:Event ) {
			var outGlow:GlowFilter=new GlowFilter(0xFF0000,1,8,8,2,1,true,false);
			nopLoader.removeEventListener( Event.COMPLETE, nopStarMove );

			if (nopLoader.data.err==0) {
				var rx:int=int(nopLoader.data.rx);
				var ry:int=int(nopLoader.data.ry);
				var iAdd:uint;

				place_x=rx;
				place_y=ry;
				switch ( int( nopLoader.data.t ) ) {
					case 1 :
						if (nopLoader.data.desc.indexOf("#FF0000")!=-1) {
							btnOrder.filters=[outGlow];
						} else {
							btnOrder.filters=null;
						}
						btnOrder.visible=true;
						iAdd=4;
						break;
					case 2 :
						if (nopLoader.data.desc.indexOf("#FF0000")!=-1) {
							btnOrder.filters=[outGlow];
						} else {
							btnOrder.filters=null;
						}
						btnOrder.visible=true;
						iAdd=0;
						break;
					case 3 :
						btnOrder.visible=false;
						btnOrder.filters=null;
						iAdd=8;
						break;
				}
				fn_circ.x=rx;
				fn_circ.y=ry;
				monitor.dtDesc.htmlText=nopLoader.data.desc;

				if (rx>=int(lin.x)&&ry>=int(lin.y)) {
					lin.gotoAndStop(iAdd + 1);
					lin.width=rx-lin.x;
					lin.height=ry-lin.y;
				}
				if (rx>=int(lin.x)&&ry<int(lin.y)) {
					lin.gotoAndStop(iAdd + 2);
					lin.width=rx-lin.x;
					lin.height=lin.y-ry;
				}
				if (rx<int(lin.x)&&ry<int(lin.y)) {
					lin.gotoAndStop(iAdd + 3);
					lin.width=lin.x-rx;
					lin.height=lin.y-ry;
				}
				if (rx<int(lin.x)&&ry>=int(lin.y)) {
					lin.gotoAndStop(iAdd + 4);
					lin.width=lin.x-rx;
					lin.height=ry-lin.y;
				}
				if (lin.width==0) {
					lin.width=1;
				}
				if (lin.height==0) {
					lin.height=1;
				}
			}
		}

		public function updateDesc( event:Event ) {
			monitor.starDesc.desc.text=monitor.starMap.mouseX+":"+monitor.starMap.mouseY;
		}

		public function showDesc( e:MouseEvent ) {
			monitor.starMap.addEventListener( Event.ENTER_FRAME, updateDesc );
			monitor.starDesc.visible=true;
			monitor.starDesc.startDrag( true );
		}

		public function hideDesc( e:MouseEvent ) {
			monitor.starMap.removeEventListener( Event.ENTER_FRAME, updateDesc );
			monitor.starDesc.stopDrag();
			monitor.starDesc.visible=false;
		}

		public function nopPlanetLoaded( event:Event ) {
			var i:uint;
			var nebulaLoader:Loader = new Loader();

			lin.stop();
			nopLoader.removeEventListener( Event.COMPLETE, nopPlanetLoaded );
			monitor.dtSystemName.htmlText="Система : "+nopLoader.data.sname;
			monitor.dtDesc.htmlText=nopLoader.data.ftxt;

			var nebulaURL:URLRequest=new URLRequest("img/n"+nopLoader.data.bgid+".jpg");
			nebulaLoader.load( nebulaURL );
			monitor.bgNebula.addChild( nebulaLoader );

			var ClassReference:Class=getDefinitionByName("st"+nopLoader.data["stype"]) as Class;
			var star:MovieClip = new ClassReference();
			star.x=340;
			star.y=220;
			monitor.planetMap.addChild( star );

			if (nopLoader.data["pt"]==0) {
				var radx:Number=int(nopLoader.data["arg2"])*2;
				var rady:Number=int(nopLoader.data["arg2"])*1.5;
				lin.x=int(340+Math.sin(nopLoader.data["arg1"]*3.14/180)*radx/2);
				lin.y=int(220+Math.cos(nopLoader.data["arg1"]*3.14/180)*rady/2);
			} else {
				lin.x=nopLoader.data["arg1"];
				lin.y=nopLoader.data["arg2"];
			}

			st_circ.x=lin.x;
			st_circ.y=lin.y;
			monitor.planetMon.addChild( st_circ );

			fn_circ.x=lin.x;
			fn_circ.y=lin.y;
			monitor.planetMon.addChild( fn_circ );

			lin.width=0;
			lin.height=0;
			monitor.planetMon.addChild( lin );

			var oldOrb:int=0;
			for (i=0; i<nopLoader.data.cnt; i++) {
				if (oldOrb!=nopLoader.data["or"+i]) {
					var orb:MovieClip = new orbit();
					orb.x=340;
					orb.y=220;
					radx=int(nopLoader.data["or"+i])*2;
					rady=int(nopLoader.data["or"+i])*1.5;
					orb.width=radx;
					orb.height=rady;
					monitor.planetMon.addChild( orb );
					oldOrb=nopLoader.data["or"+i];
				}

				ClassReference=getDefinitionByName("p"+nopLoader.data["ty"+i]) as Class;
				var planet:MovieClip = new ClassReference();
				planet.x=340+Math.sin(nopLoader.data["an"+i]*3.14/180)*radx/2;
				planet.y=220+Math.cos(nopLoader.data["an"+i]*3.14/180)*rady/2;
				monitor.planetMap.addChild( planet );
				if (nopLoader.data["ty"+i]!=5) {
					var mvShadow:MovieClip = new shadow();
					mvShadow.x=planet.x;
					mvShadow.y=planet.y;
					mvShadow.width=planet.width+1;
					mvShadow.height=planet.height+1;
					mvShadow.rotation=6.28-nopLoader.data["an"+i];
					monitor.planetMap.addChild( mvShadow );
				}
			}

			for (i=0; i<nopLoader.data.fcnt; i++) {
				var ship:MovieClip;
				switch ( int( nopLoader.data["ct"+i] ) ) {
					case 1 :
						ship = new ss();
						break;

					case 2 :
						ship = new sf();
						break;

					case 3 :
						ship = new sq();
						break;
				}
				ship.x=nopLoader.data["sx"+i];
				ship.y=nopLoader.data["sy"+i];
				monitor.planetMon.addChild( ship );
			}
			monitor.addEventListener( MouseEvent.MOUSE_UP, planetClick );
		}

		public function planetClick( e:MouseEvent ) {
			place_x=monitor.planetMap.mouseX;
			place_y=monitor.planetMap.mouseY;
			nopLoader.addEventListener( Event.COMPLETE, nopPlanetMove );
			nopLoader.load(new URLRequest( "page.php?id=38&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));
			//nopLoader.load(new URLRequest( "d:\page38.txt" ));
		}

		public function nopPlanetMove( event:Event ) {
			var outGlow:GlowFilter=new GlowFilter(0xFF0000,1,8,8,2,1,true,false);
			nopLoader.removeEventListener( Event.COMPLETE, nopPlanetMove );

			if (nopLoader.data.err==0) {
				var rx:int=int(nopLoader.data.rx);
				var ry:int=int(nopLoader.data.ry);
				var iAdd:uint;

				place_x=rx;
				place_y=ry;
				switch ( int( nopLoader.data.t ) ) {
					case 1 :
						if (nopLoader.data.desc.indexOf("#FF0000")!=-1) {
							btnOrder.filters=[outGlow];
						} else {
							btnOrder.filters=null;
						}
						btnOrder.visible=true;
						iAdd=4;
						break;
					case 2 :
						if (nopLoader.data.desc.indexOf("#FF0000")!=-1) {
							btnOrder.filters=[outGlow];
						} else {
							btnOrder.filters=null;
						}
						btnOrder.visible=true;
						iAdd=0;
						break;
					case 3 :
						btnOrder.visible=false;
						btnOrder.filters=null;
						iAdd=8;
						break;
				}
				fn_circ.x=rx;
				fn_circ.y=ry;
				monitor.dtDesc.htmlText=nopLoader.data.desc;

				if (rx>=int(lin.x)&&ry>=int(lin.y)) {
					lin.gotoAndStop(iAdd + 1);
					lin.width=rx-lin.x;
					lin.height=ry-lin.y;
				}
				if (rx>=int(lin.x)&&ry<int(lin.y)) {
					lin.gotoAndStop(iAdd + 2);
					lin.width=rx-lin.x;
					lin.height=lin.y-ry;
				}
				if (rx<int(lin.x)&&ry<int(lin.y)) {
					lin.gotoAndStop(iAdd + 3);
					lin.width=lin.x-rx;
					lin.height=lin.y-ry;
				}
				if (rx<int(lin.x)&&ry>=int(lin.y)) {
					lin.gotoAndStop(iAdd + 4);
					lin.width=lin.x-rx;
					lin.height=ry-lin.y;
				}
				if (lin.width==0) {
					lin.width=1;
				}
				if (lin.height==0) {
					lin.height=1;
				}
			}
		}
	}
}
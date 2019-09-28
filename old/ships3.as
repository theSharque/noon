package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
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

	public class ships3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var chanel:SoundChannel;
		private var iConservMax:uint;
		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();
		private var monitor:MovieClip;
		private var rTween:Tween;

		private var place_x:int;
		private var place_y:int;
		private var oldX:int;
		private var oldY:int;
		private var st_circ:MovieClip = new start_circle();
		private var fn_circ:MovieClip = new final_circle();
		private var lin:MovieClip = new traction();

		private var sLoader:URLLoader = new URLLoader();
		private var doRefresh:Boolean = true;
		private var sDp:DataProvider = new DataProvider();
		private var shipsTimer:Timer = new Timer(1000);
		private var shipsStartTime:Number = (new Date()).valueOf();
		private var fireTimer:Timer = new Timer(1000);
		private var dTween:Tween;
		private var shields:Array = new Array();
		private var perc:Array = new Array();

		private var lastShip:String = root.loaderInfo.parameters.ls;
		private var needTimer:Boolean = false;

		private var oLoader:URLLoader = new URLLoader();
		private var oDp:DataProvider = new DataProvider();

		private var iLoader:URLLoader = new URLLoader();
		private var iDp:DataProvider = new DataProvider();
		
		private var fLoader:URLLoader = new URLLoader();
		private var fDp:DataProvider = new DataProvider();

		private var stDp:DataProvider = new DataProvider();
		private var taDp:DataProvider = new DataProvider();

		private var wLoader:URLLoader = new URLLoader();
		private var warId:String;
		private var lastMove:String;

		public function ships3() {
			nopLoader.dataFormat = URLLoaderDataFormat.VARIABLES;

			myFormat.color = 0xFFFFFF;
			myFormat.font = "Verdana";
			myFormat.size = 12;

			myHeadFormat.color = 0xBFBFFF;
			myHeadFormat.font = "Verdana";
			myHeadFormat.size = 12;
			myHeadFormat.bold = true;

			dgShips.addEventListener( Event.CHANGE, shipsChange );
			dgShips.setRendererStyle( "textFormat", myFormat );
			dgShips.setStyle( "headerTextFormat", myHeadFormat );
			dgShips.addColumn( "Имя" );
			dgShips.addColumn( "Расположение" );
			dgShips.columns[0].width = 100;
			dgShips.columns[1].width = 220;
			dgShips.dataProvider = sDp;
			dgShips.setStyle("cellRenderer",AlternatingRowColors);
			shipsTimer.addEventListener(TimerEvent.TIMER, shipsRefresh);
			
			dgOrders.addEventListener( Event.CHANGE, ordersChange );
			dgOrders.setRendererStyle( "textFormat", myFormat );
			dgOrders.setStyle( "headerTextFormat", myHeadFormat );
			dgOrders.addColumn( "Приказ" );
			dgOrders.dataProvider=oDp;
			dgOrders.setStyle("cellRenderer",AlternatingRowColors);

			btnOrder.addEventListener(MouseEvent.CLICK, clickOrder);
			btnOrder.visible = false;

			sLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, shipsLoaded);
			doRefresh = true;
//			sLoader.load(new URLRequest("d:\page31.txt"));
			sLoader.load(new URLRequest("page.php?id=31"));

			oLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			oLoader.addEventListener(Event.COMPLETE, ordersLoaded);

			iLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, itemsLoaded);

			fLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			fLoader.addEventListener(Event.COMPLETE, fleetLoaded);

			wLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			wLoader.addEventListener(Event.COMPLETE, fireRender);
			fireTimer.addEventListener(TimerEvent.TIMER, fireUp);
		}

		public function shipsLoaded(event:Event) {
			var i:uint;
			var e:TimerEvent;
			sDp.removeAll();
			shipsStartTime = (new Date()).valueOf();
			shipsRefresh( e );
			var needScroll:Boolean = false
/*
trace( dgShips.vPosition );
			if( dgShips.vPosition ) {
			}
*/
			dgShips.selectedIndex = 0;
			needTimer = false;
			if (sLoader.data.cnt > 0) {
				for (i=0; i<sLoader.data.cnt; i++) {
					if (lastShip == sLoader.data["id" + i]) {
						dgShips.selectedIndex = i;
					}
					if (int(sLoader.data["tp" + i]) > 0) {
						needTimer = true;
					}
				}
			}

			dgShips.scrollToIndex( dgShips.selectedIndex );
			
			if(doRefresh) {
				shipsChange(event);
			}

			if (needTimer) {
				shipsTimer.start();
			}
		}

		public function shipsRefresh(e:TimerEvent) {
			var i:uint;
			var iPos:Array;
			var diff:int = 0;
			var currentTime:Number = (new Date()).valueOf();

			if (sLoader.data.cnt > 0) {
				if (dgShips.selectedIndices) {
					iPos = dgShips.selectedIndices;
				}
				sDp.removeAll();
				for (i=0; i<sLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Имя"] = sLoader.data["name" + i];
					dgFill["bgColor"] = sLoader.data["c" + i];

					if (! isNaN(sLoader.data["tp" + i])) {
						diff = int( ( int( sLoader.data["tp" + i] * 1000 ) - ( currentTime - shipsStartTime ) ) / 1000 );
						if (diff > 0) {
							var vD:uint = int(diff / 86400);
							diff = diff % 86400;
							var vH = int(diff / 3600);
							diff = diff % 3600;
							var vM = int(diff / 60);
							var vS = diff % 60;
							var timestring:String = "";
							if (vD > 0) {
								timestring = vD + ".";
							}
							if (vH >= 10) {
								timestring += vH + ":";
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
							if( iPos.length == 1 && iPos[0] == i && sLoader.data["c" + i] != '0xCC0000' ) {
								doRefresh = true;
							} else {
								doRefresh = false;
							}
							sLoader.load(new URLRequest("page.php?id=31"));
							shipsTimer.stop();
						}
					} else {
						dgFill["Расположение"]=sLoader.data["place"+i];
					}
					sDp.addItem(dgFill);
				}
				dgShips.selectedIndices=iPos;
			}
		}

		public function shipsChange(event:Event) {
			var i:uint;
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			oDp.removeAll();

			if (dgShips.selectedItems.length>1) {
				var btUrl:String="page.php?id=34&cnt="+dgShips.selectedItems.length;
				for (i = 0; i < dgShips.selectedIndices.length; i++) {
					btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
				}
				//oLoader.load(new URLRequest("d:\page34.txt"));
				oLoader.load(new URLRequest(btUrl));
			} else {
				lastShip=sLoader.data["id"+dgShips.selectedIndex];
				oLoader.load(new URLRequest("page.php?id=32&shid="+lastShip));
//				oLoader.load(new URLRequest("d:\page32.txt"));
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
						monitor.dtCount.text = '1';
						monitor.btnDeconserv.addEventListener(MouseEvent.CLICK, clickDeconserv);
						monitor.btnDeconservAll.addEventListener(MouseEvent.CLICK, clickDeconservAll);
						break;
				}
				monitor.x=350;
				addChild( monitor );
				monitor.dtInfo.htmlText="Загрузка...";
				if (dgShips.selectedItems.length==1) {
					nopLoader.addEventListener( Event.COMPLETE, nopInfoLoad );
					nopLoader.load(new URLRequest("page.php?id=36&shid="+sLoader.data["id"+dgShips.selectedIndex]));
//					nopLoader.load(new URLRequest("d:\page36.txt"));
				}
			}
		}

		public function nopInfoLoad(event:Event) {
			nopLoader.removeEventListener( Event.COMPLETE, nopInfoLoad );
			monitor.dtInfo.htmlText=nopLoader.data.out;
			if (nopLoader.data.info!=undefined) {
				monitor.dtShips.htmlText=nopLoader.data.info;
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
				dgFill["bgColor"] = "0x000000";
				stDp.addItem(dgFill);
			}
			monitor.dgStrateg.selectedIndex = nopLoader.data.scnt - 1;

			taDp.removeAll();
			for (i=0; i<nopLoader.data.tcnt; i++) {
				dgFill = new Array();
				dgFill["Тип"]=nopLoader.data["ta"+i];
				dgFill["bgColor"] = "0x000000";
				taDp.addItem(dgFill);
			}
			monitor.dgTactic.selectedIndex = nopLoader.data.tcnt - 1;

			monitor.btnAtack.visible = true;
		}

		private function ordersLoaded(event:Event) {
			var i:uint;
			oDp.removeAll();
			if (oLoader.data.cnt>0) {
				for (i=0; i<oLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Приказ"]=oLoader.data["name"+i];
					dgFill["bgColor"]=oLoader.data["c"+i];
					oDp.addItem(dgFill);
				}
				btnOrder.visible=false;
			}
		}

		public function fleetLoaded( event:Event ) {
			var i:uint;
			fDp.removeAll();
			if (fLoader.data.err==0 && fLoader.data.cnt>0) {
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

		public function clickFleetOut( e:MouseEvent ) {
			var i:uint;
			var btUrl:String;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			btUrl="page.php?id=353&cnt="+monitor.dgShips.selectedItems.length;
			btUrl=btUrl + "&fid="+sLoader.data["id"+dgShips.selectedIndex];
			for (i = 0; i < monitor.dgShips.selectedIndices.length; i++) {
				btUrl=btUrl+"&sh"+i+"="+fLoader.data["id"+monitor.dgShips.selectedIndices[i]];
			}
			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );

			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page35.txt"));
		}

		public function ordersChange(event:Event) {
			var newMonitor:MovieClip;
			var wid:String;

			var id:String=oLoader.data["id"+dgOrders.selectedIndex];
			if (id.indexOf(":")>0) {
				wid = id.substr(id.indexOf(":")+1);
				id = id.substr(0,id.indexOf(":"));
			}

			switch ( int(id) ) {
				case 0 :
					newMonitor = new make_fleet();
					break;
				case 1 :
				case 22 :
				case 23 :
				case 24 :
				case 34 :
					newMonitor = new ship_land();
					break;
				case 2 :
					newMonitor = new ship_flyout();
					break;
				case 3 :
					newMonitor = new ship_undock();
					break;
				case 4 :
				case 31:
					newMonitor = new ship_dock();
					break;
				case 7 :
					newMonitor = new disband_fleet();
					newMonitor.dgShips.setRendererStyle( "textFormat", myFormat );
					newMonitor.dgShips.setStyle( "headerTextFormat", myHeadFormat );
					fLoader.load(new URLRequest("page.php?id=352&shid="+sLoader.data["id"+dgShips.selectedIndex]));
					newMonitor.btnFleetOut.addEventListener(MouseEvent.CLICK, clickFleetOut);
					break;
				case 8 :
					newMonitor = new system_move();
					nopLoader.addEventListener( Event.COMPLETE, nopPlanetLoaded );
					nopLoader.load(new URLRequest( "page.php?id=37&shid="+sLoader.data["id"+dgShips.selectedIndex] ));
					//nopLoader.load(new URLRequest( "d:\page37.txt" ));
					break;
				case 9 :
					newMonitor = new star_move();
					newMonitor.coords.visible = false;
					newMonitor.coords.alpha = 0;
					newMonitor.btnShowCoords.addEventListener(MouseEvent.CLICK, showCoords);
					newMonitor.coords.btnSetCoord.addEventListener(MouseEvent.CLICK, hideCoords);
					nopLoader.addEventListener( Event.COMPLETE, nopStarLoaded );
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
					if (sName.substr(0,1)=="*") {
						newMonitor.dtName.text=sName.substr(1);
					} else {
						newMonitor.dtName.text=sName;
					}
					newMonitor.btnRename.addEventListener(MouseEvent.CLICK, clickOrder);
					break;
				case 14 :
					newMonitor = new planet_attack();
					break;
				case 16 :
				case 32 :
				case 33 :
					newMonitor = new ship_attack();
					break;
				case 17 :
				case 18 :
					newMonitor = new fleet_attack();
					break;
				case 50 :
					newMonitor = new ship_war();
					warId = wid;
					nopLoader.addEventListener( Event.COMPLETE, warRender );
					nopLoader.load(new URLRequest("wo.php?id=361&wid="+wid));
//					nopLoader.load(new URLRequest("d:\page361.txt"));
					break;
			}

			if (newMonitor) {
				if (getQualifiedClassName(monitor)=="star_move") {
					monitor.starMap.removeEventListener( MouseEvent.MOUSE_DOWN, starStartScroll );
					monitor.starMap.removeEventListener( MouseEvent.MOUSE_UP, starStopScroll );
					monitor.starMap.removeEventListener( MouseEvent.MOUSE_OVER, showDesc );
					monitor.starMap.removeEventListener( MouseEvent.MOUSE_OUT, hideDesc );
				}
				if (getQualifiedClassName(monitor)=="system_move") {
					monitor.removeEventListener( MouseEvent.MOUSE_UP, planetClick );
				}
				removeChild( monitor );
				monitor=newMonitor;
				monitor.x=350;
				addChild( monitor );
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
					btnOrder.visible=true;
					break;
				default :
					btnOrder.visible=false;
					break;
			}
		}

		public function clickWarehouse( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			navigateToURL( new URLRequest("page.php?id=4&shid="+sLoader.data["id"+dgShips.selectedIndex]), "main" );
		}

		public function warRender( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopOrderRefresh );

			var i:int = 0;
			var t:int = 0;
			var inLines:int = 1;
			var ifLines:int = 1;
			var inShipCnt:int = 0;
			var ifShipCnt:int = 0;
			var iMaxShip:int = 0;
			var iXStart:int = 0;
			var iYStart:int = 0;
			var sw:int;
			var fMag:Number = 1;
			var s:int = 0;

			lastMove = nopLoader.data.lm;

			if( nopLoader.data.ncnt % 2 == 1 ) {
				inShipCnt = t = i = 1;
			} else {
				inShipCnt = t = i = 2;
			}

			for( i ;i < nopLoader.data.ncnt; i+=t ) {
				inLines++;
				t++;
			}

			if( nopLoader.data.fcnt % 2 == 1 ) {
				ifShipCnt = t = i = 1;
			} else {
				ifShipCnt = t = i = 2;
			}

			for( i ;i < nopLoader.data.fcnt; i+=t ) {
				ifLines++;
				t++;
			}

			if( inLines > ifLines ) {
				if( inLines > 1 ) {
					fMag = 200 / ( inLines * 200 );
				}
			} else {
				if( ifLines > 1 ) {
					fMag = 200 / ( ifLines * 200 );
				}
			}

			iMaxShip = nopLoader.data.ncnt;
			for( t = 0; t < inLines; t++ ) {
				if( iMaxShip >= inShipCnt ) {
					iXStart = 330 - ( inShipCnt * fMag * 300 ) / 2;
				} else {
					iXStart = 330 - ( iMaxShip * fMag * 300 ) / 2;
				}
				for( i = 0; i < inShipCnt && i < iMaxShip; i++ ) {

					var nship:MovieClip;
					switch( int( nopLoader.data.ntp ) ) {
						case 0:
						case 1:
							nship = new ship_back();
							break;
						case 2:
							nship = new planet_back();
							break;
						case 3:
							nship = new orbit_back();
							break;
					}

					nship.width = 300 * fMag;
					nship.height = 200 * fMag;
					nship.x = iXStart + i * 300 * fMag;
					nship.y = 500 - ( inLines * 200 * fMag ) + t * 200 * fMag;
					nship.name = nopLoader.data["nid"+s];
					nship.shield.prc.width = 200 - ( ( nopLoader.data["nst"+s] / 200 ) * nopLoader.data["nsh"+s] );
					nship.gotoAndPlay( int( Math.random() * 70 ) );
					monitor.field_ships.addChild( nship );
					perc[ nopLoader.data["nid"+s] ] = nopLoader.data["nsh"+s];
					shields[ nopLoader.data["nid"+s] ] = nopLoader.data["nst"+s];
					s++;
				}
				iMaxShip -= inShipCnt;
				inShipCnt++;
			}

			s = 0;
			iMaxShip = nopLoader.data.fcnt;
			for( t = 0; t < ifLines; t++ ) {
				if( iMaxShip >= ifShipCnt ) {
					iXStart = 330 - ( ifShipCnt * fMag * 300 ) / 2;
				} else {
					iXStart = 330 - ( iMaxShip * fMag * 300 ) / 2;
				}
				for( i = 0; i < ifShipCnt && i < iMaxShip; i++ ) {

					var fship:MovieClip;
					switch( int( nopLoader.data.ftp ) ) {
						case 0:
						case 1:
							fship = new ship_front();
							break;
						case 2:
							fship = new planet_front();
							break;
						case 3:
							fship = new orbit_front();
							break;
					}

					fship.width = 300 * fMag;
					fship.height = 200 * fMag;
					fship.x = iXStart + i * 300 * fMag;
					fship.y = ( ifLines * 200 * fMag ) - 200 * fMag - t * 200 * fMag;
					fship.name = nopLoader.data["fid"+s];
					fship.shield.prc.width = 200 - ( ( nopLoader.data["fst"+s] / 200 ) * nopLoader.data["fsh"+s] );
					fship.gotoAndPlay( int( Math.random() * 70 ) );
					monitor.field_ships.addChild( fship );
					perc[ nopLoader.data["fid"+s] ] = nopLoader.data["fsh"+s];
					shields[ nopLoader.data["fid"+s] ] = nopLoader.data["fst"+s];
					s++;
				}
				iMaxShip -= ifShipCnt;
				ifShipCnt++;
			}

			wLoader.load(new URLRequest( "wo.php?id=362&wi="+warId+"&lm="+lastMove ));
//			wLoader.load(new URLRequest( "d:\page362.txt" ));
		}

		public function fireRender( event:Event ) {
			var i:int;
			var ffx:int, ffy:int, ftx:int, fty:int;
			var line:String;
			var wLine:Array;
			var mcFire:MovieClip;
			var die:Boolean = false;
			var dObj:MovieClip;

			while( mcFire = monitor.field_fire.getChildByName( "fire" ) ) {
				monitor.field_fire.removeChild( mcFire );
			}

			if( wLoader.data.err == 0 && wLoader.data.cnt > 0 ) {
				lastMove = wLoader.data.lm;
				for( i = 0; i < wLoader.data.cnt; i++ ) {
					line = wLoader.data['l'+i];
					wLine = line.split( ':' );

					ffx = monitor.field_ships.getChildByName( wLine[0] ).x;
					ffy = monitor.field_ships.getChildByName( wLine[0] ).y;
					ffx += monitor.field_ships.getChildByName( wLine[0] ).width / 2;
					if( ffy > 250 ) {
						ffy += monitor.field_ships.getChildByName( wLine[0] ).height / 10 * 3;
					} else {
						ffy += monitor.field_ships.getChildByName( wLine[0] ).height / 10 * 5;
					}

					ftx = monitor.field_ships.getChildByName( wLine[2] ).x;
					fty = monitor.field_ships.getChildByName( wLine[2] ).y;
					ftx += monitor.field_ships.getChildByName( wLine[2] ).width / 2;
					if( fty > 250 ) {
						fty += monitor.field_ships.getChildByName( wLine[2] ).height / 10 * 4;
					} else {
						fty += monitor.field_ships.getChildByName( wLine[2] ).height / 10 * 5;
					}

					dObj = monitor.field_ships.getChildByName( wLine[2] );
					
					die = false;
					if( wLine[5] == 0 ) {
						ftx += ( Math.random() * 100 ) - 50;
						fty += ( Math.random() * 100 ) - 50;
					} else {
						if( wLine[5] > 0 ) {
							ftx += ( Math.random() * 10 ) - 5;
							fty += ( Math.random() * 10 ) - 5;
							perc[wLine[2]] = perc[wLine[2]] - wLine[5];
							dObj.shield.prc.width = ( 200 / shields[wLine[2]] ) * perc[wLine[2]];
						} else {
							ftx += ( Math.random() * 10 ) - 5;
							fty += ( Math.random() * 10 ) - 5;
							die = true;
						}
					}

					var fObj:MovieClip;

					switch( int( wLine[4] ) ) {
						case 0 :
							fObj = new fireT1();
							fObj.gotoAndPlay( int( Math.random() * 10 ) );
							break;
						case 1 :
							fObj = new fireT2();
							fObj.gotoAndPlay( int( Math.random() * 10 ) );
							break;
						case 2 :
							fObj = new fireT3();
							break;
						case 3 :
							fObj = new fireT4();
							break;
					}
					if( ffx == ftx ) {
						ftx += 2;
					}

					fObj.x = ffx;
					fObj.y = ffy;
					fObj.width = Math.abs( ftx - ffx );
					fObj.height = Math.abs( fty - ffy );
					if( ftx < ffx ) {
						fObj.scaleX = -fObj.scaleX;
					}
					if( fty < ffy ) {
						fObj.scaleY = -fObj.scaleY;
					}

					fObj.name = "fire";
					monitor.field_fire.addChild( fObj );

					if( die ) {
						dTween = new Tween(dObj, "alpha", Strong.easeOut, 100, 0, 1, true);
					}
				}
			}
			fireTimer.start();
		}

		public function fireUp( e:TimerEvent ) {
			wLoader.load(new URLRequest( "wo.php?id=362&wi="+warId+"&lm="+lastMove ));
//			wLoader.load(new URLRequest( "d:\page362.txt" ));
		}

		public function showCoords(e:MouseEvent) {
			monitor.coords.visible = true;
			monitor.coords.dtX.text = place_x;
			monitor.coords.dtY.text = place_y;

			rTween = new Tween(monitor.coords, "alpha", Strong.easeOut, monitor.coords.alpha, 1, 1, true);
		}

		public function hideCoords( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			place_x=int( monitor.coords.dtX.text );
			place_y=int( monitor.coords.dtY.text );
			nopLoader.addEventListener( Event.COMPLETE, nopStarMove );
			nopLoader.load(new URLRequest( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));

			rTween = new Tween(monitor.coords, "alpha", Strong.easeOut, monitor.coords.alpha, 0, 1, true);
			rTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function pUnvisible( event:Event ) {
			monitor.coords.visible = false;
		}

		public function clickOrder(e:MouseEvent) {
			var i:uint;
			var btUrl:String;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			var id:String=oLoader.data["id"+dgOrders.selectedIndex];
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
					if (dgShips.selectedItems.length>1) {
						btUrl="page.php?id=35&cnt="+dgShips.selectedItems.length;
						for (i = 0; i < dgShips.selectedIndices.length; i++) {
							btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
						}
						nopLoader.load(new URLRequest( btUrl ));
						//nopLoader.load(new URLRequest("d:\page35.txt"));
					} else {
						nopLoader.load(new URLRequest("page.php?id=33&shid=" + sLoader.data["id"+dgShips.selectedIndex] + "&orid=" + escape( oLoader.data["id"+dgOrders.selectedIndex] )));
						//nopLoader.load(new URLRequest("d:\page33.txt"));
					}
					break;
				case 8 :
					btUrl="page.php?id=39&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&x="+place_x+"&y="+place_y;
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page39.txt"));
					break;
				case 9 :
					btUrl="page.php?id=373&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&x="+place_x+"&y="+place_y;
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page373.txt"));
					break;
				case 11 :
					btUrl="page.php?id=33&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&orid=11&nname="+monitor.dtName.text;
					nopLoader.load(new URLRequest( btUrl ));
					//nopLoader.load(new URLRequest("d:\page33.txt"));
					break;
				case 14 :
				case 16 :
				case 17 :
				case 18 :
					if (dgShips.selectedItems.length > 1) {
						btUrl="page.php?id=351&cnt="+dgShips.selectedItems.length;
						for (i = 0; i < dgShips.selectedIndices.length; i++) {
							btUrl=btUrl+"&sh"+i+"="+sLoader.data["id"+dgShips.selectedIndices[i]];
						}
						nopLoader.load(new URLRequest( btUrl ));
						//nopLoader.load(new URLRequest("d:\page35.txt"));
					} else {
						nopLoader.load(new URLRequest("page.php?id=331&shid=" + sLoader.data["id"+dgShips.selectedIndex] + "&orid=" + escape( oLoader.data["id"+dgOrders.selectedIndex] )));
						//nopLoader.load(new URLRequest("d:\page33.txt"));
					}
					break;
			}
		}

		public function clickDeconserv(e:MouseEvent) {
			var btUrl:String="page.php?id=391&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&cnt="+int(monitor.dtCount.text);
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page391.txt"));
		}

		public function clickDeconservAll(e:MouseEvent) {
			var btUrl:String="page.php?id=391&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&cnt="+iConservMax;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener( Event.COMPLETE, nopOrderRefresh );
			nopLoader.load(new URLRequest( btUrl ));
			//nopLoader.load(new URLRequest("d:\page391.txt"));
		}

		public function nopOrderRefresh( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopOrderRefresh );
			if ( nopLoader.data.err == 0 && nopLoader.data.fid != undefined ) {
				lastShip=nopLoader.data.fid;
			}
			doRefresh = true;
			sLoader.load(new URLRequest("page.php?id=31"));
			//sLoader.load(new URLRequest("d:\page31.txt"));
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
				monitor.starMap.addChild( star );
				if( nopLoader.data["fr"+i] ) {
					var frstar:MovieClip = new frs();
					frstar.x=nopLoader.data["sx"+i];
					frstar.y=nopLoader.data["sy"+i];
					monitor.starMap.addChild( frstar );
				}
				if( nopLoader.data["fo"+i] ) {
					var fostar:MovieClip = new fos();
					fostar.x=nopLoader.data["sx"+i];
					fostar.y=nopLoader.data["sy"+i];
					monitor.starMap.addChild( fostar );
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

			monitor.starMap.x = 330 - nopLoader.data.shx;
			monitor.starMap.y = 250 - nopLoader.data.shy;

			lin.x=nopLoader.data.shx;
			lin.y=nopLoader.data.shy;
			lin.width=0;
			lin.height=0;
			monitor.starMap.addChild( lin );

			homeStar.x=nopLoader.data.hstx;
			homeStar.y=nopLoader.data.hsty;
			monitor.starMap.addChild( homeStar );
			
			if( nopLoader.data.quest == 'true' ) {
				questStar.x=nopLoader.data.qsx;
				questStar.y=nopLoader.data.qsy;
				monitor.starMap.addChild( questStar );
			}

			monitor.starMap.addEventListener( MouseEvent.MOUSE_DOWN, starStartScroll );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_UP, starStopScroll );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_OVER, showDesc );
			monitor.starMap.addEventListener( MouseEvent.MOUSE_OUT, hideDesc );
		}

		public function starStartScroll( e:MouseEvent ) {
			hideDesc( e );
			oldX = int( monitor.starMap.x );
			oldY = int( monitor.starMap.y );
			monitor.starMap.startDrag( false );
		}

		public function starStopScroll( e:MouseEvent ) {
			if ( oldX == int( monitor.starMap.x ) && oldY == int( monitor.starMap.y ) ) {
				place_x=monitor.starMap.mouseX;
				place_y=monitor.starMap.mouseY;
				nopLoader.addEventListener( Event.COMPLETE, nopStarMove );
				nopLoader.load(new URLRequest( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));
				//nopLoader.load(new URLRequest( "d:\page372.txt" ));
				//trace( "page.php?id=372&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y );
			}
			monitor.starMap.stopDrag();
			showDesc( e );
		}

		public function nopStarMove( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopStarMove );

			if (nopLoader.data.err==0) {
				var rx:int=int(nopLoader.data.rx);
				var ry:int=int(nopLoader.data.ry);
				var iAdd:uint;

				place_x=rx;
				place_y=ry;
				switch ( int( nopLoader.data.t ) ) {
					case 1 :
						btnOrder.visible=true;
						iAdd=4;
						break;
					case 2 :
						btnOrder.visible=true;
						iAdd=0;
						break;
					case 3 :
						btnOrder.visible=false;
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
			lin.stop();
			nopLoader.removeEventListener( Event.COMPLETE, nopPlanetLoaded );
			monitor.dtSystemName.htmlText="Система : "+nopLoader.data.sname;
			monitor.dtDesc.htmlText="В системе обнаружено "+nopLoader.data.fcnt+" не планетарных объектов";
			
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
			monitor.planetMap.addChild( st_circ );

			fn_circ.x=lin.x;
			fn_circ.y=lin.y;
			monitor.planetMap.addChild( fn_circ );

			lin.width=0;
			lin.height=0;
			monitor.planetMap.addChild( lin );

			for (i=0; i<nopLoader.data.cnt; i++) {
				var orb:MovieClip = new orbit();
				orb.x=340;
				orb.y=220;
				radx=int(nopLoader.data["or"+i])*2;
				rady=int(nopLoader.data["or"+i])*1.5;
				orb.width=radx;
				orb.height=rady;
				monitor.planetMap.addChild( orb );

				ClassReference=getDefinitionByName("p"+nopLoader.data["ty"+i]) as Class;
				var planet:MovieClip = new ClassReference();
				planet.x=340+Math.sin(nopLoader.data["an"+i]*3.14/180)*radx/2;
				planet.y=220+Math.cos(nopLoader.data["an"+i]*3.14/180)*rady/2;
				monitor.planetMap.addChild( planet );
			}

			for (i=0; i<nopLoader.data.fcnt; i++) {
				var ship:MovieClip;
				if (nopLoader.data["ct"+i]==1) {
					ship = new ss();
					ship.x=nopLoader.data["sx"+i];
					ship.y=nopLoader.data["sy"+i];
					monitor.planetMap.addChild( ship );
				}
				if (nopLoader.data["ct"+i]==2) {
					ship = new sf();
					ship.x=nopLoader.data["sx"+i];
					ship.y=nopLoader.data["sy"+i];
					monitor.planetMap.addChild( ship );
				}
			}
			monitor.addEventListener( MouseEvent.MOUSE_UP, planetClick );
		}

		public function planetClick( e:MouseEvent ) {
			place_x=monitor.planetMap.mouseX;
			place_y=monitor.planetMap.mouseY;
			nopLoader.addEventListener( Event.COMPLETE, nopPlanetMove );
			nopLoader.load(new URLRequest( "page.php?id=38&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y ));
			//nopLoader.load(new URLRequest( "d:\page38.txt" ));
			//trace( "page.php?id=38&shid="+sLoader.data["id"+dgShips.selectedIndex]+"&mx="+place_x+"&my="+place_y );
		}

		public function nopPlanetMove( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopPlanetMove );

			if (nopLoader.data.err==0) {
				var rx:int=int(nopLoader.data.rx);
				var ry:int=int(nopLoader.data.ry);
				var iAdd:uint;

				place_x=rx;
				place_y=ry;
				switch ( int( nopLoader.data.t ) ) {
					case 1 :
						btnOrder.visible=true;
						iAdd=4;
						break;
					case 2 :
						btnOrder.visible=true;
						iAdd=0;
						break;
					case 3 :
						btnOrder.visible=false;
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
package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextFormat;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class station3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var chanel:SoundChannel;
		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();
		
		private var iSelObject:uint = 0;
		private var iItemFilter:uint = 0;

		private var sLoader:URLLoader = new URLLoader();
		private var sDp:DataProvider = new DataProvider();

		private var iLoader:URLLoader = new URLLoader();
		private var iDp:DataProvider = new DataProvider();

		private var oLoader:URLLoader = new URLLoader();

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function station3() {
			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			nopLoader.addEventListener(Event.COMPLETE, nopRefresh);

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

			cbFilterLeft.textField.setStyle( "textFormat", myHeadFormat );
			cbFilterLeft.dropdown.setRendererStyle( "textFormat", myFormat );
			cbFilterLeft.selectedIndex=1;
			cbFilterLeft.addEventListener( Event.CHANGE, cbFilterLeftChange );

			elBay.visible = false;
			elSell.visible = false;

			dgStation.setRendererStyle( "textFormat", myFormat );
			dgStation.setStyle( "headerTextFormat", myHeadFormat );
			dgStation.addColumn( "Наименование" );
			dgStation.addColumn( "Покуп." );
			dgStation.addColumn( "кол. " );
			dgStation.addColumn( "Прод." );
			dgStation.addColumn( "кол." );
			dgStation.addColumn( "мин." );
			dgStation.addColumn( "сред." );
			dgStation.addColumn( "макс." );
			dgStation.columns[0].width=180;
			dgStation.columns[2].width=90;
			dgStation.columns[4].width=90;
			dgStation.dataProvider=sDp;
			dgStation.setStyle("cellRenderer",AlternatingRowColors);
			dgStation.addEventListener( Event.CHANGE, sChange );

			sLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, loadLots);
//			sLoader.load(new URLRequest("d:\page23.txt"));
			sLoader.load(new URLRequest("page.php?id=23"));

			cbFilter.textField.setStyle( "textFormat", myHeadFormat );
			cbFilter.dropdown.setRendererStyle( "textFormat", myFormat );
			cbFilter.selectedIndex=1;
			cbFilter.addEventListener( Event.CHANGE, cbFilterChange );

			cbItems.selectedIndex=1;
			cbItems.dataProvider = iDp;
			cbItems.rowCount = 18;
			cbItems.addEventListener( Event.CHANGE, cbItemChange );

			iLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, loadItems);
//			iLoader.load(new URLRequest("d:\page233.txt"));
			iLoader.load(new URLRequest("page.php?id=233"));

			oLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			oLoader.addEventListener(Event.COMPLETE, objectLoaded);

			elBay.dtPrice.addEventListener( Event.CHANGE, bayChange );
			elBay.dtPrice.restrict = "0-9.";
			elBay.dtCount.addEventListener( Event.CHANGE, bayChange );
			elBay.dtCount.restrict = "0-9";
			elSell.dtPrice.addEventListener( Event.CHANGE, sellChange );
			elSell.dtPrice.restrict = "0-9.";
			elSell.dtCount.addEventListener( Event.CHANGE, sellChange );
			elSell.dtCount.restrict = "0-9";
			
			btnSave.addEventListener( MouseEvent.CLICK, btnSaveClick );
			btnSave.visible = false;
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
				hLoader.load( new URLRequest( "page.php?id=8&asc=station_"+hintName ) );
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

		private function cbFilterChange(event:Event) {
//			sLoader.load(new URLRequest("d:\page23.txt"));
			cbFilterLeft.selectedIndex = cbFilter.selectedIndex;
			iItemFilter = cbFilterLeft.selectedItem.data;
			iSelObject = 0;
			sLoader.load(new URLRequest("page.php?id=23&rf="+cbFilter.selectedItem.data));
			iLoader.load(new URLRequest("page.php?id=233&rf="+iItemFilter));
		}

		private function loadLots(event:Event) {
			var i:uint;

			sDp.removeAll();
			if ( int( sLoader.data.rows ) > 0 ) {
				for (i=0; i<sLoader.data.rows; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=sLoader.data["l"+i+"c1"];
					dgFill["Покуп."]=sLoader.data["l"+i+"c3"];
					dgFill["кол. "]=sLoader.data["l"+i+"c2"];
					dgFill["Прод."]=sLoader.data["l"+i+"c5"];
					dgFill["кол."]=sLoader.data["l"+i+"c4"];
					dgFill["мин."]=sLoader.data["l"+i+"c6"];
					dgFill["сред."]=sLoader.data["l"+i+"c7"];
					dgFill["макс."]=sLoader.data["l"+i+"c8"];

					if (sLoader.data["l"+i+"c9"]) {
						dgFill["bgColor"]=sLoader.data["l"+i+"c9"];
					}
					sDp.addItem(dgFill);
					if( iSelObject > 0 && iSelObject == sLoader.data["l"+i+"c0"] ) {
						dgStation.selectedIndex = dgStation.length - 1;
					}
				}
				sChange(event);
			}
		}

		private function cbFilterLeftChange(event:Event) {
//			iLoader.load(new URLRequest("d:\page233.txt"));
			cbFilter.selectedIndex = cbFilterLeft.selectedIndex;
			iItemFilter = cbFilterLeft.selectedItem.data;
			iSelObject = 0;
			sLoader.load(new URLRequest("page.php?id=23&rf="+cbFilter.selectedItem.data));
			iLoader.load(new URLRequest("page.php?id=233&rf="+iItemFilter));
		}

		private function loadItems(event:Event) {
			var i:uint;
			iDp.removeAll();

			if ( iLoader.data.err == 0 && int( iLoader.data.cnt ) > 0 ) {
				for (i=0; i<iLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["data"]=iLoader.data["id"+i];
					dgFill["label"]=iLoader.data["name"+i];
					if (iLoader.data["c"+i]) {
						dgFill["bgColor"]=iLoader.data["c"+i];
					}
					iDp.addItem(dgFill);
					if (iSelObject > 0 && iSelObject == iLoader.data["id"+i]) {
						var snd:Sound = new beep();
						chanel = snd.play();
						chanel.soundTransform = stVolume;
						cbItems.selectedIndex = cbItems.length - 1;
					}
				}
				cbItems.textField.setStyle( "textFormat", myHeadFormat );
				cbItems.dropdown.setRendererStyle( "textFormat", myFormat );
				if( iSelObject == 0 ) {
					cbItems.selectedIndex=0;
				}
				cbItemChange( event );
			}
		}

		private function cbItemChange(event:Event) {
			var i:int;
			var snd:Sound = new beep();

			chanel = snd.play();
			chanel.soundTransform = stVolume;
			elBay.visible = false;
			elSell.visible = false;

			dgStation.selectedIndex = -1;
			for( i=0; i<sLoader.data.rows; i++ ) {
				if( sLoader.data["l"+i+"c0"] == cbItems.selectedItem.data ) {
					iSelObject = cbItems.selectedItem.data;
					dgStation.selectedIndex = i;
				}
			}
			dgStation.scrollToIndex( dgStation.selectedIndex );

//			oLoader.load(new URLRequest("d:\page231.txt"));
			oLoader.load(new URLRequest("page.php?id=231&oid="+cbItems.selectedItem.data));
		}

		private function objectLoaded(event:Event) {
			if( oLoader.data.err == 0 ) {
				dtSumm.text = oLoader.data.money;
				if( oLoader.data.maxcnt != undefined ) {
					dtCount.text = oLoader.data.maxcnt;
				} else {
					dtCount.text = '0';
				}
				if( oLoader.data.canbay == 1 ) {
					elBay.visible = true;
					elBay.dtMin.text = oLoader.data.i_min;
					elBay.dtAvg.text = oLoader.data.i_avg;
					elBay.dtMax.text = oLoader.data.i_max;
					elBay.dtCount.text = oLoader.data.i_cnt;
					elBay.dtPrice.text = oLoader.data.i_price;
					bayChange(event);
				} else {
					elBay.visible = false;
				}
				if( oLoader.data.cansell == 1 ) {
					elSell.visible = true;
					elSell.dtMin.text = oLoader.data.o_min;
					elSell.dtAvg.text = oLoader.data.o_avg;
					elSell.dtMax.text = oLoader.data.o_max;
					elSell.dtCount.text = oLoader.data.o_cnt;
					elSell.dtPrice.text = oLoader.data.o_price;
					sellChange(event);
				} else {
					elSell.visible = false;
				}
			}
		}

		private function bayChange(event:Event) {
			var outGlow:GlowFilter=new GlowFilter(0x0000FF,0.5,5,5,2,1,false,false);
			var cntGlow:GlowFilter=new GlowFilter(0x00FFFF,0.4,10,10,2,3,true,false);
			var errGlow:GlowFilter=new GlowFilter(0xFF0000,0.4,10,10,2,3,true,false);

			if( elBay.dtCount.text != Math.round( Number( elBay.dtCount.text ) ) ) {
				elBay.bgCount.filters=[errGlow,outGlow];
			} else {
				elBay.bgCount.filters=[cntGlow,outGlow];
			}

			if( elBay.dtPrice.text != Number( elBay.dtPrice.text ) ) {
				elBay.bgPrice.filters=[errGlow,outGlow];
			} else {
				elBay.bgPrice.filters=[cntGlow,outGlow];
			}

			if( elBay.dtCount.text == Math.round( Number( elBay.dtCount.text ) ) &&
				elBay.dtPrice.text == Number( elBay.dtPrice.text ) ) {
				btnSave.visible = true;
				elBay.dtSumm.text = Math.round( elBay.dtCount.text * elBay.dtPrice.text * 100 ) / 100;
				if( Number( elBay.dtSumm.text ) > Number( dtSumm.text ) ) {
					btnSave.visible = false;
					elBay.bgCount.filters=[errGlow,outGlow];
					elBay.bgPrice.filters=[errGlow,outGlow];
				}
			} else {
				btnSave.visible = false;
				elBay.dtSumm.text = "";
			}
		}

		private function sellChange(event:Event) {
			var outGlow:GlowFilter=new GlowFilter(0x0000FF,0.5,5,5,2,1,false,false);
			var cntGlow:GlowFilter=new GlowFilter(0x00FFFF,0.4,10,10,2,3,true,false);
			var errGlow:GlowFilter=new GlowFilter(0xFF0000,0.4,10,10,2,3,true,false);

			if( elSell.dtCount.text != Math.round( Number( elSell.dtCount.text ) ) ||
				Number( elSell.dtCount.text ) > Number( dtCount.text ) ) {
				elSell.bgCount.filters=[errGlow,outGlow];
			} else {
				elSell.bgCount.filters=[cntGlow,outGlow];
			}

			if( elSell.dtPrice.text != Number( elSell.dtPrice.text ) ) {
				elSell.bgPrice.filters=[errGlow,outGlow];
			} else {
				elSell.bgPrice.filters=[cntGlow,outGlow];
			}

			if( elSell.dtCount.text == Math.round( Number( elSell.dtCount.text ) ) &&
				elSell.dtPrice.text == Number( elSell.dtPrice.text ) &&
				Number( elSell.dtCount.text ) <= Number( dtCount.text ) ) {
				btnSave.visible = true;
				elSell.dtSumm.text = Math.round( elSell.dtCount.text * elSell.dtPrice.text * 100 ) / 100;
			} else {
				btnSave.visible = false;
				elSell.dtSumm.text = "";
			}
		}

		private function sChange(event:Event) {
			var i:uint;
			iSelObject = sLoader.data["l"+dgStation.selectedIndex+"c0"];
			if( iItemFilter != 0 ) {
//				cbFilterLeft.selectedIndex = 0;
//				iLoader.load(new URLRequest("d:\page233.txt"));
//				iLoader.load(new URLRequest("page.php?id=233&rf=0"));
				iLoader.load(new URLRequest("page.php?id=233&rf="+iItemFilter));
			} else {
				for(i=0; i<cbItems.length; i++) {
					if (iSelObject == cbItems.getItemAt( i ).data) {
						cbItems.selectedIndex = i;
					}
				}
//				oLoader.load(new URLRequest("d:\page231.txt"));
				oLoader.load(new URLRequest("page.php?id=231&oid="+iSelObject));
			}

		}

		public function btnSaveClick(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			var btnUrl:String = "page.php?id=232&oid=" + cbItems.selectedItem.data + 
"&iprice="+elBay.dtPrice.text + "&icnt="+elBay.dtCount.text + 
"&oprice="+elSell.dtPrice.text + "&ocnt=" + elSell.dtCount.text;
			nopLoader.load(new URLRequest( btnUrl ));
		}
		
		private function nopRefresh(event:Event) {
//			sLoader.load(new URLRequest("d:\page23.txt"));
			sLoader.load(new URLRequest("page.php?id=23&rf="+cbFilter.selectedItem.data));
		}
	}
}
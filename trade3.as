package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextFormat;
	import fl.controls.DataGrid;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;

	public class trade3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var selfNick:String = root.loaderInfo.parameters.sn;
		private var selfUid:String = root.loaderInfo.parameters.uid;
		private var chanel:SoundChannel;
		private var cTween:Tween;
		private var sTween:Tween;
		private var bTween:Tween;
		private var oTween:Tween;
		private var pTween:Tween;

		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();

		private var myMonoFormat:TextFormat = new TextFormat();
		private var myMonoHeadFormat:TextFormat = new TextFormat();

		private var cLoader:URLLoader = new URLLoader();
		private var cDp:DataProvider = new DataProvider();

		private var oLoader:URLLoader = new URLLoader();
		private var oDp:DataProvider = new DataProvider();
		private var oDescLoader:URLLoader = new URLLoader();

		private var bsLoader:URLLoader = new URLLoader();
		private var bsDp:DataProvider = new DataProvider();

		private var bwLoader:URLLoader = new URLLoader();
		private var bwDp:DataProvider = new DataProvider();

		private var ssLoader:URLLoader = new URLLoader();
		private var ssDp:DataProvider = new DataProvider();

		private var swLoader:URLLoader = new URLLoader();
		private var swDp:DataProvider = new DataProvider();

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();
		
		private var sSell:String;
		private var sBay:String;

		public function trade3() {
			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			hinter.visible = false;
			hinter.mvTimer.visible = false;
			hinter.startDrag( true );

			payCalc.visible = false;
			payCalc.dtSumm.text = '';
			payCalc.dtSumm.addEventListener( Event.CHANGE, showBtnPay );
			payCalc.btnCalc.visible=false;
			payCalc.dtInCach.visible=false;
			payCalc.cbPrices.visible=false;
			payCalc.btnPay.visible=false;
			payCalc.btnWay.visible=false;
			payCalc.btnNoPay.addEventListener( MouseEvent.CLICK, hidePay );
			payCalc.btnPay.addEventListener( MouseEvent.CLICK, payInterkassa );
//			payCalc.btnWay.addEventListener( MouseEvent.CLICK, payWay2pay );
			payCalc.dtNick.addEventListener(Event.CHANGE, checkNick);

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

			myMonoFormat.color=0xFFFFFF;
			myMonoFormat.font="Lucida Console, DejaVu Sans Mono, monospace";
			myMonoFormat.size=12;

			myMonoHeadFormat.color=0xBFBFFF;
			myMonoHeadFormat.font="Lucida Console, DejaVu Sans Mono, monospace";
			myMonoHeadFormat.size=12;
			myMonoHeadFormat.bold=true;

			comp.btnCompUp.addEventListener(MouseEvent.CLICK, PageCompUp);
			comp.btnSell.addEventListener(MouseEvent.CLICK, cmpSell);
			comp.btnBay.addEventListener(MouseEvent.CLICK, cmpBay);
			comp.cbFilter.textField.setStyle( "textFormat", myHeadFormat );
			comp.cbFilter.dropdown.setRendererStyle( "textFormat", myFormat );
			comp.cbFilter.selectedIndex=0;
			comp.cbFilter.addEventListener( Event.CHANGE, cbFilterChange );
			comp.dtCount.addEventListener( Event.CHANGE, cbFilterChange );
			comp.dgList.setRendererStyle( "textFormat", myFormat );
			comp.dgList.setStyle( "headerTextFormat", myHeadFormat );
			comp.dgList.addColumn( "Наименование" );
			comp.dgList.addColumn( "Цена прод." );
			comp.dgList.addColumn( "Кол.прод." );
			comp.dgList.addColumn( "Звезда прод." );
			comp.dgList.addColumn( "Цена пок." );
			comp.dgList.addColumn( "Кол.пок." );
			comp.dgList.addColumn( "Звезда пок." );
			comp.dgList.columns[0].width=240;
			comp.dgList.columns[1].width=70;
			comp.dgList.columns[2].width=70;
			comp.dgList.columns[3].width=130;
			comp.dgList.columns[4].width=70;
			comp.dgList.columns[5].width=70;
			comp.dgList.columns[6].width=130;
			comp.dgList.dataProvider=cDp;
			comp.dgList.addEventListener( Event.CHANGE, cmpChange );
			comp.dgList.setStyle("cellRenderer",AlternatingRowColors);
			comp.btnSell.visible = false;
			comp.btnBay.visible = false;
			cLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			cLoader.addEventListener(Event.COMPLETE, loadComp);
//			cLoader.load(new URLRequest("d:\page63.txt"));
//			cLoader.load(new URLRequest("page.php?id=63"));
			cLoader.load(new URLRequest("page.php?id=63&min=1&rf=0"));

			bay.btnBayUp.addEventListener(MouseEvent.CLICK, PageBayUp);
			bay.dtShips.setRendererStyle( "textFormat", myFormat );
			bay.dtShips.setStyle( "headerTextFormat", myHeadFormat );
			bay.dtShips.addEventListener( Event.CHANGE, bsChange );
			bay.dtShips.addColumn( "Наименование" );
			bay.dtShips.addColumn( "Расположение" );
			bay.dtShips.addColumn( "Объем" );
			bay.dtShips.columns[0].width=130;
			bay.dtShips.columns[1].width=200;
			bay.dtShips.columns[2].width=70;
			bay.dtShips.dataProvider=bsDp;
			bay.dtShips.setStyle("cellRenderer",AlternatingRowColors);
			bay.dtWare.setRendererStyle( "textFormat", myFormat );
			bay.dtWare.setStyle( "headerTextFormat", myHeadFormat );
			bay.dtWare.addEventListener( Event.CHANGE, bwChange );
			bay.dtWare.addColumn( "Наименование" );
			bay.dtWare.addColumn( "На корабле" );
			bay.dtWare.addColumn( "В наличии" );
			bay.dtWare.addColumn( "Цена прод." );
			bay.dtWare.dataProvider=bwDp;
			bay.dtWare.setStyle("cellRenderer",AlternatingRowColors);
			bay.dtCount.addEventListener( Event.CHANGE, countBayChange );
			bay.btnBay.visible=false;
			bay.btnBayAll.visible=false;
			bay.btnBay.addEventListener(MouseEvent.CLICK, fnBay);
			bay.btnBayAll.addEventListener(MouseEvent.CLICK, fnBayAll);

			bwLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			bwLoader.addEventListener(Event.COMPLETE, loadBayWare);
			bsLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			bsLoader.addEventListener(Event.COMPLETE, loadBayShips);
//			bsLoader.load(new URLRequest("d:\page55.txt"));
			bsLoader.load(new URLRequest("page.php?id=55"));

			sell.btnSellUp.addEventListener(MouseEvent.CLICK, PageSellUp);
			sell.dtShips.setRendererStyle( "textFormat", myFormat );
			sell.dtShips.setStyle( "headerTextFormat", myHeadFormat );
			sell.dtShips.addEventListener( Event.CHANGE, ssChange );
			sell.dtShips.addColumn( "Наименование" );
			sell.dtShips.addColumn( "Расположение" );
			sell.dtShips.addColumn( "Объем" );
			sell.dtShips.columns[0].width=130;
			sell.dtShips.columns[1].width=200;
			sell.dtShips.columns[2].width=70;
			sell.dtShips.dataProvider=ssDp;
			sell.dtShips.setStyle("cellRenderer",AlternatingRowColors);
			sell.dtWare.setRendererStyle( "textFormat", myFormat );
			sell.dtWare.setStyle( "headerTextFormat", myHeadFormat );
			sell.dtWare.addEventListener( Event.CHANGE, swChange );
			sell.dtWare.addColumn( "Наименование" );
			sell.dtWare.addColumn( "На корабле" );
			sell.dtWare.addColumn( "Требуется" );
			sell.dtWare.addColumn( "Цена пок." );
			sell.dtWare.dataProvider=swDp;
			sell.dtWare.setStyle("cellRenderer",AlternatingRowColors);
			sell.dtCount.addEventListener( Event.CHANGE, countSellChange );
			sell.btnSell.visible=false;
			sell.btnSellAll.visible=false;
			sell.btnSell.addEventListener(MouseEvent.CLICK, fnSell);
			sell.btnSellAll.addEventListener(MouseEvent.CLICK, fnSellAll);

			swLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			swLoader.addEventListener(Event.COMPLETE, loadSellWare);
			ssLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			ssLoader.addEventListener(Event.COMPLETE, loadSellShips);
//			ssLoader.load(new URLRequest("d:\page56.txt"));
			ssLoader.load(new URLRequest("page.php?id=56"));

			conf.btnConfUp.addEventListener(MouseEvent.CLICK, PageConfUp);
			conf.dgList.setRendererStyle( "textFormat", myFormat );
			conf.dgList.setStyle( "headerTextFormat", myHeadFormat );
			conf.dgList.addColumn( "Наименование" );
			conf.dgList.dataProvider=oDp;
			conf.dgList.setStyle("cellRenderer",AlternatingRowColors);
			conf.bgBayCredit.gotoAndStop( 1 );
			conf.bgBayConf.gotoAndStop( 1 );
			conf.btnBayCredit.visible = false;
			conf.btnBayConf.visible = false;
			conf.dtConfCount.addEventListener(Event.CHANGE, confCountChange);
			conf.btnBayCredit.addEventListener(MouseEvent.CLICK, bayCreditClick);
			conf.btnBayConf.addEventListener(MouseEvent.CLICK, bayConfClick);
			oLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			oLoader.addEventListener(Event.COMPLETE, loadConf);
//			oLoader.load(new URLRequest("d:\page65.txt"));
			oLoader.load(new URLRequest("page.php?id=65"));
			conf.dgList.addEventListener( Event.CHANGE, oChange );
			oDescLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			oDescLoader.addEventListener(Event.COMPLETE, loadConfDesc);

			nopLoader.addEventListener(Event.COMPLETE, nopRefresh);
		}

		private function cbFilterChange(event:Event) {
//			cLoader.load(new URLRequest("d:\page63.txt"));
			cLoader.load(new URLRequest("page.php?id=63&min="+comp.dtCount.text+"&rf="+comp.cbFilter.selectedItem.data));
			comp.btnSell.visible = false;
			comp.btnBay.visible = false;
		}

		public function showPay( e:MouseEvent ) {
			payCalc.visible = true;
			payCalc.dtSumm.text = '';
			payCalc.dtNick.text = selfNick;
			payCalc.dtInCach.visible=false;
			payCalc.cbPrices.visible = false;
			payCalc.btnPay.visible = false;
			payCalc.btnWay.visible = false;
			pTween = new Tween(payCalc, "alpha", Strong.easeOut, payCalc.alpha, 1, 1, true);
		}

		public function hidePay( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			pTween = new Tween(payCalc, "alpha", Strong.easeOut, payCalc.alpha, 0, 1, true);
			pTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function pUnvisible( event:Event ) {
			payCalc.visible = false;
		}

		public function summChange(event:Event) {
			if( payCalc.dtSumm.text != '' && int( payCalc.dtSumm.text ) == payCalc.dtSumm.text ) {
				payCalc.btnCalc.visible = true;
			} else {
				payCalc.btnCalc.visible = false;
			}
		}

		public function showBtnPay(event:Event) {
			if( payCalc.dtSumm.text != '' && int( payCalc.dtSumm.text ) == payCalc.dtSumm.text ) {
				payCalc.btnPay.visible = true;
//				payCalc.btnWay.visible = true;
			} else {
				payCalc.btnPay.visible = false;
				payCalc.btnWay.visible = false;
			}
		}

		public function checkNick( event:Event ) {
			nopLoader.addEventListener(Event.COMPLETE, checkedNick);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=128&user="+payCalc.dtNick.text ));
		}

		public function checkedNick( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, checkedNick );
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			if( nopLoader.data.err != 0 ) {
				inGlow.color = 0xFF0000;
			} else {
				selfNick = payCalc.dtNick.text;
				selfUid = nopLoader.data.uid;
			}

			payCalc.bgTo.filters = [inGlow, outGlow];
		}

		private function payInterkassa( e:MouseEvent ) {
			var req:URLRequest = new URLRequest( 'https://21noon.com/page.php?id=83693' );
			var uVar:URLVariables = new URLVariables();
			var e:MouseEvent;
			req.method = URLRequestMethod.POST;

			uVar.ik_desc = "Покупка "+payCalc.dtSumm.text+" конфедерат для "+selfNick;
			uVar.ik_am = payCalc.dtSumm.text;
			uVar.ik_x_uid = selfUid;
			uVar.ik_x_sum = payCalc.dtSumm.text;
            req.data = uVar;
			navigateToURL( req, "_blank" );
			hidePay( e );
		}

		private function payWay2pay( e:MouseEvent ) {
			var req:URLRequest = new URLRequest( 'https://21noon.com/w2p_out.php' );
			var uVar:URLVariables = new URLVariables();
			var e:MouseEvent;
			req.method = URLRequestMethod.POST;
			
			uVar.uid = selfUid;
			uVar.summ = payCalc.dtSumm.text;
            req.data = uVar;
			navigateToURL( req, "_blank" );
			hidePay( e );
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
				hLoader.load( new URLRequest( "page.php?id=8&asc=trade_"+hintName ) );
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

		private function loadComp(event:Event) {
			var i:uint;
			var iSel:int = -1;
			if( comp.dgList.selectedIndex ) {
				iSel = comp.dgList.selectedIndex;
			}
			if (cLoader.data.cnt>0) {
				cDp.removeAll();
				for (i=0; i<cLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=cLoader.data["n"+i];
					dgFill["Цена прод."]=cLoader.data["bm"+i];
					dgFill["Кол.прод."]=cLoader.data["bc"+i];
					dgFill["Звезда прод."]=cLoader.data["bs"+i];
					dgFill["Цена пок."]=cLoader.data["sm"+i];
					dgFill["Кол.пок."]=cLoader.data["sc"+i];
					dgFill["Звезда пок."]=cLoader.data["ss"+i];
					dgFill["bgColor"]=cLoader.data["c"+i];
					cDp.addItem(dgFill);
				}
				if( iSel > -1 ) {
					comp.dgList.selectedIndex = iSel;
				}
			}
		}

		private function cmpSell( e:MouseEvent ) {
			navigateToURL( new URLRequest("page.php?id=18&login="+sSell), "main" );
		}

		private function cmpBay( e:MouseEvent ) {
			navigateToURL( new URLRequest("page.php?id=18&login="+sBay), "main" );
		}

		private function cmpChange(event:Event) {
			cLoader.load(new URLRequest("page.php?id=63&oid="+cLoader.data["id"+comp.dgList.selectedIndex]+"&rf="+comp.cbFilter.selectedItem.data));
/*
			if( comp.cbFilter.selectedIndex > 0 ) {
			} else {
				cLoader.load(new URLRequest("page.php?id=63&oid="+cLoader.data["id"+comp.dgList.selectedIndex]));
			}
*/
			if( cLoader.data["bl"+comp.dgList.selectedIndex] != '' ) {
				sSell = cLoader.data["bl"+comp.dgList.selectedIndex];
				comp.btnSell.visible = true;
			} else {
				comp.btnSell.visible = false;
			}
			if( cLoader.data["sl"+comp.dgList.selectedIndex] != '' ) {
				sBay = cLoader.data["sl"+comp.dgList.selectedIndex];
				comp.btnBay.visible = true;
			} else {
				comp.btnBay.visible = false;
			}
		}

		private function loadBayShips(event:Event) {
			var i:uint;
			var iPos:int;

			iPos = bay.dtShips.selectedIndex;
			bsDp.removeAll();
			if (bsLoader.data.cnt>0) {
				for (i=0; i<bsLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"] = bsLoader.data["name"+i];
					dgFill["Расположение"] = bsLoader.data["place"+i];
					dgFill["Объем"] = bsLoader.data["cargo"+i];
					bsDp.addItem(dgFill);
				}
				bay.dtShips.selectedIndex = iPos;
				if( bay.dtShips.selectedIndex >= 0 ) {
					bwLoader.load(new URLRequest("page.php?id=57&shid="+bsLoader.data["id"+bay.dtShips.selectedIndex]));
				}
			}
		}

		private function bsChange(event:Event) {
//			bwLoader.load(new URLRequest("d:\page57.txt"));
			bwLoader.load(new URLRequest("page.php?id=57&shid="+bsLoader.data["id"+bay.dtShips.selectedIndex]));
			bay.btnBay.visible=false;
			bay.btnBayAll.visible=false;
			bay.dtMoney.text = "";
			bay.dtCount.text = "";
			bay.dtTitle.text = "";
			bay.dtSumm.text = "";
		}

		private function loadSellShips(event:Event) {
			var i:uint;
			var iPos:int;

			iPos = sell.dtShips.selectedIndex;
			ssDp.removeAll();
			if (ssLoader.data.cnt>0) {
				for (i=0; i<ssLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"] = ssLoader.data["name"+i];
					dgFill["Расположение"] = ssLoader.data["place"+i];
					dgFill["Объем"] = ssLoader.data["cargo"+i];
					ssDp.addItem(dgFill);
				}
				sell.dtShips.selectedIndex = iPos;
				if( sell.dtShips.selectedIndex >= 0 ) {
					swLoader.load(new URLRequest("page.php?id=58&shid="+ssLoader.data["id"+sell.dtShips.selectedIndex]));
				}
			}
		}

		private function ssChange(event:Event) {
//			swLoader.load(new URLRequest("d:\page58.txt"));
			swLoader.load(new URLRequest("page.php?id=58&shid="+ssLoader.data["id"+sell.dtShips.selectedIndex]));
			sell.btnSell.visible=false;
			sell.btnSellAll.visible=false;
			sell.dtMoney.text = "";
			sell.dtCount.text = "";
			sell.dtTitle.text = "";
			sell.dtSumm.text = "";
		}

		private function loadBayWare(event:Event) {
			var i:uint;
			var iSelected:uint = 0;

			if( bay.dtWare.selectedIndex ) {
				iSelected=bay.dtWare.selectedIndex;
			}
			if( !isNaN( Number( bwLoader.data.money ) ) ) {
				bay.dtMoney.text = bwLoader.data.money;
			}

			bwDp.removeAll();
			if (bwLoader.data.cnt>0) {
				if( bwLoader.data.err == 0 ) {
					for (i=0; i<bwLoader.data.cnt; i++) {
						var dgFill = new Array();
						dgFill["Наименование"] = bwLoader.data["n"+i];
						dgFill["На корабле"] = bwLoader.data["sc"+i];
						dgFill["В наличии"] = bwLoader.data["oc"+i];
						dgFill["Цена прод."] = bwLoader.data["op"+i];
						dgFill["bgColor"] = bwLoader.data["t"+i];
						bwDp.addItem(dgFill);
					}
				}
				bay.dtWare.selectedIndex = iSelected;
				bwChange( event );
			}
		}

		private function bwChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			bay.btnBay.visible=false;
			if( bwLoader.data["oc"+bay.dtWare.selectedIndex] >= 1 ) {
				bay.btnBayAll.visible=true;
			} else {
				bay.btnBayAll.visible=false;
			}

			bay.dtCount.text = 0;
			bay.dtTitle.text = bwLoader.data["n"+bay.dtWare.selectedIndex];
			countBayChange( event );
		}

		private function countBayChange(event:Event) {
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var cntGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);
			var bayGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);
			var titleGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			if( int( bwLoader.data["oc"+bay.dtWare.selectedIndex] ) > 0 ) {
				bay.btnBay.visible = true;
			}

			if( Number( bay.dtCount.text ) != bay.dtCount.text || bay.dtCount.text == "" || bay.dtCount.text == "0" ) {
				bay.btnBay.visible = false;
				cntGlow.color = 0xFF0000;
			}

			if( int( bay.dtCount.text ) > bwLoader.data["oc"+bay.dtWare.selectedIndex] ) {
				bay.dtSumm.text = Number( bwLoader.data["op"+bay.dtWare.selectedIndex] ) * int( bwLoader.data["oc"+bay.dtWare.selectedIndex] );
				bay.btnBay.visible = false;
				bayGlow.color = 0x00FF00;
			} else {
				bay.dtSumm.text = Number( bwLoader.data["op"+bay.dtWare.selectedIndex] ) * int( bay.dtCount.text );
			}

			if( Number( bay.dtSumm.text ) > Number( bwLoader.data.money ) ) {
				bay.btnBay.visible = false;
				bayGlow.color = 0xFF0000;
			}

			bay.bgCount.filters = [cntGlow, outGlow];
			bay.bgBay.filters = [bayGlow, outGlow];
			bay.bgTitle.filters = [titleGlow, outGlow];
		}

		private function loadSellWare(event:Event) {
			var i:uint;
			var iSelected:uint = 0;

			if( sell.dtWare.selectedIndex ) {
				iSelected=sell.dtWare.selectedIndex;
			}
			if( !isNaN( ( swLoader.data.money ) ) ) {
				sell.dtMoney.text = swLoader.data.money;
			}

			swDp.removeAll();
			if (swLoader.data.cnt>0) {
				if( swLoader.data.err == 0 ) {
					for (i=0; i<swLoader.data.cnt; i++) {
						var dgFill = new Array();
						dgFill["Наименование"] = swLoader.data["n"+i];
						dgFill["На корабле"] = swLoader.data["sc"+i];
						dgFill["Требуется"] = swLoader.data["ic"+i];
						dgFill["Цена пок."] = swLoader.data["ip"+i];
						dgFill["bgColor"] = swLoader.data["t"+i];
						swDp.addItem(dgFill);
					}
				}
				sell.dtWare.selectedIndex = iSelected;
				swChange( event );
			}
		}

		private function swChange(event:Event) {
			var snd:Sound = new beep();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			sell.btnSell.visible=false;
			if( swLoader.data["sc"+sell.dtWare.selectedIndex] >= 1 ) {
				sell.btnSellAll.visible=true;
			} else {
				sell.btnSellAll.visible=false;
			}

			sell.dtCount.text = 0;
			sell.dtTitle.text = swLoader.data["n"+sell.dtWare.selectedIndex];
			countSellChange( event );
		}

		private function countSellChange(event:Event) {
			var iMin:int;
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var cntGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);
			var sellGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);
			var titleGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			if( int( swLoader.data["ic"+sell.dtWare.selectedIndex] ) > 0 &&
				int( swLoader.data["sc"+sell.dtWare.selectedIndex] ) > 0 ) {
				sell.btnSell.visible = true;
			}

			if( int( sell.dtCount.text ) != sell.dtCount.text || sell.dtCount.text == "" || sell.dtCount.text == "0" ) {
				sell.btnSell.visible = false;
				cntGlow.color = 0xFF0000;
			}

			if( int( swLoader.data["sc"+sell.dtWare.selectedIndex] ) < int( swLoader.data["ic"+sell.dtWare.selectedIndex] ) ) {
				iMin = swLoader.data["sc"+sell.dtWare.selectedIndex];
			} else {
				iMin = swLoader.data["ic"+sell.dtWare.selectedIndex];
			}

			if( int( sell.dtCount.text ) > iMin ) {
				sell.dtSumm.text = Number( swLoader.data["ip"+sell.dtWare.selectedIndex] ) * int( iMin );
				sell.btnSell.visible = false;
				sellGlow.color = 0x00FF00;
			} else {
				sell.dtSumm.text = Number( swLoader.data["ip"+sell.dtWare.selectedIndex] ) * int( sell.dtCount.text );
			}

			sell.bgCount.filters = [cntGlow, outGlow];
			sell.bgSell.filters = [sellGlow, outGlow];
			sell.bgTitle.filters = [titleGlow, outGlow];
		}

		public function fnBay(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			var btUrl:String;
			btUrl = "page.php?id=53&shid="+bsLoader.data["id"+bay.dtShips.selectedIndex]+"&oid="+bwLoader.data["id"+bay.dtWare.selectedIndex]+"&ocnt="+int(bay.dtCount.text);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest(btUrl));
		}
		
		public function fnBayAll(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			var btUrl:String;
			btUrl = "page.php?id=53&shid="+bsLoader.data["id"+bay.dtShips.selectedIndex]+"&oid="+bwLoader.data["id"+bay.dtWare.selectedIndex]+"&ocnt="+bwLoader.data["oc"+bay.dtWare.selectedIndex];
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest(btUrl));
		}
		
		public function fnSell(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			var btUrl:String;
			btUrl = "page.php?id=54&shid="+ssLoader.data["id"+sell.dtShips.selectedIndex]+"&oid="+swLoader.data["id"+sell.dtWare.selectedIndex]+"&ocnt="+int(sell.dtCount.text);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest(btUrl));
		}
		
		public function fnSellAll(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			var btUrl:String;
			btUrl = "page.php?id=54&shid="+ssLoader.data["id"+sell.dtShips.selectedIndex]+"&oid="+swLoader.data["id"+sell.dtWare.selectedIndex]+"&ocnt="+swLoader.data["sc"+sell.dtWare.selectedIndex];
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest(btUrl));
		}
		
		private function nopRefresh(event:Event) {
			bsLoader.load(new URLRequest("page.php?id=55"));
			ssLoader.load(new URLRequest("page.php?id=56"));
			oChange(event);
		}
		
		public function PageCompUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			setChildIndex( comp, 3 );
			setChildIndex( conf, 2 );
			setChildIndex( sell, 1 );
			setChildIndex( bay, 0 );
			cTween = new Tween(comp, "alpha", Strong.easeOut, comp.alpha, 1, 1, true);
			sTween = new Tween(sell, "alpha", Strong.easeOut, sell.alpha, 0.5, 1, true);
			oTween = new Tween(conf, "alpha", Strong.easeOut, conf.alpha, 0.5, 1, true);
			bTween = new Tween(bay, "alpha", Strong.easeOut, bay.alpha, 0.5, 1, true);
		}

		public function PageBayUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			setChildIndex( bay, 3 );
			setChildIndex( comp, 2 );
			setChildIndex( conf, 1 );
			setChildIndex( sell, 0 );
			bTween = new Tween(bay, "alpha", Strong.easeOut, bay.alpha, 1, 1, true);
			cTween = new Tween(comp, "alpha", Strong.easeOut, comp.alpha, 0.5, 1, true);
			oTween = new Tween(conf, "alpha", Strong.easeOut, conf.alpha, 0.5, 1, true);
			sTween = new Tween(sell, "alpha", Strong.easeOut, sell.alpha, 0.5, 1, true);
		}

		public function PageSellUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			setChildIndex( sell, 3 );
			setChildIndex( conf, 2 );
			setChildIndex( bay, 1 );
			setChildIndex( comp, 0 );
			sTween = new Tween(sell, "alpha", Strong.easeOut, sell.alpha, 1, 1, true);
			oTween = new Tween(conf, "alpha", Strong.easeOut, conf.alpha, 0.5, 1, true);
			cTween = new Tween(comp, "alpha", Strong.easeOut, comp.alpha, 0.5, 1, true);
			bTween = new Tween(bay, "alpha", Strong.easeOut, bay.alpha, 0.5, 1, true);
		}

		public function PageConfUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			setChildIndex( conf, 3 );
			setChildIndex( sell, 2 );
			setChildIndex( bay, 1 );
			setChildIndex( comp, 0 );
			oTween = new Tween(conf, "alpha", Strong.easeOut, conf.alpha, 1, 1, true);
			sTween = new Tween(sell, "alpha", Strong.easeOut, sell.alpha, 0.5, 1, true);
			cTween = new Tween(comp, "alpha", Strong.easeOut, comp.alpha, 0.5, 1, true);
			bTween = new Tween(bay, "alpha", Strong.easeOut, bay.alpha, 0.5, 1, true);
		}

		private function loadConf(event:Event) {
			var i:uint;

			if( oLoader.data.link != '0' ) {
				conf.dtConfTitle.htmlText = "<font color='#FFFF00'>Купить конфедераты</font>";
				conf.dtConfTitle.addEventListener( MouseEvent.CLICK, showPay );
//				conf.dtConfTitle.htmlText = "<font color='#FFFF00'><a href=" + unescape( oLoader.data.link ) + ">Купить конфедераты</a></font>";
			}
			oDp.removeAll();
			if (oLoader.data.cnt>0) {
				for (i=0; i<oLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"] = oLoader.data["n"+i];
					dgFill["bgColor"] = oLoader.data["c"+i];
					oDp.addItem(dgFill);
				}
			}
		}

		private function oChange(event:Event) {
			conf.dtDesc.htmlText = "Загрузка...";
			conf.dtCredit.text = "";
			conf.dtConf.text = "";
			conf.dtCreditSumm.text = "";
			conf.dtConfSumm.text = "";
			conf.btnBayCredit.visible = false;
			conf.btnBayConf.visible = false;
//			oDescLoader.load(new URLRequest("d:\page651.txt"));
			oDescLoader.load(new URLRequest("page.php?id=651&oid="+oLoader.data["id"+conf.dgList.selectedIndex]));
		}

		private function loadConfDesc(event:Event) {
			if( oDescLoader.data.err == 0 ) {
				conf.dtDesc.htmlText = oDescLoader.data.desc;
				conf.dtCredit.text = oDescLoader.data.money;
				conf.dtConf.text = oDescLoader.data.conf;
				conf.dtConfCount.text = 1;
				conf.dtCreditSumm.text = oDescLoader.data.pr;
				conf.dtConfSumm.text = oDescLoader.data.cp;

				if( oDescLoader.data.bb == 1 ) {
					conf.btnBayCredit.visible = true;
				}

				if( oDescLoader.data.cb == 1 ) {
					conf.btnBayConf.visible = true;
				}
			} else {
				conf.dtDesc.htmlText = "Нет данных";
			}
			conf.dtScroll.update();
			if (conf.dtScroll.enabled == false) {
				conf.dtScroll.visible = false;
			} else {
				conf.dtScroll.visible = true;
			}
		}

		public function confCountChange(event:Event) {
			if( int(conf.dtConfCount.text) != conf.dtConfCount.text || int(conf.dtConfCount.text) <= 0 ) {
				conf.dtConfCount.text = 1;
			}
			conf.dtCreditSumm.text = Math.round( Number(oDescLoader.data.pr) * int(conf.dtConfCount.text) * 100 ) / 100;
			conf.dtConfSumm.text = Math.round( Number(oDescLoader.data.cp) * int(conf.dtConfCount.text) * 100 ) / 100;
			if( oDescLoader.data.bb == 1 && Number( conf.dtCreditSumm.text ) < Number( conf.dtCredit.text ) ) {
				conf.btnBayCredit.visible = true;
			}
			if( oDescLoader.data.cb == 1 && Number( conf.dtCreditSumm.text ) < Number( conf.dtCredit.text ) ) {
				conf.btnBayConf.visible = true;
			}
		}

		public function bayCreditClick(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=652&tp=1&oid="+oLoader.data["id"+conf.dgList.selectedIndex]+"&ocnt="+int(conf.dtConfCount.text)));
		}

		public function bayConfClick(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=652&tp=2&oid="+oLoader.data["id"+conf.dgList.selectedIndex]+"&ocnt="+int(conf.dtConfCount.text)));
		}
	}
}
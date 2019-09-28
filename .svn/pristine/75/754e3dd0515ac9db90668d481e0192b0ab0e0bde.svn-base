package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFieldType;

	public class misc3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var chanel:SoundChannel;
		private var eTween:Tween;
		private var lTween:Tween;
		private var tTween:Tween;
		private var aTween:Tween;
		private var rTween:Tween;
		private var sTween:Tween;
		private var hTween:Tween;
		
		private var item:String = root.loaderInfo.parameters.itm;

		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();

		private var eLoader:URLLoader = new URLLoader();
		private var eDp:DataProvider = new DataProvider();
		private var eDescLoader:URLLoader = new URLLoader();

		private var aLoader:URLLoader = new URLLoader();
		private var aLoad:Boolean = false;
		private var aDp:DataProvider = new DataProvider();
		private var aInfoLoader:URLLoader = new URLLoader();
		private var uLoader:URLLoader = new URLLoader();
		private var uDp:DataProvider = new DataProvider();
		private var uInfoLoader:URLLoader = new URLLoader();
		private var ordLoader:URLLoader = new URLLoader();

		private var rLoader:URLLoader = new URLLoader();
		private var rLoad:Boolean = false;
		private var rDp:DataProvider = new DataProvider();

		private var sLoader:URLLoader = new URLLoader();
		private var sLoad:Boolean = false;
		private var sCount:uint;
		private var sTypes:Array = new Array(15);

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		private var hTester:Array = new Array( 10 );
		private var valArr:Array = new Array( 10 );
		private var iLoader:URLLoader = new URLLoader();
		private var iLoad:Boolean = false;
		private var iDp:DataProvider = new DataProvider();
		private var qLoader:URLLoader = new URLLoader();
		private var fLoader:URLLoader = new URLLoader();
		private var vLoader:URLLoader = new URLLoader();
		private var xLoader:URLLoader = new URLLoader();

		private var tLoader:URLLoader = new URLLoader();
		private var tLoad:Boolean = false;
		private var tfDp:DataProvider = new DataProvider();
		private var taDp:DataProvider = new DataProvider();
		private var tpDp:DataProvider = new DataProvider();
		private var tmDp:DataProvider = new DataProvider();
		private var ttDp:DataProvider = new DataProvider();
		private var tqDp:DataProvider = new DataProvider();
		private var trDp:DataProvider = new DataProvider();
		private var tsDp:DataProvider = new DataProvider();

		private var smLoader:URLLoader = new URLLoader();
		private var smLoad:Boolean = false;
		private var place_x:int;
		private var place_y:int;
		private var oldX:int;
		private var oldY:int;

		private var shLoader:URLLoader = new URLLoader();

		public function misc3() {
			var i:uint;
			var elMov:MovieClip;
			
			nopLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			nopLoader.addEventListener(Event.COMPLETE, robotRefresh);

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

			enc.pgUp.addEventListener(MouseEvent.CLICK, PageEncUp);
			enc.dgList.setRendererStyle( "textFormat", myFormat );
			enc.dgList.setStyle( "headerTextFormat", myHeadFormat );
			enc.dgList.addColumn( "Наименование" );
			enc.dgList.dataProvider=eDp;
			enc.dgList.setStyle("cellRenderer",AlternatingRowColors);
			eLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			eLoader.addEventListener(Event.COMPLETE, loadEnc);
//			eLoader.load(new URLRequest("d:\page61.txt"));
			eLoader.load(new URLRequest("page.php?id=61"));
			enc.dgList.addEventListener( Event.CHANGE, eChange );
			eDescLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			eDescLoader.addEventListener(Event.COMPLETE, loadEncDesc);

			aliance.btnAlCreate.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlEnter.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlUpgrade.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlMail.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlLeave.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlCancel.addEventListener(MouseEvent.CLICK, alianceOrder);
			aliance.btnAlInfo.addEventListener(MouseEvent.CLICK, showDesc);

			alDesc.btnOk.addEventListener( MouseEvent.CLICK, clickOk );
			alDesc.btnCancel.addEventListener( MouseEvent.CLICK, clickCancel );
			alDesc.visible = false;
			alDesc.alpha = 0;

			aliance.btnUsAccept.addEventListener(MouseEvent.CLICK, userOrder);
			aliance.btnUsDeligade.addEventListener(MouseEvent.CLICK, userOrder);
			aliance.btnUsMail.addEventListener(MouseEvent.CLICK, userOrder);
			aliance.btnUsInfo.addEventListener(MouseEvent.CLICK, userOrder);
			aliance.btnUsDecline.addEventListener(MouseEvent.CLICK, userOrder);
			aliance.btnUsLeave.addEventListener(MouseEvent.CLICK, userOrder);

			aliance.pgUp.addEventListener(MouseEvent.CLICK, PageAlianceUp);
			aliance.dgAliances.setRendererStyle( "textFormat", myFormat );
			aliance.dgAliances.setStyle( "headerTextFormat", myHeadFormat );
			aliance.dgAliances.addColumn( "Наименование" );
			aliance.dgAliances.addColumn( "Уровень" );
			aliance.dgAliances.columns[0].width=180;
			aliance.dgAliances.columns[1].width=100;
			aliance.dgAliances.dataProvider=aDp;
			aliance.dgAliances.setStyle("cellRenderer",AlternatingRowColors);
			aliance.dgAliances.addEventListener( Event.CHANGE, aChange );
			aLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			aLoader.addEventListener(Event.COMPLETE, loadAliance);
//			aLoader.load(new URLRequest("d:\page68.txt"));
//			aLoader.load(new URLRequest("page.php?id=68"));
			aInfoLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			aInfoLoader.addEventListener(Event.COMPLETE, loadAlianceInfo);
			aliance.dgUsers.setRendererStyle( "textFormat", myFormat );
			aliance.dgUsers.setStyle( "headerTextFormat", myHeadFormat );
			aliance.dgUsers.addColumn( "Имя" );
			aliance.dgUsers.dataProvider=uDp;
			aliance.dgUsers.setStyle("cellRenderer",AlternatingRowColors);
			aliance.dgUsers.addEventListener( Event.CHANGE, uChange );
			uLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			uLoader.addEventListener(Event.COMPLETE, loadUsers);
			uInfoLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			uInfoLoader.addEventListener(Event.COMPLETE, loadUserInfo);
			alianceHide();

			robots.pgUp.addEventListener(MouseEvent.CLICK, PageRobotsUp);
			robots.dgList.setRendererStyle( "textFormat", myFormat );
			robots.dgList.setStyle( "headerTextFormat", myHeadFormat );
			robots.dgList.addColumn( "Оставшееся время" );
			robots.dgList.addColumn( "Расположение объекта" );
			robots.dgList.addColumn( "Объект" );
			robots.dgList.addColumn( "Координаты" );
			robots.dgList.columns[0].width=150;
			robots.dgList.columns[1].width=350;
			robots.dgList.columns[2].width=250;
			robots.dgList.columns[3].width=250;
			robots.dgList.dataProvider=rDp;
			robots.dgList.setStyle("cellRenderer",AlternatingRowColors);
			rLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			rLoader.addEventListener(Event.COMPLETE, loadRobots);
//			rLoader.load(new URLRequest("d:\page64.txt"));
//			rLoader.load(new URLRequest("page.php?id=64"));

			settings.pgUp.addEventListener(MouseEvent.CLICK, PageSettingsUp);
			settings.volMusic.addEventListener(MouseEvent.MOUSE_DOWN, musChange);
			settings.volSound.addEventListener(MouseEvent.MOUSE_DOWN, sndChange);
			sLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, loadSettings);
//			sLoader.load(new URLRequest("d:\page66.txt"));
//			sLoader.load(new URLRequest("page.php?id=66"));
			settings.btnSave.addEventListener(MouseEvent.CLICK, saveSettings);
			settings.btnKillUser.addEventListener(MouseEvent.CLICK, killUser);
			for( i=0; i<12; i++ ) {
				elMov = settings.getChildByName( "el"+i ) as MovieClip;
				elMov.alpha = 0;
				elMov.cbChat.setStyle( "textFormat", myFormat );
				elMov.cbMail.setStyle( "textFormat", myFormat );
			}

			hire.pgUp.addEventListener(MouseEvent.CLICK, PageHireUp);
			hire.cbInConf.setStyle( "textFormat", myFormat );
			hire.dtTime.addEventListener( Event.CHANGE, checkField );
			hire.dtSumm.addEventListener( Event.CHANGE, checkField );
			hire.cbInConf.addEventListener( MouseEvent.CLICK, checkField );
			hire.btnSave.addEventListener(MouseEvent.CLICK, saveQuest );

			iLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, hireLoad);
//			iLoader.load(new URLRequest("d:\page642.txt"));
//			iLoader.load(new URLRequest("page.php?id=642"));
			hire.cbQuest.dataProvider=iDp;
			hire.cbQuest.addEventListener( Event.CHANGE, hireChange );
			hire.cbPersonal.textField.setStyle( "textFormat", myHeadFormat );
			hire.cbPersonal.dropdown.setRendererStyle( "textFormat", myFormat );
			hire.cbPersonal.rowCount = 16;
			hire.cbPersonal.selectedIndex = 0;

			top.pgUp.addEventListener(MouseEvent.CLICK, PageTopUp);
			tLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			tLoader.addEventListener(Event.COMPLETE, topLoad);
//			tLoader.load(new URLRequest("d:\page671.txt"));
//			tLoader.load(new URLRequest("page.php?id=671"));
			top.dgTopF.setRendererStyle( "textFormat", myFormat );
			top.dgTopF.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopF.addColumn( "Имя" );
			top.dgTopF.addColumn( "Значение" );
			top.dgTopF.dataProvider=tfDp;
			top.dgTopF.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopA.setRendererStyle( "textFormat", myFormat );
			top.dgTopA.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopA.addColumn( "Имя" );
			top.dgTopA.addColumn( "Значение" );
			top.dgTopA.dataProvider=taDp;
			top.dgTopA.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopP.setRendererStyle( "textFormat", myFormat );
			top.dgTopP.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopP.addColumn( "Имя" );
			top.dgTopP.addColumn( "Значение" );
			top.dgTopP.dataProvider=tpDp;
			top.dgTopP.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopM.setRendererStyle( "textFormat", myFormat );
			top.dgTopM.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopM.addColumn( "Имя" );
			top.dgTopM.addColumn( "Значение" );
			top.dgTopM.dataProvider=tmDp;
			top.dgTopM.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopT.setRendererStyle( "textFormat", myFormat );
			top.dgTopT.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopT.addColumn( "Имя" );
			top.dgTopT.addColumn( "Значение" );
			top.dgTopT.dataProvider=ttDp;
			top.dgTopT.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopQ.setRendererStyle( "textFormat", myFormat );
			top.dgTopQ.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopQ.addColumn( "Имя" );
			top.dgTopQ.addColumn( "Значение" );
			top.dgTopQ.dataProvider=tqDp;
			top.dgTopQ.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopR.setRendererStyle( "textFormat", myFormat );
			top.dgTopR.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopR.addColumn( "Имя" );
			top.dgTopR.addColumn( "Значение" );
			top.dgTopR.dataProvider=trDp;
			top.dgTopR.setStyle("cellRenderer",AlternatingRowColors);
			top.dgTopS.setRendererStyle( "textFormat", myFormat );
			top.dgTopS.setStyle( "headerTextFormat", myHeadFormat );
			top.dgTopS.addColumn( "Имя" );
			top.dgTopS.addColumn( "Значение" );
			top.dgTopS.dataProvider=tsDp;
			top.dgTopS.setStyle("cellRenderer",AlternatingRowColors);

			atlas.pgUp.addEventListener(MouseEvent.CLICK, PageAtlasUp);
			smLoader.addEventListener( Event.COMPLETE, starLoad );
			smLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
//			smLoader.load( new URLRequest( "page.php?id=371" ) );
//			smLoader.load( new URLRequest( "d:\page371.txt" ) );
			atlas.btnCreate.addEventListener(MouseEvent.CLICK, starHintSave);
			atlas.btnClear.addEventListener(MouseEvent.CLICK, starHintClear);
			atlas.btnCreate.visible = false;
			atlas.btnClear.visible = false;
			atlas.starMap.mvCross.visible = false;
			atlas.cbColor.textField.setStyle( "textFormat", myHeadFormat );
			atlas.cbColor.dropdown.setRendererStyle( "textFormat", myFormat );
			atlas.cbColor.selectedIndex=0;
			atlas.cbAliance.setStyle( "textFormat", myFormat );

			shLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			shLoader.addEventListener(Event.COMPLETE, starHintLoad);

			qLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			qLoader.addEventListener(Event.COMPLETE, questLoad);

			fLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			fLoader.addEventListener(Event.COMPLETE, checkLoad);

			vLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			vLoader.addEventListener(Event.COMPLETE, validateLoad);

			xLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			xLoader.addEventListener(Event.COMPLETE, questAdd);
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
				hLoader.load( new URLRequest( "page.php?id=8&asc=misc_"+hintName ) );
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

		private function loadEnc(event:Event) {
			var i:uint;

			eDp.removeAll();
			if (eLoader.data.cnt>0) {
				for (i=0; i<eLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"] = eLoader.data["n"+i];
					dgFill["bgColor"] = eLoader.data["c"+i];
					eDp.addItem(dgFill);
					if( item == eLoader.data["n"+i] ) {
						enc.dgList.selectedIndex = enc.dgList.length - 1;
						eChange(event);
					}
				}

				if( int( enc.dgList.selectedIndex ) == -1 ) {
					enc.dgList.selectedIndex = 0;
				} else {
					enc.dgList.scrollToIndex( enc.dgList.selectedIndex + 10 );
				}
				eChange(event);
			}
		}

		private function eChange(event:Event) {
			enc.dtDesc.htmlText = "Загрузка...";
//			eDescLoader.load(new URLRequest("d:\page62.txt"));
			eDescLoader.load(new URLRequest("page.php?id=62&oid="+eLoader.data["id"+enc.dgList.selectedIndex]));
		}

		private function loadEncDesc(event:Event) {
			if( eDescLoader.data.err == 0 ) {
				enc.dtDesc.htmlText = eDescLoader.data.desc;
			} else {
				enc.dtDesc.htmlText = "Нет данных";
			}
			enc.dtScroll.update();
			if (enc.dtScroll.enabled == false) {
				enc.dtScroll.visible = false;
			} else {
				enc.dtScroll.visible = true;
			}
		}

		private function alianceHide() {
			aliance.bgName.visible = false;
			aliance.dtName.visible = false;
			aliance.dtNew.visible = false;
			aliance.dtNewName.visible = false;
			aliance.btnAlCreate.visible = false;
			aliance.btnAlEnter.visible = false;
			aliance.btnAlUpgrade.visible = false;
			aliance.dtUpgrade.visible = false;
			aliance.btnAlMail.visible = false;
			aliance.btnAlLeave.visible = false;
			aliance.btnAlCancel.visible = false;
			aliance.btnAlInfo.visible = false;
			usersHide();
		}

		private function usersHide() {
			aliance.btnUsAccept.visible = false;
			aliance.btnUsDeligade.visible = false;
			aliance.btnUsMail.visible = false;
			aliance.btnUsInfo.visible = false;
			aliance.btnUsDecline.visible = false;
			aliance.btnUsLeave.visible = false;
		}

		private function loadAliance(event:Event) {
			var i:uint;

			aDp.removeAll();

			if (aLoader.data.cnt>0) {
				for (i=0; i<aLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"] = aLoader.data["n"+i];
					dgFill["bgColor"] = aLoader.data["c"+i];
					dgFill["Уровень"] = aLoader.data["l"+i];
					aDp.addItem(dgFill);
					if( int( aLoader.data.ua ) == int( aLoader.data["id"+i] ) ) {
						aliance.dgAliances.selectedIndex = aliance.dgAliances.length - 1;
					}
				}
			}
			aChange(event);
		}

		private function aChange(event:Event) {
			alianceHide();
//			aInfoLoader.load(new URLRequest("d:\page681.txt"));
			aInfoLoader.load(new URLRequest("page.php?id=681&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]));

//			uLoader.load(new URLRequest("d:\page69.txt"));
			uLoader.load(new URLRequest("page.php?id=69&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]));
		}

		private function loadAlianceInfo(event:Event) {
			if( aInfoLoader.data.err == 0 ) {
				alDesc.dtAlDesc.text = aInfoLoader.data.txt;
				alDesc.dtScroll.update();
				if (alDesc.dtScroll.enabled == false) {
					alDesc.dtScroll.visible = false;
				} else {
					alDesc.dtScroll.visible = true;
				}


				if( aInfoLoader.data.ba1 == 1 ) {
					aliance.btnAlCreate.visible = true;
					aliance.bgName.visible = true;
					aliance.dtName.visible = true;
					aliance.dtNew.visible = true;
					aliance.dtNewName.visible = true;
				} else {
					aliance.btnAlCreate.visible = false;
					aliance.bgName.visible = false;
					aliance.dtName.visible = false;
					aliance.dtNew.visible = false;
					aliance.dtNewName.visible = false;
				}

				if( aInfoLoader.data.ba2 == 1 ) {
					aliance.btnAlEnter.visible = true;
				} else {
					aliance.btnAlEnter.visible = false;
				}

				if( aInfoLoader.data.ba3 == 1 ) {
					aliance.btnAlUpgrade.visible = true;
					aliance.dtUpgrade.visible = true;
				} else {
					aliance.btnAlUpgrade.visible = false;
					aliance.dtUpgrade.visible = false;
				}

				if( aInfoLoader.data.ba4 == 1 ) {
					aliance.btnAlMail.visible = true;
				} else {
					aliance.btnAlMail.visible = false;
				}

				if( aInfoLoader.data.ba5 == 1 ) {
					aliance.btnAlLeave.visible = true;
				} else {
					aliance.btnAlLeave.visible = false;
				}

				if( aInfoLoader.data.ba6 == 1 ) {
					aliance.btnAlCancel.visible = true;
				} else {
					aliance.btnAlCancel.visible = false;
				}

				if( aInfoLoader.data.ba7 == 1 ) {
					alDesc.dtAlDesc.type = TextFieldType.INPUT;
					aliance.btnAlInfo.visible = true;
					alDesc.btnOk.visible = true;
				} else {
					alDesc.dtAlDesc.type = TextFieldType.DYNAMIC;
					aliance.btnAlInfo.visible = true;
					alDesc.btnOk.visible = false;
				}
			}
		}

		public function showDesc( e:MouseEvent ) {
			alDesc.visible = true;
			sTween = new Tween( alDesc, "alpha", Strong.easeOut, alDesc.alpha, 1, 1, true );
		}

		public function clickCancel( e:MouseEvent ) {
			sTween = new Tween( alDesc, "alpha", Strong.easeOut, alDesc.alpha, 0, 1, true );
			sTween.addEventListener( TweenEvent.MOTION_FINISH, pUnvisible );
		}

		public function pUnvisible( event:Event ) {
			alDesc.visible = false;
		}

		public function clickOk( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			clickCancel( e );

			ordLoader.load(new URLRequest("page.php?id=682&ord=7&txt="+escape( alDesc.dtAlDesc.text )+"&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]));
		}

		private function loadUsers(event:Event) {
			var i:uint;

			uDp.removeAll();
			if (uLoader.data.cnt>0) {
				for (i=0; i<uLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Имя"] = uLoader.data["n"+i];
					dgFill["bgColor"] = uLoader.data["c"+i];
					uDp.addItem(dgFill);
				}
			}
		}

		private function uChange(event:Event) {
			usersHide();
//			uInfoLoader.load(new URLRequest("d:\page681.txt"));
			uInfoLoader.load(new URLRequest("page.php?id=691&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]+"&uid="+uLoader.data["id"+aliance.dgUsers.selectedIndex]));
		}

		private function loadUserInfo(event:Event) {
			if( uInfoLoader.data.err == 0 ) {
				if( uInfoLoader.data.bu1 == 1 ) {
					aliance.btnUsAccept.visible = true;
				} else {
					aliance.btnUsAccept.visible = false;
				}

				if( uInfoLoader.data.bu2 == 1 ) {
					aliance.btnUsDeligade.visible = true;
				} else {
					aliance.btnUsDeligade.visible = false;
				}

				if( uInfoLoader.data.bu3 == 1 ) {
					aliance.btnUsMail.visible = true;
					aliance.btnUsInfo.visible = true;
				} else {
					aliance.btnUsMail.visible = false;
					aliance.btnUsInfo.visible = false;
				}

				if( uInfoLoader.data.bu4 == 1 ) {
					aliance.btnUsDecline.visible = true;
				} else {
					aliance.btnUsDecline.visible = false;
				}

				if( uInfoLoader.data.bu5 == 1 ) {
					aliance.btnUsLeave.visible = true;
				} else {
					aliance.btnUsLeave.visible = false;
				}
			}
		}

		private function alianceOrder(e:MouseEvent) {
			var ordId:String;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			ordLoader.addEventListener(Event.COMPLETE, alianceRefresh);
			switch( e.target.name ) {
				case 'btnAlCreate':
					ordId = "1&name="+escape( aliance.dtName.text );
					break;
				case 'btnAlEnter':
					ordId = "2";
					break;
				case 'btnAlUpgrade':
					ordId = "3";
					break;
				case 'btnAlMail':
					navigateToURL( new URLRequest("page.php?id=1&msgto=Aliance"), "main" );
					ordId = "";
					break;
				case 'btnAlLeave':
					ordId = "5";
					break;
				case 'btnAlCancel':
					ordId = "6";
					break;
			}
			if( ordId != "" ) {
				ordLoader.load(new URLRequest("page.php?id=682&ord="+ordId+"&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]));
			}
		}

		private function alianceRefresh(event:Event) {
			ordLoader.removeEventListener( Event.COMPLETE, alianceRefresh );
			aLoader.load(new URLRequest("page.php?id=68"));
		}

		private function userOrder(e:MouseEvent) {
			var ordId:String;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			ordLoader.addEventListener(Event.COMPLETE, alianceRefresh);
			switch( e.target.name ) {
				case 'btnUsAccept':
					ordId = "1";
					break;
				case 'btnUsDeligade':
					ordId = "2";
					break;
				case 'btnUsMail':
					navigateToURL( new URLRequest("page.php?id=1&msgto="+escape( uLoader.data["n"+aliance.dgUsers.selectedIndex] )), "main" );
					ordId = "";
					break;
				case 'btnUsInfo':
					navigateToURL( new URLRequest("page.php?id=18&login="+escape( uLoader.data["n"+aliance.dgUsers.selectedIndex] )), "main" );
					ordId = "";
					break;
				case 'btnUsDecline':
					ordId = "4";
					break;
				case 'btnUsLeave':
					ordId = "5";
					break;
			}
			if( ordId != "" ) {
				ordLoader.load(new URLRequest("page.php?id=692&ord="+ordId+"&uid="+uLoader.data["id"+aliance.dgUsers.selectedIndex]));
			}
		}

		private function usersRefresh(event:Event) {
			ordLoader.removeEventListener( Event.COMPLETE, usersRefresh );
			uLoader.load(new URLRequest("page.php?id=69&aid="+aLoader.data["id"+aliance.dgAliances.selectedIndex]));
		}

		private function robotRefresh(event:Event) {
//			rLoader.load(new URLRequest("d:\page64.txt"));
			rLoader.load(new URLRequest("page.php?id=64"));
		}

		private function loadRobots(event:Event) {
			var i:uint;

			rDp.removeAll();
			if (rLoader.data.cnt>0) {
				for (i=0; i<rLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Оставшееся время"] = rLoader.data["ut"+i];
					dgFill["Расположение объекта"] = rLoader.data["pn"+i];
					dgFill["Объект"] = rLoader.data["on"+i];
					dgFill["Координаты"] = rLoader.data["xy"+i];
					dgFill["bgColor"] = rLoader.data["c"+i];
					rDp.addItem(dgFill);
				}
			}
		}

		private function loadSettings(event:Event) {
			var elMov:MovieClip;
			var i:uint;
			if( sLoader.data.err == 0 && sLoader.data.cnt > 0 ) {
				settings.volMusic.pos.width = sLoader.data.mv * 2;
				settings.volSound.pos.width = sLoader.data.sv * 2;
				sCount = sLoader.data.cnt;
				for (i=0; i<sLoader.data.cnt; i++) {
					sTypes[i] = sLoader.data[ "t"+i ];
					elMov = settings.getChildByName( "el"+i ) as MovieClip;
					elMov.alpha = 100;
					elMov.dtDesc.text = sLoader.data[ "d"+i ]
					if( sLoader.data[ "c"+i ] == 1 ) {
						elMov.cbChat.selected = true;
					}
					if( sLoader.data[ "m"+i ] == 1 ) {
						elMov.cbMail.selected = true;
					}
				}
			}
		}
		
		public function saveSettings(e:MouseEvent) {
			var path:String;
			var i:uint;
			var elMov:MovieClip;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			path = "cnt=" + sCount;
			for( i = 0; i < sCount; i++ ) {
				elMov = settings.getChildByName( "el"+i ) as MovieClip;
				path = path + "&t" + i + "=" + sTypes[i];
				path = path + "&c" + i + "=" + elMov.cbChat.selected;
				path = path + "&m" + i + "=" + elMov.cbMail.selected;
			}

			path = path + "&mv=" + int( settings.volMusic.pos.width / 2 ) + "&sv=" + int( settings.volSound.pos.width / 2 );
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=67&" + path));
		}

		public function killUser(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.removeEventListener( Event.COMPLETE, robotRefresh );
			nopLoader.addEventListener(Event.COMPLETE, nopUserKill);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=674"));
		}

		public function nopUserKill( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopUserKill );
			navigateToURL( new URLRequest("page.php"), "_top" );
		}

		private function hideArg( i:uint ) {
			var elBg:MovieClip;
			var elArg:TextField;
			var elVal:TextField;

			elBg = hire.getChildByName( "bgArg" + i ) as MovieClip;
			elBg.visible = false;

			elArg = hire.getChildByName( "dtArg" + i ) as TextField;
			elArg.visible = false;

			elVal = hire.getChildByName( "dtVal" + i ) as TextField;
			elVal.visible = false;
			elVal.text = "";
		}

		private function showArg( i:uint ) {
			var elBg:MovieClip;
			var elArg:TextField;
			var elVal:TextField;
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			elBg = hire.getChildByName( "bgArg" + i ) as MovieClip;
			elBg.visible = true;
			elBg.filters = [inGlow, outGlow];

			elArg = hire.getChildByName( "dtArg" + i ) as TextField;
			elArg.visible = true;

			elVal = hire.getChildByName( "dtVal" + i ) as TextField;
			elVal.visible = true;
			elVal.text = "";
		}

		private function starLoad(event:Event) {
			var i:uint;
			var homeStar:MovieClip = new hs();
			var questStar:MovieClip = new qs();

			atlas.dtDesc.htmlText=smLoader.data.desc;

			for (i=0; i<smLoader.data.cnt; i++) {
				var ClassReference:Class=getDefinitionByName("s"+smLoader.data["st"+i]) as Class;
				var star:MovieClip = new ClassReference();
				star.x=smLoader.data["sx"+i];
				star.y=smLoader.data["sy"+i];
				star.name = "s"+smLoader.data["st"+i]+"x"+smLoader.data["sx"+i]+"y"+smLoader.data["sy"+i];
				atlas.starMap.bgGalaxy.addChild( star );
				if( smLoader.data["fr"+i] ) {
					var frstar:MovieClip = new frs();
					frstar.x=smLoader.data["sx"+i];
					frstar.y=smLoader.data["sy"+i];
					atlas.starMap.addChild( frstar );
				}
				if( smLoader.data["fo"+i] ) {
					var fostar:MovieClip = new fos();
					fostar.x=smLoader.data["sx"+i];
					fostar.y=smLoader.data["sy"+i];
					atlas.starMap.addChild( fostar );
				}
				if( smLoader.data["as"+i] ) {
					var alstar:MovieClip = new als();
					alstar.x=smLoader.data["sx"+i];
					alstar.y=smLoader.data["sy"+i];
					atlas.starMap.addChild( alstar );
				}
			}

			for (i=0; i<smLoader.data.ycnt; i++) {
				var y_circ:MovieClip = new ys();
				y_circ.x=smLoader.data["ysx"+i];
				y_circ.y=smLoader.data["ysy"+i];
				atlas.starMap.addChild( y_circ );
			}

			atlas.starMap.x = 330 - smLoader.data.shx;
			atlas.starMap.y = 250 - smLoader.data.shy;

			homeStar.x=smLoader.data.hstx;
			homeStar.y=smLoader.data.hsty;
			atlas.starMap.addChild( homeStar );
			
			if( smLoader.data.quest == 'true' ) {
				questStar.x=smLoader.data.qsx;
				questStar.y=smLoader.data.qsy;
				atlas.starMap.addChild( questStar );
			}

			atlas.starMap.addEventListener( MouseEvent.MOUSE_DOWN, starStartScroll );
			atlas.starMap.addEventListener( MouseEvent.MOUSE_UP, starStopScroll );
			atlas.starMap.addEventListener( MouseEvent.MOUSE_OVER, showStarDesc );
			atlas.starMap.addEventListener( MouseEvent.MOUSE_OUT, hideStarDesc );
		}

		public function starHintSave( e:MouseEvent ) {
			var starHint:MovieClip;

			switch( int( atlas.cbColor.selectedItem.data ) ) {
				case 0:
					starHint = new sh();
					starHint.name = "shx"+place_x+"y"+place_y;
					break;

				case 1:
					starHint = new se();
					starHint.name = "sex"+place_x+"y"+place_y;
					break;

				case 2:
					starHint = new sr();
					starHint.name = "srx"+place_x+"y"+place_y;
					break;
			}
			starHint.x=place_x;
			starHint.y=place_y;
			atlas.starMap.bgGalaxy.addChild( starHint );

			shLoader.load( new URLRequest( "page.php?id=673&x="+place_x+"&y="+place_y+"&text="+escape( atlas.dtHint.text )+"&type="+atlas.cbColor.selectedItem.data+"&vis="+( atlas.cbAliance.selected ? 1 : 0 ) ) );
		}

		public function starHintClear( e:MouseEvent ) {
			var starHint:MovieClip;

			while( starHint = atlas.starMap.bgGalaxy.getChildByName( "shx"+place_x+"y"+place_y ) ) {
				atlas.starMap.bgGalaxy.removeChild( starHint );
			}

			while( starHint = atlas.starMap.bgGalaxy.getChildByName( "sex"+place_x+"y"+place_y ) ) {
				atlas.starMap.bgGalaxy.removeChild( starHint );
			}

			while( starHint = atlas.starMap.bgGalaxy.getChildByName( "srx"+place_x+"y"+place_y ) ) {
				atlas.starMap.bgGalaxy.removeChild( starHint );
			}

			shLoader.load( new URLRequest( "page.php?id=673&x="+place_x+"&y="+place_y+"&clear=1" ) );
		}

		public function starHintLoad(event:Event) {
			atlas.dtHint.text = '';
			atlas.btnCreate.visible = false;
			atlas.btnClear.visible = false;
		}

		public function showStarDesc( e:MouseEvent ) {
			atlas.starMap.addEventListener( Event.ENTER_FRAME, updateDesc );
			atlas.starDesc.visible=true;
			atlas.starDesc.startDrag( true );
		}

		public function hideStarDesc( e:MouseEvent ) {
			atlas.starMap.removeEventListener( Event.ENTER_FRAME, updateDesc );
			atlas.starDesc.stopDrag();
			atlas.starDesc.visible=false;
		}

		public function updateDesc( event:Event ) {
			atlas.starDesc.desc.text=atlas.starMap.mouseX+":"+atlas.starMap.mouseY;
		}

		public function starStartScroll( e:MouseEvent ) {
			hideStarDesc( e );
			oldX = int( atlas.starMap.x );
			oldY = int( atlas.starMap.y );
			atlas.starMap.startDrag( false );
		}

		public function starStopScroll( e:MouseEvent ) {
			if ( oldX == int( atlas.starMap.x ) && oldY == int( atlas.starMap.y ) ) {
				place_x=atlas.starMap.mouseX;
				place_y=atlas.starMap.mouseY;
				nopLoader.addEventListener( Event.COMPLETE, nopStarInfo );
				nopLoader.load(new URLRequest( "page.php?id=372&mx="+place_x+"&my="+place_y ));
//				nopLoader.load( new URLRequest( "d:\page372.txt" ) );
			}

			atlas.starMap.stopDrag();
			showStarDesc( e );
		}

		public function nopStarInfo( event:Event ) {
			nopLoader.removeEventListener( Event.COMPLETE, nopStarInfo );

			if (nopLoader.data.err==0) {
				place_x=int(nopLoader.data.rx);
				place_y=int(nopLoader.data.ry);

				atlas.dtDesc.htmlText=nopLoader.data.desc;
				atlas.starMap.mvCross.visible = true;
				atlas.starMap.mvCross.x = place_x;
				atlas.starMap.mvCross.y = place_y;

				if( nopLoader.data.hint ) {
					atlas.dtHint.text = nopLoader.data.hint;
					atlas.btnCreate.visible = false;
					atlas.btnClear.visible = true;
				} else {
					atlas.dtHint.text = '';
					atlas.btnCreate.visible = true;
					atlas.btnClear.visible = false;					
				}
			}
		}

		private function topLoad(event:Event) {
			var i:uint;
			var lines:Array;
			var sData:Array;
			var dgFill:Array;
			if( tLoader.data.err == 0 ) {
				taDp.removeAll();
				lines = tLoader.data.at.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.atm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						taDp.addItem(dgFill);
					}
				}

				tpDp.removeAll();
				lines = tLoader.data.pt.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.ptm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						tpDp.addItem(dgFill);
					}
				}

				tmDp.removeAll();
				lines = tLoader.data.mt.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.mtm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						tmDp.addItem(dgFill);
					}
				}

				tfDp.removeAll();
				lines = tLoader.data.ft.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.ftm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						tfDp.addItem(dgFill);
					}
				}

				ttDp.removeAll();
				lines = tLoader.data.tt.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.ttm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						ttDp.addItem(dgFill);
					}
				}

				tqDp.removeAll();
				lines = tLoader.data.qt.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.qtm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						tqDp.addItem(dgFill);
					}
				}

				trDp.removeAll();
				lines = tLoader.data.rt.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.rtm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						trDp.addItem(dgFill);
					}
				}

				tsDp.removeAll();
				lines = tLoader.data.st.split( "|" );
				for (i=0; i<lines.length; i++) {
					if( lines[i].indexOf( ":" ) > 0 ) {
						sData = lines[i].split( ":" );
						dgFill = new Array();
						dgFill["Имя"]=sData[0];
						dgFill["Значение"]=sData[1];
						if( int( tLoader.data.stm ) == i ) {
							dgFill["bgColor"] = '0x006600';
						}
						tsDp.addItem(dgFill);
					}
				}
			}
		}

		private function hireLoad(event:Event) {
			var i:uint;

			hideArg( 0 );
			hideArg( 1 );
			hideArg( 2 );
			hideArg( 3 );
			hideArg( 4 );
			hideArg( 5 );
			hideArg( 6 );
			hideArg( 7 );
			hideArg( 8 );
			hideArg( 9 );

			hire.dtSumm.text = "";
			hire.dtTime.text = "";
			hire.bgError.visible = false;
			hire.dtError.visible = false;
			hire.cbInConf.selected = false;
			hire.btnSave.visible = false;

			if( iLoader.data.err == 0 && iLoader.data.cnt > 0 ) {
				hire.dtCredit.text = iLoader.data.cred;
				hire.dtConf.text = iLoader.data.conf;

				iDp.removeAll();
				for (i=0; i<iLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["data"]=iLoader.data["id"+i];
					dgFill["label"]=iLoader.data["n"+i];
					iDp.addItem(dgFill);
				}

				hire.cbQuest.textField.setStyle( "textFormat", myHeadFormat );
				hire.cbQuest.dropdown.setRendererStyle( "textFormat", myFormat );
				hire.cbQuest.rowCount = 16;
				hire.cbQuest.selectedIndex = 0;
				hireChange( event );
			}
		}

		private function hireChange(event:Event) {
//			qLoader.load(new URLRequest("d:\page644.txt"));
			qLoader.load(new URLRequest("page.php?id=644&qt="+hire.cbQuest.selectedItem.data));
		}

		private function questLoad(event:Event) {
			var i:uint;
			var elArg:TextField;
			var elVal:TextField;

			if( qLoader.data.err == 0 ) {
				hire.cbInConf.selected = false;
				hire.dtSumm.text = "";
				hire.dtTime.text = "";
				hire.btnSave.visible = false;
				hire.dtError.htmlText = "";
				hire.dtError.visible = false;
				hire.bgError.visible = false;
				for (i=0; i<10; i++) {
					if( qLoader.data["n"+i] ) {
						hTester[ i ] = false;
						showArg( i );
						elArg = hire.getChildByName( "dtArg" + i ) as TextField;
						elArg.htmlText = qLoader.data["n"+i];
						elVal = hire.getChildByName( "dtVal" + i ) as TextField;
						elVal.removeEventListener( Event.CHANGE, checkField );
						elVal.addEventListener( Event.CHANGE, checkField );
					} else {
						hTester[ i ] = true;
						hideArg( i );
					}
				}
			}
		}

		public function checkField(event:Event) {
			var i:uint;
			var elVal:TextField;

			elVal = ( event.type == MouseEvent.CLICK ? hire.dtSumm : event.target as TextField );
			switch( elVal.name.substr( 0, 5 ) ) {
				case 'dtVal' :
					i = int( elVal.name.substr( 5, 1 ) );
					valArr[ i ] = elVal.text;
//					fLoader.load(new URLRequest("d:\page641.txt"));
					fLoader.load(new URLRequest("page.php?id=641&fi="+i+"&ft="+qLoader.data["t"+i]+"&fv="+escape( elVal.text )));
					break;

				case 'dtSum' :
				case null :
					if( hire.cbInConf.selected ) {
//						fLoader.load(new URLRequest("d:\page641.txt"));
						fLoader.load(new URLRequest("page.php?id=641&fi=m&ft=5&fv="+escape( elVal.text )));
					} else {
//						fLoader.load(new URLRequest("d:\page641.txt"));
						fLoader.load(new URLRequest("page.php?id=641&fi=m&ft=4&fv="+escape( elVal.text )));
					}
					break;

				case 'dtTim' :
//					fLoader.load(new URLRequest("d:\page641.txt"));
					fLoader.load(new URLRequest("page.php?id=641&fi=t&ft=7&fv="+escape( elVal.text )));
					break;
			}

		}

		private function checkLoad(event:Event) {
			var i:uint;
			var ok:uint;
			var t:uint;
			var elBg:MovieClip;
			var elArg:TextField;
			var elVal:TextField;
			var sUrl:String;

			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			switch( fLoader.data.fi ) {
				case 'm' :
					elBg = hire.getChildByName( "bgMoney" ) as MovieClip;
					elBg.visible = true;
					break;

				case 't' :
					elBg = hire.getChildByName( "bgTime" ) as MovieClip;
					elBg.visible = true;
					break;

				default:
					i = fLoader.data.fi;
					elBg = hire.getChildByName( "bgArg" + i ) as MovieClip;
					elBg.visible = true;
					break;
			}

			if( fLoader.data.err != 0 ) {
				hTester[ i ] = false;
				inGlow.color = 0xFF0000;
				if( fLoader.data.errtext ) {
					hire.dtError.htmlText = fLoader.data.errtext;
					hire.dtError.visible = true;
					hire.bgError.visible = true;
				}
				if( fLoader.data.t == 3 ) {
					elArg = hire.getChildByName( "dtArg" + i ) as TextField;
					elArg.htmlText = qLoader.data["n"+i];
				}
			} else {
				hTester[ i ] = true;
				if( fLoader.data.errtext ) {
					hire.dtError.htmlText = fLoader.data.errtext;
					hire.dtError.visible = true;
					hire.bgError.visible = true;
				} else {
					hire.dtError.htmlText = "";
					hire.dtError.visible = false;
					hire.bgError.visible = false;
				}
				if( fLoader.data.t == 3 ) {
					elArg = hire.getChildByName( "dtArg" + i ) as TextField;
					elArg.htmlText = fLoader.data.sname + " " + qLoader.data["n"+i];
				}
				
				ok = 0;
				sUrl = "&qt=" + hire.cbQuest.selectedItem.data;
				sUrl = sUrl + "&vis=" + hire.cbPersonal.selectedItem.data
				sUrl = sUrl + "&long=" + hire.dtTime.text;
				sUrl = sUrl + "&conf=" + ( hire.cbInConf.selected ? 1 : 0 );
				sUrl = sUrl + "&price=" + hire.dtSumm.text;

				for (t=0; t<10; t++) {
					if( valArr[ t ] == undefined ) {
						ok++;
					} else if( hTester[ t ] ) {
						ok++;
						sUrl = sUrl + "&v" + t + "=" + escape( valArr[ t ] );
					}
				}

				if( ok == 10 ) {
//					vLoader.load(new URLRequest("d:\page645.txt"));
					vLoader.load(new URLRequest("page.php?id=645" + sUrl));
				}
			}

			elBg.filters = [inGlow, outGlow];
		}

		private function validateLoad(event:Event) {
			if( vLoader.data.err != 0 ) {
				hire.btnSave.visible = false;
				if( vLoader.data.errtext ) {
					hire.dtError.visible = true;
					hire.bgError.visible = true;
					hire.dtError.htmlText = vLoader.data.errtext;
				}
			} else {
				hire.btnSave.visible = true;
				if( vLoader.data.errtext ) {
					hire.dtError.htmlText = vLoader.data.errtext;
					hire.dtError.visible = true;
					hire.bgError.visible = true;
				} else {
					hire.dtError.htmlText = "";
					hire.dtError.visible = false;
					hire.bgError.visible = false;
				}
			}
		}

		public function saveQuest(e:MouseEvent) {
			var ok:uint;
			var t:uint;
			var sUrl:String;

			ok = 0;
			sUrl = "&qt=" + hire.cbQuest.selectedItem.data;
			sUrl = sUrl + "&vis=" + hire.cbPersonal.selectedItem.data
			sUrl = sUrl + "&long=" + hire.dtTime.text;
			sUrl = sUrl + "&conf=" + ( hire.cbInConf.selected ? 1 : 0 );
			sUrl = sUrl + "&price=" + hire.dtSumm.text;

			for (t=0; t<10; t++) {
				if( valArr[ t ] == undefined ) {
					ok++;
				} else if( hTester[ t ] ) {
					ok++;
					sUrl = sUrl + "&v" + t + "=" + escape( valArr[ t ] );
				}
			}

			if( ok == 10 ) {
//				xLoader.load(new URLRequest("d:\page645.txt"));
				xLoader.load(new URLRequest("page.php?id=643" + sUrl));
			}
		}

		public function questAdd(event:Event) {
//			iLoader.load(new URLRequest("d:\page642.txt"));
			iLoader.load(new URLRequest("page.php?id=642"));
		}

		public function PageEncUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( enc, 6 );
			setChildIndex( atlas, 5 );
			setChildIndex( aliance, 4 );
			setChildIndex( hire, 3 );
			setChildIndex( robots, 2 );
			setChildIndex( top, 1 );
			setChildIndex( settings, 0 );
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 1, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}

		public function PageAtlasUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !smLoad ) {
				smLoader.load( new URLRequest( "page.php?id=371" ) );
				smLoad = true;
			}

			setChildIndex( atlas, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( aliance, 4 );
			setChildIndex( hire, 3 );
			setChildIndex( robots, 2 );
			setChildIndex( top, 1 );
			setChildIndex( settings, 0 );
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}

		public function PageAlianceUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !aLoad ) {
				aLoader.load(new URLRequest("page.php?id=68"));
				aLoad = true;
			}

			setChildIndex( aliance, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( atlas, 4 );
			setChildIndex( hire, 3 );
			setChildIndex( robots, 2 );
			setChildIndex( top, 1 );
			setChildIndex( settings, 0 );
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}

		public function PageHireUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !iLoad ) {
				iLoader.load(new URLRequest("page.php?id=642"));
				iLoad = true;
			}

			setChildIndex( hire, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( atlas, 4 );
			setChildIndex( aliance, 3 );
			setChildIndex( robots, 2 );
			setChildIndex( top, 1 );
			setChildIndex( settings, 0 );
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}

		public function PageRobotsUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !rLoad ) {
				rLoader.load(new URLRequest("page.php?id=64"));
				rLoad = true;
			}

			setChildIndex( robots, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( atlas, 4 );
			setChildIndex( aliance, 3 );
			setChildIndex( hire, 2 );
			setChildIndex( top, 1 );
			setChildIndex( settings, 0 );
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}
		
		public function PageTopUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !tLoad ) {
				tLoader.load(new URLRequest("page.php?id=671"));
				tLoad = true;
			}

			setChildIndex( top, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( atlas, 4 );
			setChildIndex( aliance, 3 );
			setChildIndex( hire, 2 );
			setChildIndex( robots, 1 );
			setChildIndex( settings, 0 );
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 0.5, 1, true);
		}

		public function PageSettingsUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			if( !sLoad ) {
				sLoader.load(new URLRequest("page.php?id=66"));
				sLoad = true;
			}

			setChildIndex( settings, 6 );
			setChildIndex( enc, 5 );
			setChildIndex( atlas, 4 );
			setChildIndex( aliance, 3 );
			setChildIndex( hire, 2 );
			setChildIndex( robots, 1 );
			setChildIndex( top, 0 );
			sTween = new Tween(settings, "alpha", Strong.easeOut, settings.alpha, 1, 1, true);
			eTween = new Tween(enc, "alpha", Strong.easeOut, enc.alpha, 0.5, 1, true);
			lTween = new Tween(atlas, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
			aTween = new Tween(aliance, "alpha", Strong.easeOut, aliance.alpha, 0.5, 1, true);
			hTween = new Tween(hire, "alpha", Strong.easeOut, hire.alpha, 0.5, 1, true);
			rTween = new Tween(robots, "alpha", Strong.easeOut, robots.alpha, 0.5, 1, true);
			tTween = new Tween(top, "alpha", Strong.easeOut, top.alpha, 0.5, 1, true);
		}

		public function musChange(e:MouseEvent) {
			settings.volMusic.pos.width = settings.volMusic.mouseX;
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=67&mv=" + int( settings.volMusic.pos.width / 2 )));
		}

		public function sndChange(e:MouseEvent) {
			settings.volSound.pos.width = settings.volSound.mouseX;
			var snd:Sound = new buzz();
			chanel = snd.play();
			stVolume.volume = Number( settings.volSound.pos.width / 200 );
			chanel.soundTransform = stVolume;
		}
	}
}
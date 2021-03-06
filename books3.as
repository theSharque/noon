﻿package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.net.navigateToURL;
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
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class books3 extends MovieClip {
		private var stVolume:SoundTransform = new SoundTransform( Number( root.loaderInfo.parameters.sv ) / 100, 0 );
		private var startPage:int = int( root.loaderInfo.parameters.sp );
		private var msgTo:String = root.loaderInfo.parameters.msgto;
		private var selfNick:String = root.loaderInfo.parameters.sn;
		private var selfUid:String = root.loaderInfo.parameters.uid;
		private var chanel:SoundChannel;

		private var qTween:Tween;
		private var lTween:Tween;
		private var mTween:Tween;
		private var sTween:Tween;
		private var rTween:Tween;
		private var pTween:Tween;
		private var tTween:Tween;

		private var myFormat:TextFormat = new TextFormat();
		private var myHeadFormat:TextFormat = new TextFormat();
		private var nopLoader:URLLoader = new URLLoader();

		private var myMonoFormat:TextFormat = new TextFormat();
		private var myMonoHeadFormat:TextFormat = new TextFormat();

		private var iLoader:URLLoader = new URLLoader();
		
		private var mLoader:URLLoader = new URLLoader();
		private var msgLoader:URLLoader = new URLLoader();
		private var msgDp:DataProvider = new DataProvider();

		private var lLoader:URLLoader = new URLLoader();
		private var lrnLoader:URLLoader = new URLLoader();
		private var lrnTimer:Timer=new Timer(1000);
		private var lrnStartTime:Number = (new Date()).valueOf();
		private var lrnDp:DataProvider = new DataProvider();

		private var qLoader:URLLoader = new URLLoader();
		private var qDescLoader:URLLoader = new URLLoader();
		private var qDp:DataProvider = new DataProvider();
		private var qPos:int = -1;

		private var sLoader:URLLoader = new URLLoader();
		private var sDp:DataProvider = new DataProvider();

		private var rLoader:URLLoader = new URLLoader();
		private var frDp:DataProvider = new DataProvider();
		private var foDp:DataProvider = new DataProvider();
		private var igDp:DataProvider = new DataProvider();

		private var hintTimer:Timer=new Timer(3000);
		private var hintName:String;
		private var hLoader:URLLoader = new URLLoader();

		public function books3() {
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
			payCalc.btnPal.addEventListener( MouseEvent.CLICK, payPal );
			payCalc.dtNick.addEventListener(Event.CHANGE, checkNick);

			root.addEventListener( MouseEvent.MOUSE_OVER, startHint );
			hintTimer.addEventListener(TimerEvent.TIMER, loadHint);
			hLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			hLoader.addEventListener(Event.COMPLETE, hintLoaded);
			root.addEventListener( MouseEvent.MOUSE_OUT, hideHint );

			iLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			iLoader.addEventListener(Event.COMPLETE, loadLeftSide);
//			iLoader.load(new URLRequest("d:\page13.txt"));
			iLoader.load(new URLRequest("page.php?id=13"));

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

			messages.btn_messages.addEventListener(MouseEvent.CLICK, PageMessagesUp);
			messages.btn_delete.visible=false;
			messages.btn_delete_all.visible=false;
			messages.btn_reply.visible=false;
			messages.btn_write.visible=false;
			messages.dgListMsg.addEventListener( Event.CHANGE, msgChange );
			messages.dgListMsg.setRendererStyle( "textFormat", myFormat );
			messages.dgListMsg.setStyle( "headerTextFormat", myHeadFormat );
			messages.dgListMsg.addColumn( "От" );
			messages.dgListMsg.addColumn( "Дата сообщения" );
			messages.dgListMsg.addColumn( "Текст" );
			messages.dgListMsg.columns[0].width=100;
			messages.dgListMsg.columns[1].width=140;
			messages.dgListMsg.columns[2].width=432;
			messages.dgListMsg.dataProvider=msgDp;
			messages.dgListMsg.setStyle("cellRenderer",AlternatingRowColors);
			mLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			mLoader.addEventListener(Event.COMPLETE, loadMessages);
//			mLoader.load(new URLRequest("d:\page125.txt"));
			mLoader.load(new URLRequest("page.php?id=125"));
			msgLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			msgLoader.addEventListener(Event.COMPLETE, msgLoaded);
			messages.btn_delete.addEventListener(MouseEvent.CLICK, msgDelete);
			messages.btn_reply.addEventListener(MouseEvent.CLICK, showSend);
			messages.btn_write.addEventListener(MouseEvent.CLICK, showSend);
			messages.btn_delete_all.addEventListener(MouseEvent.CLICK, msgDeleteAll);

			learn.btn_learn.addEventListener(MouseEvent.CLICK, PageLearnUp);
			learn.btn_start_learn.visible=false;
			learn.btnInstall.visible=false;
			learn.dgListLrn.addEventListener( Event.CHANGE, lrnChange );
			learn.dgListLrn.setRendererStyle( "textFormat", myFormat );
			learn.dgListLrn.setStyle( "headerTextFormat", myHeadFormat );
			learn.dgListLrn.addColumn( "Наименование" );
			learn.dgListLrn.addColumn( "Уровень" );
			learn.dgListLrn.addColumn( "Время обучения" );
			learn.dgListLrn.columns[0].width = 460;
			learn.dgListLrn.columns[1].width = 80;
			learn.dgListLrn.columns[2].width = 150;
			learn.dgListLrn.dataProvider=lrnDp;
			learn.dgListLrn.setStyle("cellRenderer",AlternatingRowColors);
			lLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			lLoader.addEventListener(Event.COMPLETE, loadLearn);
//			lLoader.load(new URLRequest("d:\page122.txt"));
			lLoader.load(new URLRequest("page.php?id=122"));
			lrnLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			lrnLoader.addEventListener(Event.COMPLETE, lrnLoaded);
			learn.btn_start_learn.addEventListener(MouseEvent.CLICK, lrnStart);
			learn.btnInstall.addEventListener(MouseEvent.CLICK, lrnStart);
			lrnTimer.addEventListener(TimerEvent.TIMER, lrnTimeUp);

			quest.btn_quest.addEventListener(MouseEvent.CLICK, PageQuestUp);

			quest.dgListQst.addEventListener( Event.CHANGE, qChange );
			quest.dgListQst.setRendererStyle( "textFormat", myFormat );
			quest.dgListQst.setStyle( "headerTextFormat", myHeadFormat );
			quest.dgListQst.addColumn( "Краткое описание" );
			quest.dgListQst.dataProvider = qDp;
			quest.dgListQst.setStyle("cellRenderer",AlternatingRowColors);
			qLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			qLoader.addEventListener(Event.COMPLETE, loadQuest);
//			qLoader.load(new URLRequest("d:\page11.txt"));
			qLoader.load(new URLRequest("page.php?id=11"));
			quest.butQuest.visible=false;
			quest.butQuestStop.visible=false;
			quest.butQuest.addEventListener(MouseEvent.CLICK, qStart);
			quest.butQuestStop.addEventListener(MouseEvent.CLICK, qStop);
			quest.btn_delete.visible=false;
			quest.btn_delete.addEventListener(MouseEvent.CLICK, qDelete);

			qDescLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			qDescLoader.addEventListener(Event.COMPLETE, qDescLoaded);

			stat.btn_stat.addEventListener(MouseEvent.CLICK, PageStatUp);
			stat.btnRename.visible = false;
			stat.btnMine.visible = false;
			stat.btnStop.visible = false;
			stat.btnDisp.visible = false;
			stat.btnDispAll.visible = false;
			stat.btnDefence.visible = false;
			stat.dgList.addEventListener( Event.CHANGE, statChange );
			stat.dgList.setRendererStyle( "textFormat", myFormat );
			stat.dgList.setStyle( "headerTextFormat", myHeadFormat );
			stat.dgList.addColumn( "Объекты владения" );
			stat.dgList.dataProvider=sDp;
			stat.dgList.setStyle("cellRenderer",AlternatingRowColors);
			sLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			sLoader.addEventListener(Event.COMPLETE, loadStat);
//			sLoader.load(new URLRequest("d:\page131.txt"));
			sLoader.load(new URLRequest("page.php?id=131"));
			stat.mSure.btnSetup.addEventListener(MouseEvent.CLICK, clickDefence);
			stat.mSure.btnCancel.addEventListener(MouseEvent.CLICK, hideSure);
			stat.mSure.visible = false;
			stat.mSure.alpha = 0;

			relation.btn_relation.addEventListener(MouseEvent.CLICK, PageRelationUp);
			relation.dgFriend.addEventListener( Event.CHANGE, friendClick );
			relation.dgFriend.setRendererStyle( "textFormat", myFormat );
			relation.dgFriend.setStyle( "headerTextFormat", myHeadFormat );
			relation.dgFriend.addColumn( "Друзья" );
			relation.dgFriend.dataProvider=frDp;
			relation.dgFriend.setStyle("cellRenderer",AlternatingRowColors);
			relation.dgFoe.addEventListener( Event.CHANGE, foeClick );
			relation.dgFoe.setRendererStyle( "textFormat", myFormat );
			relation.dgFoe.setStyle( "headerTextFormat", myHeadFormat );
			relation.dgFoe.addColumn( "Враги" );
			relation.dgFoe.dataProvider=foDp;
			relation.dgFoe.setStyle("cellRenderer",AlternatingRowColors);
			relation.dgIgnore.addEventListener( Event.CHANGE, ignoreClick );
			relation.dgIgnore.setRendererStyle( "textFormat", myFormat );
			relation.dgIgnore.setStyle( "headerTextFormat", myHeadFormat );
			relation.dgIgnore.addColumn( "Игнорирование" );
			relation.dgIgnore.dataProvider=igDp;
			relation.dgIgnore.setStyle("cellRenderer",AlternatingRowColors);
			relation.btnInfo.visible=false;
			relation.btnInfo.addEventListener(MouseEvent.CLICK, infoClick);
			rLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			rLoader.addEventListener(Event.COMPLETE, loadRelation);
//			rLoader.load(new URLRequest("d:\page151.txt"));
			rLoader.load(new URLRequest("page.php?id=151"));

			pRename.btnRename.addEventListener(MouseEvent.CLICK, clickRename);
			pRename.btnCancel.addEventListener(MouseEvent.CLICK, hideRename);
			pRename.visible = false;
			pRename.alpha = 0;

			stat.btnRename.addEventListener(MouseEvent.CLICK, showRename);
			stat.btnMine.addEventListener(MouseEvent.CLICK, clickMine);
			stat.btnStop.addEventListener(MouseEvent.CLICK, clickStop);
			stat.btnDisp.addEventListener(MouseEvent.CLICK, clickDisp);
			stat.btnDispAll.addEventListener(MouseEvent.CLICK, clickDispAll);
			stat.btnDefence.addEventListener(MouseEvent.CLICK, showSure);

			pSend.btnSend.addEventListener(MouseEvent.CLICK, clickSend);
			pSend.btnCancel.addEventListener(MouseEvent.CLICK, hideSend);
			pSend.dtTo.addEventListener(Event.CHANGE, checkName);
			pSend.visible = false;
			pSend.alpha = 0;
			
			if( msgTo ) {
				showSend( null );
			}

			if( startPage == 2 ) {
				PageLearnUp( null );
			}
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

		private function payPal( e:MouseEvent ) {
			navigateToURL( new URLRequest("paypal.php"), "main" );
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
				hLoader.load( new URLRequest( "page.php?id=8&asc=books_"+hintName ) );
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

		private function friendClick(event:Event) {
			relation.dgIgnore.selectedIndex = -1;
			relation.dgFoe.selectedIndex = -1;
			relation.btnInfo.visible=true;
		}

		private function foeClick(event:Event) {
			relation.dgIgnore.selectedIndex = -1;
			relation.dgFriend.selectedIndex = -1;
			relation.btnInfo.visible=true;
		}

		private function ignoreClick(event:Event) {
			relation.dgFoe.selectedIndex = -1;
			relation.dgFriend.selectedIndex = -1;
			relation.btnInfo.visible=true;
		}

		private function loadRelation(event:Event) {
			var i:uint;

			if( rLoader.data.err == 0 ) {

				frDp.removeAll();
				if( rLoader.data.frcnt > 0 ) {
					for ( i = 0; i < rLoader.data.frcnt; i++ ) {
						var frFill = new Array();
						frFill["Друзья"] = rLoader.data["fr"+i];
						if( rLoader.data["frc"+i] ) {
							frFill["bgColor"] = rLoader.data["frc"+i];
						}
						frDp.addItem( frFill );
					}
				}

				foDp.removeAll();
				if( rLoader.data.focnt > 0 ) {
					for ( i = 0; i < rLoader.data.focnt; i++ ) {
						var foFill = new Array();
						foFill["Враги"] = rLoader.data["fo"+i];
						if( rLoader.data["foc"+i] ) {
							foFill["bgColor"] = rLoader.data["foc"+i];
						}
						foDp.addItem( foFill );
					}
				}

				igDp.removeAll();
				if( rLoader.data.cicnt > 0 ) {
					for ( i = 0; i < rLoader.data.cicnt; i++ ) {
						var igFill = new Array();
						igFill["Игнорирование"] = rLoader.data["ci"+i];
						if( rLoader.data["cic"+i] ) {
							igFill["bgColor"] = rLoader.data["cic"+i];
						}
						igDp.addItem( igFill );
					}
				}
			}
		}

		private function infoClick( e:MouseEvent ) {
			if( relation.dgFoe.selectedIndex >= 0 ) {
				navigateToURL( new URLRequest("page.php?id=18&login="+rLoader.data["fo"+relation.dgFoe.selectedIndex]), "main" );
			}
			if( relation.dgFriend.selectedIndex >= 0 ) {
				navigateToURL( new URLRequest("page.php?id=18&login="+rLoader.data["fr"+relation.dgFriend.selectedIndex]), "main" );
			}
			if( relation.dgIgnore.selectedIndex >= 0 ) {
				navigateToURL( new URLRequest("page.php?id=18&login="+rLoader.data["ci"+relation.dgIgnore.selectedIndex]), "main" );
			}
		}

		private function clickSend( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			hideSend( e );

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));

			nopLoader.load(new URLRequest( "page.php?id=129&to="+escape( pSend.dtTo.text )+"&text="+escape( pSend.dtText.text )));
		}

		public function checkName( event:Event ) {
			nopLoader.addEventListener(Event.COMPLETE, checkedName);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=128&user="+escape( pSend.dtTo.text )));
		}

		public function checkedName( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, checkedName );
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			if( nopLoader.data.err != 0 ) {
				inGlow.color = 0xFF0000;
				pSend.btnSend.visible = false;
			} else {
				pSend.btnSend.visible = true;
			}

			pSend.bgTo.filters = [inGlow, outGlow];
		}

		public function clickMine( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=133&ord=2&oid="+sLoader.data["id"+stat.dgList.selectedIndex] ));
		}

		public function clickStop( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=133&ord=6&oid="+sLoader.data["id"+stat.dgList.selectedIndex] ));
		}

		public function clickDisp( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=133&ord=4&oid="+sLoader.data["id"+stat.dgList.selectedIndex] ));
		}

		public function clickDispAll( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=133&ord=3&oid="+sLoader.data["id"+stat.dgList.selectedIndex] ));
		}

		public function showSure( e:MouseEvent ) {
			stat.mSure.visible = true;
			tTween = new Tween(stat.mSure,"alpha",Strong.easeOut,stat.mSure.alpha,1,1,true);
		}

		public function hideSure( e:MouseEvent ) {
			tTween = new Tween(stat.mSure,"alpha",Strong.easeOut,stat.mSure.alpha,0,1,true);
			tTween.addEventListener(TweenEvent.MOTION_FINISH, mUnvisible);
		}

		public function mUnvisible( event:Event ) {
			stat.mSure.visible = false;
		}

		public function clickDefence( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=134&oid="+sLoader.data["id"+stat.dgList.selectedIndex] ));
			hideSure( e );
		}

		public function showRename( e:MouseEvent ) {
			pRename.visible = true;
			pRename.dtNewName.text = '';
			rTween = new Tween(pRename, "alpha", Strong.easeOut, pRename.alpha, 1, 1, true);
		}

		public function hideRename( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			rTween = new Tween(pRename, "alpha", Strong.easeOut, pRename.alpha, 0, 1, true);
			rTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function showSend( e:MouseEvent ) {
			var outGlow:GlowFilter = new GlowFilter(0x0000FF, 1, 5, 5, 2, 1, false, false);
			var inGlow:GlowFilter = new GlowFilter(0x00FFFF, 0.4, 10, 10, 2, 3, true, false);

			pSend.visible = true;
			pSend.dtText.text = '';
			if( msgTo ) {
				pSend.dtTo.text = msgTo;
				checkName( null );
			} else {
				pSend.dtTo.text = '';
			}

			pSend.bgTo.filters = [inGlow, outGlow];
			rTween = new Tween(pSend, "alpha", Strong.easeOut, pSend.alpha, 1, 1, true);
		}

		public function hideSend( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			rTween = new Tween(pSend, "alpha", Strong.easeOut, pSend.alpha, 0, 1, true);
			rTween.addEventListener(TweenEvent.MOTION_FINISH, pUnvisible);
		}

		public function pUnvisible( event:Event ) {
			pRename.visible = false;
			pSend.visible = false;
			payCalc.visible = false;
		}

		private function clickRename( e:MouseEvent ) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;
			hideRename( e );

			nopLoader.addEventListener(Event.COMPLETE, refreshAll);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( "page.php?id=133&ord=1&oid="+sLoader.data["id"+stat.dgList.selectedIndex]+"&name="+escape( pRename.dtNewName.text )));
		}

		private function refreshAll( event:Event ) {
			event.target.removeEventListener( Event.COMPLETE, refreshAll );
			iLoader.load(new URLRequest("page.php?id=13"));
			qLoader.load(new URLRequest("page.php?id=11"));
			sLoader.load(new URLRequest("page.php?id=131"));
		}

		private function loadLeftSide(event:Event) {
			if ( int(iLoader.data.err) == 0 ) {
				movLeftSide.dtHomeStar.text=iLoader.data.hstar;
				movLeftSide.dtHomePlanet.text=iLoader.data.hplanet;
				movLeftSide.dtStar.text=iLoader.data.sname;
				movLeftSide.dtPlanet.text=iLoader.data.pname;
				movLeftSide.dtCredits.text=iLoader.data.summ;
				movLeftSide.dtConfederates.text=iLoader.data.conf;
				movLeftSide.dtRobots.text=iLoader.data.robots;
				movLeftSide.dtWar.text=iLoader.data.c_wr;
				movLeftSide.dtStatus.text=iLoader.data.c_st;
				movLeftSide.dtLevel.text=iLoader.data.c_lv;
				movLeftSide.dtReferal.text=iLoader.data.referal;
				movLeftSide.dtInsur.htmlText=iLoader.data.insur;
				movLeftSide.dtRefCnt.text=iLoader.data.refcnt;
				if (iLoader.data.link!='0') {
					movLeftSide.dtLink.text = "Купить";
					movLeftSide.dtLink.addEventListener( MouseEvent.CLICK, showPay );
					//movLeftSide.dtLink.htmlText="<a href="+unescape(iLoader.data.link)+">Купить</a>";
				}
			}
		}

		private function loadMessages(event:Event) {
			var i:uint;
			messages.btn_delete.visible=false;
			messages.btn_reply.visible=false;
			messages.btn_write.visible=true;
			messages.btn_delete_all.visible=false;
			msgDp.removeAll();
			if (mLoader.data.cnt>0) {
				for (i=0; i<mLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["От"]=mLoader.data["from"+i];
					dgFill["Дата сообщения"]=mLoader.data["time"+i];
					dgFill["Текст"]=mLoader.data["text"+i];
					if( mLoader.data["rd"+i] == 0 ) {
						dgFill["bgColor"] = "0x000066";
					} else {
						dgFill["bgColor"] = "0x000033"
					}
					msgDp.addItem(dgFill);
				}
				messages.btn_delete_all.visible=true;
			}
		}

		private function msgChange(event:Event) {
			var iPos:Array;
			messages.dtTextMsg.htmlText="Загрузка...";
			messages.btn_delete.visible=false;
//			msgLoader.load(new URLRequest("d:\page126.txt"));
			msgLoader.load(new URLRequest("page.php?id=126&msgid="+mLoader.data["id"+messages.dgListMsg.selectedIndex]));
			mLoader.data["rd"+messages.dgListMsg.selectedIndex] = 1;
			iPos = messages.dgListMsg.selectedIndices;
			loadMessages( event );
			messages.dgListMsg.selectedIndices = iPos;
		}

		private function msgLoaded(event:Event) {
			if (msgLoader.data.err==0) {
				messages.dtTextMsg.htmlText=msgLoader.data.text;
				messages.dtScroll.update();
				if (messages.dtScroll.enabled == false) {
					messages.dtScroll.visible = false; 
				} else {
					messages.dtScroll.visible = true;
				}
				messages.btn_delete.visible=true;

				if( msgLoader.data.reply ) {
					msgTo = mLoader.data["from"+messages.dgListMsg.selectedIndex];
					messages.btn_write.visible=false;
					messages.btn_reply.visible=true;
				} else {
					msgTo = '';
					messages.btn_reply.visible=false;
					messages.btn_write.visible=true;
				}
			}
		}

		public function msgDelete(e:MouseEvent) {
			var i:uint;
			var btUrl:String="page.php?id=127&cnt="+messages.dgListMsg.selectedIndices.length;
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			for (i=0; i<messages.dgListMsg.selectedIndices.length; i++) {
				btUrl=btUrl+"&mid"+i+"="+mLoader.data["id"+messages.dgListMsg.selectedIndices[i]];
			}
			nopLoader.addEventListener(Event.COMPLETE, afterDelete);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest( btUrl ));
		}

		public function msgDeleteAll(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, afterDelete);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=127&all=true"));
		}

		private function afterDelete(event:Event) {
			event.target.removeEventListener( Event.COMPLETE, afterDelete );
			messages.dtTextMsg.htmlText='';
//			mLoader.load(new URLRequest("d:\page125.txt"));
			mLoader.load(new URLRequest("page.php?id=125"));
		}

		private function lrnRefresh() {
			var i:uint;
			var iPos:uint = 0;
			var diff:uint = 0;
			var currentTime:Number = (new Date()).valueOf();

			if (lLoader.data.cnt>0) {
				if( learn.dgListLrn.selectedIndex ) {
					iPos=learn.dgListLrn.selectedIndex;
				}
				lrnDp.removeAll();
				for (i=0; i<lLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Наименование"]=lLoader.data["name"+i];
					dgFill["Уровень"]=lLoader.data["lev"+i];
					switch( lLoader.data["time"+i] ) {
						case "0" :
							dgFill["bgColor"] = "0x666666";
							dgFill["Время обучения"]="Изучено";
							break;

						case "-100" :
							dgFill["bgColor"] = "0x006600";
							dgFill["Время обучения"]="Имплантант";
							break;

						case "-200" :
							dgFill["bgColor"] = "0x336633";
							dgFill["Время обучения"]="Установлен";
							break;

						case "-1000" :
							dgFill["bgColor"] = "0x000000";
							dgFill["Время обучения"]="Недоступно";
							break;

						default :
							if (! isNaN(lLoader.data["tp"+i])) {
								diff = uint( ( uint( lLoader.data["tp" + i] * 1000 ) - ( currentTime - lrnStartTime ) ) / 1000 );
								if (diff > 0) {
									var vD:uint = uint( diff / 86400 );
									diff = diff % 86400;
									var vH = uint( diff / 3600 );
									diff = diff % 3600;
									var vM = uint( diff / 60 );
									var vS = diff % 60;
									var timestring:String="";
									if (vD>0) {
										timestring=vD+".";
									}
									if( vH >= 10 ) {
										timestring += vH+":";
									} else {
										timestring += "0"+vH+":";
									}

									if( vM >= 10 ) {
										timestring += vM+":";
									} else {
										timestring += "0"+vM+":";
									}

									if( vS >= 10 ) {
										timestring += vS;
									} else {
										timestring += "0"+vS;
									}

									dgFill["Время обучения"]=timestring;
									dgFill["bgColor"] = "0x006600";
								} else {
									lrnTimer.stop();
									lrnTimer.reset();
//									lLoader.load(new URLRequest("d:\page122.txt"));
									lLoader.load(new URLRequest("page.php?id=122"));
									break;
								}
							} else {
								dgFill["Время обучения"]=lLoader.data["time"+i];
							}
							break;
					}
					lrnDp.addItem(dgFill);
				}
				learn.dgListLrn.selectedIndex=iPos;
			}
		}

		private function loadLearn(event:Event) {
			lrnStartTime = (new Date()).valueOf();
			learn.btn_start_learn.visible=false;
			lrnRefresh();
			lrnTimer.start();
		}

		private function lrnChange(event:Event) {
			learn.dtTextLrn.htmlText = "Загрузка...";
//			lrnLoader.load(new URLRequest("d:\page123.txt"));
			lrnLoader.load(new URLRequest("page.php?id=123&bookid="+lLoader.data["id"+learn.dgListLrn.selectedIndex]));
			if ( lLoader.data["time"+learn.dgListLrn.selectedIndex] <= 0 ||
				lLoader.data["tp"+learn.dgListLrn.selectedIndex] > 0 ||
				lLoader.data.bid > lLoader.data.lmax ) {
				learn.btn_start_learn.visible=false;
			} else {
				learn.btn_start_learn.visible=true;
			}
			
			if( lLoader.data["inst"+learn.dgListLrn.selectedIndex] ) {
				learn.btnInstall.visible=true;
			} else {
				learn.btnInstall.visible=false;
			}
		}

		private function lrnLoaded(event:Event) {
			learn.dtTextLrn.htmlText=lrnLoader.data.desc;
			learn.dtScroll.update();
			if (learn.dtScroll.enabled == false) {
				learn.dtScroll.visible = false;
			} else {
				learn.dtScroll.visible = true;
			}
		}

		public function lrnStart(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			learn.btn_start_learn.visible=false;
			learn.btnInstall.visible=false;

			nopLoader.addEventListener(Event.COMPLETE, afterStartLearn);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=124&book_id="+lLoader.data["id"+learn.dgListLrn.selectedIndex]));
		}

		private function afterStartLearn(event:Event) {
			event.target.removeEventListener( Event.COMPLETE, afterStartLearn );
			learn.dtTextLrn.htmlText='';
//			lLoader.load(new URLRequest("d:\page122.txt"));
			lLoader.load(new URLRequest("page.php?id=122"));
		}

		private function lrnTimeUp(e:TimerEvent) {
			lrnRefresh();
		}

		private function loadQuest(event:Event) {
			var i:uint;
			qPos = -1;
			if (qLoader.data.cnt>0) {
				quest.butQuest.visible=false;
				quest.butQuestStop.visible=false;
				quest.btn_delete.visible=false;
				qDp.removeAll();
				for (i=0; i<qLoader.data.cnt; i++) {
					var dgFill = new Array();
					dgFill["Краткое описание"] = qLoader.data["n"+i];
					if( qLoader.data.p == i ) {
						qPos = i;
						dgFill["bgColor"] = '0x006600';
					}

					if( qLoader.data["m"+i] == 1 ) {
						dgFill["bgColor"] = '0x000066';
					}

					qDp.addItem(dgFill);
				}
			}
			if( qLoader.data.decline ) {
				qPos = qLoader.data.cnt + 1;
			}
		}

		private function qChange(event:Event) {
			quest.dtTextQst.htmlText = "Загрузка...";
//			qDescLoader.load(new URLRequest("d:\page12.txt"));
			qDescLoader.load(new URLRequest("page.php?id=12&qid="+qLoader.data["id"+quest.dgListQst.selectedIndex]));
			if( qLoader.data.hidetype != 1 && qPos >= 0 && quest.dgListQst.selectedIndex == qPos ) {
				quest.butQuestStop.visible=true;
			} else {
				quest.butQuestStop.visible=false;
			}

			if( qLoader.data["m"+quest.dgListQst.selectedIndex] == 1 ) {
				quest.btn_delete.visible=true;
			} else {
				quest.btn_delete.visible=false;
			}

			if( qPos == -1 ) {
				quest.butQuest.visible=true;
			} else {
				quest.butQuest.visible=false;
			}
		}
		
		private function qStart(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, qComander);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=16&qid="+qLoader.data["id"+quest.dgListQst.selectedIndex]));
		}

		private function qStop(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, qComander);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=17&qid="+qLoader.data["id"+quest.dgListQst.selectedIndex]));
		}

		private function qDelete(e:MouseEvent) {
			var snd:Sound = new buzz();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			nopLoader.addEventListener(Event.COMPLETE, qComander);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=161&qid="+qLoader.data["id"+quest.dgListQst.selectedIndex]));
		}

		private function qComander(event:Event) {
			event.target.removeEventListener( Event.COMPLETE, qComander );
			quest.dtTextQst.htmlText='';
//			qLoader.load(new URLRequest("d:\page11.txt"));
			qLoader.load(new URLRequest("page.php?id=11"));
		}

		private function qDescLoaded(event:Event) {
			quest.dtTextQst.htmlText=qDescLoader.data.desc;
			quest.dtScroll.update();
			if (quest.dtScroll.enabled == false) {
				quest.dtScroll.visible = false;
			} else {
				quest.dtScroll.visible = true;
			}
		}

		private function loadStat(event:Event) {
			var i:uint;
			var iPos:int;
			if( stat.dgList.selectedIndex >= 0 ) {
				iPos = stat.dgList.selectedIndex;
			} else {
				iPos = 0;
			}
			if( sLoader.data.err == 0 && sLoader.data.cnt > 0 ) {
				sDp.removeAll();
				for ( i = 0; i < sLoader.data.cnt; i++ ) {
					var dgFill = new Array();
					dgFill["Объекты владения"] = sLoader.data["n"+i];
					if( sLoader.data["c"+i] ) {
						dgFill["bgColor"] = sLoader.data["c"+i];
					}
					sDp.addItem( dgFill );
				}
				stat.dgList.selectedIndex = iPos;
				statChange( event );
			}
		}

		private function statChange(event:Event) {
			nopLoader.addEventListener(Event.COMPLETE, loadStatInfo);
//			nopLoader.load(new URLRequest("d:\nop.txt"));
			nopLoader.load(new URLRequest("page.php?id=132&oid="+sLoader.data["id"+stat.dgList.selectedIndex]));
		}

		private function loadStatInfo(event:Event) {
			event.target.removeEventListener( Event.COMPLETE, loadStatInfo );

			if( nopLoader.data.err == 0 ) {
				stat.dtStarPlanet.htmlText = sLoader.data["n"+stat.dgList.selectedIndex];
				stat.dtDefType.htmlText = nopLoader.data.defType;
				stat.dtPlanetBuildings.htmlText = nopLoader.data.pbcnt;
				stat.dtOrbitBuildings.htmlText = nopLoader.data.obcnt;
				stat.dtPlanetShield.htmlText = nopLoader.data.pshld;
				stat.dtPlanetAtack.htmlText = nopLoader.data.patck;
				stat.dtPlanetShips.htmlText = nopLoader.data.pship;
				stat.dtPlanetWare.htmlText = nopLoader.data.pware;
				stat.dtOrbitShield.htmlText = nopLoader.data.oshld;
				stat.dtOrbitAtack.htmlText = nopLoader.data.oatck;
				stat.dtOrbitShips.htmlText = nopLoader.data.oship;
				stat.dtOrbitWare.htmlText = nopLoader.data.oware;
				stat.dtDefence.htmlText = nopLoader.data.defence;

				if( nopLoader.data.def == 1 ) {
					stat.btnDefence.visible = true;
				} else {
					stat.btnDefence.visible = false;
				}

				if( nopLoader.data.ren == 1 ) {
					stat.btnRename.visible = true;
					stat.dtRename.htmlText=nopLoader.data.tren;
				} else {
					stat.btnRename.visible = false;
					stat.dtRename.htmlText=nopLoader.data.tren;
				}
				switch( int( nopLoader.data.auto ) ) {
					case 3:
						stat.btnMine.visible = true;
						stat.btnStop.visible = true;
						stat.btnDisp.visible = true;
						stat.btnDispAll.visible = true;
						break;
					case 1 :
						stat.btnMine.visible = true;
						stat.btnStop.visible = true;
						stat.btnDisp.visible = false;
						stat.btnDispAll.visible = false;
						break;
					default :
						stat.btnMine.visible = false;
						stat.btnStop.visible = false;
						stat.btnDisp.visible = false;
						stat.btnDispAll.visible = false;
						break;
				}
			}
		}

		public function PageMessagesUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( messages, 4 );
			setChildIndex( learn, 3 );
			setChildIndex( quest, 2 );
			setChildIndex( stat, 1 );
			setChildIndex( relation, 0 );
			mTween = new Tween(messages, "alpha", Strong.easeOut, messages.alpha, 1, 1, true);
			lTween = new Tween(learn, "alpha", Strong.easeOut, learn.alpha, 0.5, 1, true);
			qTween = new Tween(quest, "alpha", Strong.easeOut, quest.alpha, 0.5, 1, true);
			sTween = new Tween(stat, "alpha", Strong.easeOut, stat.alpha, 0.5, 1, true);
			rTween = new Tween(relation, "alpha", Strong.easeOut, relation.alpha, 0.5, 1, true);
		}

		public function PageLearnUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( learn, 4 );
			setChildIndex( quest, 3 );
			setChildIndex( messages, 2 );
			setChildIndex( stat, 1 );
			setChildIndex( relation, 0 );
			lTween = new Tween(learn, "alpha", Strong.easeOut, learn.alpha, 1, 1, true);
			mTween = new Tween(messages, "alpha", Strong.easeOut, messages.alpha, 0.5, 1, true);
			qTween = new Tween(quest, "alpha", Strong.easeOut, quest.alpha, 0.5, 1, true);
			sTween = new Tween(stat, "alpha", Strong.easeOut, stat.alpha, 0.5, 1, true);
			rTween = new Tween(relation, "alpha", Strong.easeOut, relation.alpha, 0.5, 1, true);
		}

		public function PageQuestUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( quest, 4 );
			setChildIndex( learn, 3 );
			setChildIndex( messages, 2 );
			setChildIndex( stat, 1 );
			setChildIndex( relation, 0 );
			qTween = new Tween(quest, "alpha", Strong.easeOut, quest.alpha, 1, 1, true);
			lTween = new Tween(learn, "alpha", Strong.easeOut, learn.alpha, 0.5, 1, true);
			mTween = new Tween(messages, "alpha", Strong.easeOut, messages.alpha, 0.5, 1, true);
			sTween = new Tween(stat, "alpha", Strong.easeOut, stat.alpha, 0.5, 1, true);
			rTween = new Tween(relation, "alpha", Strong.easeOut, relation.alpha, 0.5, 1, true);
		}

		public function PageStatUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( stat, 4 );
			setChildIndex( relation, 3 );
			setChildIndex( quest, 2 );
			setChildIndex( learn, 1 );
			setChildIndex( messages, 0 );
			sTween = new Tween(stat, "alpha", Strong.easeOut, stat.alpha, 1, 1, true);
			qTween = new Tween(quest, "alpha", Strong.easeOut, quest.alpha, 0.5, 1, true);
			lTween = new Tween(learn, "alpha", Strong.easeOut, learn.alpha, 0.5, 1, true);
			mTween = new Tween(messages, "alpha", Strong.easeOut, messages.alpha, 0.5, 1, true);
			rTween = new Tween(relation, "alpha", Strong.easeOut, relation.alpha, 0.5, 1, true);
		}

		public function PageRelationUp(e:MouseEvent) {
			var snd:Sound = new scratch();
			chanel = snd.play();
			chanel.soundTransform = stVolume;

			setChildIndex( relation, 4 );
			setChildIndex( stat, 3 );
			setChildIndex( quest, 2 );
			setChildIndex( learn, 1 );
			setChildIndex( messages, 0 );
			rTween = new Tween(relation, "alpha", Strong.easeOut, relation.alpha, 1, 1, true);
			sTween = new Tween(stat, "alpha", Strong.easeOut, stat.alpha, 0.5, 1, true);
			qTween = new Tween(quest, "alpha", Strong.easeOut, quest.alpha, 0.5, 1, true);
			lTween = new Tween(learn, "alpha", Strong.easeOut, learn.alpha, 0.5, 1, true);
			mTween = new Tween(messages, "alpha", Strong.easeOut, messages.alpha, 0.5, 1, true);
		}
	}
}
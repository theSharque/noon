package {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	public class pTimer extends Timer {
		private var iFinal:int;
		private var iTotal:int;
		private var iCnt:int;
		private var mvObj:MovieClip;
		private var nStartTime:Number = (new Date()).valueOf();
		private var fRefresh:Function;
		private var piX:int;
		private var piY:int;

		public function pTimer( fin:int, tot:int, cnt:int, obj:MovieClip, color:int, func:Function, iX:int, iY:int ) {
			iFinal = fin;
			iTotal = tot;
			iCnt = cnt;
			mvObj = obj;
			nStartTime = (new Date()).valueOf();
			fRefresh = func;
			piX = iX;
			piY = iY;

			super( 500 );
			this.addEventListener(TimerEvent.TIMER, doTick);
			obj.disp.textColor = color;
		}
		
		public function doTick( e:TimerEvent ) {
			var nCurrentTime:Number = (new Date()).valueOf();
			var diff:int = int( ( int( iFinal * 1000 ) - ( nCurrentTime - nStartTime ) ) / 1000 );
			var nDif:Number = ( iFinal * 1000 - ( nCurrentTime - nStartTime ) ) / 1000;
			if( diff > 0 ) {
				var vD:uint = int( diff / 86400 );
				diff = diff % 86400;
				var vH:int = int( diff / 3600 );
				diff = diff % 3600;
				var vM:int = int( diff / 60 );
				var vS:int = diff % 60;
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
				mvObj.disp.text = timestring
				mvObj.cnt.x = -30 + iCnt * 5;
				mvObj.lin.x = 20 + ( -50 / ( iTotal / nDif ) );
			} else {
				if( iCnt > 0 ) {
					iCnt--;
					iFinal = iTotal;
					nStartTime = (new Date()).valueOf();
				} else if( iCnt < 0 ) {
					iFinal = iTotal;
					nStartTime = (new Date()).valueOf();
				} else if( iCnt == 0 ) {
					this.stop();
					mvObj.parent.removeChild( mvObj );
					fRefresh( piX, piY );
				}
			}
		}
	}
}
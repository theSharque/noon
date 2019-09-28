package {
    import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ICellRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
    import flash.display.Sprite;
    import flash.geom.Rectangle;

	public class AlternatingRowColors extends CellRenderer implements ICellRenderer {
		
		public function AlternatingRowColors():void {
			super();
		}

		public static function getStyleDefinition():Object {
			return CellRenderer.getStyleDefinition();
		}

		override protected function drawLayout():void {
			var tf:TextFormat;
			textField.width = this.width;
			if( !isNaN( Number( String( textField.text ).split( " " ).join( "" ) ) ) ) {
				tf = textField.getTextFormat();
				tf.align = TextFormatAlign.RIGHT;
				textField.setTextFormat(tf);
			}
			super.drawLayout();
        }

		override protected function drawBackground():void {
            var temp:Sprite = new Sprite();
			temp.graphics.beginFill(0x999999);
   	        temp.graphics.drawRect(0,0,100,100);
       	    temp.graphics.endFill();
			if( data.bgColor ) {
				temp.graphics.beginFill(data.bgColor);
			} else {
				temp.graphics.beginFill( 0x000033 );
			}
			temp.graphics.drawRect(1,0,99,99);
			temp.graphics.endFill();
			temp.scale9Grid = new Rectangle(1,1,98,98);
			setStyle("upSkin", temp);
			super.drawBackground();			
		}
	}
}
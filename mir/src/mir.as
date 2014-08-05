package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;
	
	import mir.MirBmp;
	import mir.Utils;
	
	public class mir extends Sprite {
		public function mir() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.color = 0x808080;

			Utils.loadAsset("http://mir.qww.pw/0", function(bytes:ByteArray):void {
				var bmp:MirBmp;
				bmp = Utils.extractMirBmp(bytes);
				bmp = Utils.extractMirBmp(bytes);
				addChild(new Bitmap(bmp.bitmap));
			});
		}
	}
}
package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mir.Res;
	import mir.Util;
	
	public final class UI extends Sprite {
		private const main:Bitmap = new Bitmap();

		public function UI() {
			addChild(main);
		}

		public function test(n:int):void {
			Util.copyMirBitmapDataToBitmap(Res.ui.g(n.toString()), main, new Rectangle(0,30));
			if (main.bitmapData)
				trace(n, main.x, main.y, main.bitmapData.width, main.bitmapData.height);
			else
				trace(n, main.x, main.y);
		}

		private function init():void {
		}
	}
}
package  {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.Res;
	import mir.Utils;
	
	public class Ground extends Sprite {
		public var struct:StructGround;
		public var timer:Timer;
		public var map_x:int;
		public var map_y:int;

		public function Ground() {
			Utils.loadBinary(Const.ASSETS_DOMAIN + "ground.bin", f);
			var bmp:Bitmap;
			var w:int, h:int;
			for (h = 0; h < 6; h++) {
				for (w = 0; w < 8; w++) {
					bmp = new Bitmap();
					bmp.x = w * 96;
					bmp.y = h * 64;
					addChild(bmp);
				}
			}

			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timer_task);
			timer.start();
			addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				map_x++;
				map_y++;
				update();
			});
		}

		public function f(bytes:ByteArray):void {
			struct = new StructGround(bytes);
			update();
		}
		
		private function update():void {
			if (!struct) return
			var w:int, h:int;
			var i:int;
			for (h = 0; h < 6; h++) {
				for (w = 0; w < 8; w++) {
					(getChildAt(i++) as Bitmap).bitmapData = Res.tiles.g(struct.g(w+map_x, h+map_y));
				}
			}
		}

		private function timer_task(e:TimerEvent):void {
			trace(10);
			update();
		}
	}
}
package  {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.Res;
	import mir.Utils;
	
	public final class Ground extends Sprite {
		public var struct:StructGround;
		public var timer:Timer;

		private var mapX:int;
		private var mapY:int;

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
				mapX++;
				update();
			});
			addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				var t:Timer = new Timer(100, 6);
				t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
					if (t.currentCount != t.repeatCount) {
						y -= 64/6;
						Debug.trace(y);
					}
				});
				t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
					y = 0;
					mapY++;
					update();
				});
				t.start();
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
					(getChildAt(i++) as Bitmap).bitmapData = Res.tiles.g(struct.g(w+mapX, h+mapY));
				}
			}
		}

		private function timer_task(e:TimerEvent):void {
			update();
		}
	}
}
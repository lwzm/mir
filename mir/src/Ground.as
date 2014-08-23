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

		private var stepsX:Array;
		private var stepsY:Array;
		private var mX:int=320;
		private var mY:int=0;
		private var mX_:int;
		private var mY_:int;
		private static const FRAME:int = 6;
		private static const FRAME_RATE:int = 100;

		public function Ground() {
			Utils.loadBinary(Const.ASSETS_DOMAIN + "ground.bin", function(bytes:ByteArray):void {
				struct = new StructGround(bytes);
				update();
			});
			var bmp:Bitmap;
			var w:int, h:int;
			for (h = 0; h < Const.TILE_Y / 2; h++) {
				for (w = 0; w < Const.TILE_X / 2; w++) {
					bmp = new Bitmap();
					bmp.x = w * (0+Const.TILE_W) * 2;
					bmp.y = h * (0+Const.TILE_H) * 2;
					addChild(bmp);
				}
			}

			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timer_task);
			timer.start();
			reg();
		}
		
		public function go():void {
			var t:Timer = new Timer(FRAME_RATE, FRAME);
			function t1(e:TimerEvent):void {
				var i:int = t.currentCount - 1;
				if (i != t.repeatCount) {
					x = stepsX[i];
					y = stepsY[i];
				}
			}
			function t2(e:TimerEvent):void {
				var i:int = t.currentCount - 1;
				mX = mX_;
				mY = mY_;
				if (mX % 2) {
					x = stepsX[i];
					y = stepsY[i];
				} else {
					update();
				}
				t.removeEventListener(TimerEvent.TIMER, t1);
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, t2);
			}
			t.addEventListener(TimerEvent.TIMER, t1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, t2);
			t.start();
		}

		public function get mapX():int { return mX; }
		public function get mapY():int { return mY; }

		public function set mapX(n:int):void {
			stepsX = Utils.steps(x, Const.TILE_W * (mX - n) + x, FRAME);
			mX_ = n;
		}

		public function set mapY(n:int):void {
			stepsY = Utils.steps(y, Const.TILE_H * (mY - n) + y, FRAME);
			mY_ = n;
		}

		private function reg():void {
			addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				mapX += (e.altKey ? 2 : 1) * (e.ctrlKey ? 1 : -1);
				mapY += (e.altKey ? 2 : 1) * (e.ctrlKey ? 1 : -1);
				trace([stepsX, stepsY]);
				go();
			});
			addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				mapY += (e.altKey ? 2 : 1) * (e.ctrlKey ? 1 : -1);
			});
		}

		
		private function update():void {
			if (!struct) return;
			var w:int, h:int, i:int, _x:int, _y:int;
			x = -(mX % 2) * Const.TILE_W;
			y = -(mY % 2) * Const.TILE_H;
			for (h = 0; h < Const.TILE_Y / 2; h++) {
				for (w = 0; w < Const.TILE_X / 2; w++) {
					_x = w + mX / 2;
					_y = h + mY / 2;
					(getChildAt(i++) as Bitmap).bitmapData = (_x >= 0 && _y >= 0) ? Res.tiles.g(struct.g(_x, _y)) : null;
				}
			}
		}

		private function timer_task(e:TimerEvent):void {
			if (!struct) return;
			Debug.trace([x, y, mX, mY]);
			var w:int, h:int, i:int, _x:int, _y:int;
			var bmp:Bitmap;
			for (h = 0; h < Const.TILE_Y / 2; h++) {
				for (w = 0; w < Const.TILE_X / 2; w++) {
					_x = w + mX / 2;
					_y = h + mY / 2;
					bmp = getChildAt(i++) as Bitmap;
					(_x >= 0 && _y >= 0 && !bmp.bitmapData) ? bmp.bitmapData = Res.tiles.g(struct.g(_x, _y)) : null;
				}
			}
		}
	}
}
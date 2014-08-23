package mir  {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	
	public final class Ground extends Sprite {
		public var struct:StructGround;

		private var stepsX:Array;
		private var stepsY:Array;
		private var mX:int=300;
		private var mY:int=300;
		private var mX_:int;
		private var mY_:int;
		private var idx:int;
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

			var t:Timer = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, timer_task);
			t.start();
			reg();
		}
		
		public function f1():void {
			stepsX ? x = stepsX[idx] : null;
			stepsY ? y = stepsY[idx] : null;
			++idx;
		}

		public function f2():void {
			if (stepsX) {
				x = stepsX.pop();
				mX = mX_;
				mX % 2 ? null : update();
			}
			if (stepsY) {
				y = stepsY.pop();
				mY = mY_;
				mY % 2 ? null : update();
			}
			idx = 0;
			stepsX = stepsY = null;
		}

		private function go():void {
			var t:Timer = new Timer(FRAME_RATE, FRAME);
			var i:int;
			function t1(e:TimerEvent):void {
				if (t.currentCount != t.repeatCount) {
					f1();
				}
			}
			function t2(e:TimerEvent):void {
				f2();
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
//				mapY += (e.altKey ? 2 : 1) * (e.ctrlKey ? 1 : -1);
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
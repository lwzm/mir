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
		private var mX:int;
		private var mY:int;
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
			for (h = 0; h < Const.TILE_Y; h += 2) {
				for (w = 0; w < Const.TILE_X; w += 2) {
					bmp = new Bitmap();
					bmp.x = Const.TILE_W * w;
					bmp.y = Const.TILE_H * h;
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
			}
			if (stepsY) {
				y = stepsY.pop();
				mY = mY_;
			}
			idx = 0;
			stepsX = stepsY = null;
			update();
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
				mapY += (e.altKey ? 2 : 1) * (e.ctrlKey ? 1 : -1);
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
			for (h = 0; h < Const.TILE_Y; h += 2) {
				for (w = 0; w < Const.TILE_X; w += 2) {
					_x = w + mX;
					_y = h + mY;
					setTile(getChildAt(i++) as Bitmap, _x, _y);
				}
			}
		}

		private function timer_task(e:TimerEvent):void {
			if (!struct) return;
			var w:int, h:int, i:int, _x:int, _y:int;
			for (h = 0; h < Const.TILE_Y; h += 2) {
				for (w = 0; w < Const.TILE_X; w += 2) {
					_x = w + mX;
					_y = h + mY;
					setTile(getChildAt(i++) as Bitmap, _x, _y, true);
				}
			}
		}
		
		private function setTile(bmp:Bitmap, x:int, y:int, lazy:Boolean=false):void {
			var s:String;
			if (x >= 0 && y >= 0) {
				if (lazy && bmp.bitmapData) return;
				s = struct.g(x, y);
				if (s) {
					bmp.bitmapData = Res.tiles.g(s);
				} else {
					bmp.bitmapData = null;
				}
			}
		}
	}
}
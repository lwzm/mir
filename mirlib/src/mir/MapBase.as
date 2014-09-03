package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class MapBase extends Sprite {
//		public var struct:IMapStruct;
		public var struct:StructMapBase;
		
		private var timer:Timer;

		protected var mX:int;
		protected var mY:int;

		private var stepsX:Array;
		private var stepsY:Array;
		private var mX_:int;
		private var mY_:int;
		private var idx:int;

		private static const FRAME:int = 6;

		public function MapBase(asset:String) {
			x = Const.MAP_OFFSET_X;
			y = Const.MAP_OFFSET_Y;
			initChildren();
			Util.loadBinary(Const.ASSETS_DOMAIN + asset, buildStruct);
		}
		
		protected function initChildren():void { throw Error }
		protected function initStruct(bytes:ByteArray):void { throw Error }
		protected function update(active:Boolean=false):void { throw Error }

		private function buildStruct(bytes:ByteArray):void {
			initStruct(bytes);
			update(true);
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, update_periodically);
			timer.start();
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
			struct && update(true);
		}

		public function get mapX():int { return mX; }
		public function get mapY():int { return mY; }

		public function set mapX(n:int):void {
			if (mX == n) return;
			stepsX = Util.steps(x, Const.TILE_W * (mX - n) + x, FRAME);
			mX_ = n;
		}

		public function set mapY(n:int):void {
			if (mY == n) return;
			stepsY = Util.steps(y, Const.TILE_H * (mY - n) + y, FRAME);
			mY_ = n;
		}

		private function update_periodically(e:TimerEvent):void {
			update();
		}
	}
}
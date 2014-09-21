package mir {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Role extends Sprite {
		public static const MOTION_DEFAULT:int = 0;
		public static const EVENT_MOTION:String = "mirMotion";
		public static const EVENT_MOTION_END:String = "mirMotionEnd";

		public const shadow:Sprite = new Sprite();

		public var direction:int;
		public var shadowVisible:Boolean;
		private var ended:Boolean;

		private const filtersRecord:Object = {};

		private var aniLastStep:int;

		protected var motionNext:int;
		protected var motionCurrent:int;
		protected var aniIdx:int;

		
		public function Role() {
			mouseEnabled = false;
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = false;
			hitArea = Res.hitArea;

			hitArea.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				addFilter("highlight");
				shadow.visible = true;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				delFilter("highlight");
				shadow.visible = shadowVisible;
			});
			
			ended = true;
		}
		
		protected function initAni():int { throw Error; }
		protected function tryAni():void { throw Error; }
		protected function applyAni():void { throw Error; }

		public function ani():void {
			if (breakable) {
				aniIdx = 0;
				motionCurrent = motionNext;
				motionNext = MOTION_DEFAULT;
                ended = false;
				aniLastStep = initAni();
			} else {
				tryAni();
			}
			applyAni();
			dispatchEvent(new Event(EVENT_MOTION));
			if (aniIdx === aniLastStep) {
                ended = true;
				dispatchEvent(new Event(EVENT_MOTION_END));
			}
			++aniIdx;
		}

		public function get n():int {
			return aniIdx;
		}

		public function get breakable():Boolean {
			return ended || (motionNext !== MOTION_DEFAULT && motionCurrent === MOTION_DEFAULT)
		}

		override public function set x(n:Number):void {
			super.x = n;
			shadow.x = n;
			hitArea.x = n;
		}

		override public function set y(n:Number):void {
			super.y = n;
			shadow.y = n;
			hitArea.y = n;
		}

		public function get motion():int {
			return motionCurrent;
		}

		public function set motion(n:int):void {
			motionNext = n;
		}

		private function applyFiltersRecord():void {
			var name:String;
			var arr:Array = [];
			for (name in filtersRecord) {
				arr.push(Filters[name]);
			}
			shadow.filters = filters = arr;
		}

		public function addFilter(name:String):void {
			filtersRecord[name] = true;
			applyFiltersRecord();
		}

		public function delFilter(name:String):void {
			delete filtersRecord[name];
			applyFiltersRecord();
		}

	}
}
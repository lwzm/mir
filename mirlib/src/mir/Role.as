package mir {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Role extends Sprite {
		public static const MOTION_DEFAULT:int = 0;
		public static const EVENT_MOTION:String = "mirMotion";
		public static const EVENT_MOTION_END:String = "mirMotionEnd";

		public const shadow:Sprite = new Sprite();
		public const effects:Sprite = new Sprite();
		private const filtersRecord:Object = {};

		public var shadowVisible:Boolean;
		public var direction:int;
		public var aniIdx:int;
		protected var aniLastStep:int;
		protected var motionNext:int;
		protected var motionCurrent:int;

		private var end:Boolean;

		public function Role() {
			mouseEnabled = false;
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = false;
			
			effects.mouseEnabled = false;

			hitArea = Res.hitArea;

			hitArea.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				addFilter("highlight");
				shadow.visible = true;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				delFilter("highlight");
				shadow.visible = shadowVisible;
			});
			
			end = true;
		}
		
		protected function initAni():void { throw Error; }
		protected function tryAni():void { throw Error; }
		protected function applyAni():void { throw Error; }

		public function ani(_:Event=null):void {
			if (resetable) {
				end = false;
				aniIdx = 0;
				motionCurrent = motionNext;
				motionNext = MOTION_DEFAULT;
				initAni();
			} else {
				tryAni();
			}
			applyAni();
			dispatchEvent(new Event(EVENT_MOTION));
			if (aniIdx >= aniLastStep) {
				end = true;
				dispatchEvent(new Event(EVENT_MOTION_END));
			}
			++aniIdx;
		}

		private function get resetable():Boolean {
			return end || (motionNext !== MOTION_DEFAULT && motionCurrent === MOTION_DEFAULT)
		}

		override public function set x(n:Number):void {
			super.x = n;
			shadow.x = n;
			effects.x = n;
			hitArea.x = n;
		}

		override public function set y(n:Number):void {
			super.y = n;
			shadow.y = n;
			effects.y = n;
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
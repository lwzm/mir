package mir {
	/*
	center hero: (376, 209)
	*/
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public final class Hero extends Sprite {

		public static const DELAIES:Array = [500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 150];

		public static const MOTION_DEFAULT:int = 0;
		public static const MOTION_WALK:int = 1;
		public static const MOTION_RUN:int = 2;

		public var shadow:Sprite;

		private var timer:Timer;
		private var bmpBody:Bitmap;
		private var bmpHair:Bitmap;
		private var bmpWeapon:Bitmap;
		private var bmpBodyShadow:Bitmap;
		private var bmpHairShadow:Bitmap;
		private var bmpWeaponShadow:Bitmap;

		public var nameBody:String;
		public var nameHair:String;
		public var nameWeapon:String;

		public var shadowVisible:Boolean;
		
//		public var deltaX:int;
//		public var deltaY:int;
//		public var stepsX:Array;
//		public var stepsY:Array;
//		public var stepsX:Vector.<int>;
//		public var stepsY:Vector.<int>;

		private var arrBody:Array;
		private var arrHair:Array;
		private var arrWeapon:Array;
		private var arrLength:int;

		private var _b:int;
		private var _h:int;
		private var _w:int;
		private var _s:int;
		private var _m:int;
		private var _m_todo:int;
		private var _d:int;
		private var _d_todo:int;

		private var filtersRecord:Object;
		private var aniIdx:int;
		
		private var hooks:Vector.<Function>;
		private var hooksTodo:Vector.<Function>;

		public function Hero() {
			mouseEnabled = false;
			shadow = new Sprite();
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = false;
			hitArea = new Sprite();
			hitArea.graphics.beginFill(0, 0.0);
			hitArea.graphics.drawRect(0,-32,48,64);
			hitArea.graphics.drawCircle(0,0,3);
			bmpBody = new Bitmap();
			bmpHair = new Bitmap();
			bmpWeapon = new Bitmap();
			bmpBodyShadow = new Bitmap();
			bmpHairShadow = new Bitmap();
			bmpWeaponShadow = new Bitmap();
			addChild(bmpBody);
			addChild(bmpHair);
			addChild(bmpWeapon);
			shadow.addChild(bmpBodyShadow);
			shadow.addChild(bmpHairShadow);
			shadow.addChild(bmpWeaponShadow);

			timer = new Timer(DELAIES[0]);
			timer.addEventListener(TimerEvent.TIMER, animate);
			timer.start();

			filtersRecord = {};

			body = hair = weapon = sex = motion = direction = 0;
			tuneLayers(isUp(_d));

			hitArea.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				addFilter("highlight");
				shadow.visible = true;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				delFilter("highlight");
				shadow.visible = shadowVisible;
			});
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

		private function animate(e:TimerEvent):void {
			var b:MirBitmapData, h:MirBitmapData, w:MirBitmapData;
			if (aniIdx == 0) {
				exeHook(0);
				switchDelay();
				switchLayers();
				renameThem();
				arrBody = Res.bodies.g(nameBody);
				arrHair = _h ? Res.hairs.g(nameHair) : RemoteMultiple.dummy;
				arrWeapon = _w ? Res.weapons.g(nameWeapon) : RemoteMultiple.dummy;
				arrLength = arrBody.length;
				hooks = hooksTodo;
				hooksTodo = null;
			} else {
				if (!arrBody[0]) {  // retry body
					arrBody = Res.bodies.g(nameBody);
					arrLength = arrBody.length;
				}
			}
			b = arrBody[aniIdx] as MirBitmapData;
			h = arrHair[aniIdx] as MirBitmapData;
			w = arrWeapon[aniIdx] as MirBitmapData;
			Util.copyMirBitmapDataToBitmap(b, bmpBody);
			Util.copyMirBitmapDataToBitmap(h, bmpHair);
			Util.copyMirBitmapDataToBitmap(w, bmpWeapon);
			Util.copyMirBitmapDataToBitmap(b, bmpBodyShadow);
			Util.copyMirBitmapDataToBitmap(h, bmpHairShadow);
			Util.copyMirBitmapDataToBitmap(w, bmpWeaponShadow);
			tuneXY();
			if (++aniIdx < arrLength) {
				exeHook(1);
			} else {
				exeHook(2);
				if (_m_todo === -1) {
					if (_m !== MOTION_DEFAULT) {
						timer.delay = 3000;
						trace('b');
					}
					_m = MOTION_DEFAULT;
				} else {
					_m = _m_todo;
				}
				_m_todo = -1;
				aniIdx = 0;
			}
		}

		private function tuneXY():void {
			var deltaX:int, deltaY:int;
			switch (_m) {
				case MOTION_WALK:
					deltaX = Const.WALK_DIRECTIONS_X_DELTA[_d][aniIdx];
					deltaY = Const.WALK_DIRECTIONS_Y_DELTA[_d][aniIdx];
					break;
				case MOTION_RUN:
					deltaX = Const.RUN_DIRECTIONS_X_DELTA[_d][aniIdx];
					deltaY = Const.RUN_DIRECTIONS_Y_DELTA[_d][aniIdx];
					break;
				default:
					break;
			}
			if (deltaX) {
				x += deltaX;
			}
			if (deltaY) {
				y += deltaY;
			}
		}

		private function exeHook(i:int):void {
			if (hooks && hooks[i]) {
				hooks[i]()
			}
		}

		private function setHook(i:int, f:Function):void {
			if (!hooksTodo) {
				hooksTodo = new Vector.<Function>(4);
			}
			hooksTodo[i] = f;
		}

		public function set hook0(f:Function):void { setHook(0, f); }
		public function set hook1(f:Function):void { setHook(1, f); }
		public function set hook2(f:Function):void { setHook(2, f); }
		public function set hook3(f:Function):void { setHook(3, f); }

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

		public function get body():int { return _b; }
		public function get hair():int { return _h; }
		public function get weapon():int { return _w; }
		public function get sex():int { return _s; }
		public function get motion():int { return _m; }
		public function get direction():int { return _d; }

		public function set body(b:int):void {
			_b = b;
			nameBody = buildName(b);
		}
		public function set hair(h:int):void {
			_h = h;
			nameHair = buildName(h);
		}
		public function set weapon(w:int):void {
			_w = w;
			nameWeapon = buildName(w);
		}
		public function set sex(s:int):void {
			_s = s;
			renameThem();
		}

		public function set motion(m:int):void {
			if (_m == MOTION_DEFAULT) {
				_m = m;
				aniIdx = 0;
				switchDelay();
				renameThem();
			} else {
				_m_todo = m;
			}
		}

		public function set direction(d:int):void {
			_d_todo = d;
		}
		
		private function switchDelay():void {
			var delay:Number = DELAIES[_m];
			if (timer.delay != delay) {
				timer.delay = delay;
			}
		}

		private function switchLayers():void {
			if (_d != _d_todo) {
				var w0:Boolean = isUp(_d);
				var w1:Boolean = isUp(_d_todo);
				if (w0 !== w1) {
					tuneLayers(w1);
				}
				_d = _d_todo;
			}
		}

		private function renameThem():void {
			nameBody = buildName(body);
			nameHair = buildName(hair);
			nameWeapon = buildName(weapon);
		}

		private function buildName(x:int):String {
			/* _s < 2; _m < 11; _d < 8; */
			return (x * 22 + _s * 11 + _m).toString() + _d.toString(16);
		}

		private static function isUp(d:int):Boolean {  // is weapon upper?
			return d >= 1 && d <= 4;
		}

		private function tuneLayers(isWeaponUp:Boolean):void {
			if (isWeaponUp) {
				setChildIndex(bmpWeapon, 2);
				shadow.setChildIndex(bmpWeaponShadow, 2);
			} else {
				setChildIndex(bmpWeapon, 0);
				shadow.setChildIndex(bmpWeaponShadow, 0);
			}
		}
	}
}

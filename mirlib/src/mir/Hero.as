package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public final class Hero extends Sprite {

		public static const DELAIES:Array = [500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 150];
		public static const MIRBMP_DEFAULT:Array = [null];
		public static const MOTION_DEFAULT:int = 0;

		public var timer:Timer;

		public var shadow:Sprite;
		public var bmpBody:Bitmap;
		public var bmpHair:Bitmap;
		public var bmpWeapon:Bitmap;
		public var bmpBodyShadow:Bitmap;
		public var bmpHairShadow:Bitmap;
		public var bmpWeaponShadow:Bitmap;
		private var arrBody:Array;
		private var arrHair:Array;
		private var arrWeapon:Array;
		private var arrLength:int;

		public var nameBody:String;
		public var nameHair:String;
		public var nameWeapon:String;
		
		public var deltaX:Number = 0;
		public var deltaY:Number = 0;
		private var _delta_x:Number = 0;
		private var _delta_y:Number = 0;

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
		
		public function Hero() {
			blendMode = BlendMode.NORMAL;
			mouseEnabled = false;
			shadow = new Sprite();
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = false;
			hitArea = new Sprite();
			hitArea.graphics.beginFill(0, 0);
			hitArea.graphics.drawRect(0,-32,48,64);
			bmpBody = new Bitmap();
			bmpHair = new Bitmap();
			bmpWeapon = new Bitmap();
			bmpBodyShadow = new Bitmap();
			bmpHairShadow = new Bitmap();
			bmpWeaponShadow = new Bitmap();
			timer = new Timer(DELAIES[0]);
			filtersRecord = {};
			body = hair = weapon = sex = motion = direction = 0;
			tuneLayers(isUp(_d));

			timer.addEventListener(TimerEvent.TIMER, timer_task);
			timer.start();
			
			hitArea.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				motion = 1;
//				deltaX = 48;
			});
			hitArea.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
//				motion = 2;
//				deltaY = -64;
				direction = (direction+1) % 8;
				motion = 0;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				addFilter("highlight");
				shadow.visible = true;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				delFilter("highlight");
				shadow.visible = false;
			});
		}

		public function addFilter(name:String):void {
			if (name in filtersRecord)
				return
			var arr:Array = filters;
			filtersRecord[name] = arr.length;
			arr.push(Filters[name]);
			shadow.filters = filters = arr;
		}

		public function delFilter(name:String):void {
			shadow.filters = filters = filters.filter(function(item:*, index:int, array:Array):Boolean {
				return index !== filtersRecord[name];
			});
			delete filtersRecord[name];
		}

		private function timer_task(e:TimerEvent):void {
			update();
		}

		private function update():void {
			if (aniIdx == 0) {
				arrBody = Res.bodies.g(nameBody);
				arrHair = _h ? Res.hairs.g(nameHair) : MIRBMP_DEFAULT;
				arrWeapon = _w ? Res.weapons.g(nameWeapon) : MIRBMP_DEFAULT;
				arrLength = Math.max(arrBody.length, arrHair.length, arrWeapon.length);
				_delta_x = deltaX / arrLength;
				_delta_y = deltaY / arrLength;
				deltaX = deltaY = 0;
			}
			var b:MirBitmapData = arrBody[aniIdx] as MirBitmapData;
			var h:MirBitmapData = arrHair[aniIdx] as MirBitmapData;
			var w:MirBitmapData = arrWeapon[aniIdx] as MirBitmapData;
			Utils.copyMirBitmapDataToBitmap(b, bmpBody);
			Utils.copyMirBitmapDataToBitmap(h, bmpHair);
			Utils.copyMirBitmapDataToBitmap(w, bmpWeapon);
			Utils.copyMirBitmapDataToBitmap(b, bmpBodyShadow);
			Utils.copyMirBitmapDataToBitmap(h, bmpHairShadow);
			Utils.copyMirBitmapDataToBitmap(w, bmpWeaponShadow);
			x += _delta_x;
			y += _delta_y;
			if (++aniIdx >= arrLength) {
				_delta_x = _delta_y = 0;
				_m = _m_todo;
				_m_todo = MOTION_DEFAULT;
				swc();
			}
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
				swc();
			} else {
				_m_todo = m;
			}
		}

		public function set direction(d:int):void {
			_d_todo = d;
		}
		
		private function swc():void {
			aniIdx = 0;
			var delay:int = DELAIES[_m];
			if (timer.delay != delay) {
				timer.delay = delay;
			}
			if (_d != _d_todo) {
				var w0:Boolean = isUp(_d);
				var w1:Boolean = isUp(_d_todo);
				if (w0 !== w1) {
					tuneLayers(w1);
				}
				_d = _d_todo;
			}
			renameThem();
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
				addChild(bmpBody);
				addChild(bmpHair);
				addChild(bmpWeapon);
				shadow.addChild(bmpBodyShadow);
				shadow.addChild(bmpHairShadow);
				shadow.addChild(bmpWeaponShadow);
			} else {
				addChild(bmpWeapon);
				addChild(bmpBody);
				addChild(bmpHair);
				shadow.addChild(bmpWeaponShadow);
				shadow.addChild(bmpBodyShadow);
				shadow.addChild(bmpHairShadow);
			}
		}
	}
}
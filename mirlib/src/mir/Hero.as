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

		public var nameBody:String;
		public var nameHair:String;
		public var nameWeapon:String;

		private var _b:int;
		private var _h:int;
		private var _w:int;
		private var _s:int;
		private var _m:int;
		private var _m_todo:int;
		private var _d:int;
		private var _d_todo:int;
		private var _lock:Boolean;

		private var filtersRecord:Object;
		private var aniIdx:int;
		
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

		public function Hero() {
//			alpha = 0;
//			buttonMode = true;
//			useHandCursor = true;
			mouseEnabled = false;
			shadow = new Sprite();
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = false;
			hitArea = new Sprite();
			hitArea.graphics.beginFill(0, 0);
			hitArea.graphics.drawRect(0,0,48,32);//todo
			blendMode = BlendMode.NORMAL;
			bmpBody = new Bitmap();
			bmpHair = new Bitmap();
			bmpWeapon = new Bitmap();
			bmpBodyShadow = new Bitmap();
			bmpHairShadow = new Bitmap();
			bmpWeaponShadow = new Bitmap();
			timer = new Timer(DELAIES[0]);
			filtersRecord = {};
			body = hair = weapon = sex = motion = direction = 0;
			tuneLayers(isup(_d));
			timer.addEventListener(TimerEvent.TIMER, timer_task);
			timer.start();
			
			hitArea.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				motion = 1;
			});
			hitArea.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				motion = 2;
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				addFilter("highlight");
				shadow.visible = true;
				trace('in');
			});
			hitArea.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				delFilter("highlight");
				shadow.visible = false;
				trace('out');
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
			var arr_b:Array, arr_h:Array, arr_w:Array;
			arr_b = Res.bodies.g(nameBody);
			arr_h = _h ? Res.hairs.g(nameHair) : MIRBMP_DEFAULT;
			arr_w = _w ? Res.weapons.g(nameWeapon) : MIRBMP_DEFAULT;
			Utils.copyMirBitmapDataToBitmap(arr_b[aniIdx] as MirBitmapData, bmpBody);
			Utils.copyMirBitmapDataToBitmap(arr_h[aniIdx] as MirBitmapData, bmpHair);
			Utils.copyMirBitmapDataToBitmap(arr_w[aniIdx] as MirBitmapData, bmpWeapon);
			Utils.copyMirBitmapDataToBitmap(arr_b[aniIdx] as MirBitmapData, bmpBodyShadow);
			Utils.copyMirBitmapDataToBitmap(arr_h[aniIdx] as MirBitmapData, bmpHairShadow);
			Utils.copyMirBitmapDataToBitmap(arr_w[aniIdx] as MirBitmapData, bmpWeaponShadow);
			if (++aniIdx >= Math.max(arr_b.length, arr_h.length, arr_w.length)) {
				_lock = false;
				if (_m_todo != MOTION_DEFAULT) {
					motion = _m_todo;
					_m_todo = MOTION_DEFAULT;
				} else {
					motion = _m_todo;
				}
			}
		}

		public function get body():int { return _b; }
		public function get hair():int { return _h; }
		public function get weapon():int { return _w; }
		public function get sex():int { return _s; }
		public function get motion():int { return _m; }
		public function get direction():int { return _d; }

		public function set body(b:int):void {
			_b = b;
			nameBody = build_name(b);
		}
		public function set hair(h:int):void {
			_h = h;
			nameHair = build_name(h);
		}
		public function set weapon(w:int):void {
			_w = w;
			nameWeapon = build_name(w);
		}
		public function set sex(s:int):void {
			_s = s;
			rename_them();
		}

		public function set motion(m:int):void {
			if (_m != MOTION_DEFAULT && _lock) {
				_m_todo = m;
			} else {
				aniIdx = 0;
				_lock = true;
				_m = m;
				var delay:int = DELAIES[m];
				if (timer.delay != delay) {
					timer.delay = delay;
				}
				if (_d != _d_todo) {
					var w0:Boolean = isup(_d);
					var w1:Boolean = isup(_d_todo);
					if (w0 !== w1) {
						tuneLayers(w1);
					}
					_d = _d_todo;
				}
				rename_them();
			}
		}

		public function set direction(d:int):void {
			_d_todo = d;
			/*
			rename_them();
			if (d >= 1 && d <= 4) {
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
			*/
		}

		private function rename_them():void {
			nameBody = build_name(body);
			nameHair = build_name(hair);
			nameWeapon = build_name(weapon);
		}

		private function build_name(x:int):String {
			/* _s < 2; _m < 11; _d < 8; */
			return (x * 22 + _s * 11 + _m).toString() + _d.toString(16);
		}

		private static function isup(d:int):Boolean {  // is weapon upper?
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
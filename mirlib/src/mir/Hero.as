package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Hero extends Sprite {

		public static const delaies:Array = [500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 150];
		public static const mirbmp_default:Array = [null];
		public static const motion_default:int = 0;

		public var timer:Timer;

		public var bmp_body:Bitmap;
		public var bmp_hair:Bitmap;
		public var bmp_weapon:Bitmap;

		public var name_body:String;
		public var name_hair:String;
		public var name_weapon:String;

		private var _b:int;
		private var _h:int;
		private var _w:int;
		private var _s:int;
		private var _m:int;
		private var _m_todo:int;
		private var _m_lock:Boolean;
		private var _d:int;

		private var filters_record:Object;
		private var animation_index:int;

		public function Hero() {
			blendMode = BlendMode.NORMAL;
			bmp_body = new Bitmap();
			bmp_hair = new Bitmap();
			bmp_weapon = new Bitmap();
			timer = new Timer(delaies[0]);
			filters_record = {};
			body = 0;
			hair = 0;
			weapon = 0;
			sex = 0;
			direction = 0;
			motion = 0;
			timer.addEventListener(TimerEvent.TIMER, timer_task);
			timer.start();
			
			addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				motion = 1;
			});
			addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				motion = 2;
			});
			addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				var arr:Array = filters;
				filters_record.highlight = arr.length;
				arr.push(Filters.highlight);
				filters = arr;
			});
			addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				filters = filters.filter(function(item:*, index:int, array:Array):Boolean {
					return index !== filters_record.highlight;
				});
			});
		}

		private function timer_task(e:TimerEvent):void {
			var arr_b:Array, arr_h:Array, arr_w:Array;
			arr_b = Res.bodies.g(name_body);
			arr_h = _h ? Res.hairs.g(name_hair) : mirbmp_default;
			arr_w = _w ? Res.weapons.g(name_weapon) : mirbmp_default;
			Utils.copyMirBitmapDataToBitmap(arr_b[animation_index] as MirBitmapData, bmp_body);
			Utils.copyMirBitmapDataToBitmap(arr_h[animation_index] as MirBitmapData, bmp_hair);
			Utils.copyMirBitmapDataToBitmap(arr_w[animation_index] as MirBitmapData, bmp_weapon);
			if (++animation_index >= Math.max(arr_b.length, arr_h.length, arr_w.length)) {
				_m_lock = false;
				if (_m_todo != motion_default) {
					motion = _m_todo;
					_m_todo = motion_default;
				} else {
					motion = motion_default;
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
			name_body = build_name(b);
		}
		public function set hair(h:int):void {
			_h = h;
			name_hair = build_name(h);
		}
		public function set weapon(w:int):void {
			_w = w;
			name_weapon = build_name(w);
		}
		public function set sex(s:int):void {
			_s = s;
			rename_them();
		}

		public function set motion(m:int):void {
			if (_m != motion_default && _m_lock) {
				_m_todo = m;
			} else {
				animation_index = 0;
				_m_lock = true;
				_m = m;
				rename_them();
				var delay:int = delaies[m];
				if (timer.delay != delay) {
					timer.delay = delay;
				}
			}
		}

		public function set direction(d:int):void {
			_d = d;
			rename_them();
			if (d >= 1 && d <= 4) {
				addChild(bmp_body);
				addChild(bmp_hair);
				addChild(bmp_weapon);
			} else {
				addChild(bmp_weapon);
				addChild(bmp_body);
				addChild(bmp_hair);
			}
		}

		private function rename_them():void {
			name_body = build_name(body);
			name_hair = build_name(hair);
			name_weapon = build_name(weapon);
		}

		private function build_name(x:int):String {
			/* _s < 2; _m < 11; _d < 8; */
			return (x * 22 + _s * 11 + _m).toString() + _d.toString(16);
		}
		
	}
}
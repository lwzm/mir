package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Hero extends Sprite {

		public static const delay_list:Array = [500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 100];

		public var timer:Timer;

		public var bmp_body:Bitmap;
		public var bmp_hair:Bitmap;
		public var bmp_weapon:Bitmap;

		public var name_body:String;
		public var name_hair:String;
		public var name_weapon:String;

		private var _b:uint;
		private var _h:uint;
		private var _w:uint;
		private var _s:uint;
		private var _m:uint;
		private var _d:uint;

		public function Hero() {
			blendMode = BlendMode.NORMAL;
			bmp_body = new Bitmap();
			bmp_hair = new Bitmap();
			bmp_weapon = new Bitmap();
			timer = new Timer(delay_list[0]);
			body = 0;
			hair = 0;
			weapon = 0;
			sex = 0;
			direction = 0;
			motion = 0;
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				var mirbmp:MirBitmapData;
				var n:uint = timer.currentCount;
				mirbmp = Res.bodies.g(name_body, n);
				mirbmp ? mirbmp.to(bmp_body) : null;
				mirbmp = hair ? Res.hairs.g(name_hair, n) : null;
				mirbmp ? mirbmp.to(bmp_hair) : null;
				mirbmp = weapon ? Res.weapons.g(name_weapon, n) : null;
				mirbmp ? mirbmp.to(bmp_weapon) : null;
			});
			timer.start();
		}

		public function get body():uint { return _b; }
		public function set body(body:uint):void {
			_b = body;
			name_body = build_name(body);
		}
		public function get hair():uint { return _h; }
		public function set hair(hair:uint):void {
			_h = hair;
			name_hair = build_name(hair);
		}
		public function get weapon():uint { return _w; }
		public function set weapon(weapon:uint):void {
			_w = weapon;
			name_weapon = build_name(weapon);
		}
		public function get sex():uint { return _s; }
		public function set sex(sex:uint):void {
			_s = sex;
			rename_them();
		}

		public function get motion():uint { return _m; }
		public function set motion(motion:uint):void {
			_m = motion;
			rename_them();
			var delay:uint = delay_list[motion];
			if (timer.delay != delay) {
				timer.delay = delay;
			}
		}

		public function get direction():uint { return _d; }
		public function set direction(direction:uint):void {
			_d = direction;
			rename_them();
			if (direction >= 1 && direction <= 4) {
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

		private function build_name(x:uint):String {
			/* _s < 2; _m < 11; _d < 8; */
			return (x * 22 + _s * 11 + _m).toString() + _d.toString(16);
		}
		
	}
}
package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Hero extends Sprite {

		public static const delay_list:Array = [500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 100];

		public var body_id:uint=0;
		public var hair_id:uint;
		public var weapon_id:uint=11;
		public var sex:uint=1;
		public var frame:uint;

		public var body:Bitmap;
		public var hair:Bitmap;
		public var weapon:Bitmap;

		public var timer:Timer;

		private var d:uint;
		private var m:uint;

		public function Hero() {
			body = new Bitmap();
			hair = new Bitmap();
			weapon = new Bitmap();
			timer = new Timer(delay_list[0]);
			direction = 0;
			motion = 0;
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				frame++;
				update();
			});
			timer.start();
		}

		public function get motion():uint {
			return m;
		}
		public function set motion(motion:uint):void {
			m = motion;
			var delay:uint = delay_list[motion];
			if (timer.delay != delay) {
				timer.delay = delay;
			}
		}

		public function get direction():uint {
			return d;
		}
		public function set direction(direction:uint):void {
			d = direction;
			if (direction >= 1 && direction <= 4) {
				addChild(body);
				addChild(hair);
				addChild(weapon);
			} else {
				addChild(weapon);
				addChild(body);
				addChild(hair);
			}
		}

		public function update():void {
			var mirbmp:MirBitmapData;
			mirbmp = Res.bodies.ggg(body_id, sex, motion, d, frame);
			mirbmp ? mirbmp.to(body) : null;
			mirbmp = hair_id ? Res.hairs.ggg(hair_id, sex, motion, d, frame) : null;
			mirbmp ? mirbmp.to(hair) : null;
			mirbmp = weapon_id ? Res.weapons.ggg(weapon_id, sex, motion, d, frame) : null;
			mirbmp ? mirbmp.to(weapon) : null;
		}
		
	}
}
package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Hero extends Sprite {
		public var body_id:uint;
		public var hair_id:uint=2;
		public var weapon_id:uint=1;
		public var sex:uint;
		public var motion:uint=10;
		public var direction:uint;
		public var frame:uint;

		public var body:Bitmap;
		public var hair:Bitmap;
		public var weapon:Bitmap;

		public var timer:Timer;

		public function update():void {
			if (direction >= 1 && direction <= 4) {
				addChild(body);
				addChild(hair);
				addChild(weapon);
			} else {
				addChild(weapon);
				addChild(body);
				addChild(hair);
			}
			var mirbmp:MirBitmapData;
			mirbmp = Res.bodies.ggg(body_id, sex, motion, direction, frame);
			mirbmp ? mirbmp.to(body) : null;
			mirbmp = Res.hairs.ggg(hair_id, sex, motion, direction, frame);
			mirbmp ? mirbmp.to(hair) : null;
			mirbmp = Res.weapons.ggg(weapon_id, sex, motion, direction, frame);
			mirbmp ? mirbmp.to(weapon) : null;
		}
		
		public static function get max():uint {
			return 1;
		}

		public function Hero() {
			body = new Bitmap();
			hair = new Bitmap();
			weapon = new Bitmap();
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				frame++;
				update();
			});
			timer.start();
			trace(max);
		}

	}
}
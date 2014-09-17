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

		public static const MOTION_DEFAULT:int = 0;
		public static const MOTION_WALK:int = 1;
		public static const MOTION_RUN:int = 2;
		public static const MOTION_WAIT:int = 3;
		public static const MOTION_ATTACK:int = 4;
		public static const MOTION_ATTACK2:int = 5;
		public static const MOTION_ATTACK3:int = 6;
		public static const MOTION_CAST:int = 7;
		public static const MOTION_DIG:int = 8;
		public static const MOTION_HURT:int = 9;
		public static const MOTION_DIE:int = 10;

		public const shadow:Sprite = new Sprite();

		private const bmpBody:Bitmap = new Bitmap();
		private const bmpHair:Bitmap = new Bitmap();
		private const bmpWeapon:Bitmap = new Bitmap();
		private const bmpBodyShadow:Bitmap = new Bitmap();
		private const bmpHairShadow:Bitmap = new Bitmap();
		private const bmpWeaponShadow:Bitmap = new Bitmap();
		private const filtersRecord:Object = {};

		public var nameBody:String;
		public var nameHair:String;
		public var nameWeapon:String;
		
		public var body:int;
		public var hair:int;
		public var weapon:int;
		public var sex:int;
		public var direction:int;
		private var motionNext:int;
		private var motionCurrent:int;

		private var steps:int;
		private var arrBody:Array;
		private var arrHair:Array;
		private var arrWeapon:Array;
		private var aniIdx:int;

		public var ended:Boolean;

		private var shadowVisible:Boolean;
		
		public function Hero(self:Boolean=false) {
			mouseEnabled = false;
			shadow.alpha = 0.5;
			shadow.mouseEnabled = false;
			shadow.visible = shadowVisible = self;
			hitArea = new Sprite();
			hitArea.graphics.beginFill(0, 0.0);
			hitArea.graphics.drawRect(0,-32,48,64);
			hitArea.graphics.drawCircle(0,0,3);
			addChild(bmpBody);
			addChild(bmpHair);
			addChild(bmpWeapon);
			shadow.addChild(bmpBodyShadow);
			shadow.addChild(bmpHairShadow);
			shadow.addChild(bmpWeaponShadow);

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
		
		public function get n():int {
			return aniIdx - 1;
		}

		public function get breakable():Boolean {
			return ended || (motionNext !== MOTION_DEFAULT && motionCurrent === MOTION_DEFAULT)
		}

		public function ani():void {
			var b:MirBitmapData, h:MirBitmapData, w:MirBitmapData;
			if (breakable) {
				aniIdx = 0;
				motionCurrent = motionNext;
				motionNext = MOTION_DEFAULT;
				rebuildNames();
				changeAsset();
				tuneLayers();
                ended = false;
			} else {
				if (!arrBody[0]) {
					changeAsset();  // try again
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
			if (++aniIdx >= steps) {
                ended = true;
			}
		}

		public function get motion():int {
			return motionCurrent;
		}

		public function set motion(n:int):void {
			motionNext = n;
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

		private function changeAsset():void {
			arrBody = Res.bodies.g(nameBody);
			arrHair = Res.hairs.g(nameHair);
			arrWeapon = Res.weapons.g(nameWeapon);
			steps = arrBody.length;
		}
		
		private function rebuildNames():void {
			nameBody = buildName(body);
			nameHair = hair ? buildName(hair) : null;
			nameWeapon = weapon ? buildName(weapon) : null;
		}

		private function buildName(x:int):String {
			/* _s < 2; _m < 11; _d < 8; */
			return (x * 22 + sex * 11 + motionCurrent).toString() + direction.toString(16);
		}

		private function tuneLayers():void {
			if (direction >= 1 && direction <= 4) {
				setChildIndex(bmpWeapon, 2);
				shadow.setChildIndex(bmpWeaponShadow, 2);
			} else {
				setChildIndex(bmpWeapon, 0);
				shadow.setChildIndex(bmpWeaponShadow, 0);
			}
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

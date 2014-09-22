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
	import flash.globalization.LastOperationStatus;
	import flash.utils.Timer;
	
	public final class Hero extends Role {

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

		private const bmpBody:Bitmap = new Bitmap();
		private const bmpHair:Bitmap = new Bitmap();
		private const bmpWeapon:Bitmap = new Bitmap();
		private const bmpBodyShadow:Bitmap = new Bitmap();
		private const bmpHairShadow:Bitmap = new Bitmap();
		private const bmpWeaponShadow:Bitmap = new Bitmap();

		public var nameBody:String;
		public var nameHair:String;
		public var nameWeapon:String;
		
		public var body:int;
		public var hair:int;
		public var weapon:int;
		public var sex:int;

		private var arrBody:Array;
		private var arrHair:Array;
		private var arrWeapon:Array;

		public function Hero(self:Boolean=false) {
			shadow.visible = shadowVisible = self;
			addChild(bmpBody);
			addChild(bmpHair);
			addChild(bmpWeapon);
			shadow.addChild(bmpBodyShadow);
			shadow.addChild(bmpHairShadow);
			shadow.addChild(bmpWeaponShadow);
		}
		
		override protected function initAni():void {
			rebuildNames();
			changeAsset();
			tuneLayers();
			aniLastStep = arrBody.length - 1;
		}
			
		override protected function tryAni():void {
			if (!arrBody[0]) {
				changeAsset();  // try again
				aniLastStep = arrBody.length - 1;
			}
		}

		override protected function applyAni():void {
			const b:MirBitmapData = arrBody[aniIdx] as MirBitmapData;
			const h:MirBitmapData = arrHair[aniIdx] as MirBitmapData;
			const w:MirBitmapData = arrWeapon[aniIdx] as MirBitmapData;
			Util.copyMirBitmapDataToBitmap(b, bmpBody);
			Util.copyMirBitmapDataToBitmap(h, bmpHair);
			Util.copyMirBitmapDataToBitmap(w, bmpWeapon);
			Util.copyMirBitmapDataToBitmap(b, bmpBodyShadow);
			Util.copyMirBitmapDataToBitmap(h, bmpHairShadow);
			Util.copyMirBitmapDataToBitmap(w, bmpWeaponShadow);
		}
			
		private function changeAsset():void {
			arrBody = Res.bodies.g(nameBody);
			arrHair = Res.hairs.g(nameHair);
			arrWeapon = Res.weapons.g(nameWeapon);
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

	}
}

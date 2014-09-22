package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public final class Monster extends Role {

		public static const MOTION_WALK:int = 1;
		public static const MOTION_ATTACK:int = 2;
		public static const MOTION_HURT:int = 3;
		public static const MOTION_DIE:int = 4;
		public static const EFFECT_ATTACK:int = 5;
		public static const EFFECT_DIE:int = 6;
		public static const EFFECT_APPEAR:int = 7;
		public static const EFFECT_DISAPPEAR:int = 8;

		private const bmpBody:Bitmap = new Bitmap();
		private const bmpBodyShadow:Bitmap = new Bitmap();

		public var nameBody:String;
		
		public var body:int;

		private var arrBody:Array;

		public function Monster() {
			addChild(bmpBody);
			shadow.addChild(bmpBodyShadow);
		}

		override protected function initAni():void {
			rebuildNames();
			changeAsset();
			aniLastStep = arrBody.length - 1;
		}
			
		override protected function tryAni():void {
			if (!arrBody[0]) {
				changeAsset();
				aniLastStep = arrBody.length - 1;
			}
		}
			
		override protected function applyAni():void {
			const b:MirBitmapData = arrBody[aniIdx] as MirBitmapData;
			Util.copyMirBitmapDataToBitmap(b, bmpBody);
			Util.copyMirBitmapDataToBitmap(b, bmpBodyShadow);
		}

		private function rebuildNames():void {
			nameBody = body.toString() + motionCurrent.toString() + direction.toString(16);
		}

		private function changeAsset():void {
			arrBody = Res.monsters.g(nameBody);
		}

	}
}
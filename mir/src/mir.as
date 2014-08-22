package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import mir.Hero;
	import mir.Res;
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="60")]
	public class mir extends Sprite {

		public function mir() {
			initStage();
			addChild(new Ground());
			initHeroes();
//			b();
		}
		
		private function b():void {
//			var v:ByteArray = new Embed.bodies._00;
//			Debug.trace(v.length);
		}

		private function initStage():void {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
		}

		public function initHeroes():void {
			var arr = [];
			for (var i:int = 0; i < 5; i++) {
				var h:Hero = new Hero();
				h.x = 0*Math.random() * 800;
				h.y = 600//Math.random() * 600;
				h.hair=2;
				h.sex = 0//Math.random() * 2;
				h.direction = 0//Math.random() * 8;
				h.body = 0//Math.random() * 6;
				h.weapon = 25//Math.random() * 25;
				addChild(h);
				arr.push(h);
//				addChild(h.shadow);
			}
			for each (var v in arr) {
				addChild(v.shadow);
			}
			for each (var v in arr) {
				addChild(v.hitArea);
			}
			for (i=0;i<8;i++) {
				Res.bodies.g('0'+i);
			}
		}
	}
}

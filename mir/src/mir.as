package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import mir.Ground;
	import mir.Hero;
	import mir.Res;
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="60")]
	public class mir extends Sprite {
		var ground:Ground;

		public function mir() {
			initStage();
			ground = new Ground();
			addChild(ground);
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
			for (var i:int = 0; i < 1; i++) {
				var h:Hero = new Hero();
				h.x = 400
				h.y = 300//Math.random() * 600;
				h.hair=2;
				h.sex = 0//Math.random() * 2;
				h.direction = 0//Math.random() * 8;
				h.body = 0//Math.random() * 6;
				h.weapon = 25//Math.random() * 25;
				function f() {
					h.hook0 = function() { ground.mapY -= 2; }
					h.hook1 = ground.f1;
					h.hook2 = ground.f2;
					h.motion = 2;
//					h.deltaX = 48;
				}
				h.hitArea.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
					f();
				});

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

package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mir.Hero;
	import mir.MapGround;
	import mir.Res;
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="60")]
	public class mir extends Sprite {

		private var ground:MapGround;
		private var objects:MapObjects;
		private var center:Point = new Point(400, 220);
		private var range:Array;

		public function mir() {
			initStage();
			ground = new MapGround();
			objects = new MapObjects();
			addChild(ground);
			addChild(objects);
			Debug.trace(objects.numChildren)

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
			
			range = [-1/8, 1/8, 3/8, 5/8, 7/8, 9/8, 11/8, 13/8].map(function(n:Number, idx, arr):Number {
				trace(n);
				return Math.sin(Math.PI/2 * n);
			});
			Debug.trace(range);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {
			});
			stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				var p:Point = new Point(e.stageX, e.stageY);
				if (p.equals(center)) return;
				Debug.trace(Math.atan2(p.y - center.y, p.x - center.x));
			});
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				Debug.trace([e.stageX, e.stageY]);
			});
		}

		public function initHeroes():void {
			var arr = [];
			for (var i:int = 0; i < 1; i++) {
				var h:Hero = new Hero();
				h.x = 376
				h.y = 209//Math.random() * 600;
				h.hair=2;
				h.sex = 0//Math.random() * 2;
				h.direction = 5//Math.random() * 8;
				h.body = 0//Math.random() * 6;
				h.weapon = 25//Math.random() * 25;
				function f() {
					h.hook0 = function() { ground.mapY += 2; ground.mapX += 2; objects.mapX += 2; objects.mapY += 2};
					h.hook1 = function() { ground.f1(); objects.f1();};
					h.hook2 = function() { ground.f2(); objects.f2();};
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

package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.CoordinateSystem;
	import mir.Hero;
	import mir.MapGround
	import mir.MapMiddle;
	import mir.MapObjects;
	import mir.Res;
	import mir.StructMapAnimations;
	import mir.Util;
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="40")]
	public class mir extends Sprite {

		private var ground:MapGround;
		private var objects:MapObjects;
		private var middle:MapMiddle;
		private var center:Point = new Point(400, 220);
		private var range:Array;
		private var h:Hero = new Hero();
		private var pressed:Boolean;
		private var coor:CoordinateSystem = new CoordinateSystem(center, 8);
		private var floor:int;

		public function mir() {
			Util.autoGc();
//			Util.loadString(Const.ASSETS_DOMAIN+"animations.bin", function(s:String):void {
//				Debug.traceObj(new StructMapAnimations(s));
//			});
			initStage();
			var map:String = "0";
			var xx:int = 290;
			var yy:int = 290;
			ground = new MapGround(map);
			objects = new MapObjects(map);
			middle = new MapMiddle(map);
			addChild(ground);
			addChild(middle);
//			for each (var obj:Sprite in objects.
			addChild(objects);
			addChild(h);
			addChild(h.hitArea);
			h.body = 5
			h.hair = 2
			h.weapon = 5
			ground.mapX = xx
			ground.mapY = yy
			objects.mapX = xx
			objects.mapY = yy
			middle.mapX = xx
			middle.mapY = yy
            ground.f2();
            objects.f2();
            middle.f2();
			h.x = 376
			h.y = 209//Math.random() * 600;

//			initHeroes();
		}
		
		private function fmv():void {
			var p:Point = new Point(stage.mouseX, stage.mouseY);
			if (p.equals(center)) return;
			f(coor.direction(p), 1);
		}

		private function initStage():void {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 

			/*
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {
				var p:Point = new Point(e.stageX, e.stageY);
				trace(coor.direction(p));
			});
			*/


			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void {
				pressed = true;
				fmv();
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent):void {
				pressed = false;
				h.motion = 0;
			});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				trace(e.keyCode, e.charCode);
				if (e.keyCode == 38) {
					floor--;
				}
				if (e.keyCode == 40) {
					floor++;
				}
				if (floor < 0) floor = 0;
				addChildAt(h, floor);
			});
			/*
			stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				var p:Point = new Point(e.stageX, e.stageY);
				if (p.equals(center)) return;
				f(coor.direction(p), 1);
			});
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				var p:Point = new Point(e.stageX, e.stageY);
				if (p.equals(center)) return;
				f(coor.direction(p), 2);
			});
			*/
		}

		public function f(d:uint, l:int):void {
			h.hook0 = function() { 
				var x:int, y:int;
				switch (d) {
					case 0: y = -l; break;
					case 1: x = l, y = -l;break;
					case 2: x = l;break;
					case 3: x = l, y = l;break;
					case 4: y = l;break;
					case 5: x = -l; y = l;break;
					case 6: x = -l;break;
					case 7: x = -l, y= -l;break;
					default: break;
				}
				ground.mapX += x;
				ground.mapY += y;
				objects.mapX += x;
				objects.mapY += y;
				middle.mapX += x;
				middle.mapY += y;
			};
			h.hook1 = function() { ground.f1(); objects.f1(); middle.f1(); };
			h.hook2 = function() { ground.f2(); objects.f2(); middle.f2(); if (pressed) {fmv()}};
			h.direction = d;
			h.motion = l;
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

package  {
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
	import mir.Filters;
	import mir.Hero;
	import mir.MapGround;
	import mir.MapMiddle;
	import mir.MapObjects;
	import mir.Res;
	import mir.Scene;
	import mir.Util;
	
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="40")]
	public class mir extends Sprite {

		private var center:Point = new Point(400, 220);
		private var h:Hero = new Hero();
		private var s:Scene = new Scene("0");
		private var pressed:Boolean;
		private var coor:CoordinateSystem = new CoordinateSystem(center, 8);
		private var floor:int;
		private var X:int;
		private var Y:int;
		
		private var stateRun:Boolean;
		private var stateWalk:Boolean;

		public function mir() {
//			h.shadowVisible = true;
			initStage();
			addChild(s.sprite);
//			s.sprite.addChild(h.shadow);
			s.X = X = 300;
			s.Y = Y = 300;
			s.place(X, Y, h);

			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void {
				stateRun = true;
				run();
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent):void {
				stateRun = false;
				h.motion = Hero.MOTION_DEFAULT;
			});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				stateWalk = true;
				walk();
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				stateWalk = false;
				h.motion = Hero.MOTION_DEFAULT;
			});
		}

		private function run():void {
			s.update();
			var p:Point = new Point(stage.mouseX, stage.mouseY);
			var d:int = coor.direction(p);
			if (p.equals(center))
				return;
			h.direction = d;
			h.motion = Hero.MOTION_RUN;
			var i:int;
			var fs:Vector.<Function> = s.move(d, Hero.MOTION_RUN);
			h.hook1 = function():void {
				fs[i++]();
			}
			h.hook2 = function():void {
				var x:int, y:int, l:int;
				l = 2;
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
				s.X += x;
				s.Y += y;
				s.update();
//				var old = h.parent;
//				s.place(s.X, s.Y, h);
//				Debug.trace(old === h.parent);
//				h.parent.filters = [Filters.red];
				if (stateRun) {
					run();
				}
			}
		}

		private function walk():void {
			s.update();
			var p:Point = new Point(stage.mouseX, stage.mouseY);
			var d:int = coor.direction(p);
			if (p.equals(center))
				return;
			h.direction = d;
			h.motion = Hero.MOTION_WALK;
			var i:int;
			var fs:Vector.<Function> = s.move(d, Hero.MOTION_WALK);
			h.hook1 = function():void {
//				fs[i++]();
			}
			h.hook2 = function():void {
				var dx:int, dy:int, l:int;
				l = 1;
				switch (d) {
					case 0: dy = -l; break;
					case 1: dx = l, dy = -l;break;
					case 2: dx = l;break;
					case 3: dx = l, dy = l;break;
					case 4: dy = l;break;
					case 5: dx = -l; dy = l;break;
					case 6: dx = -l;break;
					case 7: dx = -l, dy= -l;break;
					default: break;
				}
//				s.X += x;
//				s.Y += y;
//				s.update();
				X += dx;
				Y += dy;
				s.place(X,Y, h);
				if (stateWalk) {
					walk();
				}
			}
		}

		private function initStage():void {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			Util.autoGc();
		}
	}
}

package  {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.system.fscommand;
	import flash.utils.Timer;
	
	import mx.utils.StringUtil;
	
	import mir.Const;
	import mir.CoordinateSystem;
	import mir.Filters;
	import mir.Hero;
	import mir.Monster;
	import mir.Res;
	import mir.Role;
	import mir.RoleC;
	import mir.Scene;
	import mir.Util;
	
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="50")]
	public class mir extends Sprite {

		public function mir() {
			initStage();
			this["scene"]();
			var ui:UI = new UI();
			addChild(ui);
			
			// debug ui
			var sp:UISprite;
			ui.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				e.stopPropagation();
				sp = e.target as UISprite;
				if (sp) {
					Debug.trace(sp.name);
					var shapeName:String = 'shape';
					var s:Shape = sp.getChildByName(shapeName) as Shape;
					if (s) {
						sp.removeChild(s);
					} else {
						sp.addChild(s = new Shape());
						s.name = shapeName;
						s.graphics.beginFill(0xff0000, 0.5);
						s.graphics.drawRect(0, 0, sp.width, sp.height);
					}
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (sp) {
					switch (e.keyCode) {
						case 37: sp.x -= 1; break;
						case 38: sp.y -= 1; break;
						case 39: sp.x += 1; break;
						case 40: sp.y += 1; break;
					}
				}
			});
			// debug ui
		}

		private function scene():void {
			var s:Scene = new Scene("0");
			var h:Hero = new Hero(true);
			var m:Monster = new Monster();
			m.body = 111;
			var t:Timer = new Timer(100);
			t.addEventListener(TimerEvent.TIMER, function(e:Event):void{m.ani()});
			t.start();
			m.addEventListener(Role.EVENT_MOTION_END, function(e:Event):void {
				m.motion = (m.motion == 7) ? 8 : 7;
			});
			h.body = 3;
			h.weapon = 17;
			h.hair = 2;
			addChild(s);
			s.X = 392;
			s.Y = 326;
			s.place(h, s.X, s.Y);
			s.place(m, s.X + 1, s.Y-9);
			var hc:RoleC = new RoleC(h, s);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
//				s.showMask = !s.showMask;
			});
		}

		private function initStage():void {
			var i:int = undefined;
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			Util.autoGc();
			Res.stage = stage;  // !!!
		}
	}
}

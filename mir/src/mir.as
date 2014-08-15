package {
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.Hero;
	import mir.MirBitmapData;
	import mir.Res;
	import mir.Utils;
	
	
	public class mir extends Sprite {
		public function mir() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.color = 0x808080;
			
			var h:Hero = new Hero();
			
			var txt:TextField = new TextField();
			txt.height = 600;
			addChild(txt);
//			addChild(bt);

			Utils.loadString(Const.ASSETS_DOMAIN + "files.txt", function(text:String):void {
				txt.text = text;
			});

			function count(o:*):int {
				var i:int;
				for (var k in o) i++;
				return i;
			}
//			addEventListener(MouseEvent.CLICK, function(e:Event):void {
//				h.motion = h.motion >= 10 ? 0 : h.motion + 1;
//				trace(count(Res.bodies.all))
//				trace(e);
//			});

			var sp:Sprite = new Sprite();
			sp.x = 0;
			sp.y = 0;
			addChild(sp);
			sp.addChild(h);
			for (var i:int = 0; i < 100; i++) {
				var hh:Hero = new Hero();
				hh.x = Math.random() * 1800;
				hh.y = Math.random() * 900;
				hh.hair=2;
				hh.sex = Math.random() * 2;
				hh.direction = Math.random() * 8;
				hh.body = Math.random() * 6;
				hh.weapon = Math.random() * 25;
				hh.motion = Math.random() * 11;
				sp.addChild(hh);
			}
			
//			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
//				sp.x = e.localX;
//				sp.y = e.localY;
//			});
		}
	}
}

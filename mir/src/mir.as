package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.ContextMenu;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.MirBmp;
	import mir.Utils;
	
	public class mir extends Sprite {
		public function mir() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
//			stage.color = 0x808080;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
//				trace(stage.width, stage.height);
				sp.x = e.localX;
				sp.y = e.localY;
			});
			
			var sp:Sprite = new Sprite();
			var bmp:Bitmap = new Bitmap();
			sp.addChild(bmp);
			addChild(sp);

			var y:int;

			function f(arr:Array):void {
				var mirbmp:MirBmp;
				var bmp:Bitmap;
				var sp:Sprite;
				var i:int;
				for each (mirbmp in arr) {
					sp = new Sprite();
					bmp = new Bitmap(mirbmp.bitmap);
					bmp.visible = false;
					sp.addChild(bmp);
					bmp = new Bitmap(mirbmp.shadow);
					sp.addChild(bmp);
					sp.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
						var sp:Sprite = e.target as Sprite;
						var bmp:Bitmap = sp.getChildAt(0) as Bitmap;
						var bmp2:Bitmap = sp.getChildAt(1) as Bitmap;
						bmp.visible = true;
						bmp2.visible = false;
					});
					sp.x = i;
					sp.y = y;
					i += 8;
					addChild(sp);
				}
				y += 20;
			}
			
			var arr:Array = [];
			var i:int;

			function ff():void {
				var mirbmp:MirBmp = arr[i++] as MirBmp;
				if (i >= arr.length) {
					i = 0;
				}
				bmp.bitmapData = mirbmp.bitmap;
				bmp.x = mirbmp.x;
				bmp.y = mirbmp.y;
			}

			var timer:Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, ff);
			
			Utils.loadMirBmps("http://mir.qww.pw/tmp/bodies/04", arr, true, timer.start);
			Utils.loadMirBmp("http://mir.qww.pw/tmp/bodies/94", function(mirbmp:MirBmp){
				addChild(new Bitmap(mirbmp.bitmap));
			});

//			Utils.loadBitmaps("http://mir.qww.pw/tmp/items1", [], true, f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/items2", f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/items3", f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/magic_icons", f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/ui", f);
		}
	}
}
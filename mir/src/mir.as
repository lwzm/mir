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
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.MirBmp;
	import mir.Utils;
	
	public class mir extends Sprite {
		public function mir() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.color = 0x808080;
			
			var txt:TextField = new TextField();
			txt.height = 600;
			addChild(txt);

			Utils.load("http://lwzgit.duapp.com/files.txt", function(text:String):void {
				txt.text = text;
			}, URLLoaderDataFormat.TEXT);

			addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void {
				trace(txt.selectedText);
				var s:String = txt.selectedText.replace(/\s+$/, "");
				s.length ? Utils.loadMirBmps("http://lwzgit.duapp.com/" + s, start) : null;
			});

			var sp:Sprite = new Sprite();
			sp.x = 400;
			sp.y = 300;
			addChild(sp);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void {
				sp.x = e.localX;
				sp.y = e.localY;
			});
			
			var bmp:Bitmap = new Bitmap();
			sp.addChild(bmp);

			function start(arr:Vector.<MirBmp>):void {
				var i:int;
				var timer:Timer = new Timer(100, arr.length);
				timer.addEventListener(TimerEvent.TIMER, f);
				timer.start();
				function f(e:TimerEvent):void {
					var mirbmp:MirBmp = arr[i++];
					if (i >= arr.length) {
						i = 0;
					}
					bmp.bitmapData = mirbmp.bitmap;
					bmp.x = mirbmp.x;
					bmp.y = mirbmp.y;
				}
			}

			
//			Utils.loadMirBmps("http://lwzgit.duapp.com/bodies/24", start);
//			Utils.loadMirBmp("http://lwzgit.duapp.com/tilesm/0", function(mirbmp:MirBmp):void {
//				addChild(new Bitmap(mirbmp.bitmap));
//			});

//			Utils.loadMirBmps("http://lwzgit.duapp.com/magic_icons", start);
//			Utils.loadAsset("http://mir.qww.pw/tmp/items2", start);
//			Utils.loadAsset("http://mir.qww.pw/tmp/items3", f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/magic_icons", f);
//			Utils.loadAsset("http://mir.qww.pw/tmp/ui", f);
//			var v = new Vector.<int>();
//			v[1];
		}
	}
}
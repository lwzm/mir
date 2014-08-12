package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.Bmp;
	import mir.MirBitmapData;
	import mir.MirBitmaps;
	import mir.Utils;
	
	import fl.controls.ComboBox;
	import org.hamcrest.SelfDescribing;
	
	public class mir extends Sprite {
		public function mir() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.color = 0x808080;
			
			var bt:SimpleButton = new CustomSimpleButton();
			bt.x = 300;
			bt.y = 300;
			
			var txt:TextField = new TextField();
			txt.height = 600;
			addChild(txt);
			addChild(bt);

			Utils.loadString("http://tmp.qww.pw/files.txt", function(text:String):void {
				txt.text = text;
			});

			addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void {
				trace(txt.selectedText);
				var s:String = txt.selectedText.replace(/\s+$/, "");
//				s.length ? Utils.loadMirBitmaps("http://lwzgit.duapp.com/" + s, start) : null;
				s.length ? Utils.loadMirBitmaps("http://tmp.qww.pw/" + s, start) : null;
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
			
			var g:Number = 0.333
			var gray:ColorMatrixFilter = new ColorMatrixFilter([
				g, g, g, 0, 0,
				g, g, g, 0, 0,
				g, g, g, 0, 0,
				0, 0, 0, 1, 0,
			]);
			var highlight:ColorMatrixFilter = new ColorMatrixFilter([
				1, 0, 0, 0, 20,
				0, 1, 0, 0, 20,
				0, 0, 1, 0, 20,
				0, 0, 0, 1, 0,
			]);
			var green:ColorMatrixFilter = new ColorMatrixFilter([
				0, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0, 1, 0,
			]);
			var trans:ColorMatrixFilter = new ColorMatrixFilter([
				1, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, .5, 0,
			]);

//			var cb:ComboBox = new ComboBox();

			sp.filters = [];
			trace(bmp.filters.length);
			function start(arr:Array):void {
				var i:int;
				var timer:Timer = new Timer(50, arr.length);
				timer.addEventListener(TimerEvent.TIMER, f);
				timer.start();
				
				function f(e:TimerEvent):void {
					var mirbmp:MirBitmapData = arr[i++];
					if (i >= arr.length) {
						i = 0;
					}
					bmp.blendMode = arr.blendMode;
					bmp.bitmapData = mirbmp;
					bmp.x = mirbmp ? mirbmp.x : 0;
					bmp.y = mirbmp ? mirbmp.y : 0;
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
import flash.display.Shape;
import flash.display.SimpleButton;

class CustomSimpleButton extends SimpleButton {
	private var upColor:uint   = 0xFFCC00;
	private var overColor:uint = 0xCCFF00;
	private var downColor:uint = 0x00CCFF;
	private var size:uint      = 80;
	
	public function CustomSimpleButton() {
		downState      = new ButtonDisplayState(downColor, size);
		overState      = new ButtonDisplayState(overColor, size);
		upState        = new ButtonDisplayState(upColor, size);
		hitTestState   = new ButtonDisplayState(0x0, size);
		hitTestState.x = 0;
		hitTestState.y = 0;
		useHandCursor  = true;
	}
}

class ButtonDisplayState extends Shape {
	private var bgColor:uint;
	private var size:uint;
	
	public function ButtonDisplayState(bgColor:uint, size:uint) {
		this.bgColor = bgColor;
		this.size    = size;
		draw();
	}
	
	private function draw():void {
		graphics.beginFill(bgColor);
		graphics.drawRect(0, 0, size, size);
		graphics.endFill();
	}
}

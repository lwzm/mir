package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mir.Const;
	import mir.Res;
	import mir.Util;
	
	public final class UI extends Sprite {
		public const modules:Object = {};
		private const hotkeys:Object = {};

		public function UI() {
			Util.loadString(Const.ASSETS_DOMAIN + "ui.json" + Const.ASSETS_VERSION, function(str:String):void {
				init(JSON.parse(str));
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			});
//			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, test);
		}

		private function onClick(e:MouseEvent):void {
			Debug.trace(e);
		}

		private function onKeyDown(e:KeyboardEvent):void {
			const keys:Array = [];
			e.ctrlKey && keys.push("^");
			e.altKey && keys.push("!");
			e.shiftKey && keys.push("+");
			keys.push(e.keyCode);
			const f:Function = hotkeys[keys.join(" ")];
			f && f();
		}

		private function registerHotkeys(ui:UISprite, config:Object):void {
			var key:String, args:Object;
			for (key in config) {
				hotkeys[key] = hotkeyCallback(ui, config[key]);
			}
		}

		private static function hotkeyCallback(ui:UISprite, config:Object):Function {
			return function():void {
				ui.visible = !ui.visible;
				for (var k:String in config) {
					ui[k] = config[k];
				}
			}
		}

		public function test(_):void {
			for each (var ui:UISprite in modules) {
				(ui.getChildAt(0) as Bitmap).bitmapData = Res.ui.g(ui.res);
			}
		}

		private function init(config:Object):void {

			var name:String, _:Object, ui:UISprite, bmp:Bitmap;

			for (name in config) {
				_ = config[name];
				ui = modules[name] = new UISprite();
				ui.name = name;
				ui.x = _.x;
				ui.y = _.y;
//				ui.visible = !_.hidden;
				ui.draggable = _.draggable;
				ui.state = _.state;
				ui.res = _.res;
				ui.resOnClick = _.resOnClick;
				ui.visibleOnClickOnly = _.visibleOnClickOnly;

				bmp = new Bitmap();
				bmp.bitmapData = Res.ui.g(_.res);
				ui.addChild(bmp);

				registerHotkeys(ui, _.hotkeys);
			}

			var s:String;

			for (name in config) {
				ui = modules[name];
				(modules[config[name].father] || this).addChild(ui);
			}

			for (name in config) {
				ui = modules[name];
				for each (s in (config[name].stateSections || [])) {
					ui.addChild(modules[s]);
				}
			}

		}
	}
}
package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mir.Const;
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
		}

		private function onClick(e:MouseEvent):void {
//			Debug.trace(e);
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

		private function registerCommands(ui:UISprite, commands:Object):void {
			var name:String, attr:String, target:UISprite;
			if (commands is String) {
				ui.addEventListener(MouseEvent.CLICK, this[commands]);
			} else {
				for (name in commands) {
					target = modules[name];
					for (attr in commands[name]) {
						ui.addEventListener(MouseEvent.CLICK, commandCallback(target, attr, commands[name][attr]));
					}
				}
			}
        }
		private static function commandCallback(ui:UISprite, attr:String, value:*):Function {
            return function(e:Event):void {
                ui[attr] = value;
            }
        }
		
		private function command1(e:Event):void {
			trace('cmd1');
		}

		private function init(config:Object):void {
			var name:String;
			var _:Object;
			var ui:UISprite;

			for (name in config) {
				_ = config[name];
				ui = modules[name] = new UISprite();
				ui.name = name;
				ui.x = _.x;
				ui.y = _.y;
				ui.visible = !_.hidden;
				ui.draggable = _.draggable;
				ui.dummyRes = _.dummyRes;
				ui.res = _.res;
				ui.resOnClick = _.resOnClick;
				ui.visibleOnClickOnly = _.visibleOnClickOnly;
            }

			for (name in config) {
				_ = config[name];
				ui = modules[name];
				registerHotkeys(ui, _.hotkeys);
				registerCommands(ui, _.commands);
			}


			for (name in config) {
				_ = config[name];
				ui = modules[name];
				var pages:Array = _.pages;
				if (pages) {
                    ui.pages = pages;
					for each (var s:String in pages) {
						modules[s].visible = false;
						ui.addChild(modules[s]);
					}
                    ui.page = _.page; // at last
				}
			}

			for (name in config) {
				ui = modules[name];
				ui.parent || (modules[config[name].father] || this).addChild(ui);
			}

		}
	}
}

package  {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mir.Res;
	import mir.Util;

	/**
	 * visibleOnClick bool 只在点击时显示, 平时 alpha 都为 0, 等待被点击
	 * res int 资源ID
	 * resOnClick int 响应点击操作时切换的资源ID
	 * hotkeys obj 切换显示状态的快捷键, 可多个, << Control^ Alt! Shift+ >>, key 是按键名字, 由空格组合起来, value 为参数, 嗯, 描述起来比较复杂...
	 * commands obj 点击时执行的指令, 分为简单动态描述指令 (type: obj), 自定义指令 (type: str)
	 * hidden bool 初始状态不主动显示
	 * father str 父名字, 解析最后阶段根据这个名字来调整 parent, 没有则属于顶层 UISprite
	 * doc todo...
	 */
	public final class UISprite extends Sprite {
		public var visibleOnClickOnly:Boolean;
		public var dummyRes:Boolean;
		public var pages:Array;

		private var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var bmpDataOnClick:BitmapData;
		private var resName:String;
		private var resOnClickName:String;
		private var pageName:String;

		public function UISprite():void {
			addChild(bmp = new Bitmap());
			addEventListener(MouseEvent.MOUSE_DOWN, activate);
			addEventListener(MouseEvent.MOUSE_UP, inactivate);
			addEventListener(MouseEvent.MOUSE_OUT, inactivate);
			addEventListener(MouseEvent.CLICK, click);
		}

		public function set res(id:int):void {
			if (!id) return;
			resName = id.toString();
			addEventListener(Event.ENTER_FRAME, fetchRes);
		}
		
		public function set resOnClick(id:int):void {
			if (!id) return;
			resOnClickName = id.toString();
			addEventListener(Event.ENTER_FRAME, fetchResOnClick);
		}

		public function set switchBoolean(attr:String):void {
			this[attr] = !this[attr];
		}

		public function set page(pName:String):void {
			if (pageName) {
				getChildByName(pageName).visible = false;
			}
			try {
				addChild(getChildByName(pName)).visible = true;
                pageName = pName;
			} catch (err:Error) {
				trace(pName, err);
			}
		}

		public function set pageSwitch(delta:int):void {
            var i:int;
            i = pages.indexOf(pageName) + delta;
            if (i < 0) {
                i = pages.length - 1;
            } else if (i >= pages.length) {
                i = 0;
            }
            page = pages[i];
		}
		
		private function fetchRes(e:Event):void {
			var data:BitmapData = Res.ui.g(resName);
			if (data) {
				removeEventListener(e.type, fetchRes);
				if (dummyRes) {
					data = Util.dumpBitmapData(data, new Rectangle(1, 1, 0, 0));
				}
				bmp.bitmapData = bmpData = data;
				if (visibleOnClickOnly) {
					bmp.alpha = 0;
				}
			}
		}

		private function fetchResOnClick(e:Event):void {
			const data:BitmapData = Res.ui.g(resOnClickName);
			if (data) {
				removeEventListener(e.type, fetchResOnClick);
				bmpDataOnClick = data;
			}
		}

		public function set draggable(able:Boolean):void {
			if (able) {
				addEventListener(MouseEvent.MOUSE_DOWN, dragOn);
				addEventListener(MouseEvent.MOUSE_UP, dragOff);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, dragOn);
				removeEventListener(MouseEvent.MOUSE_UP, dragOff);
			}
		}

		private function click(e:Event):void {
			e.stopPropagation();
			Debug.trace([x, y]);
		}

		private function activate(e:Event):void {
			e.stopPropagation();
			parent.addChild(this);
			if (visibleOnClickOnly) {
				bmp.alpha = 1;
			} else if (bmpDataOnClick) {
				bmp.bitmapData = bmpDataOnClick;
			}
		}

		private function inactivate(e:Event):void {
			e.stopPropagation();
			bmp.bitmapData = bmpData;
			if (visibleOnClickOnly) {
				bmp.alpha = 0;
			}
		}

		private function dragOn(e:Event):void {
			e.stopPropagation();
			startDrag();
		}

		private function dragOff(e:Event):void {
			e.stopPropagation();
			stopDrag();
		}

	}
}

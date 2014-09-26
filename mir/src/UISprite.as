package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mir.Res;

	/**
	 * visibleOnClick bool 只在点击时显示, 平时 alpha 都为 0, 等待被点击
	 * res int 资源ID
	 * resOnClick int 响应点击操作时切换的资源ID
	 * hotkeys obj 切换显示状态的快捷键, 可多个, << Control^ Alt! Shift+ >>, key 是按键名字, 由空格组合起来, value 为参数, 嗯, 描述起来比较复杂...
	 * hidden bool 初始状态不主动显示, Sprite.visible = !hidden
	 * father str 父名字, 解析最后阶段根据这个名字来调整 parent, 没有则属于顶层 UISprite
	 * todo...
	 */
	public final class UISprite extends Sprite {
		public var visibleOnClickOnly:Boolean;
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
//			addEventListener(MouseEvent.RIGHT_CLICK, hide);
		}

		public function set res(id:int):void {
			resName = id.toString();
			addEventListener(Event.ENTER_FRAME, fetchRes);
		}
		
		public function set resOnClick(id:int):void {
			if (id) {
				resOnClickName = id.toString();
				addEventListener(Event.ENTER_FRAME, fetchResOnClick);
			}
		}

		public function set page(pName:String):void {
			if (pageName) {
				getChildByName(pageName).visible = false;
			}
			try {
                pageName = pName;
				addChild(getChildByName(pName)).visible = true;
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
			const data:BitmapData = Res.ui.g(resName);
			if (data) {
				removeEventListener(e.type, fetchRes);
				bmp.bitmapData = bmpData = data;
				if (visibleOnClickOnly) {
					bmp.alpha = 0;
				}
			}
		}

		private function fetchResOnClick(e:Event):void {
			const data:BitmapData = Res.ui.g(resOnClickName);
			if (data) {
				bmpDataOnClick = data;
				removeEventListener(e.type, fetchResOnClick);
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
			trace(x, y);
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

		private function hide(e:Event):void {
			e.stopPropagation();
			alpha = Number(!alpha);
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

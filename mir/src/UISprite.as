package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * visibleOnClick bool 只在点击时显示, 平时 alpha 都为 0, 等待被点击
	 * res int 资源ID
	 * resOnClick int 响应点击操作时切换的资源ID
	 * hotkeys obj 切换显示状态的快捷键, 可多个, << Control^ Alt! Shift+ >>, key 是按键名字, 由空格组合起来, value 为参数, 嗯, 描述起来比较复杂...
	 * hidden bool 初始状态不主动显示, Sprite.visible = !hidden
	 * father str 父名字, 解析最后阶段根据这个名字来调整 parent, 没有则属于顶层 UISprite
	 * state int
	 * stateSections arr
	 */
	public final dynamic class UISprite extends Sprite {
		public function set draggable(able:Boolean):void {
			if (able) {
				addEventListener(MouseEvent.MOUSE_DOWN, dragOn);
				addEventListener(MouseEvent.MOUSE_UP, dragOff);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, dragOn);
				removeEventListener(MouseEvent.MOUSE_UP, dragOff);
			}
		}

		private function dragOn(e:Event):void {
			startDrag();
		}

		private function dragOff(e:Event):void {
			stopDrag();
		}

	}
}
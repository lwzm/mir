package mir {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;

	public final class Res {
		public static const bodies:RemoteMultiple = new RemoteMultiple("bodies");
		public static const hairs:RemoteMultiple = new RemoteMultiple("hairs");
		public static const weapons:RemoteMultiple = new RemoteMultiple("weapons");
		public static const monsters:RemoteMultiple = new RemoteMultiple("monsters");

		public static const tiles:RemoteSingle = new RemoteSingle("tiles");
		public static const tilesm:RemoteSingle = new RemoteSingle("tilesm");
		public static const ui:RemoteSingle = new RemoteSingle("ui");

		public static const objects:Vector.<RemoteSingle> = Vector.<RemoteSingle>([
			new RemoteSingle("objs1"),
			new RemoteSingle("objs2"),
			new RemoteSingle("objs3"),
			new RemoteSingle("objs4"),
			new RemoteSingle("objs5"),
			new RemoteSingle("objs6"),
			new RemoteSingle("objs7"),
		]);

		public static function get hitArea():Sprite {
			const sp:Sprite = new Sprite();
			sp.graphics.beginFill(0, 0.0);
			sp.graphics.drawRect(0, -Const.TILE_H - 20, Const.TILE_W, Const.TILE_H * 2 + 15);
			sp.graphics.drawCircle(0,0,3);
			return sp;
		}

		public static var stage:Stage;  // should be setted when start up

		public static function get mousePoint():Point {
			return new Point(stage.mouseX, stage.mouseY);
		}

	}
}

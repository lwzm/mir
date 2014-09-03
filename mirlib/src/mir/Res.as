package mir {
	public final class Res {
		public static const bodies:RemoteMultiple = new RemoteMultiple("bodies");
		public static const hairs:RemoteMultiple = new RemoteMultiple("hairs");
		public static const weapons:RemoteMultiple = new RemoteMultiple("weapons");
		public static const tiles:RemoteSingle = new RemoteSingle("tiles");
		public static const tilesm:RemoteSingle = new RemoteSingle("tilesm");
		public static const objects:Vector.<RemoteSingle> = Vector.<RemoteSingle>([
//			null,
			new RemoteSingle("objs1"),
			new RemoteSingle("objs2"),
			new RemoteSingle("objs3"),
			new RemoteSingle("objs4"),
			new RemoteSingle("objs5"),
			new RemoteSingle("objs6"),
			new RemoteSingle("objs7"),
		]);
	}
}
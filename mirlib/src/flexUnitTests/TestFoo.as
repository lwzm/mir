package flexUnitTests
{
	import flash.utils.ByteArray;
	
	import mir.Foo;
	import mir.MirBmp;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	
	public class TestFoo
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testExtract_bmp():void {
			var bytes:ByteArray = new ByteArray();
			var repeat:int = 10;
			var w:int = 4;
			var h:int = 5;
			var x:int = 1000;
			var y:int = -1000;
			assertEquals(w % 4, 0);
			while (repeat--) {
				bytes.writeShort(w);
				bytes.writeShort(h);
				bytes.writeShort(x);
				bytes.writeShort(y);
				for (var i:int = 0; i < w * h; i++) {
					bytes.writeByte(repeat);
				}
			}
			bytes.deflate(); bytes.inflate();  // or bytes.position = 0;
			var mir_bmp:MirBmp;
			mir_bmp = Foo.extract_bmp(bytes);
			assertNull(mir_bmp.shadow);  // normal
			assertEquals(mir_bmp.bitmap.width, w);
			assertEquals(mir_bmp.bitmap.height, h);
			assertEquals(mir_bmp.x, x);
			assertEquals(mir_bmp.y, y);
			mir_bmp = Foo.extract_bmp(bytes, true);  // with shadow
			assertNotNull(mir_bmp.shadow);
			assertEquals(mir_bmp.bitmap.width, w);
			assertEquals(mir_bmp.bitmap.height, h);
			assertEquals(mir_bmp.shadow.width, w);
			assertEquals(mir_bmp.shadow.height, h);
			assertEquals(mir_bmp.x, x);
			assertEquals(mir_bmp.y, y);
			// ...
		}
	}
}
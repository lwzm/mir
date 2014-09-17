package mir.flexUnitTests
{
	import mir.Res;
	
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.async.Async;

	public class TestRes
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
		
		[Test(async)]
		public function test():void {
			assertNull(Res.bodies.g("00")[0]);
			Async.delayCall(this, function():void {
				assertNotNull(Res.bodies.g("00")[0]);
			}, 100);
		}

		
	}
}
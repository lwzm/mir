package
{
	import Array;
	
	import flash.display.Sprite;
	
	import flexUnitTests.TestConst;
	import flexUnitTests.TestHero;
	import flexUnitTests.TestRes;
	import flexUnitTests.TestScene;
	import flexUnitTests.TestUtils;
	
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	public class FlexUnitApplication extends Sprite
	{
		public function FlexUnitApplication()
		{
			onCreationComplete();
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
			testRunner.portNumber=8765; 
			this.addChild(testRunner); 
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "mirlib");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			testsToRun.push(flexUnitTests.TestConst);
			testsToRun.push(flexUnitTests.TestHero);
			testsToRun.push(flexUnitTests.TestRes);
			testsToRun.push(flexUnitTests.TestScene);
			testsToRun.push(flexUnitTests.TestUtils);
			return testsToRun;
		}
	}
}
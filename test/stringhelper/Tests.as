package {
	
	import flash.display.Sprite;
	import flexunit.textui.TestRunner;
	import flexunit.framework.TestListener;
	import flexunit.framework.TestResult;
	import flexunit.textui.ResultPrinter;
	import flexunit.framework.TestSuite;
	import src.StringHelperTest;
	
	public class Tests  extends Sprite{
		
		private var result:TestResult;
		
		public function Tests() {
			super();
			
			var suite:TestSuite = new TestSuite()
			suite.addTest(new StringHelperTest("trimTest"));
			suite.addTest(new StringHelperTest("emptyTest"));
			suite.addTest(new StringHelperTest("parameterizeTest"));
			suite.addTest(new StringHelperTest("humanizeTest"));
			suite.addTest(new StringHelperTest("firstToUpperTest"));
			suite.addTest(new StringHelperTest("firstToLowerTest"));
			suite.addTest(new StringHelperTest("replaceFirstTest"));
			suite.addTest(new StringHelperTest("titleCaseTest"));
			
			this.result = TestRunner.run(suite,onTestEnded);
	
		}
		
		private function onTestEnded():void {
			
		}
		
	}

}
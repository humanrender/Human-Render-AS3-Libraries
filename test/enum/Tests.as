package {
	
	import flash.display.Sprite;
	import flexunit.textui.TestRunner;
	import flexunit.framework.TestListener;
	import flexunit.framework.TestResult;
	import flexunit.textui.ResultPrinter;
	import flexunit.framework.TestSuite;
	import src.EnumTests;
	
	public class Tests  extends Sprite{
		
		private var result:TestResult;
		
		public function Tests() {
			super();
			
			var suite:TestSuite = new TestSuite()
			suite.addTest(new EnumTests("allElementsAreStrings"));
			suite.addTest(new EnumTests("allElementsAreNotStrings"));
			suite.addTest(new EnumTests("anyElementsAreStrings"));
			suite.addTest(new EnumTests("anyElementsAreNotStrings"));
			suite.addTest(new EnumTests("noElementIsString"));
			suite.addTest(new EnumTests("notAllElementsAreNotStrings"));
			suite.addTest(new EnumTests("atLeastOneElementIsString"));
			suite.addTest(new EnumTests("notEvenOneElementIsString"));
			suite.addTest(new EnumTests("findFirstElement"));
			suite.addTest(new EnumTests("findIndex"));
			suite.addTest(new EnumTests("inject"));
			suite.addTest(new EnumTests("injectWithFunction"));
			suite.addTest(new EnumTests("eachWithIndex"));
			suite.addTest(new EnumTests("dropTest"));
			suite.addTest(new EnumTests("dropWhileTest"));
			suite.addTest(new EnumTests("eachConsTest"));
			suite.addTest(new EnumTests("entriesTest"));
			suite.addTest(new EnumTests("findTest"));
			suite.addTest(new EnumTests("findAllTest"));
			suite.addTest(new EnumTests("grepTest"));
			suite.addTest(new EnumTests("groupByTest"));
			suite.addTest(new EnumTests("includeTest"));
			suite.addTest(new EnumTests("collectTest"));
			suite.addTest(new EnumTests("detectTest"));
			suite.addTest(new EnumTests("partitionTest"));
			suite.addTest(new EnumTests("rejectTest"));
			suite.addTest(new EnumTests("sortTest"));
			
			this.result = TestRunner.run(suite,onTestEnded);
	
		}
		
		private function onTestEnded():void {
			
		}
		
	}

}
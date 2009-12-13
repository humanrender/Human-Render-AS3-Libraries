package {
	
	import flash.display.Sprite;
	import net.humanrender.enum.Enum;
	import flexunit.framework.TestCase;
	
	public class EnumTests  extends TestCase {
		
		public function EnumTests(method:String = null) {
			super(method);
		}
		
		/* Casses */
		
		public function allElementsAreStrings():void {
			var enum:Enum = createStringEnum();
			assertTrue(enum.all(isString));
		}
		
		public function allElementsAreNotStrings():void {
			var enum:Enum = createMixedEnum();
			assertFalse(enum.all(isString))
		}
		
		public function anyElementsAreStrings():void {
			var enum:Enum = createMixedEnum();
			assertTrue(enum.any(isString))
		}
		
		public function anyElementsAreNotStrings():void {
			var enum:Enum = createStringEnum();
			assertFalse(enum.any(isString))
		}
		
		public function noElementIsString():void {
			var enum:Enum = createMixedEnum();
			assertTrue(enum.none(isString));
		}
		
		public function notAllElementsAreNotStrings():void {
			var enum:Enum = createStringEnum();
			assertFalse(enum.none(isString));
			
		}
		
		public function atLeastOneElementIsString():void {
			var enum:Enum = createStringEnum();
			assertTrue(enum.one(isString));
		}
		
		public function notEvenOneElementIsString():void {
			var enum:Enum = createMixedEnum();
			assertFalse(enum.one(isString));
		}
		
		private function isString(obj:*):Boolean {
			return obj is String;
		}
		
		public function findFirstElement():void {
			var enum:Enum = createStringEnum();
			assertEquals(enum.first, enum.a);
			
			enum = createMixedEnum();
			assertEquals(enum.first, enum.bool);
		}
		
		public function findIndex():void {
			var enum:Enum = createMixedEnum();
			assertEquals(enum.findIndex("bool"), 0);
			assertEquals(enum.findIndex("index1"), 1);
			assertEquals(enum.findIndex("obj"), 2);
			assertEquals(enum.findIndex("num2"), 3);
		}
		
		public function inject():void {
			var enum:Enum = createNumberEnum();
			assertStrictlyEquals(enum.inject(5), 70);
			assertStrictlyEquals(enum.inject(), 65);
		}
		
		public function injectWithFunction():void {
			var enum:Enum = createStringEnum();
			
			var expectedResult:String = "| " + enum.a + " | " + enum.b + " | " + enum.c + " | " + enum.d + " | ";
			assertStrictlyEquals(enum.inject("| ", separateStringsByBar), expectedResult);
			
			expectedResult = enum.a + " | " + enum.b + " | " + enum.c + " | " + enum.d + " | ";
			assertStrictlyEquals(enum.inject(null, separateStringsByBar), expectedResult);
		}
		
		private function separateStringsByBar(memo:*, obj:*):String {
			return (memo ? memo + obj : obj) + " | " ;
		}
		
		public function eachWithIndex():void {
			var enum:Enum = createStringEnum();
			enum.eachWithIndex(function(k:*, obj:*, i:*):void {
				assertEquals(obj, enum.getItemAt(i));
			})
			
			enum = createMixedEnum();
			enum.eachWithIndex(function(k:*, obj:*, i:*):void {
				assertEquals(obj, enum.getItemAt(i));
			})
		}
		
		public function dropTest():void {
			var enum:Enum = createMixedEnum();
			assertEquals(enum.drop(3).length, 1);
			assertEquals(enum.drop(4).length, 0);
			
			enum = createNumberEnum();
			assertEquals(enum.drop().length, 3);
			assertEquals(enum.drop(1).length, 2);
			
		}
		
		public function dropWhileTest():void {
			var enum:Enum = createNumberEnum();
			assertEquals(0, enum.dropWhile(function(obj:*):Boolean {
				return obj < 30;
			}).length);
			
			assertEquals(1, enum.dropWhile(function(obj:*):Boolean {
				return obj < 20;
			}).length);
			
			enum = createMixedEnum();
			assertEquals(2, enum.dropWhile(function(obj:*):Boolean {
				return !(obj is Number);
			}).length);
		}
		
		public function eachConsTest():void {
			var enum:Enum = createNumberEnum();
			var i:int = 0;
			enum.eachCons(function(pair:Array):void {
				assertEquals(enum.getItemAt(i), pair[0]);
				assertEquals(enum.getItemAt(i+1), pair[1]);
				i++;
			});
		}
		
		public function entriesTest():void {
			var enum:Enum = createStringEnum();
			var entries:Array = enum.entries;
			for each(var entry:Array in entries) {
				assertEquals(entry[1], enum[entry[0]]);
			}
			
			enum = createMixedEnum();
			entries = enum.entries;
			for each(entry in entries) {
				assertEquals(entry[1], enum[entry[0]]);
			}
		}
		
		public function findTest():void {
			var enum:Enum = createStringEnum();
			assertEquals("string 3", enum.find(function(object:*):Boolean { return object == "string 3" } ));
			assertEquals("string 4", enum.find(function(object:*):Boolean { return object == "string 4" } ));
		
			enum = createMixedEnum();
			assertEquals(true, enum.find(function(object:*):Boolean { return object is Boolean && object == true } ));
			assertEquals(999, enum.find(function(object:*):Boolean { return object == 999 } ));
		}
		
		public function findAllTest():void {
			var enum:Enum = createMixedEnum();
			var result:Array = enum.findAll(function(object:*):Boolean { return object is Number } );
			assertEquals(result.length, 2);
			for each(var  num:* in result){ assertTrue(num is Number) }
			
			result = enum.findAll(function(object:*):Boolean { return object is String } );
			assertEquals(result.length, 0);
		}
		
		public function grepTest():void {
			var enum:Enum = createMixedEnum();
			var result:Array = enum.grep(/[0-9]+/ );
			assertEquals(result.length, 2);
			
			for each(var  num:* in result){ assertTrue(num is Number) }
			result = enum.grep(/Object/);
			assertEquals(result.length, 1);
			
			enum = createStringEnum();
			result = enum.grep(/[\w]+\s[0-9]$/);
			assertEquals(result.length, 4);
			
			result = enum.grep(/test+\s[0-9]$/);
			assertEquals(result.length, 2);
			
			result = enum.grep(/dummy/);
			assertEquals(result.length, 0);
			
			enum = createNumberEnum();
			result = enum.grep(/[0-9]+/ , function(num:Number):Number { return num * 100; } );
			assertEquals(result.length, 3);
			
			var length:int = result.length;
			for (var i:int = 0; i < length; i++) { assertEquals(enum.getItemAt(i), result[i] / 100); }
		}
		
		public function groupByTest():void {
			var enum:Enum = createNumberEnum();
			var result:Enum = enum.groupBy(function(item:*):String {
				return (item % 2) == 0 ? "even" : "odd";
			});
			for (var label:String in result) {
				var arr:Array = result[label] as Array;
				for each(var num:Number in arr) {
					var labl:String = (num % 2) == 0 ? "even" : "odd";
					assertEquals(labl, label);
				}
			}
		}
		
		public function includeTest():void {
			var enum:Enum = new Enum();
			var val1:Object = {test:"Test"}
			var val2:Sprite = new Sprite();
			var val3:Number = 99;
			var val4:String = "string";
			enum.val1 = val1;
			enum.val2 = val2;
			enum.val3 = val3;
			enum.val4 = val4;
			
			assertTrue(enum.includes(val1));
			assertTrue(enum.includes(val2));
			assertTrue(enum.includes(val3));
			assertTrue(enum.includes(val4));
			assertFalse(enum.includes(new Sprite()));
		}
		
		public function collectTest():void {
			var enum:Enum = createNumberEnum();
			var results:Array = enum.collect(function(o:*):*{
				return "test";
			});
			for each(var result:* in results) {
				assertEquals(result, "test");
			}
			
			results = enum.collect(function(o:Number):*{
				return o*10;
			});
			var length:int = results.length;
			for (var i:uint = 0; i < length; i++) {
				assertEquals(enum.getItemAt(i) * 10, results[i]);
			}
		}
		
		public function detectTest():void {
			var enum:Enum = createMixedEnum();
			assertNull(enum.detect(function(o:*):void { } ));
			assertEquals(enum.detect(function(o:*):void { } , 300), 300);
			
			var result:* = enum.detect(function(o:*):Boolean { return !(o is Boolean) && !(o is Number) });
			assertEquals(result.prop, enum.obj.prop);
		}
		
		public function partitionTest():void {
			var enum:Enum = createNumberEnum();
			var results:Array = enum.partition(function(o:*):*{
				return o < 30;
			});
			for each(var result:* in results[0]) { assertTrue(result < 30);}
			for each(result in results[1]) {assertTrue(result > 30);}
			
			enum = createMixedEnum();
			results = enum.partition(function(o:*):*{
				return o is Number;
			});
			var length:int = results.length;
			for each(result in results[0]) { assertTrue(result is Number); }
			for each(result in results[1]) {assertTrue(!(result is Number));}
		}
		
		public function rejectTest():void {
			var enum:Enum = createMixedEnum();
			var result:Array = enum.reject(function(object:*):Boolean { return object is Number } );
			assertEquals(result.length, 2);
			for each(var  num:* in result){ assertFalse(num is Number) }
			
			result = enum.reject(function(object:*):Boolean { return object is String } );
			assertEquals(result.length, 4);
		}
		
		public function sortTest():void {
			var enum:Enum = createNumberEnum();
			var sa:Array = enum.sort();
			var sd:Array = enum.sort(Array.DESCENDING);
			testAscending(sa)
			testDescending(sd)
		}
		
		private function testAscending(arr:Array):void {
				var l:int = arr.length;
				var past:Number;
				for (var i:int = 0; i < l; i++) {
					var obj:Number =  arr[0];
					if (!past) {
						past = obj;
						continue;
					}else {
						var next:Number = arr[i];
						assertTrue(next > past);
						if (i + 1 >= l) break;
						past = next;
					}
				}
			}
			
			private function testDescending(arr:Array):void {
				var l:int = arr.length;
				var past:Number;
				for (var i:int = 0; i < l; i++) {
					var obj:Number =  arr[0];
					if (!past) {
						past = obj;
						continue;
					}else {
						var next:Number = arr[i];
						assertTrue(next < past);
						if (i + 1 >= l) break;
						past = next;
					}
				}
			}
		
		/* Private functions */	
		
		private function createStringEnum():Enum{
			var enum:Enum = new Enum();
			enum.a = "test 1";
			enum.b = "string 3";
			enum.c = "test 2";
			enum.d = "string 4";
			return enum;
		}
		
		private function createMixedEnum():Enum{
			var enum:Enum = new Enum();
			enum.bool = true;
			enum.index1 = 3;
			enum.obj = {prop:"test"};
			enum.num2 = 999;
			return enum;
		}
		
		private function createNumberEnum():Enum {
			var enum:Enum = new Enum();
			enum.x = 10;
			enum.y = 20;
			enum.z = 35;
			return enum;
		}
		
	}

}
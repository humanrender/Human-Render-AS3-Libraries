package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import net.humanrender.classes.utils.enum.Hash;
	
	public class enum_test extends Sprite{
		
		public function enum_test() {
			super();
			
			var hash:Hash = new Hash();
			
			hash.aKey = 1;
			hash.bValue = "b";
			hash.arr = [];
			hash.num1 = 3;
			hash.num2 = 4;
			hash.num3 = 5;
			hash.popo = "popo";
			
			trace("Straight " + hash);
			var revertedHash:Hash = hash.invert();
			trace("Inverted " + revertedHash);
			
			var stringHash:Hash = new Hash("Initial value");
			stringHash.store( { test:"test" } , "pedro");
			
			var mov:MovieClip = new MovieClip();
			stringHash.store(mov, "pepe");
			stringHash.ciudad = "San Antonio";
			
			var mov2:MovieClip = new MovieClip();
			trace(stringHash.fetch(mov2) + " || " + stringHash.fetch(mov));
			
			testDeletions(hash,stringHash,mov);
			
			testFirst(hash);
			testFirst(stringHash);
			testFirst(new Hash());
			
			testLoops(hash);
			testLoops(stringHash);
			
			allStrings(hash);
			allStrings(stringHash);
			
			notAllStrings(hash);
			notAllStrings(stringHash);
			
			testInjects(hash);
			testInjects(stringHash);
			
		}
		
		private function testDeletions(hash:Hash,stringHash:Hash, mov:MovieClip):void {
			hash.deleteItem("aKey");
			trace("Deleted item 'aKey'  with result " + hash);
			
			hash.deleteItem("cKey");
			trace("Tried to delete 'cKey' with result " + hash);
			
			hash.deleteItemIf(function(k:*, obj:*):Boolean {
				return obj is Array;
			});
			trace("Deleted item if is Array, with result " + hash);
			
			hash.deleteItemIf(function(k:*, obj:*):Boolean {
				return obj is Number;
			});
			trace("Deleted item if is Number, with result " + hash);
			
			stringHash.deleteItem(mov);
			trace("Deleted item '"+mov+"'  with result " + stringHash);
			
		}
		
		private function testFirst(hash:Hash):void {
			trace("The first element of " + hash + " is  " + hash.first());
		}
		
		private function testLoops(hash:Hash):void {
			trace("for loops for " + hash + "{");
			trace("\t//for:")
			var numItems = hash.length();
			for (var i:int = 0; i < numItems; i++) {
				trace("\t" + hash + ".getItemAt(" + i + ") = " + hash.getItemAt(i));
			}
			
			trace("\n\t//for in:")
			for (var key:String in hash) {
				trace("\t" + key + ": " + hash.fetch(key))
			}
			
			trace("\n\t//for each:")
			for each(var element:* in hash) {
				trace("\t" + element)
			}
			trace("}");
		}
		
		private function allStrings(hash:Hash):void {
			trace("All the elements of " + hash + " are Strings: " + hash.all(isString))
		}
		
		private function notAllStrings(hash:Hash):void {
			trace("All the elements of " + hash + " are not Strings: " + hash.any(isString))
		}
		
		private function isString(value:*):Boolean {
			return value is String;
		}
		
		private function testInjects(hash:Hash):void {
			trace(hash + " inject result: " + hash.inject());
			trace(hash.inject(hash + " inject results formated: ", function(memo:*, obj:*):String {
																														return obj is String ? memo + obj.replace(/^\w/, obj.charAt(0).toUpperCase()) + " ": memo;
																											}));
		}
		
	}

}
package net.humanrender.enum {

	import flash.display.MovieClip;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import net.humanrender.enum.core.enum;
	
	use namespace flash_proxy;
	use namespace enum;
	
	/**
	 * The dynamic Enum class provides collection classes with several traversal and searching methods, and with the ability to sort. 
	 */
	dynamic public class Enum extends Proxy{
		
		/**
		 * @private
		 */
		enum var indexedKeys:Array;
		/**
		 * @private
		 */
		enum var associative:Object;
		/**
		 * @private
		 */
		private var itemCount:int = 0;		

		public function Enum() {
			super();
			initialize();
		}
		
		/**
		 * @private
		 */
		protected function initialize():void {
			indexedKeys = [];
			associative = { };
		}
		
		/**
		 * Passes each element of the collection to the given function. The method returns true if the function never returns false or null. 
		 * @example
		 * <listing version="3.0"> 
		 * function allNumbers(item:Object):Boolean{
		 * 	return item is Number;
		 * }
		 * 
		 * enum // [1,2,3,4,5,6]
		 * enum.all(allNumbers) // true
		 * 
		 * enum // [1,2,3,"string"]
		 *  enum.all(allNumbers) // false
		 * </listing>
		 * @param	funktion	The function to wich all the elements are passed for evaluation
		 * @return	true if the function never returns false or null, otherwise, return false.
		 */
		public function all(funktion:Function):Boolean {
			for each (var value:* in this) {
				if (!funktion(value)) return false;
			}
			return true;
		}
		
		/**
		 * Passes each element of the collection to the given function. The method returns true if the function ever returns a value other than false or null.
		 * @example
		 * <listing version="3.0"> 
		 * function anyNumber(item:Object):Boolean{
		 * 	return item is Number;
		 * }
		 * 
		 * enum // ["a","b","c","d","e"]
		 * enum.any(anyNumber) // true
		 * 
		 * enum // ["a",1,"c","d","e"]
		 *  enum.any(anyNumber) // false
		 * </listing>
		 * @param	funktion The function to wich all the elements are passed for evaluation
		 * @return	true if the function ever returns a value other than false or null
		 */
		public function any(funktion:Function):Boolean { return !all(funktion); }
		
		/**
		 * Returns a new array with the results of running function once for every element in enum.
		 * 
		 * @example
		 * <listing version="3.0"> 
		 * enum // [1,2,3,4]
		 * enum.collect(function(item:Number):Object{
		 * 	return item + item;
		 * }); // [2,4,6,8]
		 * 
		 * enum // [1,2,3,4]
		 * enum.collect(function(item:Object):String{
		 * 	return "value;
		 * }); // ["value","value","value","value"]
		 * </listing>
		 * 
		 * @param	funktion	The function to run for every element in enum
		 * @return	An array with the results
		 */
		public function collect(funktion:Function):Array {
			var arr:Array = [];
			eachWithIndex(function(k:*, o:*,i:uint):void {
				var result:* = funktion(o);
				arr.push(result);
			});
			return arr;
		}
		
		/**
		 * Returns the number of items in enum. 
		 */
		public function get count():uint { return indexedKeys.length; }
		
		/**
		 * Passes each entry in enum to funktion. Returns the first for which funktion is not false or null. If no object matches, returns isNull or returns null
		 * @example
		 * <listing version="3.0"> 
		 * function getNumber(item:Object):Object{
		 * 	return item is Number;
		 * }
		 * 
		 * enum // ["a","b",99,"c",100]
		 * enum.detect(getNumber); // 99
		 * 
		 * enum // ["a","b","c","d"]
		 * enum.detect(getNumber) // null
		 * 
		 * enum // ["a","b","c","d"]
		 * enum.detect(getNumber,20); // 20
		 * </listing>
		 * @param	funktion	The function to wich all the elements are passed for detection.
		 * @param	isNull The value to return if no element matches
		 * @return	 the first element in enum not to return false when passed to funktion, isNull or null
		 */
		public function detect(funktion:Function, isNull:* = null):*{
			var value:* = isNull;
			eachWithIndex(function(k:*, o:*, i:uint):Boolean {
				if (funktion(o)) { value = o; return true; };
				return false;
			});
			return value;
		}
		
		/**
		 * Calls funktion with three arguments, the key, the item and its index, for each item in enum.  If the function returns void it will go through all the children in the collection. If the function return other value than void the cycle stops when true or a not null element is returned.
		 * @example
		 * <listing version="3.0"> 
		 * enum.a = "a_val"
		 * enum.b = "b_val"
		 * enum.c = "c_val"
		 * 
		 * enum.eachWithIndex(function(key:String, item:Object, index:int):void{
		 * 	trace(key + ": " + item + " is at index " + index);
		 * });
		 * 
		 * // a: a_val is at index 0
		 * // b: b_val is at index 1
		 * // c: c_val is at index 2
		 * 
		 * enum.eachWithIndex(function(key:String, item:Object, index:int):Boolean{
		 * 	trace(key + ": " + item + " is at index " + index);
		 * 	return key == "b";
		 * });
		 * 
		 * // a: a_val is at index 0
		 * // b: b_val is at index 1
		 * 
		 * </listing>
		 * @param	funktion Function with three arguments , the key, the item and the index
		 */
		public function eachWithIndex(funktion:Function):void {
			var i:uint = 0;
			for (var key:String in this) {
				var value:* = indexedKeys[i];
				value = associative[value];
				if(isComplex(value)){
					key = value.key;
					value = value.value;
				}
				var result:* = funktion(key, value, i);
				if (!(result == void) && result ) return;
				i++;
			}
		}
		
		/**
		 * Get the index of an element with a given key. If no key matches, -1
		 * @example
		 * <listing version="3.0"> 
		 * enum.a = 1;
		 * enum.b = 99;
		 * enum.c = 42;
		 * 
		 * enum.findIndex("a"); // 0
		 * enum.findIndex("b"); // 1
		 * enum.findIndex("c"); // 2
		 * </listing>
		 * @param	key Key of the element
		 * @return The index of the element stored under the key, if no key matches return -1
		 */
		public function findIndex(key:* ):int {
			var index:int = -1;
			eachWithIndex(function(k:*, obj:*, i:uint):uint {
				if (k == key) return index = i;
				return null;
			})
			return index;
		}
		
		/**
		 * Get the first element in the collecion
		 */
		public function get first():*{ 
			var key:*;
			if (indexedKeys[0] != null )  {
				key = indexedKeys[0];
				var item:* = associative[key];
				return getValueOf(item);
			}
			return  null;
		}
		
		/**
		 * Combines all elements of enum
		 * <p>If you don't specify a function, then all the elements get summed by +</p>
		 * <p>Else if you specify a function, then for each element in enum &lt;i&gt; the block is passed an accumulator value (&lt;i&gt;memo) and the element.  The result becomes the new value for memo. At the end of the iteration, the final value of memo is the return value fo the method.
		 * <br/>If you do not explicitly specify an initial value for memo, then uses null as the initial value of memo. 
		 * @example
		 * <listing version="3.0">
		 * enum // [10,20,30]
		 * enum.inject() // 60
		 * enum.inject(5) // 65
		 * 
		 * enum // ["a","b","c"]
		 * enum.inject("| ", function(memo:String, item:String):String{ return memo  + item + " | "; }); // | a | b | c | 
		 * </listing>
		 * @param	defaultValue
		 * @param	funktion
		 * @return
		 */
		public function inject(defaultValue:* = null, funktion:Function = null):*{
			var memo:* = defaultValue;
			eachWithIndex(function(k:*, obj:*, i:uint):void {
				if (funktion != null) {
					memo = funktion(memo, obj);
				}else
					memo = memo ? memo + obj : obj;
			})
			return memo;
		}
		
		/**
		 * Synonym of collect
		 * @see #collect()
		 */
		public function map(funktion:Function):Array {
			return collect(funktion);
		}
		
		/**
		 * The opposite of  all().
		 * @see #all()
		 * @example
		 * <listing version="3.0">
		 * function allNumbers(item:Object):Boolean{
		 * 	return item is Number;
		 * }
		 * 
		 * enum // ["a","b","c","d"]
		 * 
		 *  !(enum.all(allNumbers)); // true
		 * enum.none(allNumbers); // true
		 * </listing>
		 */
		public function none(funktion:Function):Boolean {
			return !all(funktion);
		}

		/**
		 *Passes each element of the collection to the given function. The method returns true if the function returns true  at least once. 
		 * @see #any()
		 * @example
		 * <listing version="3.0"> 
		 * function anyNumber(item:Object):Boolean{
		 * 	return item is Number;
		 * }
		 * enum // ["a",1,"c","d","e"]
		 * !(enum.any(anyNumber)) // true
		 * enum.one(anyNumber) // true
		 * </listing>
		 */
		public function one(funktion:Function):Boolean {
			return !any(funktion);
		}
		
		/**
		 * Get item at an index
		 * @example
		 * <listing version="3.0"> 
		 * enum // ["z","y","w""x"]
		 * 
		 * enum.getItemAt(0) // z
		 * enum.getItemAt(2) // w
		 * </listing>
		 * @param	index	0 based position of the desired item
		 * @return	The item at the specified index
		 */
		public function getItemAt(index:uint):*{
			if (index < indexedKeys.length) {
				var key:String = indexedKeys[index]
				var obj:* = associative[key];
				return getValueOf(obj);
			}
			return null;
		}
		
		/**
		 * Drops first n elements from enum, and returns rest elements in an array.  If n is greater than the total items in the collection, an empty Array is returned.
		 * @example
		 * <listing version="3.0"> 
		 * enum // ["a","b","c","d"]
		 * enum.drop(); //  ["a","b","c","d"]
		 * 
		 * enum // ["a","b","c","d"]
		 * enum.drop(2) // ["c","d"]
		 * </listing>
		 * @param	n	Number of elements to drop
		 * @return	An array containing the rest of the elements
		 */
		public function drop(n:uint = 0):Array {
			var c:uint = count;
			var arr:Array = [];
			if (n >= c  ) return arr;
			for (n; n < c; n++) {
				arr.push(getItemAt(n));
			}
			return arr;
		}
		
		/**
		 * Drops elements up to, but not including, the first element for which the function returns null or false and returns an array containing the remaining elements. 
		 * @example
		 * <listing version="3.0"> 
		 * enum // [100,200,300,400,500,600]
		 * 
		 * enum.dropWhile(function(item:*):Boolean{
		 * 	return item < 300;
		 * }); // [400,500,600]
		 * </listing>
		 * @param	funktion A function that receives one argument, the item for the current iteration. 
		 * @return An Array with the rest of the elements after the first element for which the function returns null or false 
		 */
		public function dropWhile(funktion:Function):Array {
			var i:int = -1;
			eachWithIndex(function(k:*, obj:*, index:uint):Boolean {
				if (!funktion(obj) ) i = index +1
				return i != -1;
			});
			return isNaN(i) ? [] : drop(i);
		}
		
		/**
		 * Iterates the given block for each array of consecutive elements.
		 * @example
		 * <listing version="3.0"> 
		 * enum // [1,2,3,4,5,6]
		 * enum.eachCons(function(pair:Array):void{
		 * 	trace(pair);
		 * });
		 * 
		 * // [1,2]
		 * // [3,4]
		 * // [5,6]
		 * </listing>
		 * @param	funktion The function to be called for each pair of elements
		 */
		public function eachCons(funktion:Function):void {
			var c:int = count -1;
			eachWithIndex(function(k:*, obj:*, index:uint):Boolean {
				if (index >= c) return true;
				funktion([obj, getItemAt(index + 1)]);
				return false;
			});
		}
		
		/**
		 * Synonym of toArray()
		 * @see #toArray()
		 */
		public function get entries():Array {
			return toArray();
		}
		
		/**
		 * Synonym of detect()
		 * @see #detect()
		 */
		public function find(funktion:Function,  isNull:* = null):*{
			return detect(funktion, isNull);
		}
		
		/**
		 * Returns an array containing all elements of enum for which funktion is not false
		 * @see #reject()
		 * @example
		 * <listing version="3.0">
		 * enum //[1,2,3,"a","b",{}]
		 * 
		 * enum.findAll(function(item:*):Boolean{
		 * 	return item is Number;
		 * }); // [1,2,3]
		 * </listing>
		 * @param	funktion	The function to be called in each iteration. Must receive the item as the argument
		 * @return	An array containing all elements of enum for which funktion is not false.
		 */
		public function findAll(funktion:Function):Array{
			var arr:Array = [];
			eachWithIndex(function(k:*, o:*, i:uint):void {
				if (funktion(o)) arr.push(o);
			});
			return arr;
		}
		
		/**
		 * Returns an array of every element in enum for which the pattern matches. If the optional function is supplied, each matching element is passed to it, and the function's result is stored in the output array. 
		 * @param	pattern	RegExp pattern to compare each element to
		 * @param	funktion	Optional function that executes for each matching element, storing it's return value in the output Array. 
		 * @return	Array with the matched elements
		 * 
		 * enum // ["foo","football","dog","foul","cat"]
		 * 
		 * enum.grep(/fo/); // ["foo","football","foul"]
		 * enum.grep(/fo/,function(item:*):String{
		 * 	return "match: " + item;
		 * }); // ["match: foo","match: football","match: foul"]
		 */
		public function grep(pattern:RegExp, funktion:Function = null):Array {
			var arr:Array = [];
			eachWithIndex(function(k:*, o:*, i:uint):void {
				if (!o) return;
				var stringedObject:String = o.toString();
				if (stringedObject.match(pattern)) 
					arr.push( funktion != null ? funktion(o) : o);
			});
			return arr;
		}
		
		/**
		 * Returns an enum, which keys are evaluated result from the function, and values are arrays of elements in enum corresponding to the key. 
		 * @example
		 * <listing version="3.0">
		 * enum // [1,2,3,4,5,6]
		 * 
		 * enum.groupBy(function(item:*):String {
		 *		return (item % 2) == 0 ? "even" : "odd";
		 *	});
		 * 
		 * enum.even // [2,4,6]
		 * enum.odd // [1,3,5]
		 *	</listing>
		 * @param	funktion	Function that evaluates the "group" of the element
		 * @return	An enum which keys are the groups of elements and the values for each key is an Array containing the matched elements
		 */
		public function groupBy(funktion:Function):Enum {
			var enum:Enum = new Enum();
			eachWithIndex(function(k:*, o:*, i:uint):void {
				var label:String = funktion(o);
				if (!enum[label]) enum[label] = new Array();
				enum[label].push(o);
			});
			return enum;
		}
		
		/**
		 * Returns true if any member of enum equals item. Equality is tested using ==. 
		 * @param	item
		 * @return	If the enum contains item returns true, else returns false
		 */
		public function includes(item:*):Boolean {
			var flag:Boolean = false;
			eachWithIndex(function(k:*, o:*, i:uint):Boolean {
				if (o == item) flag = true;
				return flag;
			});
			return flag;
		}
		
		/**
		 * Synonym of includes()
		 * @see #includes()
		 */
		public function member(item:*):Boolean {
			return includes(item);
		}
		
		/**
		 * Synonym of inject()
		 * @see #inject()
		 */
		public function reduce(defaultValue:* = null, funktion:Function = null):*{
			return inject(defaultValue, funktion);
		}
		
		/**
		 * Synonym of findAll()
		 * @see #findAll()
		 */
		public function select(funktion:Function):Array {
			return findAll(funktion);
		}
		
		/**
		 * Returns two arrays, the first containing the elements of enum for which the function evaluates to true, the second containing the rest. 
		 * @example
		 * <listing version="3.0">
		 * enum // [1,2,"a",3,"b"]
		 * enum.partition(function(item:*):Boolean{
		 * 	return item is Number;
		 * }); // [[1,2,3],["a","b"]]
		 * </listing>
		 * @param	funktion	The function that evaluates the element. Should return a Boolean value
		 * @return	two arrays, the first containing the elements of enum for which the function evaluates to true, the second containing the rest.
		 */
		public function partition(funktion:Function):Array {
			var good:Array = [];
			var bad:Array = [];
			eachWithIndex(function(k:*, o:*, i:uint):void {
				if (funktion(o)) good.push(o);
				else bad.push(o);
			});
			return [good, bad];
		}
		
		/**
		 * Returns an array for all elements of enum for which funktion is false
		 * @see #findAll()
		 * @example
		 * <listing version="3.0">
		 * enum // [1,2,"a",3,"b"]
		 * enum.reject(function(item:*):Boolean{
		 * 	return item is Number;
		 * }); // ["a","b"]
		 * </listing>
		 * @param	funktion The function that evaluates the element
		 * @return	An array for all elements of enum for which funktion is false
		 */
		public function reject(funktion:Function):Array {
			var arr:Array = [];
			eachWithIndex(function(k:*, o:*, i:uint):void {
				if (!funktion(o)) arr.push(o);
			});
			return arr;
		}
		
		/**
		 * Returns an Array with the elements sorted.
		 * <p>sort() uses the native Array .sort() method. The arguments are the same as Array.sort</p>
		 * @see Array#sort()
		 * @param	...args	Arguments for the native Array.sort() function
		 * @return	An Array with the elements sorted.
		 */
		public function sort(...args):Array {
			var sortedArray:Array = drop();
			var argsLenght:int = args.length;
			if (argsLenght == 0) sortedArray.sort(); // Sort with no parameters
			else {
				var param:* = args[0];
				if (param is Function) {
					if (argsLenght > 1) {
						var options:* = args[1];
						sortedArray.sort(param, options); // Sort with function and options
					}else sortedArray.sort(param); // Sort with function
					
				}else sortedArray.sort(param); // Sort with sorting options
			}
			return sortedArray;
		}

		/* Protected methods */
		/**
		 * @private
		 */
		protected function isComplex(object:*):Boolean {
			return object.hasOwnProperty("complex") ;
		}
		
		/**
		 * @private
		 */
		protected function getValueOf(object:*):*{
			return isComplex(object) ? object.value : object;
		}
		
		/* Core methods */
		
		/**
		 * @private
		 */
		public function toString():String {
			var str:String = 	inject("{", function(memo:*, obj:*):* {
															return memo == "{" ? memo + obj : memo + ", " + obj;
														}) + "}";
			return str;
		}
		
		/**
		 * Returns an Array wich elements are arrays consisting of key/value pairs for each element in enum. The zeroth index of the arrays is the key and the first index is the value
		 * @return an Array with key/value pairs for each element in enum
		 * @example
		 * <listing version="3.0">
		 * enum.a = 10
		 * enum.b = 20
		 * enum.c = 30
		 * enum.toArray() // [["a",10],["b",20],["c",30]]
		 * </listing>
		 */
		public function toArray():Array {
			var arr:Array = [];
			eachWithIndex(function(k:*, obj:*, index:uint):void {
				arr.push([k, obj]);
			});
			return arr;
		}
		
		/* Flash Proxy overriden functions */

		/**
		 * @private
		 */
		override flash_proxy function getProperty(name:*):*{
			return __getProperty(name);
		}
		
		/**
		 * @private
		 */
		protected function __getProperty(name:*):*{
			if ( isStringKey(name)  && associative.hasOwnProperty(name.toString()) ) {
				return getValueOf(associative[name]);
			}
			else {
				for (var indexedKey:String in indexedKeys) {
					var key:String = indexedKeys[indexedKey];
					var obj:* = associative[key];
					if (isComplex(obj) && obj.key == name) {
						return obj.value
					}
				}
			}
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function setProperty(name:*, value:*):void {
			__setProperty(name, value);
		}
		
		/**
		 * @private
		 */
		protected function __setProperty(name:*, value:*):void {
			var index:int = findIndex(name) ;
			var isComplex:Boolean = !isStringKey(name);
			if (index == -1) {
				var indexedKey :*;
				indexedKey = isComplex ? "item" + (itemCount++) : name.toString();
				indexedKeys.push(indexedKey);
				
				if (isComplex) {
					associative[indexedKey] = { complex:true, key:name, value:value };
				}else {
					associative[indexedKey] = value;
				}
			}else {
				if (isComplex) {
					for each(var key:String in indexedKeys) {
						var item:Object = associative[key];
						if (item.hasOwnProperty("complex") && item.key == name)  item.key  = value;
					}
				}
				else associative[name] = value;
			}
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextNameIndex (index:int):int {
            if (index < indexedKeys.length) {
                return index + 1;
            } else {
                return 0;
            }
        }
		
		/**
		 * @private
		 */
		override  flash_proxy function nextValue(index:int):*{
			var key:String = indexedKeys[index - 1];
			var obj:* = associative[key];
			return getValueOf(obj);
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String {
			var enumerated:* = indexedKeys[index - 1];
			return enumerated;
		}
		
		/**
		 * @private
		 */
		private function isStringKey(value:*):Boolean {
			return value is QName || value is String;
		}
		
		/**
		 * @private
		 */
		private function isString(value:*):Boolean {
			return value is String;
		}
		 
	}

}
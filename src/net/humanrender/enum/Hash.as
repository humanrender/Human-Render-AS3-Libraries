package net.humanrender.enum {
	
	import flash.utils.flash_proxy;
	import net.humanrender.enum.core.enum;
	
	use namespace flash_proxy;
	use namespace enum;
	/**
	 * @private
	 */
	dynamic public class Hash extends Enum{
		
		public function Hash(defaultValue:* = null) {
			this.defaultValue = defaultValue;
			super();
		}
		
		override flash_proxy function getProperty(name:*):*{
			var property:* = super.getProperty(name);
			return (!property && defaultValue) ? defaultValue : null;
		}
		
		override public function inject(defaultValue:* = null, funktion:Function = null):*{
			if (!defaultValue && this.defaultValue) defaultValue = this.defaultValue;
			return super.inject(defaultValue, funktion);
		}
		
		public function clear():void {
			indexedKeys = [];
			associative = {};
		}
		
		protected var _defaultValue:*;
		public function get defaultValue():* { return _defaultValue; }
		public function set defaultValue(value:*):void {
			if(value !== _defaultValue)
				_defaultValue = value;
		}
		
		public function deleteItem(key:*, funktion:Function = null):void {
			eachWithIndex(function(k:*, obj:*, i:uint):Boolean {
				if (key == k) {
					deleteItemAt(i);
					return true;
				}
				return false;
			})
		}
		
		public function deleteItemIf(funktion:Function):void {
			var garbage:Array = [];
			eachWithIndex(function(k:*, obj:*, i:*):Boolean {
				if (funktion(k, obj)) garbage.push(i);
				return false;
			});
			
			garbage.reverse();
			for each(var i:int in garbage) { deleteItemAt(i); }
		}
		
		protected function deleteItemAt(index:*):void {
			var key:String = indexedKeys[index];
			indexedKeys.splice(index, 1);
			delete associative[key];
		}

		public function each(funktion:Function):void {
			eachWithIndex(function(key:*, value:*, index:uint):void {
				funktion(value);
			});
		}
		
		public function get empty():Boolean {
			return indexedKeys.length == 0;
		}
		
		public function fetch(key:*):*{
			return __getProperty(key);
		}
		
		public function length():uint { return count; }
		
		public function hasKey(key:*):Boolean {
			var object:* = fetch(key);
			return object != null;
		}
		
		public function invert():Hash {
			var hash:Hash = clone();
			hash.indexedKeys.reverse();
			return hash;
		}
		
		protected function clone():Hash {
			var hash:Hash = new Hash();
			if (indexedKeys.length == 0) return hash;
			var clonedIndexKeys:Array = [];
			for each(var obj:* in indexedKeys) {
				clonedIndexKeys.push(obj);
			}
			clonedIndexKeys.reverse();
			hash.indexedKeys = clonedIndexKeys;
			var clonedAssociative:Object = { };
			for (var key:String in associative) {
				clonedAssociative[key] = associative[key];
			}
			hash.associative = clonedAssociative;
			return hash;
		}
		
		public function store(name:*, value:*):void {
			__setProperty(name, value);
		}
		
	}

}
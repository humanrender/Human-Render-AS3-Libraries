package  {
	
	import flash.display.Sprite;
	import net.humanrender.helpers.StringHelper
	
	public class validation extends Sprite{
		
		public function validation() {
			var string:String = "The quick? brown#fox !! @<jumps_over the 10th lazy dog";
			trace(StringHelper.toTitleCase(string))
		}
		
	}

}
package com.eclecticdesignstudio.utils;


import flash.display.DisplayObject;


/**
 * ...
 * @author Joshua Granick
 */

class Utils {

	
	public static function constrain (value:Float, lower:Float, upper:Float):Float {
		
		if (value < lower) {
			
			value = lower;
			
		}
		
		if (value > upper) {
			
			value = upper;
			
		}
		
		return value;
		
	}
	
	
	public static function ifNotNull (value:Dynamic, defaultValue:Dynamic):Dynamic {
		
		if (value != null) {
			
			return value;
			
		} else {
			
			return defaultValue;
			
		}
		
	}
	
	
	/**
	* Replaces an object with a new object.
	* @author Joshua Granick
	* @version 0.2
	* @return			Whether the object was successfully replaced
	*/
	public static function replaceObject (before:DisplayObject, after:DisplayObject, transform:Bool = false, roundPosition:Bool = false):Dynamic {
		
		if (before.parent == null) {
			
			return null;
			
		}
		
		if (transform) {
			
			after.scaleX = before.scaleX;
			after.scaleY = before.scaleY;
			after.transform = before.transform;
			
		}
		
		if (!roundPosition) {
			
			after.x = before.x;
			after.y = before.y;
			
		} else {
			
			after.x = Math.round (before.x);
			after.y = Math.round (before.y);
			
		}
		
		after.alpha = before.alpha;
		after.filters = before.filters;
		
		before.parent.addChildAt (after, before.parent.getChildIndex (before));
		before.parent.removeChild (before);
		
		return after;
		
	}
	
	
}
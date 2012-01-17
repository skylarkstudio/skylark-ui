package com.eclecticdesignstudio.utils;


/**
 * @author Joshua Granick
 */
class UniqueID {
	
	
	private static var index:Hash <Int> = new Hash <Int> ();
	
	
	public static function create (name:String = "uniqueID"):String {
		
		if (!index.exists (name)) {
			
			index.set (name, 0);
			
		}
		
		var id:String = name + Std.string (index.get (name));
		index.set (name, index.get (name) + 1);
		
		return id;
		
	}
	
	
}
/**
* @author Joshua Granick
* @version 0.1
*/


package com.eclecticdesignstudio.utils;


class MessageLog {
	
	
	private static var showErrors:Bool;
	private static var showDebug:Bool;
	private static var showVerbose:Bool;
	private static var throwErrors:Bool;
	private static var thrownError:Bool;
	
	
	/**
	 * Writes a debug message to the message log. This is only visible if you have called MessageLog.showDebugMessages()
	 * @param	sender		The object which is sending the message
	 * @param	message		A debug message
	 * @param	verbose		(Optional) A lengthy debug message. This is shown instead of the regular message if you have called MessageLog.showVerboseMessages()
	 */
	public static function debug (sender:Dynamic, message:String, verbose:String = null):Void {
		
		if (showDebug) {
			
			if (showVerbose && verbose != null) {
				
				MessageLog.trace (senderName (sender) + verbose);
				
			} else {
				
				MessageLog.trace (senderName (sender) + message);
				
			}
			
		}
		
	}
	
	
	/**
	 * Writes an error message to the message log or throws an error dialog message. This is only visible if you have called MessageLog.showErrorMessages() or have called MessageLog.throwErrorDialogs()
	 * @param	sender		The object which is sending the message
	 * @param	message		An error message
	 * @param	verbose		(Optional) A lengthy error message. This is shown instead of the regular message if you have called MessageLog.showVerboseMessages()
	 */
	public static function error (sender:Dynamic, message:String, verbose:String = null):Void {
		
		if (throwErrors && !thrownError) {
			
			if (showVerbose && verbose != null) {
				
				throw (senderName (sender) + "ERROR: " + verbose);
				
			} else {
				
				throw (senderName (sender) + "ERROR: " + message);
				
			}
			
		}
		
		if (showErrors) {
			
			if (showVerbose && verbose != null) {
				
				MessageLog.trace (senderName (sender) + "ERROR: " + verbose);
				
			} else {
				
				MessageLog.trace (senderName (sender) + "ERROR: " + message);
				
			}
			
		}
		
	}
	
	
	/**
	 * Converts an object into a "sender name" string
	 * @param	sender		The object which is sending the message
	 * @return		A "sender name" string
	 */
	private static function senderName (sender:Dynamic):String {
		
		if (sender == null) {
			
			return "";
			
		} else {
			
			var senderClass:Class <Dynamic>;
			
			if (Std.is (sender, Class)) {
				
				senderClass = sender;
				
			} else {
				
				senderClass = Type.getClass (sender);
				
			}
			
			var tempArray:Array <String> = Type.getClassName (senderClass).split (".");
			return "[" + tempArray[tempArray.length - 1] + "] ";
			
		}
		
	}
	
	
	/**
	 * Enable tracing of debug messages
	 */
	public static function showDebugMessages ():Void {
		
		showDebug = true;
		
	}
	
	
	/**
	 * Enable tracing of error messages
	 */
	public static function showErrorMessages ():Void {
		
		showErrors = true;
		
	}
	
	
	/**
	 * Enable tracing of verbose messages when available
	 */
	public static function showVerboseMessages ():Void {
		
		showVerbose = true;
		
	}
	
	
	/**
	 * Enable throwing of error dialogs. (Note: Flash will only allow one dialog if it is not contained within a try/catch block)
	 */
	public static function throwErrorDialogs ():Void {
		
		throwErrors = true;
		
	}
	
	
	public static function trace (message:Dynamic):Void {
		
		trace (message);
		
	}
	
	
}
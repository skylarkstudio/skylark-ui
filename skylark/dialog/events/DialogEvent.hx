package skylark.dialog.events;


import skylark.dialog.Dialog;
import flash.events.Event;


/**
 * @author Joshua Granick
 */
class DialogEvent extends Event {
	
	
	public static inline var CANCEL:String = "DialogEvent_Cancel";
	public static inline var CLOSE:String = "DialogEvent_Close";
	public static inline var NO:String = "DialogEvent_No";
	public static inline var OK:String = "DialogEvent_OK";
	public static inline var OPTION_1:String = "DialogEvent_Option1";
	public static inline var OPTION_2:String = "DialogEvent_Option2";
	public static inline var OPTION_3:String = "DialogEvent_Option3";
	public static inline var YES:String = "DialogEvent_Yes";
	
	public var data:Dynamic;
	public var dialog:Dialog;
	
	
	public function new (type:String, dialog:Dialog = null, data:Dynamic = null) {
		
		this.dialog = dialog;
		this.data = data;
		
		super (type);
		
	}
	
	
	public override function clone ():Event { 
		
		return new DialogEvent (type, dialog, data);
		
	}
	
	
}
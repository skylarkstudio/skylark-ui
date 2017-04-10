package skylark.dialog;


import skylark.utils.UniqueID;
import flash.display.DisplayObject;


/**
 * @author Joshua Granick
 */
class DialogData {
	
	
	public var alignOffsetX:Float;
	public var alignOffsetY:Float;
	public var constructor:Class<Dynamic>;
	public var display:DisplayObject;
	public var fadeInTime:Float;
	public var fadeOutTime:Float;
	public var name:String;
	public var trackOffsetX:Float;
	public var trackOffsetY:Float;
	public var type:DialogType;
	
	
	/**
	 * Contains the definition for a Dialog
	 * @param	name		A unique name for this definition. This is used to create and control dialogs of this type without using a strong reference
	 * @param	reference		Either a Class for generating multiple dialogs, or a DisplayObject (usable only as a single instance Dialog)
	 * @param	type		The type of dialog to create, such as DialogType.FIXED or DialogType.DRAGGABLE
	 */
	public function new (reference:Dynamic, name:String = "", type:DialogType = null) {
		
		if (name == "") {
			
			name = UniqueID.create ("DialogData");
			
		}
		
		if (type == null) {
			
			type = DialogType.DRAGGABLE;
			
		}
		
		this.name = name;
		this.type = type;
		
		if (Std.is (reference, Class)) {
			
			constructor = reference;
			
		} else {
			
			display = reference;
			display.x = 0;
			display.y = 0;
			
			if (display.parent != null) {
				
				display.parent.removeChild (display);
				
			}
			
		}
		
		alignOffsetX = 0;
		alignOffsetY = 0;
		fadeInTime = 1;
		fadeOutTime = 1;
		trackOffsetX = 10;
		trackOffsetY = 0;
		
	}
	
	
}
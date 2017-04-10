package skylark.ui;


import skylark.utils.Utils;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;


/**
 * @author Joshua Granick
 */
class InlineTextEditor extends Sprite {
	
	
	public var text:String;
	
	private var Text:TextField;
	
	private var backgroundColor:Int;
	private var cachedText:String;
	private var setSelection:Bool;
	private var suffix:String;
	
	
	public function new (textField:TextField, backgroundColor:Int, suffix:String = "") {
		
		super ();
		
		Text = textField;
		this.backgroundColor = backgroundColor;
		this.suffix = suffix;
		
		construct ();
		
	}
	
	
	private function construct ():Void {
		
		Text.autoSize = TextFieldAutoSize.LEFT;
		Text.backgroundColor = backgroundColor;
		Text.type = TextFieldType.INPUT;
		Text.appendText (suffix);
		
		Text.addEventListener (Event.CHANGE, Text_onChange);
		Text.addEventListener (MouseEvent.CLICK, Text_onClick);
		Text.addEventListener (FocusEvent.FOCUS_IN, Text_onFocusIn);
		Text.addEventListener (FocusEvent.FOCUS_OUT, Text_onFocusOut);
		
		Utils.replaceObject (Text, this);
		
		Text.x = 0;
		Text.y = 0;
		Text.alpha = 1;
		addChild (Text);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function Text_onChange (event:Event):Void {
		
		if (suffix != "" && Text.text.charAt (Text.text.length - 1) != suffix) {
			
			Text.appendText (suffix);
			
		}
		
		text = Text.text.substr (0, Text.text.length - 1);
		
		dispatchEvent (new Event (Event.RESIZE));
		dispatchEvent (new Event (Event.CHANGE));
		
	}
	
	
	private function Text_onClick (event:MouseEvent):Void {
		
		if (setSelection) {
			
			Text.setSelection (0, Text.text.length);
			setSelection = false;
			
		}
		
	}
	
	
	private function Text_onFocusIn (event:FocusEvent):Void {
		
		Text.background = true;
		setSelection = true;
		cachedText = Text.text;
		
	}
	
	
	private function Text_onFocusOut (event:FocusEvent):Void {
		
		Text.background = false;
		
		if (Text.text == ":") {
			
			Text.text = cachedText;
			
			dispatchEvent (new Event (Event.RESIZE));
			
		}
		
		dispatchEvent (new FocusEvent (FocusEvent.FOCUS_OUT));
		
	}
	
	
}
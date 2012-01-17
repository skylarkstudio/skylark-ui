package com.eclecticdesignstudio.helpers;


import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


/**
 * ...
 * @author Joshua Granick
 */
class TextFieldHelper {
	
	
	public static function applyText (textField:TextField, text:String, asHTML:Bool = true):Float {
		
		var format = textField.getTextFormat ();
		var width = textField.width;
		var height = textField.height;
		
		if (asHTML) {
			
			textField.htmlText = text;
			
		} else {
			
			textField.text = text;
			textField.setTextFormat (format);
			
		}
		
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.width = width;
		
		return textField.height - height;
		
	}
	
	
}
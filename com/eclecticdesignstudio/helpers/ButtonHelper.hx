package com.eclecticdesignstudio.helpers;


import motion.actuators.GenericActuator;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;


/**
 * @author Joshua Granick
 */
class ButtonHelper {
	
	
	public static function disable (button:Dynamic, time:Float = 1, alpha:Float = 0.3) {
		
		button.mouseEnabled = false;
		
		if (Std.is (button, Sprite)) {
			
			button.mouseChildren = false;
			
		}
		
		return DisplayObjectHelper.fade (cast (button, DisplayObject), alpha, time);
		
	}
	
	
	public static function enable (button:Dynamic, time:Float = 1) {
		
		button.mouseEnabled = true;
		return DisplayObjectHelper.fade (cast (button, DisplayObject), 1, time);
		
	}
	
	
	public static function handleEvent (handler:Dynamic, parameters:Array <Dynamic>):Event -> Void {
		
		return function (event:Event):Void {
			
			Reflect.callMethod (handler, handler, parameters);
			
		}
		
	}
	
	
	public static function hide (button:Dynamic, time:Float = 1) {
		
		button.mouseEnabled = false;
		return DisplayObjectHelper.fade (cast (button, DisplayObject), 0, time);
		
	}
	
	
	public static function makeButton (target:DisplayObject, clickHandler:Dynamic = null, onlyRequireMouseDown:Bool = false):Void {
		
		if (Std.is (target, Sprite)) {
			
			untyped target.mouseChildren = false;
			untyped target.buttonMode = true;
			
		}
		
		if (clickHandler != null) {
			
			if (!onlyRequireMouseDown) {
				
				target.addEventListener (MouseEvent.CLICK, clickHandler);
				
			} else {
				
				target.addEventListener (MouseEvent.MOUSE_DOWN, clickHandler);
				
			}
			
		}
		
	}
	
	
}
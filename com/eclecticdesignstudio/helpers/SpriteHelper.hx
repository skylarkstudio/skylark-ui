package com.eclecticdesignstudio.helpers;


import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import flash.display.Sprite;
import flash.events.MouseEvent;


/**
 * @author Joshua Granick
 */
class SpriteHelper {
	
	
	public static function disable (sprite:Sprite):Void {
		
		sprite.mouseEnabled = false;
		sprite.mouseChildren = false;
		
	}
	
	
	public static function enable (sprite:Sprite, mouseChildren:Bool = true):Void {
		
		sprite.mouseEnabled = true;
		
		if (mouseChildren) {
			
			sprite.mouseChildren = true;
			
		}
		
	}
	
	
	public static function hide (sprite:Sprite, time:Float = 1):IGenericActuator {
		
		disable (sprite);
		return DisplayObjectHelper.fade (sprite, 0, time);
		
	}
	
	
	public static function show (sprite:Sprite, time:Float = 1):IGenericActuator {
		
		enable (sprite);
		return DisplayObjectHelper.fade (sprite, 1, time);
		
	}
	
	
}
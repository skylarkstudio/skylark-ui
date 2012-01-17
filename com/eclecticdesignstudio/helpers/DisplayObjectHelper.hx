﻿package com.eclecticdesignstudio.helpers;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import flash.display.DisplayObject;


/**
 * @author Joshua Granick
 */
class DisplayObjectHelper {
	
	
	public static function fade (displayObject:DisplayObject, alpha:Float, time:Float, autoVisible:Bool = true):IGenericActuator {
		
		if (time > 0) {
			
			return Actuate.tween (displayObject, time, { alpha: alpha } ).autoVisible (autoVisible);
			
		} else {
			
			if (autoVisible) {
				
				if (alpha == 0) {
					
					displayObject.visible = false;
					
				} else {
					
					displayObject.visible = true;
					
				}
				
			}
			
			return Actuate.apply (displayObject, { alpha: alpha } );
			
		}
		
	}
	
	
}
package com.eclecticdesignstudio.ui;


import com.eclecticdesignstudio.helpers.ButtonHelper;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.utils.Utils;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;



/**
 * @author Joshua Granick
 */
class SlideToggle extends EventDispatcher {
	
	
	public var Slider:Sprite;
	public var SlideTrack:Sprite;
	
	public var column (getColumn, setColumn):Int;
	public var defaultTime:Float;
	public var row (getRow, setRow):Int;
	public var snapSensitivity:Float;
	public var totalColumns:Int;
	public var totalRows:Int;
	
	private var mouseOffsetX:Float;
	private var mouseOffsetY:Float;
	
	private var _column:Int;
	private var _row:Int;
	
	
	public function new (SlideTrack:Sprite, Slider:Sprite, totalColumns:Int = 2, totalRows:Int = 1) {
		
		super ();
		
		defaultTime = 0.75;
		snapSensitivity = 1;
		
		this.SlideTrack = SlideTrack;
		this.Slider = Slider;
		
		this.totalColumns = totalColumns;
		this.totalRows = totalRows;
		
		construct ();
		
	}
	
	
	private function construct ():Void {
		
		//Slider.mouseChildren = false;
		//Slider.mouseEnabled = false;
		
		ButtonHelper.makeButton (Slider, Slider_onMouseDown, true);
		ButtonHelper.makeButton (SlideTrack, SlideTrack_onMouseDown, true);
		
	}
	
	
	public function setValue (column:Int, row:Int = 1):Void {
		
		var properties:Dynamic = { };
		
		if (totalColumns > 1) {
			
			properties.x = SlideTrack.x + ((SlideTrack.width - Slider.width) / (totalColumns - 1)) * (column - 1);
			
		}
		
		if (totalRows > 1) {
			
			properties.y = SlideTrack.y + ((SlideTrack.height - Slider.height) / (totalRows - 1)) * (row - 1);
			
		}
		
		Actuate.tween (Slider, defaultTime, properties);
		
		_column = column;
		_row = row;
		
		dispatchEvent (new Event (Event.CHANGE));
		
	}
	
	
	private function updateSlidePosition (snapSensitivity:Float):Void {
		
		var newColumn = _column;
		var newRow = _row;
		
		var checkForSnap:Float;
		var snapDifference:Float;
		
		if (totalColumns > 1) {
			
			var columnOffsetX:Float = (SlideTrack.width - Slider.width) / totalColumns;
			checkForSnap = SlideTrack.mouseX / columnOffsetX;
			snapDifference = Math.abs (checkForSnap - Std.int (checkForSnap));
			
			if (snapDifference < snapSensitivity) {
				
				newColumn = Std.int (Utils.constrain (Std.int (checkForSnap), 1, totalColumns));
				
			}
			
		}
		
		if (totalRows > 1) {
			
			var rowOffsetY:Float = (SlideTrack.height - Slider.height) / totalRows;
			checkForSnap = SlideTrack.mouseY / rowOffsetY;
			snapDifference = Math.abs (checkForSnap - Std.int (checkForSnap));
			
			if (snapDifference < snapSensitivity) {
				
				newRow = Std.int (Utils.constrain (Std.int (checkForSnap), 1, totalRows));
				
			}
			
		}
		
		if (newRow != _row || newColumn != _column) {
			
			setValue (newColumn, newRow);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function getColumn ():Int {
		
		return _column;
		
	}
	
	
	private function setColumn (value:Int):Int {
		
		setValue (value, _row);
		
		return _column;
		
	}
	
	
	private function getRow ():Int {
		
		return _row;
		
	}
	
	
	private function setRow (value:Int):Int {
		
		setValue (_column, value);
		
		return _row;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function Slider_onMouseDown (event:MouseEvent):Void {
		
		mouseOffsetX = SlideTrack.mouseX;
		mouseOffsetY = SlideTrack.mouseY;
		
		SlideTrack.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		SlideTrack.stage.addEventListener (Event.MOUSE_LEAVE, stage_onMouseUp);
		SlideTrack.stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
	}
	
	
	private function SlideTrack_onMouseDown (event:MouseEvent):Void {
		
		updateSlidePosition (1);
		
	}
	
	
	private function stage_onEnterFrame (event:Event):Void {
		
		updateSlidePosition (snapSensitivity);
		
	}
	
	
	private function stage_onMouseUp (event:Event):Void {
		
		SlideTrack.stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		SlideTrack.stage.removeEventListener (Event.MOUSE_LEAVE, stage_onMouseUp);
		SlideTrack.stage.removeEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
	}
	
	
}
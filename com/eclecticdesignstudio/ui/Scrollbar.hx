package com.eclecticdesignstudio.ui;


import motion.Actuate;
import com.eclecticdesignstudio.utils.Utils;
import flash.display.DisplayObject;
import flash.display.MovieClip;
#if !jeash
import flash.display.SimpleButton;
#end
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.Lib;


/**
 * @author Joshua Granick
 */
class Scrollbar {
	
	
	public static inline var HORIZONTAL:String = "horizontal";
	public static inline var VERTICAL:String = "vertical";
	
	public var DownArrow:DisplayObject;
	public var Scroller:DisplayObject;
	public var ScrollTrack:DisplayObject;
	public var UpArrow:DisplayObject;
	
	public var currentPosition:Float;
	public var defaultTime:Float;
	public var increment:Float;
	public var maximum:Float;
	public var minimum:Float;
	public var orientation:String;
	public var target:Dynamic;
	public var property:String;
	
	private var DownTimer:Timer;
	private var UpTimer:Timer;
	
	private var elements:Array <DisplayObject>;
	private var hidden:Bool;
	private var scrollHeight (get, null):Float;
	private var scrollWidth (get, null):Float;
	
	
	public function new (orientation:String, ScrollTrack:DisplayObject, Scroller:DisplayObject, UpArrow:DisplayObject = null, DownArrow:DisplayObject = null) {
		
		defaultTime = 0.15;
		increment = 0.15;
		
		this.orientation = orientation;
		this.ScrollTrack = ScrollTrack;
		this.Scroller = Scroller;
		this.UpArrow = UpArrow;
		this.DownArrow = DownArrow;
		
		construct ();
		
	}
	
	
	private function construct ():Void {
		
		elements = [ ScrollTrack, Scroller ];
		
		if (UpArrow != null) {
			
			UpArrow.addEventListener (MouseEvent.MOUSE_DOWN, UpArrow_onMouseDown);
			elements.push (UpArrow);
			
		}
		
		if (DownArrow != null) {
			
			DownArrow.addEventListener (MouseEvent.MOUSE_DOWN, DownArrow_onMouseDown);
			elements.push (DownArrow);
			
		}
		
		if (Std.is (Scroller, Sprite)) {
			
			untyped Scroller.buttonMode = true;
			
		}
		
		if (Std.is (ScrollTrack, Sprite)) {
			
			untyped ScrollTrack.buttonMode = true;
			
		}
		
		Scroller.addEventListener (MouseEvent.MOUSE_DOWN, Scroller_onMouseDown);
		ScrollTrack.addEventListener (MouseEvent.MOUSE_DOWN, ScrollTrack_onMouseDown);
		
		DownTimer = new Timer (100);
		DownTimer.addEventListener (TimerEvent.TIMER, DownTimer_onTimer);
		UpTimer = new Timer (100);
		UpTimer.addEventListener (TimerEvent.TIMER, UpTimer_onTimer);
		
	}
	
	
	public function disable ():Void {
		
		for (element in elements) {
			
			#if !jeash if (Std.is (element, SimpleButton)) {
				
				untyped element.mouseEnabled = false;
				
			} else #end if (Std.is (element, Sprite)) {
				
				untyped element.mouseChildren = false;
				untyped element.mouseEnabled = false;
				
			}
			
		}
		
	}
	
	
	public function disableMouseWheel ():Void {
		
		if (Scroller.stage != null) {
			
			Scroller.stage.removeEventListener (MouseEvent.MOUSE_WHEEL, stage_onMouseWheel);
			
		}
		
	}
	
	
	public function enable ():Void {
		
		for (element in elements) {
			
			#if !jeash if (Std.is (element, SimpleButton)) {
				
				untyped element.mouseEnabled = true;
				
			} else #end if (Std.is (element, Sprite)) {
				
				untyped element.mouseChildren = true;
				untyped element.mouseEnabled = true;
				
			}
			
		}
		
	}
	
	
	public function enableMouseWheel ():Void {
		
		Scroller.stage.removeEventListener (MouseEvent.MOUSE_WHEEL, stage_onMouseWheel);
		Scroller.stage.addEventListener (MouseEvent.MOUSE_WHEEL, stage_onMouseWheel);
		
	}
	
	
	public function hide (time:Float = 1):Void {
		
		for (element in elements) {
			
			Actuate.tween (element, time, { alpha: 0 } );
			
		}
		
		hidden = true;
		
	}
	
	
	public function setTarget (target:Dynamic, property:String, minimum:Float, maximum:Float):Void {
		
		this.target = target;
		this.property = property;
		this.minimum = minimum;
		this.maximum = maximum;
		
		update (0);
		
	}
	
	
	public function scroll (percentage:Float, time:Float):Void {
		
		if (property != null) {
			
			var properties:Dynamic = { };
			Reflect.setProperty (properties, property, (maximum - minimum) * percentage + minimum);
			
			Actuate.tween (target, time, properties);
			
		}
		
		if (orientation == HORIZONTAL) {
			
			Actuate.tween (Scroller, time, { x: scrollWidth * percentage + ScrollTrack.x } );
			
		} else { 
			
			Actuate.tween (Scroller, time, { y: scrollHeight * percentage + ScrollTrack.y } );
			
		}
		
		currentPosition = percentage;
		
	}
	
	
	public function show (time:Float = 1):Void {
		
		for (element in elements) {
			
			Actuate.tween (element, time, { alpha: 1 } );
			
		}
		
		hidden = false;
		
	}
	
	
	public function update (time:Float = 0):Void {
		
		if (target != null && property != null) {
			
			currentPosition = Utils.constrain ((Reflect.getProperty (target, property) - minimum) / (maximum - minimum), 0, 1);
			scroll (currentPosition, time);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_scrollHeight ():Float {
		
		return (ScrollTrack.height) - (Scroller.height);
		
	}
	
	
	private function get_scrollWidth ():Float {
		
		return (ScrollTrack.width) - (Scroller.width);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function DownArrow_onMouseDown (event:MouseEvent):Void {
		
		DownArrow.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
		DownTimer_onTimer (null);
		DownTimer.start ();
		
	}
	
	
	private function DownTimer_onTimer (event:TimerEvent):Void {
		
		scroll (Utils.constrain (currentPosition + increment, 0, 1), defaultTime);
		
	}
	
	
	private function Scroller_onMouseDown (event:MouseEvent):Void {
		
		Scroller.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		Scroller.stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		Scroller.stage.addEventListener (Event.MOUSE_LEAVE, stage_onMouseLeave);
		
	}
	
	
	private function ScrollTrack_onMouseDown (event:MouseEvent):Void {
		
		var percent:Float;
		
		if (orientation == HORIZONTAL) {
			
			percent = Utils.constrain (ScrollTrack.mouseX / (ScrollTrack.width / ScrollTrack.scaleX), 0, 1);
			
		} else {
			
			percent = Utils.constrain (ScrollTrack.mouseY / (ScrollTrack.height / ScrollTrack.scaleY), 0, 1);
			
		}
		
		if (percent > currentPosition) {
			
			scroll (Utils.constrain (currentPosition + 0.2, 0, 1), defaultTime);
			
		} else {
			
			scroll (Utils.constrain (currentPosition - 0.2, 0, 1), defaultTime);
			
		}
		
	}
	
	
	private function stage_onEnterFrame (event:Event):Void {
		
		var percentage:Float;
		
		if (orientation == HORIZONTAL) {
			
			var targetX:Float = ScrollTrack.x + Utils.constrain (ScrollTrack.mouseX * ScrollTrack.scaleX - Scroller.width / 2, 0, scrollWidth);
			percentage = (targetX - ScrollTrack.x) / scrollWidth;
			Actuate.tween (Scroller, defaultTime, { x: targetX } );
			
		} else {
			
			var targetY:Float = ScrollTrack.y + Utils.constrain (ScrollTrack.mouseY * ScrollTrack.scaleY - Scroller.height / 2, 0, scrollHeight);
			percentage = (targetY - ScrollTrack.y) / scrollHeight;
			Actuate.tween (Scroller, defaultTime, { y: targetY } );
			
		}
		
		scroll (percentage, defaultTime);
		
	}
	
	
	private function stage_onMouseLeave (event:Event):Void {
		
		cast (event.currentTarget, IEventDispatcher).removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		cast (event.currentTarget, IEventDispatcher).removeEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
		UpTimer.stop ();
		DownTimer.stop ();
		
	}
	
	
	private function stage_onMouseUp (event:MouseEvent):Void {
		
		cast (event.currentTarget, IEventDispatcher).removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		cast (event.currentTarget, IEventDispatcher).removeEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
		UpTimer.stop ();
		DownTimer.stop ();
		
	}
	
	
	private function stage_onMouseWheel (event:MouseEvent):Void {
		
		if (!hidden) {
			
			var target:Float = Utils.constrain (currentPosition - event.delta / 16, 0, 1);
			scroll (target, 1);
			
		}
		
	}
	
	
	private function UpArrow_onMouseDown (event:MouseEvent):Void {
		
		UpArrow.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
		UpTimer_onTimer (null);
		UpTimer.start ();
		
	}
	
	
	private function UpTimer_onTimer (event:TimerEvent):Void {
		
		scroll (Utils.constrain (currentPosition - increment, 0, 1), defaultTime);
		
	}
	
	
}
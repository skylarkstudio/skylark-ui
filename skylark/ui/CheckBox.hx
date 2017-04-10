package skylark.ui;


import skylark.helpers.ButtonHelper;
import motion.Actuate;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;


/**
 * @author Joshua Granick
 */
class CheckBox extends EventDispatcher {
	
	
	public var Background:Sprite;
	public var CheckIcon:Sprite;
	public var Label:Sprite;
	
	public var checked (get, set):Bool;
	public var defaultTime:Float;
	
	private var cacheBackgroundAlpha:Float;
	private var cacheLabelAlpha:Float;
	private var currentAlphaPercentage:Float;
	
	private var _checked:Bool;
	
	
	public function new (CheckIcon:Sprite, Background:Sprite, Label:Sprite = null, checked:Bool = false) {
		
		super ();
		
		defaultTime = 0.5;
		
		this.CheckIcon = CheckIcon;
		this.Background = Background;
		
		if (Label != null) {
			
			this.Label = Label;
			
		}
		
		_checked = checked;
		
		construct ();
		
	}
	
	
	private function construct ():Void {
		
		CheckIcon.mouseChildren = false;
		CheckIcon.mouseEnabled = false;
		
		ButtonHelper.makeButton (Background, Background_onClick, true);
		cacheBackgroundAlpha = Background.alpha;
		
		if (Label != null) {
			
			ButtonHelper.makeButton (Label, Background_onClick, true);
			cacheLabelAlpha = Label.alpha;
			
		}
		
		currentAlphaPercentage = 1;
		toggleChecked (_checked, 0);
		
	}
	
	
	public function disable (time:Float = 0.5, alphaPercentage:Float = 0.3):Void {
		
		Actuate.tween (Background, time, { alpha: alphaPercentage * cacheBackgroundAlpha } );
		Background.mouseEnabled = false;
		
		if (Label != null) {
			
			Actuate.tween (Label, time, { alpha: alphaPercentage * cacheLabelAlpha } );
			Label.mouseEnabled = false;
			
		}
		
		if (_checked) {
			
			Actuate.tween (CheckIcon, time, { alpha: alphaPercentage } );
			
		}
		
		currentAlphaPercentage = alphaPercentage;
		
	}
	
	
	public function enable (time:Float = 0.5):Void {
		
		Actuate.tween (Background, time, { alpha: 1 * cacheBackgroundAlpha } );
		Background.mouseEnabled = true;
		
		if (Label != null) {
			
			Actuate.tween (Label, time, { alpha: 1 * cacheLabelAlpha } );
			Label.mouseEnabled = true;
			
		}
		
		if (_checked) {
			
			Actuate.tween (CheckIcon, time, { alpha: 1 } );
			
		}
		
		currentAlphaPercentage = 1;
		
	}
	
	
	private function toggleChecked (value:Bool, time:Float, sendEvent:Bool = true):Void {
		
		if (value) {
			
			Actuate.tween (CheckIcon, time, { alpha: currentAlphaPercentage } );
			
		} else {
			
			Actuate.tween (CheckIcon, time, { alpha: 0 } );
			
		}
		
		_checked = value;
		
		if (sendEvent) {
			
			dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_checked ():Bool {
		
		return _checked;
		
	}
	
	
	private function set_checked (value:Bool):Bool {
		
		toggleChecked (value, defaultTime, false);
		
		return _checked;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function Background_onClick (event:MouseEvent):Void {
		
		toggleChecked (!_checked, defaultTime);
		
	}
	
	
}
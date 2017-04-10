package skylark.dialog;


import skylark.dialog.events.DialogEvent;
import skylark.helpers.ButtonHelper;
import skylark.helpers.SpriteHelper;
import motion.Actuate;
import motion.actuators.GenericActuator;
import flash.display.DisplayObject;
#if !jeash
import flash.display.SimpleButton;
#end
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;


/**
 * @author Joshua Granick
 */
class Dialog extends Sprite {
	
	
	public var Display:Dynamic;
	
	public var closed (default, null):Bool;
	public var dialogData:DialogData;
	
	private var dialogManager:DialogManager;
	private var dragOffsetX:Float;
	private var dragOffsetY:Float;
	private var init:Dynamic;
	
	
	public function new (dialogData:DialogData, init:Dynamic = null, dialogManager:DialogManager = null) {
		
		super ();
		
		this.dialogData = dialogData;
		this.init = init;
		this.dialogManager = dialogManager;
		
		initialize ();
		construct ();
		
	}
	
	
	public function bringForward ():Void {
		
		if (parent != null) {
			
			parent.setChildIndex (this, parent.getChildIndex (this) + 1);
			
		}
		
	}
	
	
	public function bringToFront ():Void {
		
		if (parent != null) {
			
			parent.addChild (this);
			
		}
		
	}
	
	
	public function close ():Void {
		
		hide ().onComplete (remove);
		closed = true;
		
	}
	
	
	private function construct ():Void {
		
		if (Std.is (Display, IDialogDisplay)) {
			
			Display.addEventListener (DialogEvent.CANCEL, Display_onEvent);
			Display.addEventListener (DialogEvent.CLOSE, Display_onEvent);
			Display.addEventListener (DialogEvent.NO, Display_onEvent);
			Display.addEventListener (DialogEvent.OK, Display_onEvent);
			Display.addEventListener (DialogEvent.OPTION_1, Display_onEvent);
			Display.addEventListener (DialogEvent.OPTION_2, Display_onEvent);
			Display.addEventListener (DialogEvent.OPTION_3, Display_onEvent);
			Display.addEventListener (DialogEvent.YES, Display_onEvent);
			
		}
		
		addChild (cast (Display, DisplayObject));
		
		constructButton ("CancelButton", DialogEvent.CANCEL);
		constructButton ("CloseButton", DialogEvent.CLOSE);
		constructButton ("NoButton", DialogEvent.NO);
		constructButton ("OkButton", DialogEvent.OK);
		constructButton ("Option1Button", DialogEvent.OPTION_1);
		constructButton ("Option2Button", DialogEvent.OPTION_2);
		constructButton ("Option3Button", DialogEvent.OPTION_3);
		constructButton ("YesButton", DialogEvent.YES);
		
		if (dialogData.type == DialogType.DRAGGABLE) {
			
			addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
			
		} else if (dialogData.type == DialogType.TRACK_MOUSE) {
			
			addEventListener (Event.ADDED_TO_STAGE, this_onAddedToStage);
			
		}
		
	}
	
	
	private function constructButton (name:String, eventType:String):Void {
		
		if (Reflect.hasField (Display, name) || Reflect.hasField (Display, "get_" + name)) {
			
			ButtonHelper.makeButton (Reflect.getProperty (Display, name), ButtonHelper.handleEvent (sendEvent, [ eventType ]), true);
			
		}
		
	}
	
	
	public function hide ():GenericActuator<Dynamic> {
		
		if (!closed) {
			
			return SpriteHelper.hide (this, dialogData.fadeOutTime);
			
		} else {
			
			return Actuate.timer (0);
			
		}
		
	}
	
	
	public function hideAutomatically (delay:Float = 2):Void {
		
		Actuate.timer (delay).onComplete (hide);
		
	}
	
	
	private function initialize ():Void {
		
		if (dialogData.display != null) {
			
			Display = dialogData.display;
			
		} else if (init) {
			
			Display = Type.createInstance (dialogData.constructor, [ init ] );
			
		} else {
			
			Display = Type.createEmptyInstance (dialogData.constructor);
			
		}
		
	}
	
	
	public function pushBackward ():Void {
		
		if (parent != null) {
			
			parent.setChildIndex (this, parent.getChildIndex (this) - 1);
			
		}
		
	}
	
	
	public function pushToBack ():Void {
		
		if (parent != null) {
			
			parent.setChildIndex (this, 0);
			
		}
		
	}
	
	
	/**
	 * @private
	 */
	public function remove ():Void {
		
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		if (stage != null) {
			
			stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
			
		}
		
		if (dialogManager != null) {
			
			dialogManager.remove (this);
			
		}
		
	}
	
	
	public function resetDragging ():Void {
		
		stopDragging ();
		startDragging ();
		
	}
	
	
	private function sendEvent (type:String):Void {
		
		var data:Dynamic = null;
		
		if (Std.is (Display, IDialogDisplay)) {
			
			data = Display.getData ();
			
		}
		
		dialogManager.sendEvent (new DialogEvent (type, this, data));
		
		if (type == DialogEvent.CLOSE) {
			
			close ();
			
		}
		
	}
	
	
	public function show () {
		
		closed = false;
		return SpriteHelper.show (this, dialogData.fadeInTime);
		
	}
	
	
	private function startDragging ():Void {
		
		if (dialogData.type == DialogType.DRAGGABLE) {
			
			dragOffsetX = - mouseX;
			dragOffsetY = - mouseY;
			
		} else if (dialogData.type == DialogType.TRACK_MOUSE) {
			
			dragOffsetX = dialogData.trackOffsetX;
			dragOffsetY = dialogData.trackOffsetY;
			x = Math.round (stage.mouseX + dragOffsetX);
			y = Math.round (stage.mouseY + dragOffsetY);
			
		}
		
		if (dialogData.type != DialogType.FIXED) {
			
			removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
			stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
			addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
			stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
			
		}
		
	}
	
	
	private function stopDragging ():Void {
		
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function Display_onEvent (event:Event):Void {
		
		sendEvent (event.type);
		
	}
	
	
	private function stage_onMouseUp (event:MouseEvent):Void {
		
		stopDragging ();
		
	}
	
	
	private function this_onAddedToStage (event:Event):Void {
		
		startDragging ();
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		x = x + mouseX + dragOffsetX;
		y = y + mouseY + dragOffsetY;
		//x = Math.round (x + (mouseX * scaleX + dragOffsetX - x) * 0.4);
		//y = Math.round (y + (mouseY * scaleY + dragOffsetY - y) * 0.4);
		
	}
	
	
	private function this_onMouseDown (event:MouseEvent):Void {
		
		#if !jeash if (Std.is (event.target, SimpleButton)) { return; } #end
		if (Std.is (event.target, TextField) && cast (event.target, TextField).type == TextFieldType.INPUT) { return; }
		if (Std.is (event.target, Sprite) && cast (event.target, Sprite).buttonMode) { return; }
		if (Std.is (event.target, IEventDispatcher)) {
			if (cast (event.target, IEventDispatcher).hasEventListener (MouseEvent.MOUSE_DOWN)) { return; }
			if (cast (event.target, IEventDispatcher).hasEventListener (MouseEvent.CLICK)) { return; }
		}
		
		startDragging ();
		
	}
	
	
}
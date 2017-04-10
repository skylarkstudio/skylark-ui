package skylark.dialog;


import skylark.dialog.events.DialogEvent;
import skylark.helpers.SpriteHelper;
import skylark.utils.MessageLog;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;


/**
 * @author Joshua Granick
 */
class DialogManager extends EventDispatcher {
	
	
	private static var global:DialogManager;
	
	private var dialogDataByName:Map<String, DialogData>;
	private var dropPoint:Sprite;
	private var initialized:Bool;
	private var instancesByDisplayOrder:Array<Dynamic>;
	private var instancesByName:Map<String, Array<Dialog>>;
	
	
	public function new (dropPoint:Sprite):Void {
		
		super ();
		
		this.dropPoint = dropPoint;
		
		dialogDataByName = new Map<String, DialogData> ();
		instancesByDisplayOrder = new Array <Dialog> ();
		instancesByName = new Map<String, Array <Dialog>> ();
		
	}
	
	
	/*public static function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		checkInitialized ();
		global.addEventListener (type, listener, useCapture, priority, useWeakReference);
		
	}*/
	
	
	private static function checkInitialized ():Void {
		
		if (global == null) {
			
			MessageLog.error (DialogManager, "You must use the DialogManager.initialize method to set the dropPoint before you can start using the global DialogManager instance. Otherwise you can also create a local instance by using new DialogManager ()");
			
		}
		
	}
	
	
	public function close (dialog:Dynamic):Void {
		
		var name = getName (dialog);
		var instances = instancesByName.get (name);
		
		var i = instances.length - 1;
		
		while (i >= 0) {
			
			var instance:Dialog = instances[i];
			
			if (instance != null && !instance.closed) {
				
				instance.close ();
				return;
				
			}
			
			i--;
			
		}
		
	}
	
	
	/*public static function close (dialog:Dynamic):Void {
		
		checkInitialized ();
		global.close (dialog);
		
	}*/
	
	
	public function closeAll ():Void {
		
		for (instance in instancesByDisplayOrder) {
			
			if (!instance.closed) {
				
				instance.close ();
				
			}
			
		}
		
	}
	
	
	/*public static function closeAll ():Void {
		
		checkInitialized ();
		global.closeAll ();
		
	}*/
	
	
	public function closeTop ():Void {
		
		checkInitialized ();
		
		var i = instancesByDisplayOrder.length - 1;
		
		while (i >= 0) {
			
			var instance:Dialog = instancesByDisplayOrder[i];
			
			if (!instance.closed) {
				
				instance.close ();
				return;
				
			}
			
			i--;
			
		}
		
	}
	
	
	/*public static function closeTop ():Void {
		
		checkInitialized ();
		global.closeTop ();
		
	}*/
	
	
	public function contains (name:String):Bool {
		
		return (dialogDataByName.exists (name));
		
	}
	
	
	/*public static function contains (name:String):Bool {
		
		checkInitialized ();
		return global.contains (name);
		
	}*/
	
	
	public function create (dialog:Dynamic, init:Dynamic = null, singleInstance:Bool = false):Dialog {
		
		var name:String = getName (dialog);
		
		if (Std.is (dialog, DialogData) && !contains (name)) {
			
			register (dialog);
			
		}
		
		if (dialogDataByName.exists (name)) {
			
			var dialogData = dialogDataByName.get (name);
			
			if (dialogData.display != null && instancesByName.get (name).length > 0) {
				
				show (dialogData);
				
				return null;
				
			} else {
				
				var instance = new Dialog (dialogData, init, this);
				instance.x = - instance.width / 2 + instance.dialogData.alignOffsetX;
				instance.y = - instance.height / 2 + instance.dialogData.alignOffsetY;
				SpriteHelper.hide (instance, 0);
				dropPoint.addChild (instance);
				
				if (singleInstance) {
					
					for (previousInstance in instancesByName.get (name)) {
						
						previousInstance.close ();
						
					}
					
				}
				
				instancesByName.get (name).push (instance);
				instancesByDisplayOrder.push (instance);
				
				return instance;
				
			}
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	/*public static function create (dialog:Dynamic, init:Object = null, singleInstance:Bool = false):Dialog {
		
		checkInitialized ();
		return global.create (dialog, init, singleInstance);
		
	}*/
	
	
	private static function getName (dialog:Dynamic):String {
		
		checkInitialized ();
		
		if (Std.is (dialog, Dialog)) {
			
			return untyped dialog.dialogData.name;
			
		} else if (Std.is (dialog, DialogData)) {
			
			return untyped dialog.name;
			
		} else if (dialog != null) {
			
			return Std.string (dialog);
			
		} else {
			
			return "";
			
		}
		
	}
	
	
	/*public static function hasEventListener (type:String):Bool {
		
		checkInitialized ();
		return global.hasEventListener (type);
		
	}*/
	
	
	public function hide (dialog:Dynamic, hideAll:Bool = true):Void {
		
		var name = getName (dialog);
		var instances = instancesByName.get (name);
		
		if (instances != null) {
			
			if (hideAll) {
				
				for (instance in instances) {
					
					instance.hide ();
					
				}
				
			} else if (instances.length > 0) {
				
				instances[instances.length - 1].hide ();
				
			}
			
		}
		
	}
	
	
	/*public static function hide (dialog:Dynamic, hideAll:Bool = true):Void {
		
		checkInitialized ();
		global.hide (dialog, hideAll);
		
	}*/
	
	
	public static function initialize (dropPoint:Sprite):Void {
		
		if (global == null) {
			
			global = new DialogManager (dropPoint);
			
		} else {
			
			global.dropPoint = dropPoint;
			
			if (global.instancesByDisplayOrder.length > 0) {
				
				for (instance in global.instancesByDisplayOrder) {
					
					global.dropPoint.addChild (instance);
					
				}
				
			}
			
		}
		
	}
	
	
	public function register (dialogData:DialogData):Void {
		
		dialogDataByName.set (dialogData.name, dialogData);
		
		if (!instancesByName.exists (dialogData.name)) {
			
			instancesByName.set (dialogData.name, new Array <Dialog> ());
			
		}
		
	}
	
	
	/*public static function register (dialogData:DialogData):Void {
		
		checkInitialized ();
		global.register (dialogData);
		
	}*/
	
	
	/**
	 * @private
	 */
	public function remove (instance:Dialog):Void {
		
		if (instance.parent != null) {
			
			instance.parent.removeChild (instance);
			
		}
		
		instancesByName.get (instance.dialogData.name).remove (instance);
		instancesByDisplayOrder.remove (instance);
		
	}
	
	
	/*public static function removeEventListener (type:String, listener:Dynamic, useCapture:Bool = false):Void {
		
		checkInitialized ();
		global.removeEventListener (type, listener, useCapture);
		
	}*/
	
	
	/**
	 * @private
	 */
	public function sendEvent (event:Event):Void {
		
		dispatchEvent (event);
		
	}
	
	
	public function show (dialog:Dynamic, init:Dynamic = null):Void {
		
		var name = getName (dialog);
		var instances = instancesByName.get (name);
		var instance:Dialog;
		
		if (instances != null && instances.length > 0) {
			
			instances[instances.length - 1].show ();
			
		} else {
			
			instance = create (dialog, init);
			
			if (instance != null) {
				
				instance.show ();
				
			}
			
		}
		
	}
	
	
	/*public static function show (dialog:Dynamic, init:Object = null):Void {
		
		checkInitialized ();
		global.show (dialog, init);
		
	}*/
	
	
}
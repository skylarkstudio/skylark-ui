package skylark.dialog;


import flash.events.IEventDispatcher;


/**
 * @author Joshua Granick
 */
interface IDialogDisplay extends IEventDispatcher {
	
	
	function getData ():Dynamic;
	
	
}
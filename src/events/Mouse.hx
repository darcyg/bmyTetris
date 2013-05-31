package events;

/**
 * ...
 * @author GuyF
 */
class Mouse 
{
	// http://haxe.org/manual/tips_and_tricks
	@:extern public static inline var MOUSEDOWN = "mousedown";
	@:extern public static inline var CLICK = "click";
	@:extern public static inline var MOUSEMOVE = "mousemove";
	@:extern public static inline var MOUSEOVER = "mouseover";
	@:extern public static inline var MOUSEOUT = "mouseout";
	
	@:extern public static inline var STAGEMOUSEUP = "stagemouseup";
	@:extern public static inline var STAGEMOUSEDOWN = "stagemousedown";
	@:extern public static inline var STAGEMOUSEMOVE = "stagemousemove";
	
}
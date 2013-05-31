package events;

/**
 * definition des evenements du clavier
 * http://javascript.info/tutorial/keyboard-events
 * @author GuyF
 */
class Key 
{
	// http://haxe.org/manual/tips_and_tricks
	/**
	 * Keypress triggers after keydown and gives char-code, but it is guaranteed for character keys only.
	 */
	@:extern public static inline var KEYPRESS = "keypress";
	/**
	 * Keydown triggers on any key press and gives scan-code.
	 */
	@:extern public static inline var KEYDOWN = "keydown";
	@:extern public static inline var KEYUP = "keyup";
	
}
package gf;

/**
 * ...
 * @author GuyF
 */
class GTools
{

	/**
	 * TODO : extraire dans boite à outils
	 * calcul la distance de manhattan en 2 points
	 * @param	x0
	 * @param	y0
	 * @param	x1
	 * @param	y1
	 * @return
	 */
	public static function distance_manhattan(x0:Int, y0:Int, x1:Int, y1:Int ):Int {
		return helper_absSub(x0, x1) + helper_absSub(y0, y1);
	}
	public static function helper_absSub(a:Int, b:Int):Int {
		return a > b?a - b:b - a;
	}
	
	public static function fdistance_manhattan(x0:Float, y0:Float, x1:Float, y1:Float ):Float {
		return fhelper_absSub(x0, x1) + fhelper_absSub(y0, y1);
	}
	public static function fhelper_absSub(a:Float, b:Float):Float {
		return a > b?a - b:b - a;
	}
	
}
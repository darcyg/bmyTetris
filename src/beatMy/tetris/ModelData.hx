package beatMy.tetris;

/**
 * ...
 * @author GuyF
 * singleton
 * base data 
 */
class ModelData
{
	/**
	 * une case vide
	 */
	public static var EMPTY : Int = 0;
	
	/**
	 * une case pleine et normal
	 */
	public static var FILL : Int = 1;
	/**
	 * une case pleine contenant du pouvoir
	 * (non utilisé)
	 */
	public static var POWER : Int = 2;
	
	/**
	 * nombre de colonnes du plateau
	 */
	public  static var COLS : Int = 10;
	/**
	 * nombre de lignes du plateau
	 */
	public  static var ROWS : Int = 20;
	
	/**
	 * largeur max d'une forme
	 */
	public static var SHAPE_WIDTH:Int = 4;
	/**
	 * hauteur max d'une forme
	 */
	public static var SHAPE_HEIGHT:Int = 4;
	
	/**
	 * liste des formes possibles
	 */
	public var shapes : Array<Array<Int>> ;
	
	/**
	 * liste des couleurs des formes respectives
	 */
	public var colors : Array<String>;
	
	/**
	 * instance du singleton
	 */
	private static var _me:ModelData;
	
	/**
	 * acces du singleton
	 * @return l'objet singleton
	 */
	public static function me():ModelData {
		if (_me != null) return _me;
		_me = new ModelData();
		return _me;
	}
	
	private function new() 
	{
		 intShapes();
		 initColors();
	}
	
	/**
	 * initialisation de la liste des formes
	 */
	private function intShapes() {
		shapes = [
			[1, 1, 1, 1],
			[1, 1, 1, 0,
			 1],
			[1, 1, 1, 0,
			 0, 0, 1],
			[1, 1, 0, 0,
			 1, 1],
			[1, 1, 0, 0,
			 0, 1, 1],
			[0, 1, 1, 0,
			 1, 1],
			[1, 1, 1, 0,
			 0, 1], 
			 
		];
	
	}
	
	/**
	 * initialisation de la liste des couleurs
	 */
	private function initColors() {
		colors =  ['cyan', 'orange', 'blue', 'yellow', 'red', 'green', 'purple'];
	}
	
}
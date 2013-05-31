package beatMy.tetris;
import js.html.svg.AnimatedBoolean;
import js.html.VoidCallback;

/**
 * model du plateaur
 * @author GuyF
 */
class ModelBoard
{
	/**
	 * structure du plateau
	 */
	public var board  :  Array<Array<Int>>;
	
	/**
	 * accès à l'état d'une case du plateau
	 * @param	x
	 * @param	y
	 * @return l'état de la case
	 */
	public function get_piece(x:Int, y:Int):Int {
		return board[ y ][ x ] ;
	}
	
	/**
	 * forme actuellement manipulée
	 */
	private var current : ModelPiece;
	
	/**
	 * accès à la forme actuellement manipulé
	 * @return la forme
	 */
	public function get_current():ModelPiece {
		return current;
	}
	
	
	public function new() 
	{
		helper_builder();
		current = newCurrent();
	}
	
	/**
	 * generation d'un plateu vide
	 */
	private function helper_builder():Void {
		 board  = new  Array<Array<Int>>();
		 for (y in 0...ModelData.ROWS) {
			 board[y] = new Array<Int>();
			 for (x in 0...ModelData.COLS) {
				 board[ y ][ x ] = 0;
			 }
		 }
	}
	
	/**
	 * creation d'une nouvelle forme aléatoir à manipuler
	 * @return
	 */
	public function newCurrent():ModelPiece {
		var id = Math.floor(Math.random() * ModelData.me().shapes.length);
		var ret = new ModelPiece(id);
		ret.x = 2;
		ret.y = 0;
		return ret;
		
	}
	
	/**
	 * demande de rotation de la piece
	 * @return false si la piece ne peut par tourner
	 */
	public function rotate():Bool {
		var cloneCurrent = current.clone_rotate();
		if (valide(cloneCurrent)) {
			current = cloneCurrent;
			return true;
		} else if (valide(cloneCurrent,1)) {
			current = cloneCurrent;
			current.x++;
			return true;
		} else if (valide(cloneCurrent,-1)) {
			current = cloneCurrent;
			current.x--;
			return true;
		} 
		return false;
	}
	
	/**
	 * demande de deplacement vers la gauche
	 * @return false si le deplacement est impossible
	 */
	public function left():Bool {
		if (valide(current, -1)) {
			current.x--;
			return true;
		}
		return false;
	}
	public function right():Bool {
		if (valide(current, 1)) {
			current.x++;
			return true;
		}
		return false;
	}
	
	/**
	 * test si la forme sera valide 
	 * @param	piece
	 * @param	offsetX
	 * @param	offsetY
	 * @return
	 */
	public function valide(piece:ModelPiece, offsetX:Int = 0, offsetY:Int = 0):Bool {
		for ( y in 0...piece.forme.length ) {
			for ( x in 0...piece.forme[y].length ) {
				if (  piece.forme[ y ][ x ] == ModelData.FILL ) {
					// prochaine position de la case existante
					var ny = piece.y + y + offsetY;
					var nx = piece.x + x + offsetX;
//					trace(nx+" "+ ny);
					if ( ny < 0
						|| ny >= ModelData.ROWS
						|| nx < 0
						|| nx >= ModelData.COLS
						||  board[ ny ][ nx ] != 0 
						) {
						return false;
					}
				}
			}
		}
		return true;
	}
	/**
	 * supprime les lignes pleines
	 * @return le nombre de lignes suprimée
	 */
	function clearLines():Int {
		var ret:Int = 0;
		var _y = -(ModelData.ROWS - 1);
		while (_y!=0) {
			var row = true;
			for (  x in 0...ModelData.COLS ) {
				if ( board[ -_y ][ x ] == 0 ) {
					row = false;
					break;
				}
			}
			if ( row ) {
				
				for ( _yy in _y...0) {
					for ( x in 0...ModelData.COLS ) {
						// drop down line
						board[ -_yy ][ x ] = board[ -_yy - 1 ][ x ];
						// TODO: POWER
						// IF board[ -_yy ][ x ] == ModelData.POWER
						// DO SOMETHING !
						// clear droped line
						board[ -_yy - 1 ][ x ] = 0;
					}
				}
				ret++;
			} else {
				_y++;
			}
		}
		return ret;
	}
	
	/**
	 * fige la piece sur la plateau
	 * @param	piece
	 */
	function freeze(piece:ModelPiece):Void {
		for ( y in 0...piece.forme.length ) {
			for ( x in 0...piece.forme[y].length ) {
				if ( piece.forme[ y ][ x ] == ModelData.FILL ) {
					board[ piece.y + y ][ piece.x + x ] = piece.forme[ y ][ x ];
				}
			}
		}
	}
	/**
	 * FLAG mis à jour à chaque tick
	 * partie perdu
	 */
	public var lose:Bool = false;
	/**
	 * FLAG mis à jour à chaque tick
	 * nombre de lignes vidées
	 */
	public var lineDrop:Int = 0;
	/**
	 * FLAG mis à jour à chaque tick
	 * une nouvelle forme est produite
	 */
	public var newItem:Bool = false;
	
	/**
	 * mise à jour de du model
	 */
	public function tick() {
		lose = false;
		lineDrop = 0;
		newItem = false;
		if (valide(current, 0, 1)) {
			current.y++;
		} else {
			freeze(current);
			lineDrop = clearLines();
			current = newCurrent();
			newItem = true;
			lose = ! valide(current, 0, 0);
		}
	}
	
	
	
	
}
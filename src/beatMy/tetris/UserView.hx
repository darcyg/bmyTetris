package beatMy.tetris;
import createjs.easeljs.Shape;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Stage;

/**
 * representation graphique du plateau
 * @author GuyF
 */
class UserView
{
	private var W = 300;
	private var H = 600;
	
	private var BLOCK_W:Float ;
	private var BLOCK_H:Float ;
	
	private var _stage:Stage;
	private var _board:ModelBoard;
	public function new(mainContent:Dynamic,board:ModelBoard) 
	{
		 _stage = new Stage(mainContent);
		 
		 _board = board;
		 
		
	}
	
	/**
	 * mise à jour de la dimension
	 * (fixe pour le moment)
	 */
	public function resize() {
		 BLOCK_W = W / ModelData.COLS;
		 BLOCK_H = H / ModelData.ROWS;
	}
	
	/**
	 * mise à jour de la vue
	 */
	public function update() {
		_stage.removeAllChildren();
		_stage.clear();
		render_board();
		render_boardBlocks();
		render_piece(_board.get_current());
		
		_stage.update();
	}
	
	/**
	 * dessine le fond de plateau
	 */
	private function render_board() {
		
		var b:Shape = new Shape();
		b.graphics
                .beginStroke("green")
				.rect(0, 0, W-1 , H-1 )
                //On termine le tracé.
                .closePath();
		_stage.addChild(b);
	}
	
	
	/**
	 * dessine les block collés au plateau
	 */
	private function render_boardBlocks() {
//		trace(_board);
		for (y in 0...ModelData.ROWS) {
			for (x in 0...ModelData.COLS) {
				var piece : Int = _board.get_piece(x, y);
				
				switch (_board.get_piece(x,y)) 
				{
					case ModelData.EMPTY : {
						var block = drawBlock(x , y , "black","white");
					_stage.addChild(block);}
					case ModelData.FILL : {
						var block = drawBlock(x , y , 'green');
					_stage.addChild(block);}
					//case ModelData.POWER :
					// TODO add power representation
					default:
						
				}
				
			}
		}
	}
	
	
	/**
	 * dessine un bloc 1x1 aux coordonnées
	 * @param	x
	 * @param	y
	 */
	private function drawBlock(x:Int=0, y:Int=0,fill:String="#FFCC00",border:String="#FFCC00"):Shape {
		var b:Shape = new Shape();
		b.graphics
                //On initie un nouveau tracé 
                .beginFill(fill)
				.beginStroke(border)
				.rect(0, 0, BLOCK_W - 1 , BLOCK_H - 1 )
                //On termine le tracé.
                .closePath();
		b.x = x * BLOCK_W;
		b.y = y * BLOCK_H;
        return b;
	}
	
	/**
	 * dessine une piece
	 * @param	current
	 */
	private function render_piece(current:ModelPiece) {
		
		for (y in 0...current.forme.length) {
			for (x in 0...current.forme[y].length) {
				
				switch (current.forme[y][x]) 
				{
					/*
					case ModelData.EMPTY : {
					var block = drawBlock(current.x + x, current.y + y, "black");
					_stage.addChild(block);}
					*/
					case ModelData.FILL : {
						var block = drawBlock(current.x + x, current.y + y, ModelData.me().colors[current.id]);
						_stage.addChild(block);}
					//case ModelData.POWER :
					// TODO add power representation
					default:
						
				}
				
			}
		}

	}
	
}
package beatMy.tetris;
import js.html.svg.Number;

/**
 * ...
 * @author GuyF
 */
class ModelPiece
{
	public var x: Int;
	public var y: Int;
	public var id:Int;

	public var forme:Array<Array<Int>>;
	

	public function new(?id:Int) 
	{
		if (id != null) {
			helper_builder(id);
		} else {
			
		}
	}
	
	private function helper_builder(id:Int) {
		this.id = id;
		var shape = ModelData.me().shapes[ id ];
		
		forme = new Array < Array<Int> > ();
		var yy : Int = 0;
		var xx : Int = 0;
		forme[yy] = new  Array<Int>();
		for (i in shape) {
			switch (i) 
			{
				case  ModelData.FILL :
					forme[ yy ][ xx ] = ModelData.FILL ;
					
				default: 
					forme[ yy ][ xx ] = ModelData.EMPTY; 
			}
			xx++;
			if (xx == ModelData.SHAPE_WIDTH) {
				xx = 0;
				yy++;
				forme[yy] = new  Array<Int>();
			}
		}
		
//		trace(this);
	}
	
	public function clone_rotate():ModelPiece {
		var ret = new ModelPiece();
		ret.x = x;
		ret.y = y;
		ret.id = id;
		ret.forme = new Array < Array<Int> > ();
		
		for (yy in 0...forme.length) {
			for (xx in 0...forme[yy].length) {
				if (ret.forme[ ModelData.SHAPE_WIDTH - xx -1 ] == null)	ret.forme[ ModelData.SHAPE_WIDTH - xx -1 ] = new Array <Int> ();
				ret.forme[ ModelData.SHAPE_WIDTH - xx -1][yy] = forme[ yy ][ xx ];
			}
		}
		
		var _y = 0;
		while (_y < ret.forme.length) {
			if (ret.forme[_y] == null) {
				ret.forme.splice(_y,1);
			} else {
				_y++;
			}
		}
		/*
		for ( yy in 0...ModelData.SHAPE_WIDTH) {
			ret.forme[ yy ] = new Array <Int> ();
			for ( xx in 0...ModelData.SHAPE_HEIGHT) {
				if (forme[ ModelData.SHAPE_WIDTH - xx - 1 ] == null) {
					ret.forme[ yy ][ xx ] = 0;
				} else if (	forme[ ModelData.SHAPE_WIDTH - xx - 1 ][ yy ] == null) {
					ret.forme[ yy ][ xx ] = 0;
				} else {
					ret.forme[ yy ][ xx ] = forme[ ModelData.SHAPE_WIDTH - xx - 1 ][ yy ];
				}
			}
		}
		*/
		return ret;
	}
	
	public function clone():ModelPiece {
		var ret = new ModelPiece();
		ret.x = x;
		ret.y = y;
		ret.id = id;
		ret.forme = new Array < Array<Int> > ();
		for (r in forme) {
			var row = new Array<Int>();
			ret.forme.push(row);
			var ci:Int = 0;
			for (c in r) {
				row[ci] = c;
				ci++;
			}
		}
		return ret;
	}
	
	
	
}
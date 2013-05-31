package beatMy.tetris;

/**
 * Etat des interactions du joueur
 * @author GuyF
 */
class UserStateModel
{

	public  var bROTATE : Bool	= false;
	public  var bLEFT   : Bool	= false;
	public  var bRIGHT : Bool	= false;
	public  var bDROP : Bool	= false;

	
	public function new() 
	{
		
	}
	
	/**
	 * nettoye les interactions non-continu
	 */
	public function clear() {
		bROTATE = bLEFT = bRIGHT = false;
	}
	
	
}
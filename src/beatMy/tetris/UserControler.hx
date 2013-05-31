package beatMy.tetris;
import events.Key;
import js.Browser;

/**
 * actions possibles
 */
enum ACTIONKEY {
        DROP;
        ROTATE;
        LEFT;
		RIGHT;
    }
	
/**
 * controleur des actions joueur clavier
 * @author GuyF
 */
class UserControler 
{
	/**
	 * etat courant des actions
	 */
	private var model:UserStateModel;
	/**
	 * mapping
	 * keycode -> ACTIONKEY
	 */
	private var keyMap : Map<Int,ACTIONKEY>;
	
	/**
	 * element de focus pour l'ecouteur d'evenement
	 */
	private var focusElement:Dynamic;
	
	/**
	 * 
	 * @param	model de donnée utilisateur
	 * @param	element de focus (optionnel, Browser par default)
	 */
	public function new(model:UserStateModel,?focusElement:Dynamic) 
	{
		
		this.model = model;
		if (focusElement == null) {
			this.focusElement = Browser.document;
		} else {
			this.focusElement = focusElement;
		}
		initKeyMap();
	}
	
	/**
	 * initialisation du mappage des touches
	 */
	private function initKeyMap():Void {
		keyMap = new Map();
		keyMap.set(39, ACTIONKEY.RIGHT);
		keyMap.set(37, ACTIONKEY.LEFT);
		keyMap.set(40, ACTIONKEY.DROP);
		keyMap.set(38, ACTIONKEY.ROTATE);
	}
	
	/**
	 * demarre le controleur
	 */
	public function start():Void {
		start_listenners();
	}
	
	/**
	 * arrete le controleur
	 */
	public function stop():Void {
		stop_listenners();
	}
	
	/**
	 * association des ecouteurs
	 */
	private function start_listenners():Void {
		Browser.document.addEventListener(Key.KEYDOWN, evt_keyDown);
		Browser.document.addEventListener(Key.KEYUP, evt_keyUp);
	}
	/**
	 * suppression des ecouteurs
	 */
	private function stop_listenners():Void {
		Browser.document.removeEventListener(Key.KEYDOWN, evt_keyDown);
		Browser.document.removeEventListener(Key.KEYUP, evt_keyUp);
	}
	
	/**
	 * mise à jour de l'etat du model de l'utilisateur en cas de pression
	 * @param	e :  evenement clavier
	 */
	private function evt_keyDown(e:Dynamic) {
		trace("evt_keyDown" + e.keyCode );
		if (!keyMap.exists(e.keyCode)) return;
		switch (keyMap.get(e.keyCode)) {
			case ACTIONKEY.RIGHT :
				model.bRIGHT = true;
			case ACTIONKEY.LEFT :
				model.bLEFT = true;
			case ACTIONKEY.DROP :
				model.bDROP = true;
			case ACTIONKEY.ROTATE :
				model.bROTATE = true;
			
				
			
		}
		 e.preventDefault ? e.preventDefault() : (e.returnValue = false);

	}
	
	/**
	 * mise à jour de l'etat du model de l'utilisateur en cas de relache
	 * @param	e : evenement clavier
	 */
	private function evt_keyUp(e:Dynamic) {
		trace("evt_keyUp" + e.keyCode );
		if (!keyMap.exists(e.keyCode)) return;
		
		switch (keyMap.get(e.keyCode)) {
			case ACTIONKEY.RIGHT :
				model.bRIGHT = false;
			case ACTIONKEY.LEFT :
				model.bLEFT = false;
			case ACTIONKEY.DROP :
				model.bDROP = false;
			case ACTIONKEY.ROTATE :
				model.bROTATE = false;
			
		}
		 e.preventDefault ? e.preventDefault() : (e.returnValue = false);
	}
	
}
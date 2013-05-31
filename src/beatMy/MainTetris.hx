package beatMy;

import beatMy.tetris.ModelBoard;
import beatMy.tetris.UserControler;
import beatMy.tetris.UserStateModel;
import beatMy.tetris.UserView;
import createjs.easeljs.Ticker;
import haxe.Timer;
import js.Browser;
import js.html.Element;
import js.html.Event;
import createjs.preloadjs.LoadQueue;
import js.JQuery;

/**
 * ...
 * @author GuyF
 */

class MainTetris 
{
	public static var loadQueue:LoadQueue;
	private static var _main:MainTetris;
	
	private static var mainContent:Element;
	
	static function main() 
	{
		#if debug
			trace("Debug infos for all debug compiles");
		#end
        //Ticker provides a centralized tick or heartbeat broadcast at a set interval.
        //Here we tells it to use browser "requestAnimationFrame" instead of "setTimeout" to process ticks
        Ticker.useRAF = false;
        //Maximum FPS
        Ticker.setFPS(30);
	
    	
		 //Creating of stage. We need to create stage manually. Constructor receives canvas element declared in index.html.
		mainContent = js.Browser.document.getElementById("mainContent");
		mainContent.oncontextmenu = function(e:Event) { e.stopPropagation(); return false; };
		var container:Element  = mainContent.parentElement;
		Browser.document.getElementById("loader").className = "";
		
		loadQueue = new LoadQueue(false);
		//loadQueue.addEventListener(PreloadJS.FILELOAD, evt_fileLoad);
        loadQueue.addEventListener(events.PreloadJS.COMPLETE, evt_fileLoadComplete);
        loadQueue.addEventListener(events.PreloadJS.PROGRESS, evt_fileLoadProgress);
		loadQueue.addEventListener(events.PreloadJS.ERROR, evt_fileLoadError);
		
		
		loadQueue.setMaxConnections(5);
		 
		// PreloadJS usage
		// http://nightlycoding.com/index.php/2012/09/image-slideshow-with-preloadjs-jquery-and-tweenmax/
		 
       
		
		
		//_stage.enableMouseOver(10);
		//_stage.mouseMoveOutside = true;
		
		container.oncontextmenu = onContextMenu;
		

        //Alternative to Event.ENTER_FRAME. Method tickHandler called 60 times per second
      
		
		
		_main = new MainTetris(mainContent);
		
		//container.addEventListener(events.Mouse.CLICK, _main.evt_clickMap);
		
		//Browser.document.addEventListener(events.Key.KEYDOWN, _main.evt_key);
		
		//Browser.window.addEventListener(events.Window.RESIZE, _main.evt_resize);
		//_main.evt_resize(null);
		
		Ticker.addListener(_main.tickHandler);
	}
	

	
	
	public static function evt_fileLoadError(e) {
		trace("ERROR : evt_fileLoadError");
	}
	
	public static function evt_fileLoadProgress(e) {
		trace('TOTAL: '+loadQueue.progress);
		var perc = loadQueue.progress * 100;
		
		new JQuery("#loadingFill").animate( {  'width':perc + '%' }, 2);
		Browser.document.getElementById("loader").className = "loader";
	}
	
	public static function evt_fileLoadComplete(e) {
		trace('evt_fileLoadComplete TOTAL: '+loadQueue.progress);
		 Browser.document.getElementById("loader").className = "";
		if (_main != null) {
			// TODO initialise game
			
		}
		
	}
	
	static private function onContextMenu(e:js.html.Event ) 
	{
		trace("contextMenu"+e.type);
	}
	
	private var view : UserView;
	private var playerModel : UserStateModel;
	private var playerControler : UserControler;
	private var board : ModelBoard;
	
	private var gameLoop:Timer;
	
	
	public function new (mainContent:Element):Void {
		board = new ModelBoard();
		view = new UserView(mainContent, board);
		playerModel = new UserStateModel();
		playerControler = new UserControler(playerModel,mainContent);
		view.resize();
		
		playerControler.start();
		
		Timer.delay(evtGameLoop, 300);
	}
	
	/**
	 * boucle de la logique du jeux
	 */
	private function evtGameLoop() 
	{
		
		if (playerModel.bLEFT) board.left();
		if (playerModel.bRIGHT)	board.right();
		if (playerModel.bROTATE) board.rotate();
		
		if (!playerModel.bLEFT && !playerModel.bRIGHT && !playerModel.bLEFT && !playerModel.bROTATE) {
			board.tick();
		}
		//playerModel.clear();
		if (board.lose) {
			playerControler.stop();
			return;
		}
		if (playerModel.bDROP) {
			Timer.delay(evtGameLoop, 50);
		} else {
			Timer.delay(evtGameLoop, 150);
		}
	}
	
	/**
	 * boucle de rendu
	 */
	public function tickHandler():Void 	{
		
		view.update();
		
	}
	
}
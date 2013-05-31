package gf.channels;

import createjs.easeljs.EventDispatcher;
import haxe.ds.StringMap;

/**
 * ...
 * @author GuyF
 * portage vers JS
 */

 // @version 1.0.0 [28 nov. 2011][sps] description
	
	/**
	 * <p>EventChannel permet de créer des tableux d'évént dispatcher globaux, 
	 * afin de n'utiliser que des ID de dispatcher (des noms de channels d'events)
	 * pour enregistrer des écouteurs ou dispatcher des events.</p>
	 * 
	 * <p>Ce découpage permet la diffusion d'évenements à un nombre restreints 
	 * d'écouteurs, tout en découplant les écouteurs et les émtteurs.
	 * Pour prendre un exemple concret, une vue pourra s'abonner à un canal 
	 * pour écouter un événement, sans connaitre le type du controlleur qui va 
	 * émettre l'événement sur ce canal</p>  
	 * 
	 * @version 1.0.2,  2010-06-23 1541 sps, 
     *                  Passage à des références faibles 
     *                  par défaut en surchargeant le addEventListener.      
	 * @version 1.0.1,  2010-05-28 0956 sps     
     *                  Ajout des metadata pour que les producteurs d'évenements
     *                  puissent stocker des états que récupéreront les futurs 
     *                  consommateurs d'événements qui en auraient besoin pour 
     *                  s'initialiser.
     * @version 1.0,    2010-05-17 1441 sps     creation
     * 
	 * @author sps (2010 05 17)
	 * @langversion 3.0
	 */
class EventChannel extends EventDispatcher {

	static private var _channels:StringMap<EventChannel> = new StringMap<EventChannel>();
	static public var defaultChannel:String = 'defaultChannel';
	
	 /** 
        * Espace de partage de données pour les divers producteurs/consommateurs
        * d'un eventChannel. A utiliser avec parcimonie pour éviter de tomber 
        * dans une soupes de globales. 
        * 
        * <p>Cette fonctionnalité est présente pour 
        * permettre une persistance de données entre un producteur et un 
        * consommateur qui définirraient des changement d'état (ces changement 
        * étant diffusés sur le channel, comment un nouveau consommateur 
        * rejoignant le chan pourrait connaitre l'état actuel sans devoir se 
        * lancer dans de longues interogations.</p>   
        * */
        public var metaData:Dynamic ;
	
	public function new() {
		//super();
	}
	
	/**
	 * Retourne un EventChannel pour ajouter des écouteurs ou dispatcher un evenement
	 */
	static public function get(channelName:String = null):EventChannel	{
		if (channelName == null)	channelName = defaultChannel;
		
		var aChan:EventChannel;
		if (_channels.exists(channelName))	{
			aChan = _channels.get(channelName);
		} else {
			aChan = new EventChannel();
			_channels.set(channelName, aChan);
		}
		return aChan;
	}
	
	
        
		/** 
		 * TODO si implémenté en natif: Pour les EventChannels, addEventListener utilise des références 
		 * faibles par défaut (surcharge du comportement par défaut d'AS3 qui 
		 * utilise des références fortes) */
		override public function  addEventListener(type:String, listener:Dynamic):Dynamic   {
            return super.addEventListener(type, listener);
        }
	
}
package gf.channels;

import createjs.easeljs.DisplayObject;

/**
 * ...
 * @author GuyF
 */
class DataBringerEvent<T>
{
	static public var DATA_EVENT:String = 'dataEvent';
	static private var EVENT_CHANNEL_NAME:String = 'dataChannel';
		
	public var type:String;
	public var target:Dynamic;
	public var initialData:T;
	public function new(type : String, initialData : T)
	{
		this.type = type;
		this.initialData = initialData;
	}
	
	public function dispatch() {
	
			getChannel().dispatchEvent(this);
	}
		
	
		
	static private var _channel:EventChannel; 
	static public function getChannel():EventChannel	{
			if (_channel == null) {
				_channel = EventChannel.get(EVENT_CHANNEL_NAME);
		}
			return _channel;
	}
	
}
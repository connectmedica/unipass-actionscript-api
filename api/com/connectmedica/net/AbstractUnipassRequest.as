package com.connectmedica.net {
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * Base class used when making requests to the Unipass API.
	 * 
	 * 
	 */
	public class AbstractUnipassRequest {
		
		/**
		 * @private
		 *
		 */
		protected var urlLoader:URLLoader;
		
		/**
		 * @private
		 *
		 */
		protected var urlRequest:URLRequest;
		
		/**
		 * @private
		 *
		 */
		protected var _rawResult:String;
		
		/**
		 * @private
		 *
		 */
		protected var _data:Object;
		
		/**
		 * @private
		 *
		 */
		protected var _success:Boolean;
		
		/**
		 * @private
		 *
		 */
		protected var _url:String;
		
		/**
		 * @private
		 *
		 */
		protected var _requestMethod:String;
		
		/**
		 * @private
		 *
		 */
		protected var _callback:Function;
		
		/**
		 * Instantiates a new UnipassRequest.
		 *
		 * @param url The URL to request data from.
		 * Usually will be https://www.stworzonedlazdrowia.pl.
		 * @param requestMethod The URLRequestMethod
		 * to be used for this request.
		 * <ul>
		 *	<li>GET for retrieving data (Default)</li>
		 * 	<li>POST for publishing data</li>
		 * </ul>
		 * @param callback Method to call when this request is complete.
		 * The signaure of the handler must be callback(request:UnipassRequest);
		 * Where request will be a reference to this request.
		 */
		public function AbstractUnipassRequest() {
		}
		
		/**
		 * Returns the un-parsed result from Unipass.
		 * Usually this will be a JSON formatted string.
		 *
		 */
		public function get rawResult():String {
			return _rawResult;
		}
		
		/**
		 * Returns true if this request was successful,
		 * or false if an error occurred.
		 * If success == true, the data property will be the corresponding
		 * decoded JSON data returned from Unipass.
		 *
		 * If success == false, the data property will either be the error
		 * from Unipass, or the related ErrorEvent.
		 *
		 */
		public function get success():Boolean {
			return _success;
		}
		
		/**
		 * Any resulting data returned from Unipass.
		 * @see #success
		 *
		 */
		public function get data():Object {
			return _data;
		}
		
		public function callURL(callback:Function, 
								url:String = "", 
								locale:String = null
		):void {			
			_callback = callback;
			urlRequest = new URLRequest(url.length ? url : _url);
			
			if (locale) {
				var data:URLVariables = new URLVariables();
				data.locale = locale;
				urlRequest.data = data;
			}
			loadURLLoader();
		}
		
		public function set successCallback(value:Function):void {
			_callback = value;
		}

		/**
		 * Cancels the current request.
		 *
		 */
		public function close():void {
			if (urlLoader != null) {
				urlLoader.removeEventListener(Event.COMPLETE, handleURLLoaderComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleURLLoaderIOError);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderSecurityError);
				
				try {
					urlLoader.close();
				} catch (e:*) { }
				
				urlLoader = null;
			}
		}
		
		/**
		 * @return Returns the current request URL
		 * and any parameters being used.
		 *
		 */
		public function toString():String {
			return urlRequest.url + (urlRequest.data == null ? '' : '?' + unescape(urlRequest.data.toString()));
		}
		
		// Protected Methods ///////////////////////////////////////////////////////////////////////////////////////////
		
		protected function objectToURLVariables(values:Object):URLVariables {
			var urlVars:URLVariables = new URLVariables();
			
			if (values == null) {
				return urlVars;
			}
			
			for (var n:String in values) {
				urlVars[n] = values[n];
			}
			
			return urlVars;
		}
		
		/**
		 * @private
		 *
		 */
		protected function loadURLLoader():void {
			urlLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, handleURLLoaderComplete, false, 0, false);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleURLLoaderIOError, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleURLLoaderSecurityError, false, 0, true);
			
			urlLoader.load(urlRequest);
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleURLLoaderComplete(event:Event):void {
			handleDataLoad(urlLoader.data);
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleDataLoad(result:Object,
										  dispatchCompleteEvent:Boolean = true
		):void {
			_rawResult = result as String;
			_success = true;
			
			try {
				_data = JSON.decode(_rawResult);
			} catch (e:*) {
				_data = _rawResult;
				_success = false;
			}
			
			handleDataReady();
			
			if (dispatchCompleteEvent) {
				dispatchComplete();
			}
		}
		
		/**
		 * @private
		 * 
		 * Called after the loaded data is parsed but before complete is dispatched
		 */
		protected function handleDataReady():void {
		}
		
		/**
		 * @private
		 *
		 */
		protected function dispatchComplete():void {
			if (_callback != null) { _callback(this); }
			close();
		}
		
		/**
		 * @private
		 *
		 * Unipass will return a 500 Internal ServerError
		 * when an API request fails,
		 * with JSON data attached explaining the error.
		 *
		 * @todo Check if it works!
		 */
		protected function handleURLLoaderIOError(event:IOErrorEvent):void {
			_success = false;
			_rawResult = (event.target as URLLoader).data;
			
			if (_rawResult != '') {
				try {
					_data = JSON.decode(_rawResult);
				} catch (e:*) {
					_data = {type:'Exception', message:_rawResult};
				}
			} else {
				_data = event;
			}
			
			dispatchComplete();
		}
		
		/**
		 * @private
		 *
		 */
		protected function handleURLLoaderSecurityError(event:SecurityErrorEvent):void {
			_success = false;
			_rawResult = (event.target as URLLoader).data;
			
			try {
				_data = JSON.decode((event.target as URLLoader).data);
			} catch (e:*) {
				_data = event;
			}
			
			dispatchComplete();
		}

	}
}
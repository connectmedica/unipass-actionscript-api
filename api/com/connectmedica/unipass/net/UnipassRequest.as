package com.connectmedica.unipass.net {
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class UnipassRequest extends AbstractUnipassRequest {
		
		public function UnipassRequest() {
			super();
		}
		
		/**
		 * Makes a request to the Unipass API.
		 *
		 */
		public function call(url:String, requestMethod:String = URLRequestMethod.GET, callback:Function = null, values:* = null):void {
			_url = url;
			_requestMethod = requestMethod;
			_callback = callback;
			
			var requestUrl:String = url;
			
			urlRequest = new URLRequest(requestUrl);
			urlRequest.method = _requestMethod;
			
			//If there are no user defined values, just send the request as is.
			if (values == null) {
				loadURLLoader();
				return;
			}
			
			urlRequest.data = objectToURLVariables(values);
			loadURLLoader();
		}
		
	}
	
}
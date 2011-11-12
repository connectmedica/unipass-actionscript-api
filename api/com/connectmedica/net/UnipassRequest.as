package com.connectmedica.net {
	import flash.net.URLRequest;
	
	public class UnipassRequest extends AbstractUnipassRequest {
		
		public function UnipassRequest() {
			super();
		}
		
		/**
		 * Makes a request to the Facebook Graph API.
		 *
		 */
		public function call(url:String,
							 requestMethod:String = 'GET',
							 callback:Function = null,
							 values:* = null
		):void {
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
package unipass.core {
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	import unipass.data.UnipassAuthResponse;
	import unipass.data.UnipassSession;
	import unipass.net.UnipassRequest;
	import unipass.utils.IResultParser;

	public class AbstractUnipass {
		
		/**
		 * @private
		 *
		 */
		protected var session:UnipassSession;
		
		/**
		 * @private
		 *
		 */
		protected var authResponse:UnipassAuthResponse;
		
		/**
		 * @private
		 *
		 */
		protected var oauth2:Boolean;
		
		/**
		 * @private
		 *
		 */
		protected var openRequests:Dictionary;
		
		/**
		 * @private
		 *
		 */
		protected var resultHash:Dictionary;
		
		/**
		 * @private
		 *
		 */
		protected var locale:String;
		
		/**
		 * @private
		 *
		 */
		protected var parserHash:Dictionary;
		
		public function AbstractUnipass() {
			openRequests = new Dictionary();
			resultHash = new Dictionary(true);
			parserHash = new Dictionary();
		}
		
		// Protected methods ///////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 *
		 */
		protected function get accessToken():String {
			if ((oauth2 && authResponse != null) || session != null) {
				return oauth2 ? authResponse.accessToken : session.accessToken;
			} else {
				return null;
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function api(method:String, callback:Function = null, params:* = null, requestMethod:String = URLRequestMethod.GET):void {
			if (accessToken) {
				if (params == null) { params = {}; }
				if (params.oauth_token == null) { params.oauth_token = accessToken; }
			}
			
			var req:UnipassRequest = new UnipassRequest();
			
			if (locale) { params.locale = locale; }
			
			//We need to hold on to a reference or the GC might clear this during the load.
			openRequests[req] = callback;
			
			req.call(UnipassURLHelpers.apiURL(method), requestMethod, handleRequestLoad, params);
		}
		
		/**
		 * @private
		 * 
		 */
		protected function getRawResult(data:Object):Object {
			return resultHash[data];
		}
		
		/**
		 * @private
		 * 
		 */
		protected function handleRequestLoad(target:UnipassRequest):void {
			var resultCallback:Function = openRequests[target];
			
			if (resultCallback === null) {
				delete openRequests[target];
			}
			
			if (target.success) {
				var data:Object = ('data' in target.data) ? target.data.data : target.data;
				
				resultHash[data] = target.data; //keeps a reference to the entire raw object Unipass returns (including paging, etc.)
				if (data.hasOwnProperty("error_code")) {
					resultCallback(null, data);
				} else {
					if (parserHash[target] is IResultParser) {
						var p:IResultParser = parserHash[target] as IResultParser;
						data = p.parse(data);
						parserHash[target] = null;
						delete parserHash[target];
					}
					resultCallback(data, null);
				}
			} else {
				resultCallback(null, target.data);
			}
			
			delete openRequests[target];
		}
	}
}
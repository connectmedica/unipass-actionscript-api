package com.connectmedica {
    import com.connectmedica.unipass.core.AbstractUnipass;
    import com.connectmedica.unipass.data.UnipassAuthResponse;
    
    public class Unipass extends AbstractUnipass {
        /**
         * @private
         *
         */
        protected var clientId:String;
        
        /**
         * @private
         *
         */
        protected static var _instance:Unipass;
        
        /**
         * @private
         *
         */
        protected static var _canInit:Boolean = false;
        
        /**
         * @private
         *
         */
        protected var _initCallback:Function;
        
        /**
         * Creates an instance of Unipass.
         *
         */
        public function Unipass() {
            super();
            
            if (_canInit == false) {
                throw new Error('Unipass is an singleton and cannot be instantiated.');
            }
            
            //jsBridge = new UnipassJSBridge(); //create an instance
            
            //jsCallbacks = {};
            
            //openUICalls = new Dictionary();
        }
        
        // Public API //////////////////////////////////////////////////////////////////////////////////////////////////
		
        /**
         * Initializes this Unipass singleton with your Client ID using OAuth 2.0.
         * You must call this method first.
         *
         * @param clientId The client ID you created at
         * https://www.stworzonedlazdrowia.pl
         *
         * @param callback (Optional)
         * Method to call when initialization is complete.
         * The handler must have the signature of callback(success:Object, fail:Object);
         * Success will be a UnipassSession if successful, or null if not.
         *
         * @param options (Optional)
         * Object of options used to instantiate the underling Javascript SDK
         * 
         * @param accessToken (Optional)
         * A valid Unipass access token. If you have a previously saved access token, you can pass it in here.
         *
         */
        public static function init(clientId:String,
                                    callback:Function = null,
                                    options:Object = null,
                                    accessToken:String = null
        ):void {
            getInstance().init(clientId, callback, options, accessToken);
        }
        
		/**
		 * Makes a new request on the Unipass API.
		 *
		 * @param method The method to call on the Unipass API.
		 * For example, to load the user's profile data, pass: /me
		 *
		 * @param calllback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
		 * On success, result will be the object data returned from Unipass.
		 * On fail, result will be null and fail will contain information about the error.
		 *
		 * @param params Any parameters to pass to Unipass.
		 * For example, you can pass {name:'Some name', message:'Some message'};
		 * 
		 * @param requestMethod
		 * The URLRequestMethod used to send values to Unipss.
		 * The Unipass API follows correct Request method conventions.
		 * GET will return data from Unipass.
		 * POST will send data to Unipass.
		 *
		 */
		public static function api(method:String,
								   callback:Function = null,
								   params:* = null,
								   requestMethod:String = 'GET'
		):void {
			getInstance().api(method, callback, params, requestMethod);
		}
		
        // Protected methods ///////////////////////////////////////////////////////////////////////////////////////////
		
        /**
         * @private
         *
         */
        protected function init(clientId:String,
                                callback:Function = null,
                                options:Object = null,
                                accessToken:String = null
        ):void {
            
            /*
            ExternalInterface.addCallback('handleJsEvent', handleJSEvent);
            ExternalInterface.addCallback('authResponseChange', handleAuthResponseChange);
            ExternalInterface.addCallback('logout', handleLogout);
            ExternalInterface.addCallback('uiResponse', handleUI);
            */
            _initCallback = callback;
            
            this.clientId = clientId;
            this.oauth2 = true;
            
            if (options == null) { options = {};}
            options.appId = clientId;
            options.oauth = true;
            
            //ExternalInterface.call('FBAS.init', JSON.encode(options));
            
            if (accessToken != null) {
                authResponse = new UnipassAuthResponse();
                authResponse.accessToken = accessToken;
            }
            
            if (options.status !== false) {
                //getLoginStatus();
            } else if (_initCallback != null) {
                _initCallback(authResponse, null);
                _initCallback = null;
            }
        }
        
        /**
         * @private
         *
         */
        protected static function getInstance():Unipass {
            if (_instance == null) {
                _canInit = true;
                _instance = new Unipass();
                _canInit = false;
            }
            return _instance;
        }
    }
}
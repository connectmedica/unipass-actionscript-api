package com.connectmedica {
    import com.connectmedica.core.AbstractUnipass;
    import com.connectmedica.data.UnipassAuthResponse;
    
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
            
            //jsBridge = new FacebookJSBridge(); //create an instance
            
            //jsCallbacks = {};
            
            //openUICalls = new Dictionary();
        }
        
        // Public API //////////////////////////////////////////////////////////////////////////////////////////////////
		
        /**
         * Initializes this Unipass singleton with your Client ID using OAuth 2.0.
         * You must call this method first.
         *
         * @param applicationId The application ID you created at
         * http://www.facebook.com/developers/apps.php
         *
         * @param callback (Optional)
         * Method to call when initialization is complete.
         * The handler must have the signature of callback(success:Object, fail:Object);
         * Success will be a FacebookSession if successful, or null if not.
         *
         * @param options (Optional)
         * Object of options used to instantiate the underling Javascript SDK
         * 
         * @param accessToken (Optional)
         * A valid Facebook access token. If you have a previously saved access token, you can pass it in here.
         *
         * @see http://developers.facebook.com/docs/reference/javascript/FB.init
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
		 * Makes a new request on the Facebook Graph API.
		 *
		 * @param method The method to call on the Graph API.
		 * For example, to load the user's current friends, pass: /me/friends
		 *
		 * @param calllback Method that will be called when this request is complete
		 * The handler must have the signature of callback(result:Object, fail:Object);
		 * On success, result will be the object data returned from Facebook.
		 * On fail, result will be null and fail will contain information about the error.
		 *
		 * @param params Any parameters to pass to Facebook.
		 * For example, you can pass {file:myPhoto, message:'Some message'};
		 * this will upload a photo to Facebook.
		 * @param requestMethod
		 * The URLRequestMethod used to send values to Facebook.
		 * The graph API follows correct Request method conventions.
		 * GET will return data from Facebook.
		 * POST will send data to Facebook.
		 * DELETE will delete an object from Facebook.
		 *
		 * @see flash.net.URLRequestMethod
		 * @see http://developers.facebook.com/docs/api
		 *
		 */
		public static function api(method:String,
								   callback:Function = null,
								   params:* = null,
								   requestMethod:String = 'GET'
		):void {
			getInstance().api(method,
				callback,
				params,
				requestMethod
			);
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
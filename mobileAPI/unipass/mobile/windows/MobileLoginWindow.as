package unipass.mobile.windows {
    import flash.events.Event;
    import flash.events.LocationChangeEvent;
    import flash.media.StageWebView;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import unipass.core.UnipassDisplay;
    import unipass.core.UnipassURLHelpers;
    import unipass.utils.UnipassDataUtils;
    
    public class MobileLoginWindow {
        
        protected var loginRequest:URLRequest;
        protected var userClosedWindow:Boolean = true;
        private var webView:StageWebView;
        
        public var loginCallback:Function;
        
        public function MobileLoginWindow(loginCallback:Function) {
            this.loginCallback = loginCallback;
            super();
        }
        
        public function open(clientId:String, webView:StageWebView, scope:Array /* of String */ = null, display:String = UnipassDisplay.MOBILE):void {
            this.webView = webView;
            
            loginRequest = new URLRequest();
            loginRequest.method = URLRequestMethod.GET;
            loginRequest.url = UnipassURLHelpers.authorizationURL({
                response_type: 'token',
                client_id:     clientId, 
                redirect_uri:  UnipassURLHelpers.loginSuccessURL,
                scope:         scope ? scope.join(" ") : "",
                display:       display
            });
            
            showWindow(loginRequest);
        }
        
        // Protected Methods ///////////////////////////////////////////////////////////////////////////////////////////
        
        protected function showWindow(req:URLRequest):void {
            webView.addEventListener(Event.COMPLETE, handleLocationChange, false, 0, true);
            webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, handleLocationChange, false, 0, true);
            webView.loadURL(req.url);
        }
        
        protected function handleLocationChange(event:Event):void {
            var location:String = webView.location;
//            if (location.indexOf(FacebookURLDefaults.LOGIN_FAIL_URL) == 0 || location.indexOf(FacebookURLDefaults.LOGIN_FAIL_SECUREURL) == 0)
//            {
//                webView.removeEventListener(Event.COMPLETE, handleLocationChange);
//                webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, handleLocationChange);
//                loginCallback(null, FacebookDataUtils.getURLVariables(location).error_reason);
//                userClosedWindow =  false;
//                webView.dispose();
//                webView=null;
//            }
                
            if (location.indexOf(UnipassURLHelpers.loginSuccessURL) == 0) {
                webView.removeEventListener(Event.COMPLETE, handleLocationChange);
                webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, handleLocationChange);
                
                loginCallback(UnipassDataUtils.getURLVariables(location), null);
                
                userClosedWindow = false;
                webView.dispose();
                webView = null;
            }
        }
        
    }
    
}
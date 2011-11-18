package com.connectmedica.unipass.windows {
    import com.connectmedica.unipass.core.UnipassURLDefaults;
    import com.connectmedica.unipass.core.UnipassURLHelpers;
    import com.connectmedica.unipass.utils.UnipassDataUtils;
    
    import flash.events.Event;
    import flash.events.LocationChangeEvent;
    import flash.media.StageWebView;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    public class MobileLoginWindow {
        
        protected var loginRequest:URLRequest;
        protected var userClosedWindow:Boolean = true;
        private var webView:StageWebView;
        
        public var loginCallback:Function;
        
        public function MobileLoginWindow(loginCallback:Function) {
            this.loginCallback = loginCallback;
            super();
        }
        
        public function open(clientId:String,
                             webView:StageWebView,
                             scope:String = null, 
                             display:String = 'mobile'
        ):void {
            this.webView = webView;
            
            loginRequest = new URLRequest();
            loginRequest.method = URLRequestMethod.GET;
            loginRequest.url = UnipassURLHelpers.authorizationURL({
                response_type: 'token',
                client_id: clientId, 
                redirect_uri: UnipassURLHelpers.loginSuccessURL,
                scope: scope,
                display: display
            });
            
            showWindow(loginRequest);
        }
        
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
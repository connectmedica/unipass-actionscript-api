package com.connectmedica.unipass {
    import com.connectmedica.unipass.core.AbstractUnipass;
    import com.connectmedica.unipass.core.UnipassDisplay;
    import com.connectmedica.unipass.core.UnipassURLHelpers;
    import com.connectmedica.unipass.data.UnipassSession;
    import com.connectmedica.unipass.net.UnipassRequest;
    import com.connectmedica.unipass.utils.UnipassDataUtils;
    import com.connectmedica.unipass.windows.MobileLoginWindow;
    
    import flash.display.Stage;
    import flash.media.StageWebView;
    import flash.net.SharedObject;
    import flash.net.URLRequestMethod;
    
    public class UnipassMobile extends AbstractUnipass {
        protected static const SO_NAME:String = 'com.connectmedica.UnipassMobile';
        
        protected static var _instance:UnipassMobile;
        protected static var _canInit:Boolean = false;
        
        protected var _manageSession:Boolean = true;
        protected var loginWindow:MobileLoginWindow;
        protected var clientId:String;
        protected var loginCallback:Function;
        protected var logoutCallback:Function;
        protected var initCallback:Function;
        
        protected var webView:StageWebView;
        protected var stageRef:Stage;
        
        public function UnipassMobile() {
            super();
            
            if (_canInit == false) {
                throw new Error('UnipassMobile is an singleton and cannot be instantiated.');
            }
        }
        
        public static function init(clientId:String, callback:Function, accessToken:String = null):void {
            getInstance().init(clientId, callback, accessToken);
        }
        
        public static function set locale(value:String):void {
            getInstance().locale = value;
        }
        
        public static function set manageSession(value:Boolean):void {
            getInstance().manageSession = value;
        }
        
        public static function login(callback:Function, stageRef:Stage, scope:String, webView:StageWebView = null, display:String = UnipassDisplay.MOBILE):void {
            getInstance().login(callback, stageRef, scope, webView, display);
        }
        
        public static function logout(callback:Function = null):void {
            getInstance().logout(callback);
        }
        
        public static function api(method:String, callback:Function, params:* = null, requestMethod:String = URLRequestMethod.GET):void {
            getInstance().api(method, callback, params, requestMethod);
        }
        
		public static function post(method:String, callback:Function, params:* = null):void {
			api(method, callback, params, URLRequestMethod.POST);
		}
		
        public static function getRawResult(data:Object):Object {			
            return getInstance().getRawResult(data);
        }
        
        public static function getSession():UnipassSession {
            return getInstance().session;
        }
        
        // Protected Methods ///////////////////////////////////////////////////////////////////////////////////////////
        
        protected function init(clientId:String, callback:Function, accessToken:String = null):void {
            this.initCallback = callback;
            this.clientId = clientId;
			
            if (accessToken != null) {
                session = new UnipassSession();
                session.accessToken = accessToken;
            } else if (_manageSession) {
                session = new UnipassSession();
                
                var so:SharedObject = SharedObject.getLocal(SO_NAME);
                session.accessToken = so.data.accessToken;
                session.expireDate = so.data.expireDate;
            }
            
            verifyAccessToken();
        }
        
        protected function verifyAccessToken():void {
            api('/me', handleUserLoad);
        }
        
        protected function handleUserLoad(result:Object, error:Object):void {
            if (result) {
                session.uid = result.id;
                session.user = result;
                if (loginCallback != null) {
                    loginCallback(session, null);
                }
                if (initCallback != null) {
                    initCallback(session, null);
                    initCallback = null;
                }
            } else {
                if (loginCallback != null) {
                    loginCallback(null, error);
                }
                if (initCallback != null) {
                    initCallback(null, error);
                    initCallback = null;
                }
                session = null;
            }
        }
        
        protected function login(callback:Function, stageRef:Stage, scope:String, webView:StageWebView = null, display:String = UnipassDisplay.MOBILE):void {
            this.loginCallback = callback;
            this.stageRef = stageRef;
            
            if (!webView) {
                this.webView = this.createWebView();
            } else {
                this.webView = webView;
                this.webView.stage = this.stageRef;
            }
            
            this.webView.assignFocus();
            
            if (clientId == null) {
                throw new Error('UnipassMobile.init() needs to be called first.');
            }
            
            loginWindow = new MobileLoginWindow(handleLogin);
            loginWindow.open(this.clientId, this.webView, scope, display);
        }
        
        protected function set manageSession(value:Boolean):void {
            _manageSession = value;
        }
        
        protected function handleLogin(result:Object, fail:Object):void {
            loginWindow.loginCallback = null;
            
            if (fail) {
                loginCallback(null, fail);
                return;
            }
            
            session = new UnipassSession();
            session.accessToken = result.access_token;
            session.expireDate = (result.expires_in == 0) ? null : UnipassDataUtils.stringToDate(result.expires_in) ;
            
            if (_manageSession) {
                var so:SharedObject = SharedObject.getLocal(SO_NAME);
                so.data.accessToken = session.accessToken;
                so.data.expireDate = session.expireDate;
                so.flush();
            }
            
            verifyAccessToken();
        }
        
        protected function logout(callback:Function = null):void {
            this.logoutCallback = callback;
            
            // Clear cookie for mobile
            var req:UnipassRequest = new UnipassRequest();
            
            openRequests[req] = handleLogout;
            req.call(UnipassURLHelpers.logoutURL, URLRequestMethod.GET, handleRequestLoad);
            
            var so:SharedObject = SharedObject.getLocal(SO_NAME);
            so.clear();
            so.flush();
            
            session = null;
        }
        
        protected function handleLogout(result:Object, fail:Object):void {
            //This is a specific case. Since we are hitting a different URL to 
            //logout, we do not get a normal result/fail
            if (logoutCallback != null) {
                logoutCallback(true);
                logoutCallback = null;
            }
        }
        
        protected function createWebView():StageWebView {
            if (this.webView) {
                try {
                    this.webView.dispose();
                } catch (e:*) { }
            }
            this.webView = new StageWebView();
            this.webView.stage = this.stageRef;
            return webView;
        }
        
        protected static function getInstance():UnipassMobile {
            if (_instance == null) {
                _canInit = true;
                _instance = new UnipassMobile();
                _canInit = false;
            }
            return _instance;
        }
        
    }
    
}
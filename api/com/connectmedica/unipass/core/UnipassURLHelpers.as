package com.connectmedica.unipass.core {
	import flash.net.URLVariables;
	
	public final class UnipassURLHelpers {
		
		public static function unipassURL(path:String = null):String {
			return join(UnipassURLDefaults.UNIPASS_URL, path);
		}
		
		public static function apiURL(method:String):String {
			return join(UnipassURLDefaults.UNIPASS_URL, UnipassURLDefaults.API_PATH, method);
		}

		public static function authorizationURL(variables:URLVariables):String {
			var authorizationPath:String = UnipassURLDefaults.AUTHORIZATION_PATH;
			
			if (variables.toString() !== "") { authorizationPath += '?' + variables.toString(); }
			
			return join(UnipassURLDefaults.UNIPASS_URL, authorizationPath); 
		}
		
		// Protected Methods ///////////////////////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 * 
		 */
		public static function join(...paths):String {
			var path:String = paths[0];
			
			for(var i:uint = 1; i < paths.length; i++) {
				if (paths[i] === null || paths[i] === "") continue;
				
				var p:String = paths[i] as String;
				if (path.charAt(path.length) != '/' || p.charAt(0) != '/') { path += '/'; }
				path += p;
			}
			
			return path;
		}
		
	}
	
}
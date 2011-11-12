package com.connectmedica.unipass.utils {
	import flash.net.URLVariables;
	
	public class UnipassDataUtils {
		
		/**
		 *
		 * Obtains the query string from the current HTML location
		 * and returns its values in a URLVariables instance.
		 *
		 */
		public static function getURLVariables(url:String):URLVariables {
			var params:String;
			
			if (url.indexOf('#') != -1) {
				params = url.slice(url.indexOf('#') + 1);
			} else if (url.indexOf('?') != -1) {
				params = url.slice(url.indexOf('?') + 1);
			}
			
			var vars:URLVariables = new URLVariables();
			vars.decode(params);
			
			return vars;
		}
		
	}
	
}
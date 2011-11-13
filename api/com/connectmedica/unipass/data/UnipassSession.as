package com.connectmedica.unipass.data {
	
	/**
	 * VO to hold information about the
	 * current logged in user and their session.
	 *
	 */
	public class UnipassSession {
		
		/**
		 * The current user's ID.
		 *
		 */
		public var uid:String;
		
		/**
		 * The current user's full information, as requested from a 'me' ID.
		 * This data will vary based on what privacy settings the user has
		 * enabled in their user profile.
		 *
		 */
		public var user:Object;

		/**
		 * Current session for the logged in user.
		 *
		 */
		public var sessionKey:String;

		/**
		 * The date this session will expire.
		 *
		 */
		public var expireDate:Date;
		
		/**
		 * Oauth access token for Unipass services.
		 *
		 */
		public var accessToken:String;
		
		/**
		 * Creates a new UnipassSession.
		 *
		 */
		public function UnipassSession() {
		}
		
		/**
		 * Populates the session data from a decoded JSON object.
		 *
		 */
		public function fromJSON(result:Object):void {
			if (result != null) {
				sessionKey = result.session_key;
				expireDate = new Date(result.expires);
				accessToken = result.access_token;
				uid = result.uid;
			}
		}
		
		/**
		 * Provides the string value of this instance.
		 *
		 */
		public function toString():String {
			return '[userId:' + uid + ']';
		}
	}
}
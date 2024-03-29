package unipass.data {
	
	/**
	 * VO to hold information about the
	 * current logged in user and their auth response.
	 *
	 */
	public class UnipassAuthResponse {
		
		/**
		 * The current user's ID.
		 *
		 */
		public var uid:String;
		
		/**
		 * The date this authResponse will expire.
		 *
		 */
		public var expireDate:Date;
		
		/**
		 * OAuth 2.0 access token for Unipass API.
		 *
		 */
		public var accessToken:String;
		
		public function UnipassAuthResponse() {
		}
		
		/**
		 * Populates the authResponse data from a decoded JSON object.
		 *
		 */
		public function fromJSON(result:Object):void {
			if (result != null) {
				expireDate = new Date();
				expireDate.setTime(expireDate.time + result.expiresIn * 1000);
				accessToken = result.access_token || result.accessToken;
				uid = result.userID;
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
package unipass.core {
	
	/**
	 * Constant class that stores all URLs used to communicate with Unipass.
	 * You may change these if your requests need to go though a proxy server.
	 *
	 */
	public final class UnipassURLDefaults {
		
		/**
		 * Main URL to Unipass.
		 *
		 */
		public static var UNIPASS_URL:String = 'https://www.stworzonedlazdrowia.pl';

		/**
		 * Path for calling RESTful API methods.
		 *
		 */
		public static var API_PATH:String = '/api/1';
		
		/**
		 * OAuth 2.0 authorization path, used in Unipass.as to authenicate users.
		 *
		 */
		public static var AUTHORIZATION_PATH:String = '/oauth2/authorize';
		
		/**
		 * OAuth 2.0 token path, used to exchange authorization code for access token.
		 *
		 */
		public static var TOKEN_PATH:String = '/oauth2/token';
		
		/**
		 * Path to redirect to after a successfull login to Unipass.
		 * 
		 * For use in desktop/mobile (AIR) applications.
		 *
		 */
		public static var LOGIN_SUCCESS_PATH:String = '/oauth2/login_success';
		
		/**
		 * Path to destroy current user session and logout from Unipass.
		 * 
		 */
		public static var LOGOUT_PATH:String = '/users/sign_out';
		
	}
}
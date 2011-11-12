package com.connectmedica.core {
	
	/**
	 * Constant class that stores all URLs
	 * used when communicating with Facebook.
	 * You may change these if your requests need to go though a proxy server.
	 *
	 */
	public class UnipassURLDefaults {
		
		/**
		 * URL for calling old-style RESTful API methods.
		 *
		 */
		public static var UNIPASS_URL:String = 'https://www.stworzonedlazdrowia.pl';

		/**
		 * URL for calling old-style RESTful API methods.
		 *
		 */
		public static var API_URL:String = UNIPASS_URL + '/api/1';
		
		/**
		 * OAUTH autherization URL,
		 * used in Facebook.as to authenicate users.
		 *
		 */
		public static var AUTH_URL:String = UNIPASS_URL + '/oauth2/authorize';
		
		/**
		 * OAUTH autherization URL,
		 * used in Facebook.as to authenicate users.
		 *
		 */
		public static var TOKEN_URL:String = UNIPASS_URL + '/oauth2/token';
		
		/**
		 * Used for AIR applications only.
		 * URL to re-direct to after a successfull login to Facebook.
		 *
		 * @see com.facebook.graph.FacebookDesktop#login
		 * @see http://developers.facebook.com/docs/authentication/desktop
		 *
		 */
		public static var LOGIN_SUCCESS_URL:String = UNIPASS_URL + '/oauth2/login_success.html';
	}
}
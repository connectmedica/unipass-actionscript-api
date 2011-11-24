<?php

require_once 'facebook-sdk/facebook.php';
require_once 'oauth2/GrantType/IGrantType.php';
require_once 'oauth2/GrantType/ClientCredentials.php';
require_once 'oauth2/Client.php';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

!defined('UNIPASS_URL')      && define('UNIPASS_URL',      'https://www.stworzonedlazdrowia.pl');
!defined('UNIPASS_API_PATH') && define('UNIPASS_API_PATH', '/api/1');

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Variables to be used by HTML template
global $facebook;
global $unipass_token;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Setup Facebook client
$facebook = new Facebook(array('appId' => FACEBOOK_APP_ID, 'secret' => FACEBOOK_APP_SECRET));

// Setup Unipass client
$unipass = new OAuth2\Client(UNIPASS_CLIENT_ID, UNIPASS_CLIENT_SECRET);
$unipass->setAccessTokenType(OAuth2\Client::ACCESS_TOKEN_BEARER);
$unipass->setAccessTokenParamName('oauth_token');

// See if there is a Facebook user from a cookie
$facebook_user = $facebook->getUser();

if ($facebook_user) {
    try {
        $facebook_profile = $facebook->api('/me');

        // Fetch client access token from Unipass
        $response = $unipass->getAccessToken(UNIPASS_URL.'/oauth2/token', OAuth2\Client::GRANT_TYPE_CLIENT_CREDENTIALS, array());
        $unipass_client_token = $response['result']['access_token'];
        $unipass->setAccessToken($unipass_client_token);

        // Automatically join validated Facebook account with Unipass account (by Facebook UID / Facebook user e-mail)
        $response = $unipass->fetch(UNIPASS_URL.UNIPASS_API_PATH.'/users/connect',
                                    array(
                                         'provider' => 'facebook',
                                         'uid'      => $facebook_profile['id'],
                                         'email'    => $facebook_profile['email']
                                    ),
                                    OAuth2\Client::HTTP_METHOD_POST);

        // Unipass auto-connect returns user's access_token
        $unipass_token = $response['result']['access_token'];
        $unipass->setAccessToken($unipass_token);
    } catch (Exception $e) {
        echo('<pre>'.htmlspecialchars(print_r($e, true)).'</pre>');
        $facebook = $unipass_token = null;
    }
} else {
    $url = $facebook->getLoginUrl(array('scope' => FACEBOOK_SCOPE, 'redirect_uri' => FACEBOOK_APP_URL));
    echo("<script type='text/javascript'>top.location.href = '$url';</script>");
}

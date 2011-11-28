<?php

require_once 'oauth2/GrantType/IGrantType.php';
require_once 'oauth2/GrantType/AuthorizationCode.php';
require_once 'oauth2/Client.php';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

!defined('UNIPASS_URL')            && define('UNIPASS_URL',            'https://www.stworzonedlazdrowia.pl');
!defined('UNIPASS_AUTH_ENDPOINT')  && define('UNIPASS_AUTH_ENDPOINT',  '/oauth2/authorize');
!defined('UNIPASS_TOKEN_ENDPOINT') && define('UNIPASS_TOKEN_ENDPOINT', '/oauth2/token');

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Variables to be used by HTML template
global $unipass_token;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Setup Unipass client
$unipass = new OAuth2\Client(UNIPASS_CLIENT_ID, UNIPASS_CLIENT_SECRET);
$unipass->setAccessTokenType(OAuth2\Client::ACCESS_TOKEN_BEARER);
$unipass->setAccessTokenParamName('oauth_token');

function redirect($url) {
    header('Location: '.$url);
    die('Redirect');
}

if (!isset($_GET['code'])) {
    redirect($unipass->getAuthenticationUrl(UNIPASS_URL.UNIPASS_AUTH_ENDPOINT, REDIRECT_URI));

} else {
    $params = array('code' => $_GET['code'], 'redirect_uri' => REDIRECT_URI);
    $response = $unipass->getAccessToken(UNIPASS_URL.UNIPASS_TOKEN_ENDPOINT, 'authorization_code', $params);

    if (isset($response['result']['error']) && $response['result']['error'] == 'invalid_grant') {
        redirect($unipass->getAuthenticationUrl(UNIPASS_URL.UNIPASS_AUTH_ENDPOINT, REDIRECT_URI));
    } else {
        $unipass_token = $response['result']['access_token'];
        $unipass->setAccessToken($unipass_token);
    }
}

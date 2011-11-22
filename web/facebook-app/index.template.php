<?php

require 'config.php';
require 'lib/facebook-sdk/facebook.php';
require 'lib/oauth2/GrantType/IGrantType.php';
require 'lib/oauth2/GrantType/ClientCredentials.php';
require 'lib/oauth2/Client.php';

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (!defined('UNIPASS_URL'))      define('UNIPASS_URL',      'https://www.stworzonedlazdrowia.pl');
if (!defined('UNIPASS_API_PATH')) define('UNIPASS_API_PATH', '/api/1');

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Setup Facebook client
$facebook = new Facebook(array('appId' => FACEBOOK_APP_ID, 'secret' => FACEBOOK_APP_SECRET));

// Setup Unipass client
$unipass = new OAuth2\Client(UNIPASS_CLIENT_ID, UNIPASS_CLIENT_SECRET);
$unipass->setAccessTokenType(OAuth2\Client::ACCESS_TOKEN_BEARER);
$unipass->setAccessTokenParamName('oauth_token');

// See if there is a user from a cookie
$facebook_user = $facebook->getUser();

if ($facebook_user) {
    try {
        $facebook_profile = $facebook->api('/me');

        // Fetch client access token from Unipass
        $response = $unipass->getAccessToken(UNIPASS_URL.'/oauth2/token', OAuth2\Client::GRANT_TYPE_CLIENT_CREDENTIALS, array());
        $unipass_client_token = $response['result']['access_token'];
        $unipass->setAccessToken($unipass_client_token);

        // Automatically join validated Facebook account with Unipass account (by Facebook UID / User e-mail)
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

        $response = $unipass->fetch(UNIPASS_URL.UNIPASS_API_PATH.'/me');
        $unipass_profile = $response['result'];
    } catch (Exception $e) {
        echo('<pre>' . htmlspecialchars(print_r($e, true)) . '</pre>');
        $facebook_user = null;
        $unipass_token = null;
    }
} else {
    $url = $facebook->getLoginUrl(array('scope' => $FACEBOOK_SCOPE, 'redirect_uri' => $FACEBOOK_APP_URL));
    echo("<script type='text/javascript'>top.location.href = '$url';</script>");
}

?>

<!DOCTYPE html>
<html xmlns:fb="http://www.facebook.com/2008/fbml">
<body>
<?php if ($facebook_profile) { ?>
    Your Facebook profile is
    <pre><?php print htmlspecialchars(print_r($facebook_profile, true)) ?></pre>
<?php } else { ?>
    <fb:login-button></fb:login-button>
<?php } ?>

<?php if ($unipass_token) { ?>
    Your Unipass profile is
    <pre><?php print htmlspecialchars(print_r($unipass_profile, true)) ?></pre>
<?php } else { ?>
    No Unipass data
<?php } ?>

<div id="fb-root"></div>
<script>
    window.fbAsyncInit = function() {
        FB.init({
            appId  : '<?php echo $facebook->getAppID() ?>',
            status : true,
            cookie : true,
            xfbml  : true,
            oauth  : true
        });

        FB.Event.subscribe('auth.login', function(response) {
            window.location.reload();
        });
        FB.Event.subscribe('auth.logout', function(response) {
            window.location.reload();
        });
    };
    (function() {
        var e = document.createElement('script');
        e.async = true;
        e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
        document.getElementById('fb-root').appendChild(e);
    }());
</script>
</body>
</html>

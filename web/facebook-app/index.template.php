<?php

require_once 'config.php';
require_once 'lib/connect.php';

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <!--
    Smart developers always View Source.

    This application was built using Adobe Flex, an open source framework
    for building rich Internet applications that get delivered via the
    Flash Player or to desktops via Adobe AIR.

    Learn more about Flex at http://flex.org
    // -->
    <head>
        <title>${title}</title>
        <meta name="google" value="notranslate" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <!-- Include CSS to eliminate any default margins/padding and set the height of the html element and
             the body element to 100%, because Firefox, or any Gecko based browser, interprets percentage as
             the percentage of the height of its parent container, which has to be set explicitly.  Fix for
             Firefox 3.6 focus border issues.  Initially, don't display flashContent div so it won't show
             if JavaScript disabled.
        -->
        <style type="text/css" media="screen">
            html, body  { height:100%; }
            body { margin:0; padding:0; overflow:auto; text-align:center;
                   background-color: ${bgcolor}; }
            object:focus { outline:none; }
            #flashContent { display:none; }
        </style>

        <!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
        <!-- BEGIN Browser History required section ${useBrowserHistory}>
        <link rel="stylesheet" type="text/css" href="history/history.css" />
        <script type="text/javascript" src="history/history.js"></script>
        <!${useBrowserHistory} END Browser History required section -->

        <script type="text/javascript" src="swfobject.js"></script>
        <script type="text/javascript">
            // For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection.
            var swfVersionStr = "${version_major}.${version_minor}.${version_revision}";
            // To use express install, set to playerProductInstall.swf, otherwise the empty string.
            var xiSwfUrlStr = "${expressInstallSwf}";
            var flashvars = {};
            flashvars.facebookToken = "<?= $facebook->getAccessToken() ?>";
            flashvars.unipassToken = "<?= $unipass_token ?>";
            var params = {};
            params.quality = "high";
            params.bgcolor = "${bgcolor}";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            var attributes = {};
            attributes.id = "${application}";
            attributes.name = "${application}";
            attributes.align = "middle";
            swfobject.embedSWF(
                "${swf}.swf", "flashContent",
                "${width}", "${height}",
                swfVersionStr, xiSwfUrlStr,
                flashvars, params, attributes);
            // JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
            swfobject.createCSS("#flashContent", "display:block;text-align:left;");
        </script>
    </head>
    <body>
        <div id="fb-root"></div>
        <!-- SWFObject's dynamic embed method replaces this alternative HTML content with Flash content when enough
             JavaScript and Flash plug-in support is available. The div is initially hidden so that it doesn't show
             when JavaScript is disabled.
        -->
        <div id="flashContent">
            <p>
                To view this page ensure that Adobe Flash Player version
                ${version_major}.${version_minor}.${version_revision} or greater is installed.
            </p>
            <script type="text/javascript">
                var pageHost = ((document.location.protocol == "https:") ? "https://" : "http://");
                document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='"
                                + pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" );
            </script>
        </div>

        <noscript>
            <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="${width}" height="${height}" id="${application}">
                <param name="movie" value="${swf}.swf" />
                <param name="quality" value="high" />
                <param name="bgcolor" value="${bgcolor}" />
                <param name="allowScriptAccess" value="sameDomain" />
                <param name="allowFullScreen" value="true" />
                <!--[if !IE]>-->
                <object type="application/x-shockwave-flash" data="${swf}.swf" width="${width}" height="${height}">
                    <param name="quality" value="high" />
                    <param name="bgcolor" value="${bgcolor}" />
                    <param name="allowScriptAccess" value="sameDomain" />
                    <param name="allowFullScreen" value="true" />
                <!--<![endif]-->
                <!--[if gte IE 6]>-->
                    <p>
                        Either scripts and active content are not permitted to run or Adobe Flash Player version
                        ${version_major}.${version_minor}.${version_revision} or greater is not installed.
                    </p>
                <!--<![endif]-->
                    <a href="http://www.adobe.com/go/getflashplayer">
                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
                    </a>
                <!--[if !IE]>-->
                </object>
                <!--<![endif]-->
            </object>
        </noscript>

        <script type="text/javascript">
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

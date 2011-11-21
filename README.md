unipass-actionscript-api
========================

ActionScript 3 SDK for Unipass API
----------------------------------

### Usage

1. Flex Mobile AIR Application

    ```actionscript
    import mx.events.FlexEvent;
    import unipass.mobile.Unipass;
    
    protected function init(event:FlexEvent):void {
        Unipass.init("YOUR_UNIPASS_CLIENT_ID", function(session:Object, error:Object):void {
            if (session) {
                // We are already signed in, current session is read from Shared Object
                fetchMe();
            } else {
                // We are not signed in - display default Unipass login window
                Unipass.login(function(session:Object, error:Object):void {
                    if (session) { fetchMe(); }
                }, this.stage);
            }
        });
    }
    
    protected function fetchMe():void {
        Unipass.api("/me", function(me:Object, error:Object):void {
            if (me) { /* do something with me! */ }
        });
    }
    ```

### Create workspace for building SWC libraries

1. Common API

   * Create new **Flex Library Project**
   * Project name: `unipass-actionscript-api`
   * Configuration: **Generic library**
   * Main source folder: `api`

2. Web Library 

   * Create new **Flex Library Project**
   * Project name: `unipass-api-web`
   * Configuration: **Generic library**
   * Add "unipass-actionscript-api" project to build path libraries.
     Ensure that its Link Type is set to **Merged into code**.
   * Click on "Source path" tab then Add Folder: `${DOCUMENTS}/unipass-actionscript-api/webAPI`
   * Click "Browse" on Main source folder and select "[source path] webAPI" folder from "unipass-api-web".

3. Mobile Library 

   * Create new **Flex Library Project**
   * Project name: `unipass-api-mobile`
   * Configuration: **Mobile library**
   * Add "unipass-actionscript-api" project to build path libraries.
     Ensure that its Link Type is set to **Merged into code**.
   * Click on "Source path" tab then Add Folder: `${DOCUMENTS}/unipass-actionscript-api/mobileAPI`
   * Click "Browse" on Main source folder and select "[source path] mobileAPI" folder from "unipass-api-mobile".

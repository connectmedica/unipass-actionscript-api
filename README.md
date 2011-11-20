unipass-actionscript-api
========================

ActionScript 3 SDK for Unipass API
----------------------------------

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

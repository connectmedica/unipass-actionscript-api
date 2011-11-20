unipass-actionscript-api
========================

ActionScript 3 SDK for Unipass API
----------------------------------

### Create workspace for building SWC libraries

1. Web Library 

   * Create new Flex Library project
   * Project name: `unipass-actionscript-api`
   * Generic library
   * Do NOT include Adobre AIR libraries
   * Main src folder: api

2. Mobile Library 

   * Create new Flex Library Project
   * Project name: `unipass-actionscript-api-mobile`
   * Check "Mobile library"
   * Add "unipass-actionscript-api" project to build path libraries. 
     Ensure that its Link Type is set to "Merged into code".
   * Click on "Source path" tab and Add Folder. 
     Browse for "unipass-actionscript-api" and select "mobileAPI" folder located inside previously created 
     "unipass-actionscript-api" project. The path should show "${DOCUMENTS}/unipass-actionscript-api/mobileAPI".
   * Click "Browse" on Main source folder and select "mobileAPI" folder from "[source path] unipass-actionscript api".

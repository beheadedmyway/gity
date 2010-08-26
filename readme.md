Gity - The Mac Client for Git

##CREDITS##
- Initial Gity Version Written by Aaron Smith from gngrwzrd.com
- Brandon Sneed
- Mark Szymanski

##POINTS OF INTEREST FOR OBJ-C CODE##
- `source/GTDocumentController.m/h` - document controller for document based app
- `source/GittyDocument.m/h` - this is the main controller for each separate document that get's opened.
- `source/GDOperationsController.m/h` - the operations controller is what manages all asynchronous git operations

##POINTS OF INTEREST FOR PYTHON CODE##
- The `GTOperationsController` runs python scripts in python/*

##POINTS OF INTEREST FOR HISTORY AND DIFFING##
- `diff/commit.html` (testing harness for a history commit)
- `diff/src.html` (testing harness for diffs)
- `scripts/createdifftemplate.py` (creates a template that get's copied into the final app from xcode)
- `scripts/createcommittemplate.py` (creates a template that get's copied into the final app from xcode)

##OTHER RANDOM NOTES##
- Registration has been disabled and taken out of the menu.
- The default sparkle implementation is left in still hitting my server. The URL is in the Info.plist file for the project.

##XCODE BUILDING NOTES##
- The project will build directly after a checkout.
- Gity will only build with 10.6 SDK

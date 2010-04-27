//copyright 2009 aaronsmith

#import <Foundation/NSFileManager.h>

/**
 * @file NSFileManager+Additions.h
 *
 * Header file for NSFileManager cocoa additions.
 */

/**
 * @class NSFileManager
 * 
 * Category additions to NSFileManager.
 */
@interface NSFileManager (GDAdditions)

/**
 * Returns a path to a folder, creating the folder if
 * it doesn't exist.
 */
- (NSString *) pathToFolderOfType:(const OSType) folderType shouldCreateFolder:(BOOL) create;

/**
 * Returns a path to the application support path.
 */
- (NSString *) applicationSupportFolder;

/**
 * Returns the path to the application support folder for
 * this app. The folder is the bundle identifier name.
 */
- (NSString *) thisApplicationsSupportFolder;

/**
 * Returns the path to the application support folder for
 * this app. The folder is the name of the current app.
 */
- (NSString *) thisApplicationsSupportFolderByAppName;
@end
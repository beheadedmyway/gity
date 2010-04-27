
#import <Cocoa/Cocoa.h>


/**
 * @file NSFileHandle+Additions.h
 *
 * Header file for NSFileHandle cocoa additions.
 */

/**
 * @class NSFileHandle
 * 
 * Category additions to NSFileHandle.
 */
@interface NSFileHandle (GDAdditions)

+ (NSString *) tmpFileName;
- (id) initWithFile:(NSString *) file;
- (id) initWithTruncatedFile:(NSString *) file;
+ (NSFileHandle *) tmpFile:(NSString *) path;

@end

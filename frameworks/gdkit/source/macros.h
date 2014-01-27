
#import <Foundation/Foundation.h>

/**
 * @file macros.h
 * 
 * Header file that contains macros, and other c definitions.
 */

#ifndef __cplusplus
#define or ||
#define and &&
#define not !
#define eq ==
#define is ==
#endif
#define neq !=

#ifndef nil
#ifndef NULL
#define NULL (void *) 0
#endif
#define nil NULL
#endif

/**
 * Releases and nils out any id object.
 */
#define GDRelease(x) do{ \
	if((x)==nil){break;} \
	(x)=nil;} while(0)

/**
 * Prints an NSTask and it's arguments.
 */
NS_INLINE void GDPrintNSTask(NSTask * task) {
	if([task arguments] == nil) return;
	NSString * owt = [[task launchPath] stringByAppendingString:@" "];
	id arg;
	for(arg in [task arguments]) {
		owt = [[owt stringByAppendingString:[arg description]] stringByAppendingString:@" "];
	}
	NSLog(@"%@",owt);
}

/**
 * Prints an NSRect formatted like: NSRect(x:%g, y:%g, w:%g, h:%g).
 */
NS_INLINE void GDPrintNSRect(NSRect rect) {
	NSLog(@"NSRect(x:%g, y:%g, w:%g, h:%g)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

/**
 * Prints an NSRect prefixed with some label: "[label] NSRect(x:%g, y:%g, w:%g, h:%g)".
 */
NS_INLINE void GDPrintNSRectWithLabel(NSString * label, NSRect rect) {
	NSLog(@"[%@] NSRect(x:%g, y:%g, w:%g, h:%g)",label,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

/**
 * Prints an NSPoint formatted like: NSPoint(x:%g,y:%g).
 */
NS_INLINE void GDPrintNSPoint(NSPoint point) {
	NSLog(@"NSPoint(x:%g,y:%g)",point.x,point.y);
}

/**
 * Prints an NSPoint prefixed with some label: "[label] NSPoint(x:%g,y:%g)".
 */
NS_INLINE void GDPrintNSPointWithLabel(NSString * label,NSPoint point) {
	NSLog(@"[%@] NSPoint(x:%g,y:%g)",label,point.x,point.y);
}

/**
 * Prints an NSSize formatted like: NSSize(w:%g,h:%g).
 */
NS_INLINE void GDPrintNSSize(NSSize size) {
	NSLog(@"NSSize(w:%g,h:%g)",size.width,size.height);
}

/**
 * Prints an NSSize prefixed with some label: "[label] NSSize(w:%g,h:%g)".
 */
NS_INLINE void GDPrintNSSizeWithLabel(NSString * label,NSSize size) {
	NSLog(@"[%@] NSSize(w:%g,h:%g)",label,size.width,size.height);
}

/**
 * A shortcut for NSLog which will include __FILE__ and __LINE__ that the NSLog is on.
 */
#define gdflog(s,...) NSLog(@"<%p %@:(%d)> %@",self,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__])

/**
 * A shortcut for NSLog(@"",...).
 */
#define gdlog(s,...) NSLog(@"%@",[NSString stringWithFormat:(s),##__VA_ARGS__])

//copyright aaronsmith 2009

#import <Cocoa/Cocoa.h>

/**
 * @file GDQuartzDisplay.h
 *
 * Header file for GDQuartzDisplay.
 */

/**
 * Maximum online or active displays.
 * 
 * GDQuartzDisplay uses the core graphics API to get online/active
 * displays by calling CGGetActiveDisplayList() and CGGetOnlineDisplayList(),
 * this definition is the count that will be used when calling those functions.
 */
#define kGDMaxDisplays 12

/**
 * The GDQuartzDisplay represents a display and wraps Core Graphics quartz display functions.
 */
@interface GDQuartzDisplay : NSObject {
	
	/**
	 * The hardware display id.
	 */
	CGDirectDisplayID displayId;
}

/**
 * Returns an array of CGQuartzDisplay instances which
 * are all of the active displays attached.
 * 
 * These are displays that can be drawn to.
 */
+ (NSMutableArray *) activeDisplays;

/**
 * Returns an array of CGQuartzDisplay instances which
 * are all of the online displays.
 * 
 * These are active, mirrored, or sleeping displays.
 */
+ (NSMutableArray *) onlineDisplays;

/**
 * Returns the display that is considered the "Main Display",
 * this is the display id associated with CGMainDisplayID.
 */
+ (GDQuartzDisplay *) mainDisplay;

/**
 * Initializes a GDQuartzDisplay from a point.
 * It uses this point to find the display that contains that point.
 */
- (id) initWithPoint:(NSPoint) point;

/**
 * Initializes a GDQuartzDisplay from a rect. 
 * It uses this rect to find the display that contains that rect.
 */
- (id) initWithRect:(NSRect) rect;

/**
 * Initialize a GDQuartzDisplay from a CGDirectDisplayID.
 *
 * @param ddid A CGDirectDisplayID.
 */
- (id) initWithDirectDisplayID:(CGDirectDisplayID) ddid;

/**
 * Check if this display is the main display.
 */
- (Boolean) isMainDisplay;

/**
 * Check whether or not an NSSize is considered fullscreen
 * in this display's size.
- (Boolean) isSizeWindowedFullscreen:(NSSize) size; */

/**
 * Whether or not this display is active.
 * (drawable)
 */
- (Boolean) isActive;

/**
 * Whether or not this display is always in a mirrored set.
 */
- (Boolean) isAlwaysInMirrorSet;

/**
 * Whether or not this display is sleeping.
 */
- (Boolean) isSleeping;

/**
 * Whether or not this display is in a mirrored set.
 */
- (Boolean) isInMirrorSet;

/**
 * Whether or not this display is online (active, mirrored, or sleeping).
 */
- (Boolean) isOnline;

/**
 * Whether or not this display is running stereo
 * graphics mode.
 */
- (Boolean) isStereo;

/**
 * Whether or not this display is the primary display
 * in a mirror set.
 */
- (Boolean) isPrimaryDisplayInMirrorSet;

/**
 * The display that this display is mirroring (check against
 * isInMirrorSet).
 */
- (GDQuartzDisplay *) mirrorsDisplay;

/**
 * Get the primary display from a mirror set.
 */
- (GDQuartzDisplay *) primaryDisplay;

/**
 * Get the display rotation.
 */
- (double) rotation;

/**
 * Get's the display size in millimeters.
 */
- (NSSize) millimeterSize;

/**
 * Get's the display size in pixels.
 */
- (NSSize) pixelSize;

/**
 * The displays' bounds.
 */
- (NSRect) bounds;

/**
 * Returns an NSScreen instance for the
 * screen that this GDQuartzDisplay represents.
 */
- (NSScreen *) screen;

/**
 * Whether or not this display uses OpenGL acceleration.
 */
- (Boolean) usesOpenGLAcceleration;

@end

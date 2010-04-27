
#import <Cocoa/Cocoa.h>
#import "macros.h"

/**
 * @file GDSoundController.h
 * 
 * Header file for GDSoundController.
 */

/**
 * The GDSoundController is a controller used to play and manage sounds.
 */
@interface GDSoundController : NSObject {
	NSSound * popSound;
}

/**
 * Clears cache of sounds that were played once and retained for later use.
 */
- (void) clearCache;

/**
 * Play the "Pop" sound at default volume.
 */
- (void) pop;

/**
 * Play the "Pop" sound at the specified volume.
 *
 * @param _volume The desired volume (0-1).
 */
- (void) popAtVolume:(float) _volume;

@end

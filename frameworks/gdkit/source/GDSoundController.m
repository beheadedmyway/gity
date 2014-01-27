//copyright 2009 aaronsmith

#import "GDSoundController.h"

@implementation GDSoundController

- (void) pop {
	if(popSound is nil) popSound=[NSSound soundNamed:@"Pop"];
	@synchronized(self) {
		[popSound play];
	}
}

- (void) popAtVolume:(float) _volume {
	if(popSound is nil) popSound=[NSSound soundNamed:@"Pop"];
	@synchronized(self) {
		float _vol = [popSound volume];
		[popSound setVolume:_volume];
		[popSound play];
		[popSound setVolume:_vol];
	}
}

- (void) clearCache {
	GDRelease(popSound);
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDSoundController\n");
	#endif
	[self clearCache];
}

@end

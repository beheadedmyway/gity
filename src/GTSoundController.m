// Copyright Aaron Smith 2009
// 
// This file is part of Gity.
// 
// Gity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Gity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Gity. If not, see <http://www.gnu.org/licenses/>.

#import "GTSoundController.h"

static GTSoundController *inst;

@implementation GTSoundController

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id inst = nil;
    dispatch_once(&pred, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

- (id) init {
	if(self = [super init]) {
		pop = [NSSound soundNamed:@"Pop"];
		[pop setVolume:0.8];
	}
	
	return self;
}

- (BOOL) isMuted {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"GTMutePopSounds"];
}

- (void) pop {
	if([self isMuted])return;
	[pop play];
}

+ (id)allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}
- (id) copyWithZone:(NSZone *) zone {
	return self;
}
@end

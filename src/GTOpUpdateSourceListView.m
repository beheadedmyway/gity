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

#import "GTOpUpdateSourceListView.h"
#import "GittyDocument.h"

@implementation GTOpUpdateSourceListView

- (void) update {
	[[gd sourceListView] update];
}

- (void) main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if([self isCancelled]) {
		[pool drain];
		return;
	}
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:YES];
	done = true;
	[pool drain];
}

@end

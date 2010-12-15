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

#import "GTBaseOp.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTBaseOp

- (void) setArguments{}
- (void) taskComplete{}
- (void) initializeTask{}
- (void) validateResult{}
- (void) wasCancelled{}

- (id) initWithGD:(GittyDocument *) _gd {
	self = [self init];
	done = false;
	canceled = false;
	readsSTDERR = false;
	readsSTDOUT = false;

	if(![self isCancelled]) {
		if(_gd) {
			gd = _gd;
			git = [gd git];
			gitd = [gd gitd];
		}

		fileManager = [NSFileManager defaultManager];
	}
	
	return self;
}

- (void) readSTDOUT {
	NSFileHandle *s = [[task standardOutput] fileHandleForReading];

	if([s fileDescriptor] == -1) {
		done = true;
		return;
	}
	
	@try {
		NSData *content = [s readDataToEndOfFile];
		[s closeFile];
		
		if(!stoutEncoding) {
			stoutEncoding = NSUTF8StringEncoding;
		}
		
		stout = [[NSString alloc] initWithData:content encoding:stoutEncoding];
	}
	@catch (NSException *e) {
		// sometimes there's no stdout, so this is ok.
	}
}

- (void) readSTDERR {
	NSFileHandle *s = [[task standardError] fileHandleForReading];
	
	if([s fileDescriptor] == -1) {
		done = true;
		return;
	}
	
	@try {
		NSData *content = [s readDataToEndOfFile];
		[s closeFile];
		
		sterr = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];		
	}
	@catch (NSException *e) {
		// sometimes there's no stderr, so this is ok.
	}
}

- (void) updateArguments {
	[task setArguments:args];
}

- (BOOL) isFinished {
	return done;
}

- (BOOL) isCancelled {
	return canceled;
}

- (NSDictionary *) environment {
	return [[NSProcessInfo processInfo] environment];
}

- (void) cancel	{
	canceled = true;
	[super cancel];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTBaseOp\n");
	#endif
	
	GDRelease(stout);
	GDRelease(sterr);
	GDRelease(error);
	
	readsSTDERR = false;
	readsSTDOUT = false;
	gd = nil;
	git = nil;
	gitd = nil;
	done = false;
	fileManager = nil;
	
	[super dealloc];
}

@end

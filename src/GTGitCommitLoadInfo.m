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

#import "GTGitCommitLoadInfo.h"

@implementation GTGitCommitLoadInfo
@synthesize rawLogOutput;
@synthesize before;
@synthesize after;
@synthesize authorContains;
@synthesize messageContains;
@synthesize matchAll;
@synthesize refName;

- (void) updateBefore:(NSDate *) _before andAfter:(NSDate *) _after andAuthorContains:(NSString *) _ac andMessageContains:(NSString *) _mc andShouldMatchAll:(BOOL) _ma {
	[self setBefore:_before];
	[self setAfter:_after];
	[self setAuthorContains:_ac];
	[self setMessageContains:_mc];
	[self setMatchAll:_ma];
}

- (NSString *) afterDateAsTimeIntervalString {
	double af = [after timeIntervalSince1970];
	unsigned long long afc = ceil(af);
	return [NSString stringWithFormat:@"%qu",afc];
}

- (NSString *) beforeDateAsTimeIntervalString {
	double bf = [before timeIntervalSince1970];
	unsigned long long bfc = ceil(bf);
	return [NSString stringWithFormat:@"%qu",bfc];
}

- (NSString *) beforeDateForDisplay {
	return [before descriptionWithCalendarFormat:@"%B %e, %Y" timeZone:nil locale:nil];
}

- (NSString *) afterDateForDisplay {
	return [after descriptionWithCalendarFormat:@"%B %e, %Y" timeZone:nil locale:nil];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTGitCommitLoadInfo\n");
	#endif
	GDRelease(rawLogOutput);
	GDRelease(before);
	GDRelease(after);
	GDRelease(authorContains);
	GDRelease(messageContains);
	[super dealloc];
}

@end

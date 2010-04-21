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

#import "GTGitCommit.h"

@implementation GTGitCommit
@synthesize date;
@synthesize parents;
@synthesize refs;
@synthesize hash;
@synthesize abbrevHash;
@synthesize author;
@synthesize email;
@synthesize subject;
@synthesize body;
@synthesize notes;
@synthesize parsedCommitDetails;

- (GTGitCommit *) copyWithZone:(NSZone *) zone {
	GTGitCommit * cp = [[GTGitCommit alloc] init];
	[cp setHash:[self hash]];
	[cp setAbbrevHash:[self abbrevHash]];
	[cp setAuthor:[self author]];
	[cp setEmail:[self email]];
	[cp setSubject:[self subject]];
	[cp setBody:[self body]];
	[cp setNotes:[self notes]];
	NSTimeInterval ti = [[self date] timeIntervalSince1970];
	NSDate * dt = [[NSDate alloc] initWithTimeIntervalSince1970:ti];
	[cp setDate:dt];
	[dt release];
	NSArray * pnts = [[NSArray alloc] initWithArray:[self parents] copyItems:true];
	[cp setParents:pnts];
	[pnts release];
	NSArray * rfs = [[NSArray alloc] initWithArray:[self refs] copyItems:true];
	[cp setRefs:rfs];
	[rfs release];
	return cp;
}

- (BOOL) isMatchedByRegex:(id) aRegex {
	return [subject isMatchedByRegex:aRegex] or [author isMatchedByRegex:aRegex] or [hash isMatchedByRegex:aRegex];
}

- (void) dealloc {
	#ifdef GT_PRINT_EXTENDED_DEALLOCS
	printf("DEALLOC GTGitCommit\n");
	#endif
	GDRelease(date);
	GDRelease(parents);
	GDRelease(refs);
	GDRelease(hash);
	GDRelease(abbrevHash);
	GDRelease(author);
	GDRelease(email);
	GDRelease(subject);
	GDRelease(body);
	GDRelease(notes);
	GDRelease(parsedCommitDetails);
	[super dealloc];
}

@end

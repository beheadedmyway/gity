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

#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>
#import "defs.h"
#import "GTBaseObject.h"

@interface GTGitCommitLoadInfo : GTBaseObject {
	BOOL matchAll;
	NSDate * before;
	NSDate * after;
	NSString * rawLogOutput;
	NSString * authorContains;
	NSString * messageContains;
	NSString * refName;
}

@property (strong) NSString * rawLogOutput;
@property (copy,nonatomic) NSDate * before;
@property (copy,nonatomic) NSDate * after;
@property (copy,nonatomic) NSString * authorContains;
@property (copy,nonatomic) NSString * messageContains;
@property (assign,nonatomic) BOOL matchAll;
@property (copy,nonatomic) NSString * refName;

- (void) updateBefore:(NSDate *) _before andAfter:(NSDate *) _after andAuthorContains:(NSString *) _ac andMessageContains:(NSString *) _mc andShouldMatchAll:(BOOL) _ma;
- (NSString *) afterDateAsTimeIntervalString;
- (NSString *) beforeDateAsTimeIntervalString;
- (NSString *) beforeDateForDisplay;
- (NSString *) afterDateForDisplay;

@end

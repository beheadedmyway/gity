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
#import <RegexKit/RegexKit.h>
#import "defs.h"
#import "GTBaseObject.h"

@interface GTGitCommit : GTBaseObject {
	NSDate * date;
	NSArray * parents;
	NSArray * refs;
	NSString * hash;
	NSString * abbrevHash;
	NSString * author;
	NSString * email;
	NSString * subject;
	NSString * body;
	NSString * notes;
	NSString * parsedCommitDetails;
    NSString * graph;
}

@property (strong,nonatomic) NSDate * date;
@property (strong,nonatomic) NSArray * parents;
@property (strong,nonatomic) NSArray * refs;
@property (copy,nonatomic) NSString * hash;
@property (copy,nonatomic) NSString * abbrevHash;
@property (copy,nonatomic) NSString * author;
@property (copy,nonatomic) NSString * email;
@property (copy,nonatomic) NSString * subject;
@property (copy,nonatomic) NSString * body;
@property (copy,nonatomic) NSString * notes;
@property (copy,nonatomic) NSString * parsedCommitDetails;
@property (copy,nonatomic) NSString * graph;

- (BOOL) isMatchedByRegex:(id) aRegex;

@end

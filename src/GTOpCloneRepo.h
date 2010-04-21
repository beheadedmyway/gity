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
#import "GTPythonScripts.h"
#import "GTBasePythonTaskOperation.h"

@class GittyDocument;
@class GTCloneRepoController;

@interface GTOpCloneRepo : GTBasePythonTaskOperation {
	NSString * repoURL;
	NSString * dir;
	NSString * pathToOpen;
	GTCloneRepoController * cloneController;
}

@property (assign,nonatomic) GTCloneRepoController * cloneController;
@property (readonly,nonatomic) NSString * pathToOpen;

//- (id) initWithGD:(GittyDocument *) _gd andRepoURL:(NSString *) url inDir:(NSString *) dir;
- (id) initWithRepoURL:(NSString *) url inDir:(NSString *) _dir;

@end

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
#import "GTModalController.h"

#define kGTGitExecutablePathKey @"GTGitExecPath"

@interface GTGitCommandExecutor : NSObject {
	NSString *gitProjectPath;
	NSString *__weak gitExecPath;
    NSString *gitConfigPath;
	NSMutableDictionary *environment;
}

@property (copy,nonatomic) NSString *gitProjectPath;
@property (readonly,nonatomic) NSString *gitConfigPath;
@property (weak, readonly,nonatomic) NSString *gitExecPath;

- (void) verifyGitExecutable;
- (void) verifyGitBinaryVersion;
- (void) setEnvironments;
- (BOOL) isPathGitRepository:(NSString *) path;
- (BOOL) doesPathContainDOTGitFolder:(NSString *) path;
- (BOOL) initRepositoryInPath:(NSString *) path;
- (NSString *) gitProjectPathFromRevParse:(NSString *) proposedPath;
- (NSURL *) gitProjectPathAsNSURL;
- (NSTask *) newGitBashTask;
- (NSTask *) newPythonBinTask;

@end

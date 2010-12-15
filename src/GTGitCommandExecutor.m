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

#import "GTGitCommandExecutor.h"

@implementation GTGitCommandExecutor

@synthesize gitProjectPath, gitExecPath;

- (id) init {
	if(self = [super init]) {
		gitExecPath = [[NSUserDefaults standardUserDefaults] stringForKey:kGTGitExecutablePathKey];
		
		[self setEnvironments];
	}
	
	return self;
}

- (NSURL *) gitProjectPathAsNSURL {
	NSString *s = [@"file://" stringByAppendingString:[self gitProjectPath]];
	
	return [NSURL URLWithString:s];
}

- (BOOL) verifyRemoteURL:(NSString *) remote {
	return NO;
}

- (void) verifyGitExecutable {
	NSUInteger res;
	NSOpenPanel *op;
	
	if([[NSUserDefaults standardUserDefaults] stringForKey:kGTGitExecutablePathKey]) {
		gitExecPath = [[NSUserDefaults standardUserDefaults] stringForKey:kGTGitExecutablePathKey];
		
		if(![[NSFileManager defaultManager] fileExistsAtPath:gitExecPath] or gitExecPath is nil) {
			res = [[GTModalController sharedInstance] runCantFindGitExecAlert];
			
			if(res == NSCancelButton) {
				[[NSApplication sharedApplication] terminate:self];
			}
			
			op = [NSOpenPanel openPanel];
			
			[op setCanChooseFiles:true];
			[op setTitle:@"Choose Your Git Executable"];
			[op setCanChooseDirectories:false];
			
			@try { 
				
				// this line of code is trying an "undocumented" method - it's in a try catch just in 
			    // case it's not available (it's been there since around 10.3).
				
				NSObject *obj = [[NSObject alloc] init];
				
				if([op respondsToSelector:@selector(setShowsHiddenFiles:)]) {
					[op performSelector:@selector(setShowsHiddenFiles:) withObject:obj];
				}
				
				[obj release];
			} 
			@catch (NSException *e) {
			}
			
			res = [op runModal];
			
			if(res == NSCancelButton) {
				[[NSApplication sharedApplication] terminate:self];
			}
			
			gitExecPath = [op filename];
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:gitExecPath forKey:kGTGitExecutablePathKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} 
	else {
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/opt/local/bin/git"]) {
			gitExecPath = @"/opt/local/bin/git";
		}
		
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/opt/bin/git"]) {
			gitExecPath = @"/opt/bin/git";
		}
		
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/git"]) {
			gitExecPath = @"/usr/bin/git";
		}
		
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/local/bin/git"]) {
			gitExecPath = @"/usr/local/bin/git";
		}
		
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/local/git/bin/git"]) {
			gitExecPath = @"/usr/local/git/bin/git";
		}
		
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/git"]) {
			gitExecPath = @"/bin/git";
		}
		
		if(gitExecPath == nil) {
			res = [[GTModalController sharedInstance] runCantFindGitExecAlert];
			
			if(res == NSCancelButton) {
				[[NSApplication sharedApplication] terminate:self];
			}
			
			op = [NSOpenPanel openPanel];
			
			[op setCanChooseFiles:true];
			[op setTitle:@"Choose Your Git Executable"];
			[op setCanChooseDirectories:false];
			
			@try { 
				
				// this line of code is trying an "undocumented" method - it's in a try catch just in 
			    // case it's not available (it's been there since around 10.3).
				
				NSObject *obj = [[NSObject alloc] init];
				
				if([op respondsToSelector:@selector(setShowsHiddenFiles:)]) {
					[op performSelector:@selector(setShowsHiddenFiles:) withObject:obj];
				}
				
				[obj release];
			} 
			@catch (NSException *e) {
			}
			
			res = [op runModal];
			
			if(res == NSCancelButton) {
				[[NSApplication sharedApplication] terminate:self];
			}
			
			gitExecPath = [op filename];
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:gitExecPath forKey:kGTGitExecutablePathKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void) verifyGitBinaryVersion {
	NSMutableArray *args = [[NSMutableArray alloc] init];
	
	[args addObject:@"--version"];
	
	NSTask *task = [self newGitBashTask];
	
	[task setArguments:args];
	[task launch];
	[task waitUntilExit];
	
	NSFileHandle *fout = [[task standardOutput] fileHandleForReading];
	NSData *data = [fout readDataToEndOfFile];
	
	[fout closeFile];
	
	NSString *versionSTDOUT = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSArray *pieces = [versionSTDOUT componentsSeparatedByString:@" "];
	
	if([pieces count] < 2) {
		goto cleanup;
	}
	
	NSString *versionString = [pieces lastObject];
	NSArray *versionPieces = [versionString componentsSeparatedByString:@"."];

	if([versionPieces count] < 2) {
		goto cleanup;
	}
	
	int gitMinor = [[versionPieces objectAtIndex:1] intValue];
	
	if(gitMinor > 5) {
		goto cleanup;
	}
	
	NSString *msg = @"Git Version Not Supported";
	NSString *desc = [NSString stringWithFormat:@"You have %@, but Gity requires a minimum of 1.6.", versionString];
	
	if(gitMinor < 6) {
		desc = [NSString stringWithFormat:@"Your version of git (%@) is outdated; Gity requires at least 1.6. Please upgrade.", versionString];
	}
	
	NSRunAlertPanel(msg, desc, @"OK", nil, nil);
	
	[[NSApplication sharedApplication] terminate:nil];

cleanup:
	[task release];
	[args release];
	[versionSTDOUT release];
}

- (NSString *) gitExecPath {
	return gitExecPath;
}

- (NSString *) gitProjectPathFromRevParse:(NSString *) proposedPath {
	NSMutableArray *args = [[NSMutableArray alloc] init];
	
	[args addObject:@"rev-parse"];
	[args addObject:@"--git-dir"];
	
	NSTask *task = [self newGitBashTask];
	
	[task setCurrentDirectoryPath:proposedPath];
	[task setArguments:args];
	
	[args release];
	
	[task launch];
	[task waitUntilExit];
	
	if([task terminationStatus] == 128) {
		[task release];
		return nil;
	}
	
	NSFileHandle *fout = [[task standardOutput] fileHandleForReading];
	NSData *data = [fout readDataToEndOfFile];
	NSString *path = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if([path isEqual:@".git\n"]) {
		[path release];
		[task release];
		return proposedPath;
	}
	
	[path autorelease];
	[task release];
	
	return [path stringByDeletingLastPathComponent];
}

- (NSTask *) newGitBashTask {
	NSTask *task = [[NSTask alloc] init];
	NSPipe *stdo = [NSPipe pipe];
	NSPipe *stde = [NSPipe pipe];
	
	[task setStandardOutput:stdo];
	[task setStandardError:stde];
	[task setEnvironment:environment];
	
	if(gitProjectPath) [task setCurrentDirectoryPath:gitProjectPath];
	
	[task setLaunchPath:gitExecPath];
	
	return task;
}

- (NSTask *) newPythonBinTask {
	NSTask *task = [[NSTask alloc] init];
	NSPipe *stdo = [NSPipe pipe];
	NSPipe *stde = [NSPipe pipe];
	
	[task setStandardOutput:stdo];
	[task setStandardError:stde];
	[task setEnvironment:environment];
	
	if(gitProjectPath) {
		[task setCurrentDirectoryPath:gitProjectPath];
	}
	
	[task setLaunchPath:@"/usr/bin/python"];
	
	return task;
}

- (void) setEnvironments {
	environment = [[NSMutableDictionary alloc] init];
	
	[environment setObject:@"/bin:/usr/bin/:/usr/local/bin/:/opt/local/bin" forKey:@"PATH"];
	[environment setObject:[NSString stringWithCString:getenv("HOME") encoding:NSUTF8StringEncoding] forKey:@"HOME"];
}

- (BOOL) doesPathContainDOTGitFolder:(NSString *) path {
	NSString *gitdir = [path stringByAppendingPathComponent:@".git"];
	BOOL isdir;
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gitdir isDirectory:&isdir];
	
	if(!fileExists || !isdir) {
		return FALSE;
	}
	
	return TRUE;
}

- (BOOL) isPathGitRepository:(NSString *) path {
	
	if(![self doesPathContainDOTGitFolder:path]) {
		return FALSE;
	}
	
	NSTask *status = [self newGitBashTask];
	
	[status setCurrentDirectoryPath:path];
	[status setArguments:[NSArray arrayWithObjects:@"status",nil]];
	[status launch];
	[status waitUntilExit];
	
	int res = [status terminationStatus];
	
	[status release];
	
	if(res > 1) {
		return FALSE;
	}
	
	return TRUE;
}

- (BOOL) initRepositoryInPath:(NSString *) path {
	NSTask *initask = [self newGitBashTask];
	
	[initask setCurrentDirectoryPath:path];
	[initask setArguments:[NSArray arrayWithObjects:@"init",nil]];
	[initask launch];
	[initask waitUntilExit];
	
	int res = [initask terminationStatus];
	
	[initask release];
	
	if(res > 1) {
		return false;
	}
	
	return true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("dealloc GTGitCommandExecutor\n");
	#endif
	
	GDRelease(gitProjectPath);
	GDRelease(environment);
	
	[super dealloc];
}

@end

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

static NSMutableDictionary * environment;
static NSUserDefaults * defaults;
static NSFileManager * fileManager;
static GTModalController * modals;

@implementation GTGitCommandExecutor
@synthesize gitProjectPath, gitExecPath;

- (id) init {
	if(self = [super init]) {
		if(fileManager == nil) fileManager = [NSFileManager defaultManager];
		if(defaults == nil) defaults = [NSUserDefaults standardUserDefaults];
		if(modals == nil) modals = [GTModalController sharedInstance];
		if(gitExecPath == nil) gitExecPath = [defaults stringForKey:kGTGitExecutablePathKey];
		if(environment == nil) [self setEnvironments];
	}
	return self;
}

- (NSURL *) gitProjectPathAsNSURL {
	NSString * s = [@"file://" stringByAppendingString:[self gitProjectPath]];
	return [NSURL URLWithString:s];
}

- (BOOL) verifyRemoteURL:(NSString *) remote {
	BOOL passes = false;
	//if([remote isMatchedByRegex:@""]) passes=true;
	return passes;
}

- (void) verifyGitExecutable {
	NSUInteger res;
	NSOpenPanel * op;
	if([defaults stringForKey:kGTGitExecutablePathKey]) {
		gitExecPath = [defaults stringForKey:kGTGitExecutablePathKey];
		if(![fileManager fileExistsAtPath:gitExecPath] or gitExecPath is nil) {
			res = [modals runCantFindGitExecAlert];
			if(res == NSCancelButton) [[NSApplication sharedApplication] terminate:self];
			op = [NSOpenPanel openPanel];
			[op setCanChooseFiles:true];
			[op setTitle:@"Choose Your Git Executable"];
			[op setCanChooseDirectories:false];
			@try { //this line of code is trying an "undocumented" method - it's in a try catch just in case it's not available (it's been there since around 10.3).
				NSObject * obj = [[NSObject alloc] init];
				if([op respondsToSelector:@selector(setShowsHiddenFiles:)]) [op performSelector:@selector(setShowsHiddenFiles:) withObject:obj];
				[obj release];
			} @catch (NSException * e) {}
			res = [op runModal];
			if(res == NSCancelButton) [[NSApplication sharedApplication] terminate:self];
			gitExecPath = [op filename];
		}
		[defaults setObject:gitExecPath forKey:kGTGitExecutablePathKey];
		[defaults synchronize];
	} else {
		if([fileManager fileExistsAtPath:@"/opt/local/bin/git"]) gitExecPath = @"/opt/local/bin/git";
		if([fileManager fileExistsAtPath:@"/opt/bin/git"]) gitExecPath = @"/opt/bin/git";
		if([fileManager fileExistsAtPath:@"/usr/bin/git"]) gitExecPath = @"/usr/bin/git";
		if([fileManager fileExistsAtPath:@"/usr/local/bin/git"]) gitExecPath = @"/usr/local/bin/git";
		if([fileManager fileExistsAtPath:@"/usr/local/git/bin/git"]) gitExecPath = @"/usr/local/git/bin/git";
		if([fileManager fileExistsAtPath:@"/bin/git"]) gitExecPath = @"/bin/git";
		if(gitExecPath == nil) {
			res = [modals runCantFindGitExecAlert];
			if(res == NSCancelButton) [[NSApplication sharedApplication] terminate:self];
			op = [NSOpenPanel openPanel];
			[op setCanChooseFiles:true];
			[op setTitle:@"Choose Your Git Executable"];
			[op setCanChooseDirectories:false];
			@try { //this line of code is trying an "undocumented" method - it's in a try catch just in case it's not available (it's been there since around 10.3).
				NSObject * obj = [[NSObject alloc] init];
				if([op respondsToSelector:@selector(setShowsHiddenFiles:)]) [op performSelector:@selector(setShowsHiddenFiles:) withObject:obj];
				[obj release];
			} @catch (NSException * e) {}
			res = [op runModal];
			if(res == NSCancelButton) [[NSApplication sharedApplication] terminate:self];
			gitExecPath = [op filename];
		}
		[defaults setObject:gitExecPath forKey:kGTGitExecutablePathKey];
		[defaults synchronize];
	}
}

- (void) verifyGitBinaryVersion {
	NSMutableArray * args = [[NSMutableArray alloc] init];
	[args addObject:@"--version"];
	
	NSTask * task = [self newGitBashTask];
	[task setArguments:args];
	[task launch];
	[task waitUntilExit];
	
	NSFileHandle * fout = [[task standardOutput] fileHandleForReading];
	NSData * data = [fout readDataToEndOfFile];
	[fout closeFile];
	NSString * versionSTDOUT = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSArray * pieces = [versionSTDOUT componentsSeparatedByString:@" "];
	if([pieces count] < 2) goto	cleanup;
	
	NSString * versionString = [pieces lastObject];
	//NSLog(@"git version: %@",versionString);
	/*versionString = @"1.5.8-RC";
	versionString = @"1.";
	versionString = @"1.1";
	versionString = @"1.6";*/
	NSArray * versionPieces = [versionString componentsSeparatedByString:@"."];
	if([versionPieces count] < 2) goto cleanup;
	int gitMinor = [[versionPieces objectAtIndex:1] intValue];
	if(gitMinor > 5) goto cleanup;
	NSString * msg = @"Git Version Not Supported";
	NSString * desc = [NSString stringWithFormat:@"You have %@, but Gity requires a minimum of 1.6.",versionString];
	if(gitMinor < 6) desc = [NSString stringWithFormat:@"Your version of git (%@) is outdated; Gity requires at least 1.6. Please upgrade.",versionString];
	NSRunAlertPanel(msg,desc,@"OK",nil,nil);
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
	NSMutableArray * args = [[NSMutableArray alloc] init];
	[args addObject:@"rev-parse"];
	[args addObject:@"--git-dir"];
	NSTask * task = [self newGitBashTask];
	[task setCurrentDirectoryPath:proposedPath];
	[task setArguments:args];
	[args release];
	[task launch];
	[task waitUntilExit];
	if([task terminationStatus] == 128) {
		[task release];
		return nil;
	}
	NSFileHandle * fout = [[task standardOutput] fileHandleForReading];
	NSData * data = [fout readDataToEndOfFile];
	NSString * path = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
	NSTask * task = [[NSTask alloc] init];
	NSPipe * stdo = [NSPipe pipe];
	NSPipe * stde = [NSPipe pipe];
	[task setStandardOutput:stdo];
	[task setStandardError:stde];
	[task setEnvironment:environment];
	if(gitProjectPath) [task setCurrentDirectoryPath:gitProjectPath];
	[task setLaunchPath:gitExecPath];
	return task;
}

- (NSTask *) newPythonBinTask {
	NSTask * task = [[NSTask alloc] init];
	NSPipe * stdo = [NSPipe pipe];
	NSPipe * stde = [NSPipe pipe];
	[task setStandardOutput:stdo];
	[task setStandardError:stde];
	[task setEnvironment:environment];
	if(gitProjectPath) [task setCurrentDirectoryPath:gitProjectPath];
	[task setLaunchPath:@"/usr/bin/python"];
	return task;
}

- (void) setEnvironments {
	environment =  [[NSMutableDictionary alloc] init];
	[environment setObject:@"/bin:/usr/bin/:/usr/local/bin/:/opt/local/bin" forKey:@"PATH"];
	[environment setObject:[NSString stringWithCString:getenv("HOME") encoding:NSUTF8StringEncoding] forKey:@"HOME"];
}

- (BOOL) doesPathContainDOTGitFolder:(NSString *) path {
	NSString * gitdir = [path stringByAppendingPathComponent:@".git"];
	BOOL isdir;
	BOOL fileExists = [fileManager fileExistsAtPath:gitdir isDirectory:&isdir];
	if(!fileExists || !isdir) return FALSE;
	return TRUE;
}

- (BOOL) isPathGitRepository:(NSString *) path {
	if(![self doesPathContainDOTGitFolder:path]) return FALSE;
	NSTask * status = [self newGitBashTask];
	[status setCurrentDirectoryPath:path];
	[status setArguments:[NSArray arrayWithObjects:@"status",nil]];
	[status launch];
	[status waitUntilExit];
	int res = [status terminationStatus];
	[status release];
	if(res > 1) return FALSE;
	return TRUE;
}

- (BOOL) initRepositoryInPath:(NSString *) path {
	NSTask * initask = [self newGitBashTask];
	[initask setCurrentDirectoryPath:path];
	[initask setArguments:[NSArray arrayWithObjects:@"init",nil]];
	[initask launch];
	[initask waitUntilExit];
	int res = [initask terminationStatus];
	[initask release];
	if(res > 1) return false;
	return true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("dealloc GTGitCommandExecutor\n");
	#endif
	GDRelease(gitProjectPath);
	[super dealloc];
}

@end

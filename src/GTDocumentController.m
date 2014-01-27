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

#import "GTDocumentController.h"
#import "GittyDocument.h"
#import <GDKit/GDKit.h>

static NSString *gityVersion;

@implementation GTDocumentController

#pragma mark initializers

- (id) init {
	if(self = [super init]) {
		applicationHasStarted = NO;
		git = [[GTGitCommandExecutor alloc] init];
		operations = [[GTOperationsController alloc] init];
		cliproxy = [[GTCLIProxy alloc] init];
	}

	return self;
}

#pragma mark NSApplicationDelegate

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
	NSArray *documents = [self documents];
	for (GittyDocument *document in documents)
	{
		if ([document respondsToSelector:@selector(updateAfterFilesChanged:)])
			[document updateAfterFilesChanged:nil];
	}
}

#pragma mark version info
+ (NSString *) gityVersion {
	return gityVersion;
}

#pragma mark modal triggers
- (void) askForUpdates {
	NSNumber * isInDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"GTGityHasPromptedToCheckForUpdates"];
	if(isInDefaults == nil) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GTGityHasPromptedToCheckForUpdates"];
		NSInteger res = [[GTModalController sharedInstance] runShouldCheckForUpdates];
		if(res == NSOKButton) [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GTGityCheckForUpdates"];
	}
}

#pragma mark main menu actions.
- (IBAction) installTextmateBundle:(id) sender {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSString * path = [@"~/Library/Application Support/Textmate/Bundles/Gity.tmbundle" stringByExpandingTildeInPath];
	NSString * path2 = [@"~/Library/Application Support/Textmate/Bundles" stringByExpandingTildeInPath];
	NSString * bndl = [[NSBundle mainBundle] pathForResource:@"Gity.tmbundle" ofType:@""];
	[fm createDirectoryAtPath:path2 withIntermediateDirectories:true attributes:nil error:nil];
	[fm copyItemAtPath:bndl toPath:path error:nil];
	[[GTModalController sharedInstance] runInstalledTMBundle];
}

- (IBAction) changeGitBinary:(id) sender {
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:true];
	[op setTitle:@"Choose Your Git Executable"];
	[op setCanChooseDirectories:false];
	@try { //this line of code is trying an "undocumented" method - it's in a try catch just in case it's not available (it's been there since around 10.3).
		NSObject * obj = [[NSObject alloc] init];
		if([op respondsToSelector:@selector(setShowsHiddenFiles:)]) [op performSelector:@selector(setShowsHiddenFiles:) withObject:obj];
		[obj release];
	}@catch(NSException * e){}
	int res=[op runModal];
	if(res==NSCancelButton) return;
	[[NSUserDefaults standardUserDefaults] setObject:[[op URL] path] forKey:kGTGitExecutablePathKey];
	NSRunAlertPanel(@"Restart Gity",@"Please restart Gity for the changes to take effect.",@"OK",nil,nil);
}

- (void) updateGityVersion {
	NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
	NSString * bv = [dic objectForKey:@"CFBundleVersion"];
	NSString * bv2 = [@"." stringByAppendingString:bv];
	NSString * sbv = [dic objectForKey:@"CFBundleShortVersionString"];
	gityVersion = [[sbv stringByAppendingString:bv2] retain];
}

- (IBAction) launchGitBook:(id) sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://book.git-scm.com/"]];
}

- (IBAction) launchGitManPages:(id) sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.kernel.org/pub/software/scm/git/docs/"]];
}

- (void) openNSURLAndActivate:(NSString *) path {
	[[NSWorkspace sharedWorkspace] bringCurrentApplicationToFront];
	NSString * realGitPath = [git gitProjectPathFromRevParse:path];
	if(realGitPath == nil) {
		[[GTModalController sharedInstance] runNotAGitRepoAlert];
		return;
	}
	NSURL * nurl = [NSURL fileURLWithPath:realGitPath isDirectory:true];
	GittyDocument * doc;
	for(doc in [self documents]) {
		if([doc isThisDocumentForURL:nurl]) {
			[doc showWindows];
			return;
		}
	}
	[self openDocumentWithContentsOfURL:nurl display:true error:nil];
}

- (IBAction) installTerminalUsage:(id) sender {
	BOOL success = false;
	NSString * installationPath = @"/usr/local/bin/";
	NSString * installationName = @"gity";
	NSString * absPath = [installationPath stringByAppendingString:installationName];
	NSString * toolPath = [[NSBundle mainBundle] pathForResource:@"gity" ofType:@""];
	if(toolPath) {
		AuthorizationRef auth;
		if(AuthorizationCreate(NULL,kAuthorizationEmptyEnvironment,kAuthorizationFlagDefaults,&auth)==errAuthorizationSuccess) {
			usleep(15000);
			char const * mkdir_arg[] = {"-p",[installationPath UTF8String],NULL};
			char const * mkdir = "/bin/mkdir";
			AuthorizationExecuteWithPrivileges(auth,mkdir,kAuthorizationFlagDefaults,(char**)mkdir_arg,NULL);
			char const * helperTool = "/bin/ln";
			char const * arguments[] = {"-f","-s",[toolPath UTF8String],[absPath UTF8String],NULL};
			if(AuthorizationExecuteWithPrivileges(auth,helperTool,kAuthorizationFlagDefaults,(char**)arguments,NULL)==errAuthorizationSuccess) {
				int status;
				int pid = wait(&status);
				if(pid != -1 && WIFEXITED(status) && WEXITSTATUS(status) == 0) success = true;
				else errno = WEXITSTATUS(status);
			}
			AuthorizationFree(auth,kAuthorizationFlagDefaults);
		}
	}
	if(success) {
		[[NSAlert alertWithMessageText:@"Success!" defaultButton:nil alternateButton:nil otherButton:nil
		informativeTextWithFormat:@"A bin was installed at %@",absPath] runModal];
	} else {
		[[NSAlert alertWithMessageText:@"Installation Failed" defaultButton:nil alternateButton:nil otherButton:nil
		informativeTextWithFormat:@"Installation at %@ failed",absPath] runModal];
	}
}

- (IBAction) resetPrompts:(id) sender {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GTGityHasPromptedToCheckForUpdates"];
	[[NSUserDefaults standardUserDefaults] setBool:false forKey:kGTIgnoreCommitsAhead];
	[[NSUserDefaults standardUserDefaults] setBool:false forKey:@"kGTRemindToQuitFileMerge"];
	[[NSUserDefaults standardUserDefaults] setBool:false forKey:kGTWarnAboutLooseObjects];
	[[NSUserDefaults standardUserDefaults] setBool:false forKey:@"kGTPromptForCherryPick"];
}

- (void) updateMuteStatus {
	BOOL muted = [[NSUserDefaults standardUserDefaults] boolForKey:@"GTMutePopSounds"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * mutedItem = [gitty itemWithTag:4];
	[mutedItem setState:muted];
}

- (IBAction) mutePopSounds:(id) sender {
	NSMenuItem * item = (NSMenuItem *) sender;
	[item setState:![item state]];
	[[NSUserDefaults standardUserDefaults] setBool:[item state] forKey:@"GTMutePopSounds"];
}

- (IBAction) toggleStartupItem:(id) sender {
	BOOL startup = [[NSUserDefaults standardUserDefaults] boolForKey:@"GTRunAtStartup"];
	if(!startup) [[NSWorkspace sharedWorkspace] installStartupLaunchdItem:@"com.macendeavor.Gity.Agent.plist"];
	else [[NSWorkspace sharedWorkspace] uninstallStartupLaunchdItem:@"com.macendeavor.Gity.Agent.plist"];
	[[NSUserDefaults standardUserDefaults] setBool:!startup forKey:@"GTRunAtStartup"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * launchOnStartup = [gitty itemWithTag:3];
	[launchOnStartup setState:!startup];
}

- (IBAction) toggleCheckForUpdates:(id) sender {
	NSMenuItem * item = (NSMenuItem *)sender;
	[item setState:![item state]];
	[[NSUserDefaults standardUserDefaults] setBool:[item state] forKey:@"GTGityCheckForUpdates"];
	[sparkle setAutomaticallyChecksForUpdates:[item state]];
}

- (void) updateLaunchAtStartup {
	BOOL startup = [[NSUserDefaults standardUserDefaults] boolForKey:@"GTRunAtStartup"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * launchOnStartup = [gitty itemWithTag:3];
	[launchOnStartup setState:startup];
}

- (void) updateCheckForUpdates {
	NSMenu * mm = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gm = [[mm itemWithTag:0] submenu];
	NSMenuItem * sparkleItem = [gm itemWithTag:2];
	BOOL sparkleState = [[NSUserDefaults standardUserDefaults] boolForKey:@"GTGityCheckForUpdates"];
	[sparkleItem setState:sparkleState];
	if(sparkleState)[sparkle checkForUpdatesInBackground];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *) sender {
	GittyDocument * gd = [self currentDocument];
	NSArray *documents = [self documents];
	
	if (documents)
	{
		NSMutableArray *openDocuments = [[NSMutableArray alloc] init];
		for (GittyDocument *document in documents)
			[openDocuments addObject:[[document fileURL] absoluteString]];
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:openDocuments] forKey:@"GTPreviousDocuments"];
		[openDocuments release];
	}

	if ([[NSUserDefaults standardUserDefaults] boolForKey:kGTIgnoreCommitsAhead]) 
		return NSTerminateNow;
	
	if (gd)
	{
		NSInteger res = [gd shouldQuitNow];
		if(res == NSCancelButton) return NSTerminateCancel;
	}
	
	return NSTerminateNow;
}

- (void) applicationDidFinishLaunching:(NSNotification *) notification {
	if([GTSysHelper gestaltMinorVersion] < 6) {
		NSRunAlertPanel(NSLocalizedStringFromTable(@"Gity Requires Mac OS X 10.6",@"Localized",@"snow leopard msg"),
						NSLocalizedStringFromTable(@"Gity Uses New API's in Snow Leopard, sorry :(.",@"Localized",@"snow leopard msg description"),
						NSLocalizedStringFromTable(@"OK",@"Localized",@"yes button label"),
						nil,nil);
		[[NSApplication sharedApplication] terminate:nil];
	}
	[self askForUpdates];
	[git verifyGitExecutable];
	[git verifyGitBinaryVersion];
	[self updateLaunchAtStartup];
	[self updateCheckForUpdates];
	[self updateMuteStatus];
	[self updateGityVersion];
	[cliproxy setDocument:self];
	[cliproxy connect];
	
	// reload last document at startup.
	NSArray *documents = [[NSUserDefaults standardUserDefaults] objectForKey:@"GTPreviousDocuments"];
	for (NSString *url in documents)
	{
		NSError *error = nil;
		[self openDocumentWithContentsOfURL:[NSURL URLWithString:url] display:YES error:&error];
	}	
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *) sender {
	return false;
}

- (void) openDocument:(id)sender {
	NSOpenPanel * op = [[NSOpenPanel alloc] init];
	[op setCanChooseFiles:false];
	[op setCanChooseDirectories:true];
    [op setResolvesAliases:YES];
	[op setTitle:@"Open A Git Repository"];
	NSInteger res = [op runModal];
	if(res is  NSCancelButton) return;
	NSString * path = [[op URL] path];
	NSString * realGitPath = [git gitProjectPathFromRevParse:path];
	if(realGitPath is nil) {
		[[GTModalController sharedInstance] runNotAGitRepoAlert];
		return;
	}
	NSURL * purl = [NSURL fileURLWithPath:realGitPath];
	[self openDocumentWithContentsOfURL:purl display:true error:nil];
}

- (IBAction) initNewRepo:(id) sender {
	NSOpenPanel * op = [[NSOpenPanel alloc] init];
	[op setCanChooseDirectories:true];
	[op setCanChooseFiles:false];
	[op setCanCreateDirectories:true];
	[op setTitle:NSLocalizedStringFromTable(@"Initialize Directory As A Git Repository",@"Localized",@"initialize a repo open panel title")];
	NSInteger res = [op runModal];
	if(res is NSCancelButton) return;
	NSString * path = [[op URL] path];
	if([git isPathGitRepository:path]) {
		[[GTModalController sharedInstance] runAlreadyAGitRepoAlert];
		return;
	}
	if(![git initRepositoryInPath:path]) {
		NSRunAlertPanel(NSLocalizedStringFromTable(@"Error Initializing",@"Localized",@"init error"),
							NSLocalizedStringFromTable(@"An unknown error occurred while initializing the repo",@"Localized",@"init error description"),
							NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
							nil,nil);
		return;
	}
	NSURL * purl = [NSURL fileURLWithPath:path];
	[self openDocumentWithContentsOfURL:purl display:true error:nil];
}

- (IBAction) cloneRepo:(id) sender {
	[[GTModalController sharedInstance] cloneRepo];
}

- (NSString *) typeForContentsOfURL:(NSURL *) inAbsoluteURL error:(NSError **) outError {
	return @"DocumentType";
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDocumentController\n");
	#endif
	
	GDRelease(cliproxy);
	GDRelease(operations);
	GDRelease(git);
	GDRelease(gityVersion);

	sparkle = nil;
	
	[super dealloc];
}

@end

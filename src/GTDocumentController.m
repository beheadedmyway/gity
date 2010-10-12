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

static GTModalController * modals;
static NSUserDefaults * defaults;
static NSString * gityVersion;

@implementation GTDocumentController
@synthesize registration;

#pragma mark initializers
+ (void) initialize {
	modals=[GTModalController sharedInstance];
}

- (id) init {
	if(self=[super init]) {
		git=[[GTGitCommandExecutor alloc] init];
		operations=[[GTOperationsController alloc] init];
		cliproxy=[[GTCLIProxy alloc] init];
		registration=[[GTRegistrationController alloc] init];
		[GTPythonScripts initMainBundle];
		if(defaults is nil) defaults=[NSUserDefaults standardUserDefaults];
		if(modals is nil) modals=[GTModalController sharedInstance];
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

#pragma mark window helpers
- (void) persistWindowStates {
	GittyDocument * gd;
	NSArray * docs = [self documents];
	for(gd in docs) [gd persistWindowState];
}

#pragma mark modal triggers
- (void) askForUpdates {
	NSString * isInDefaults = [defaults objectForKey:@"GTGityHasPromptedToCheckForUpdates"];
	if(isInDefaults == nil) {
		[defaults setObject:@"1" forKey:@"GTGityHasPromptedToCheckForUpdates"];
		NSInteger res = [modals runShouldCheckForUpdates];
		if(res == NSOKButton) [defaults setBool:true forKey:@"GTGityCheckForUpdates"];
		[defaults synchronize];
	}
}

#pragma mark main menu actions.
- (void) installTextmateBundle:(id) sender {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSString * path = [@"~/Library/Application Support/Textmate/Bundles/Gity.tmbundle" stringByExpandingTildeInPath];
	NSString * path2 = [@"~/Library/Application Support/Textmate/Bundles" stringByExpandingTildeInPath];
	NSString * bndl = [[NSBundle mainBundle] pathForResource:@"Gity.tmbundle" ofType:@""];
	[fm createDirectoryAtPath:path2 withIntermediateDirectories:true attributes:nil error:nil];
	[fm copyItemAtPath:bndl toPath:path error:nil];
	[modals runInstalledTMBundle];
}

- (void) showRegistration:(id) sender {
	[registration show];
}

- (void) changeGitBinary:(id) sender {
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
	[defaults setObject:[op filename] forKey:kGTGitExecutablePathKey];
	[defaults synchronize];
	NSRunAlertPanel(@"Restart Gity",@"Please restart Gity for the changes to take effect.",@"OK",nil,nil);
}

- (void) updateGityVersion {
	NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
	NSString * bv = [dic objectForKey:@"CFBundleVersion"];
	NSString * bv2 = [@"." stringByAppendingString:bv];
	NSString * sbv = [dic objectForKey:@"CFBundleShortVersionString"];
	gityVersion = [[sbv stringByAppendingString:bv2] retain];
}

- (void) launchGitBook:(id) sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://book.git-scm.com/"]];
}

- (void) launchGitManPages:(id) sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.kernel.org/pub/software/scm/git/docs/"]];
}

- (void) openNSURLAndActivate:(NSString *) path {
	[[NSWorkspace sharedWorkspace] bringCurrentApplicationToFront];
	NSString * realGitPath = [git gitProjectPathFromRevParse:path];
	if(realGitPath == nil) {
		[modals runNotAGitRepoAlert];
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

- (void) installTerminalUsage:(id) sender {
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

- (void) resetPrompts:(id) sender {
	[defaults removeObjectForKey:@"GTGityHasPromptedToCheckForUpdates"];
	[defaults setBool:false forKey:kGTIgnoreCommitsAhead];
	[defaults setBool:false forKey:@"kGTRemindToQuitFileMerge"];
	[defaults setBool:false forKey:kGTWarnAboutLooseObjects];
	[defaults setBool:false forKey:@"kGTPromptForCherryPick"];
	[defaults synchronize];
}

- (void) updateMuteStatus {
	BOOL muted = [defaults boolForKey:@"GTMutePopSounds"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * mutedItem = [gitty itemWithTag:4];
	[mutedItem setState:muted];
}

- (void) mutePopSounds:(id) sender {
	NSMenuItem * item = (NSMenuItem *) sender;
	[item setState:![item state]];
	[defaults setBool:[item state] forKey:@"GTMutePopSounds"];
	[defaults synchronize];
}

- (void) toggleStartupItem:(id) sender {
	BOOL startup = [defaults boolForKey:@"GTRunAtStartup"];
	if(!startup) [[NSWorkspace sharedWorkspace] installStartupLaunchdItem:@"com.macendeavor.Gity.Agent.plist"];
	else [[NSWorkspace sharedWorkspace] uninstallStartupLaunchdItem:@"com.macendeavor.Gity.Agent.plist"];
	[defaults setBool:!startup forKey:@"GTRunAtStartup"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * launchOnStartup = [gitty itemWithTag:3];
	[launchOnStartup setState:!startup];
}

- (void) toggleCheckForUpdates:(id) sender {
	NSMenuItem * item = (NSMenuItem *)sender;
	[item setState:![item state]];
	[defaults setBool:[item state] forKey:@"GTGityCheckForUpdates"];
	[sparkle setAutomaticallyChecksForUpdates:[item state]];
}

- (void) updateLaunchAtStartup {
	BOOL startup = [defaults boolForKey:@"GTRunAtStartup"];
	NSMenu * mainMenu = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gitty = [[mainMenu itemWithTag:0] submenu];
	NSMenuItem * launchOnStartup = [gitty itemWithTag:3];
	[launchOnStartup setState:startup];
}

- (void) updateCheckForUpdates {
	NSMenu * mm = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gm = [[mm itemWithTag:0] submenu];
	NSMenuItem * sparkleItem = [gm itemWithTag:2];
	BOOL sparkleState = [defaults boolForKey:@"GTGityCheckForUpdates"];
	[sparkleItem setState:sparkleState];
	if(sparkleState)[sparkle checkForUpdatesInBackground];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *) sender {
	GittyDocument * gd = [self currentDocument];
	if([defaults boolForKey:kGTIgnoreCommitsAhead]) return NSTerminateNow;
	if(gd) {
		NSInteger res = [gd shouldQuitNow];
		if(res == NSCancelButton) return NSTerminateCancel;
	}
	[self persistWindowStates];
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
	[registration checkLicenseInUserDefaults];
	[self askForUpdates];
	[git verifyGitExecutable];
	[git verifyGitBinaryVersion];
	[self updateLaunchAtStartup];
	[self updateCheckForUpdates];
	[self updateMuteStatus];
	[self updateGityVersion];
	[cliproxy setDocument:self];
	[cliproxy connect];
}

- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *) sender {
	return false;
}

- (void) openDocument:(id)sender {
	NSOpenPanel * op = [[NSOpenPanel alloc] init];
	[op setCanChooseFiles:false];
	[op setCanChooseDirectories:true];
	[op setTitle:@"Open A Git Repository"];
	NSInteger res = [op runModal];
	if(res is  NSCancelButton) return;
	NSString * path = [op filename];
	NSString * realGitPath = [git gitProjectPathFromRevParse:path];
	if(realGitPath is nil) {
		[modals runNotAGitRepoAlert];
		goto cleanup;
	}
	NSURL * purl = [NSURL fileURLWithPath:realGitPath];
	[self openDocumentWithContentsOfURL:purl display:true error:nil];
cleanup:
	[op release];
}

- (IBAction) initNewRepo:(id) sender {
	NSOpenPanel * op = [[NSOpenPanel alloc] init];
	[op setCanChooseDirectories:true];
	[op setCanChooseFiles:false];
	[op setCanCreateDirectories:true];
	[op setTitle:NSLocalizedStringFromTable(@"Initialize Directory As A Git Repository",@"Localized",@"initialize a repo open panel title")];
	NSInteger res = [op runModal];
	if(res is NSCancelButton) return;
	NSString * path = [op filename];
	if([git isPathGitRepository:path]) {
		[modals runAlreadyAGitRepoAlert];
		goto cleanup;
	}
	if(![git initRepositoryInPath:path]) {
		NSRunAlertPanel(NSLocalizedStringFromTable(@"Error Initializing",@"Localized",@"init error"),
							NSLocalizedStringFromTable(@"An unknown error occurred while initializing the repo",@"Localized",@"init error description"),
							NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
							nil,nil);
		goto cleanup;
	}
	NSURL * purl = [NSURL fileURLWithPath:path];
	[self openDocumentWithContentsOfURL:purl display:true error:nil];
cleanup:
	[op release];
}

- (IBAction) cloneRepo:(id) sender {
	[modals cloneRepo];
}

- (NSString *) typeForContentsOfURL:(NSURL *) inAbsoluteURL error:(NSError **) outError {
	return @"DocumentType";
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDocumentController\n");
	#endif
	GDRelease(registration);
	GDRelease(cliproxy);
	GDRelease(operations);
	GDRelease(git);
	GDRelease(gityVersion);
	modals=nil;
	sparkle=nil;
	defaults=nil;
	[super dealloc];
}

@end

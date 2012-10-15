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
#import <Sparkle/Sparkle.h>
#import <GDKit/GDKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <GDKit/GDKit.h>
#import "defs.h"
#import "GTModalController.h"
#import "GTGitCommandExecutor.h"
#import "GittyDocument.h"
#import "GTSysHelper.h"
#import "GTPythonScripts.h"
#import "GTCLIProxy.h"

@interface GTDocumentController : NSDocumentController <NSApplicationDelegate> {
	IBOutlet SUUpdater * sparkle;
	GTGitCommandExecutor * git;
	GTOperationsController * operations;
	GTCLIProxy * cliproxy;
	BOOL applicationHasStarted;
}

+ (NSString *) gityVersion;
- (IBAction) installTextmateBundle:(id) sender;
- (IBAction) changeGitBinary:(id) sender;
- (IBAction) launchGitBook:(id) sender;
- (IBAction) launchGitManPages:(id) sender;
- (void) openNSURLAndActivate:(NSString *) path;
- (IBAction) openDocument:(id) sender;
- (IBAction) toggleStartupItem:(id) sender;
- (IBAction) toggleCheckForUpdates:(id) sender;
- (void) updateCheckForUpdates;
- (void) updateLaunchAtStartup;
- (IBAction) resetPrompts:(id) sender;
- (IBAction) mutePopSounds:(id) sender;
- (void) updateMuteStatus;
- (IBAction) installTerminalUsage:(id) sender;
- (void) updateGityVersion;
- (IBAction) cloneRepo:(id) sender;
- (IBAction) initNewRepo:(id) sender;

@end

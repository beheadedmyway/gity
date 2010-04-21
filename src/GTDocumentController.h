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
#import "GTRegistrationController.h"

@interface GTDocumentController : NSDocumentController {
	IBOutlet SUUpdater * sparkle;
	GTGitCommandExecutor * git;
	GTOperationsController * operations;
	GTCLIProxy * cliproxy;
	GTRegistrationController * registration;
}

@property (readonly,nonatomic) GTRegistrationController * registration;

+ (NSString *) gityVersion;
- (void) persistWindowStates;
- (void) installTextmateBundle:(id) sender;
- (void) changeGitBinary:(id) sender;
- (void) showRegistration:(id) sender;
- (void) launchGitBook:(id) sender;
- (void) launchGitManPages:(id) sender;
- (void) openNSURLAndActivate:(NSString *) path;
- (void) openDocument:(id) sender;
- (void) toggleStartupItem:(id) sender;
- (void) toggleCheckForUpdates:(id) sender;
- (void) updateCheckForUpdates;
- (void) updateLaunchAtStartup;
- (void) resetPrompts:(id) sender;
- (void) mutePopSounds:(id) sender;
- (void) updateMuteStatus;
- (void) installTerminalUsage:(id) sender;
- (void) updateGityVersion;
- (IBAction) cloneRepo:(id) sender;
- (IBAction) initNewRepo:(id) sender;

@end

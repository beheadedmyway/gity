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
#import "GTScale9Control.h"
#import "GTWindow.h"
#import "GTStyles.h"
#import "GTBaseObject.h"
#import "GTOpCloneRepo.h"
#import "GTSpecialTextField.h"
#import "GTBaseExternalNibController.h"

@interface GTCloneRepoController : GTBaseExternalNibController <NSTextFieldDelegate> {
	BOOL errored;
	BOOL isCloning;
	NSString * destinationPath;
	NSString * openPath;
	IBOutlet NSTextField * destination;
	IBOutlet NSTextField * label;
	IBOutlet NSWindow * statusWindow;
	IBOutlet NSTextField * statusLabel;
	IBOutlet NSProgressIndicator * statusProgress;
	IBOutlet NSButton * helpButton;	
	IBOutlet GTSpecialTextField * repoURL;
	IBOutlet GTWindow * cloneRepoWindow;
	GTOpCloneRepo * cloneRepo;
	GTScale9Control * chooseDestination;
}

- (void) onCloneError:(NSInteger) code withOutput:(NSString *) message;
- (void) initButtons;
- (void) show;
- (void) reset;
- (void) cancel:(id) sender;
- (void) clone:(id) sender;
- (void) choosedir:(id) sender;
- (void) startCloning;
- (void) cloneComplete;

@end

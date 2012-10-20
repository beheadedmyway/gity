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
#import "GTBaseObject.h"
#import "GTWindow.h"
#import "GTScale9Control.h"

@class GTOperationsController;
@class GTGitDataStore;
@class GTModalController;
@class GTGitCommandExecutor;

@interface GTBaseExternalNibController : NSResponder <NSWindowDelegate> {
	id target;
	SEL action;
	BOOL available;
	BOOL working;
	IBOutlet GTWindow * window;
	GittyDocument * gd;
	GTScale9Control * ok;
	GTScale9Control * cancel;
	GTOperationsController * operations;
	GTGitDataStore * gitd;
	GTModalController * modals;
	GTGitCommandExecutor * git;
}

@property (assign,nonatomic) GittyDocument * gd;
@property (readonly, nonatomic) GTWindow *window;

- (void) awakeFromNib;
- (IBAction) cancel:(id) sender;
- (void) dealloc;
- (void) disposeNibs;
- (void) initButtons;
- (void) lazyInitWithGD:(GittyDocument *) _gd;
- (void) loadNibs;
- (IBAction) onok:(id) sender;
- (void) reset;
- (void) setRefs;
- (void) show;
- (void) showAsSheet;
- (void) showAsSheetWithCallback:(id) _target action:(SEL) _action;
- (void) sheetEnded;
- (id) initWithGD:(GittyDocument *) _gd;
- (NSPoint) getTL;
- (NSPoint) getTR;

@end

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
#import "defs.h"
#import "GTBaseObject.h"
#import "GTScaledButtonControl.h"

@class GTDocumentController;
@class GittyDocument;

typedef enum {
	kGTStatus = 1,
	kGTStatusWithLabel = 2,
	kGTStartupStatus = 3
} GTActiveStatus;

@interface GTStatusController : GTBaseObject {
	BOOL shown;
	NSMutableArray * spinnerStack;
	IBOutlet NSWindow * initialLoadWindow;
	IBOutlet NSProgressIndicator * initialLoadIndicator;
	IBOutlet NSWindow * workingWindow;
	IBOutlet NSProgressIndicator * workingProgress;
	IBOutlet NSWindow * workingLabeledWindow;
	IBOutlet NSProgressIndicator * workingLabeledProgress;
	IBOutlet NSProgressIndicator * spinner;
	IBOutlet NSTextField * workingLabel;
	GTActiveStatus activeStatus;
	GTScaledButtonControl * indicatorCancel;
}

@property (readonly,nonatomic) IBOutlet NSWindow * workingWindow;
@property (readonly,nonatomic) IBOutlet NSProgressIndicator * workingProgress;
@property (readonly,nonatomic) IBOutlet NSWindow * workingLabeledWindow;
@property (readonly,nonatomic) IBOutlet NSProgressIndicator * workingLabeledProgress;

- (void) hide;
- (BOOL) isShowingSheet;
- (void) showSpinner;
- (void) showSpinnerWithToolTip:(NSString *) tooltip;
- (void) hideSpinner;
- (void) sheetDidEnd:(id) sender;
- (void) showStatusIndicator;
- (void) showStartupIndicator;
- (void) showStatusIndicatorWithLabel:(NSString *) label;
- (void) showNonCancelableStatusIndicatorWithLabel:(NSString *) label;
- (void) updateWorkingLabel:(NSString *) label;
- (void) initCancelButton;
- (void) onCancel;

@end

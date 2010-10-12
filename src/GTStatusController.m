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

#import "GTStatusController.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

static NSApplication * app;

@implementation GTStatusController
@synthesize workingProgress;
@synthesize workingWindow;
@synthesize workingLabeledWindow;
@synthesize workingLabeledProgress;

- (void) awakeFromNib {
	spinnerStack=[[NSMutableArray alloc] init];
	[spinner setUsesThreadedAnimation:true];
	[spinner retain]; //retain here because I'm adding and removing it.
	[workingLabeledProgress setUsesThreadedAnimation:true];
	[workingProgress setUsesThreadedAnimation:true];
	[initialLoadIndicator setUsesThreadedAnimation:true];
	[self initCancelButton];
	[super awakeFromNib];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	if(app is nil) app=[NSApplication sharedApplication];
}

- (void) initCancelButton {
	indicatorCancel=[[GTScaledButtonControl alloc] initWithFrame:NSMakeRect(172,24,11,11)];
	[indicatorCancel setIcon:[NSImage imageNamed:@"cancelNormal.png"]];
	[indicatorCancel setIconOver:[NSImage imageNamed:@"cancelOver.png"]];
	[[workingLabeledWindow contentView] addSubview:indicatorCancel];
	[indicatorCancel setAction:@selector(onCancel)];
	[indicatorCancel setTarget:self];
}

- (void) onCancel {
	[operations cancelNetworkOperations];
	[self hide];
}

- (void) showStatusIndicator {
	if(shown) return;
	shown = true;
	activeStatus = kGTStatus;
	[workingProgress startAnimation:nil];
	[NSApplication detachDrawingThread:@selector(startAnimation:) toTarget:workingProgress withObject:nil];
	if ([gtwindow isMainWindow])
		[app beginSheet:workingWindow modalForWindow:gtwindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:) contextInfo:nil];
	// this is really annoying.  lets nix it.
	//[workingWindow makeKeyAndOrderFront:nil];
}

- (void) showStartupIndicator {
	if(shown) return;
	shown=true;
	activeStatus=kGTStartupStatus;
	[workingProgress startAnimation:nil];
	[NSApplication detachDrawingThread:@selector(startAnimation:) toTarget:initialLoadIndicator withObject:nil];
	[app beginSheet:initialLoadWindow modalForWindow:gtwindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:) contextInfo:nil];
}

- (void) showStatusIndicatorWithLabel:(NSString *) label {
	if(shown) return;
	if([indicatorCancel superview] is nil) [[workingLabeledWindow contentView] addSubview:indicatorCancel];
	shown = true;
	[self updateWorkingLabel:label];
	activeStatus = kGTStatusWithLabel;
	[workingLabeledProgress startAnimation:nil];
	[app beginSheet:workingLabeledWindow modalForWindow:gtwindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:) contextInfo:nil];
}

- (void) showNonCancelableStatusIndicatorWithLabel:(NSString *) label {
	if(shown) return;
	if([indicatorCancel superview]) [indicatorCancel removeFromSuperview];
	shown = true;
	[self updateWorkingLabel:label];
	activeStatus = kGTStatusWithLabel;
	[workingLabeledProgress startAnimation:nil];
	[app beginSheet:workingLabeledWindow modalForWindow:gtwindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:) contextInfo:nil];
}

- (void) showSpinner {
	[spinnerStack addObject:@""];
	[spinner setToolTip:@""];
	[spinner startAnimation:nil];
	[spinner setFrame:NSMakeRect([gtwindow frame].size.width-46,[gtwindow frame].size.height-16,10,10)];
	[[[gtwindow contentView] superview] addSubview:spinner];
}

- (void) showSpinnerWithToolTip:(NSString *) tooltip {
	[spinnerStack addObject:@""];
	[spinner setToolTip:tooltip];
	[spinner startAnimation:nil];
	[spinner setFrame:NSMakeRect([gtwindow frame].size.width-46,[gtwindow frame].size.height-16,10,10)];
	[[[gtwindow contentView] superview] addSubview:spinner];
}

- (void) hideSpinner {
	if ([NSThread isMainThread])
	{
		if(spinnerStack) {
			if([spinnerStack count] > 0) [spinnerStack removeLastObject];
			if([spinnerStack count] > 0) return;
		}
		[spinner removeFromSuperview];
		[spinner stopAnimation:nil];		
	} else {
		[self performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:YES];
	}

}

- (void) hide {
	[self performSelectorOnMainThread:@selector(sheetDidEnd:) withObject:nil waitUntilDone:NO];
}

- (void) updateWorkingLabel:(NSString *) label {
	[workingLabel setStringValue:label];
}

- (BOOL) isShowingSheet {
	return shown;
}

- (void) sheetDidEnd:(id) sender {
	if(!shown) return;
	shown=false;
	if(activeStatus is kGTStatus) {
		[app endSheet:workingWindow];
		[workingWindow orderOut:nil];
		[workingProgress stopAnimation:nil];
	}
	if(activeStatus is kGTStatusWithLabel) {
		[app endSheet:workingLabeledWindow];
		[workingLabeledWindow orderOut:nil];
		[workingLabeledProgress stopAnimation:nil];
	}
	if(activeStatus is kGTStartupStatus) {
		[app endSheet:initialLoadWindow];
		[initialLoadWindow orderOut:nil];
		[initialLoadIndicator stopAnimation:nil];
	}
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTStatusController\n");
	#endif
	if([indicatorCancel superview]) [indicatorCancel removeFromSuperview];
	GDRelease(spinnerStack);
	GDRelease(indicatorCancel);
	GDRelease(spinner);
	activeStatus=0;
	shown=false;
	[super dealloc];
}

@end

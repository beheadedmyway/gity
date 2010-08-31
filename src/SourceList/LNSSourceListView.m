#import "LNSSourceListView.h"
#import "LNSSourceListCell.h"
#import "GittyDocument.h"

@implementation LNSSourceListView
@synthesize appearance;
@synthesize gd;

- (void) setAppearance:(AppearanceKind) newAppearance {
	if(appearance!=newAppearance) {
		appearance = newAppearance;
		[self setNeedsDisplay:YES];
	}
}

- (void) mouseDown:(NSEvent *)theEvent {
	NSPoint event_location = [theEvent locationInWindow];
	NSPoint local_point = [self convertPoint:event_location fromView:nil];
	NSInteger row = [self rowAtPoint:local_point];
	GTSourceListItem * item = [self itemAtRow:row];
	if([item isChildOfBranches] && [[item name] isEqual:[[gd gitd] activeBranchName]]) {
		[gd showActiveBranch:nil];
	}
	[super mouseDown:theEvent];
}

- (void) highlightSelectionInClipRect:(NSRect) clipRect {
	NSRange rows;
	long maxRow;
	unsigned long row;
	switch (appearance) {
		default:
		case kSourceList_NumbersAppearance: {
			rows = [self rowsInRect:clipRect];
			maxRow = NSMaxRange(rows);
			long unsigned lastSelectedRow = NSNotFound;
			NSColor * highlightColor = nil;
			NSColor * highlightFrameColor = nil;
			if([[self window] firstResponder] == self &&  [[self window] isMainWindow] && [[self window] isKeyWindow]) {
				highlightColor = [NSColor colorWithCalibratedRed:98.0 / 256.0 green:120.0 / 256.0 blue:156.0 / 256.0 alpha:1.0];
				highlightFrameColor = [NSColor colorWithCalibratedRed:83.0 / 256.0 green:103.0 / 256.0 blue:139.0 / 256.0 alpha:1.0];
			} else {
				highlightColor = [NSColor colorWithCalibratedRed:160.0 / 256.0 green:160.0 / 256.0 blue:160.0 / 256.0 alpha:1.0];
				highlightFrameColor = [NSColor colorWithCalibratedRed:150.0 / 256.0 green:150.0 / 256.0 blue:150.0 / 256.0 alpha:1.0];
			}
			for(row=rows.location; row<maxRow;++row) {
				if(lastSelectedRow != NSNotFound && row != lastSelectedRow + 1) {
					NSRect selectRect = [self rectOfRow:lastSelectedRow];
					[highlightFrameColor set];
					selectRect.origin.y += NSHeight(selectRect) - 1.0;
					selectRect.size.height = 1.0;
					NSRectFill(selectRect);
					lastSelectedRow = NSNotFound;
				}
				if([self isRowSelected:row]) {
					NSRect selectRect = [self rectOfRow:row];
					if(NSIntersectsRect(selectRect, clipRect)) {
						[highlightColor set];
						NSRectFill(selectRect);
						if(row != lastSelectedRow + 1) {
							selectRect.size.height = 1.0;
							[highlightFrameColor set];
							NSRectFill(selectRect);
						}
					}
					lastSelectedRow = row;
				}
			}
			if(lastSelectedRow != NSNotFound) {
				NSRect selectRect = [self rectOfRow:lastSelectedRow];
				[highlightFrameColor set];
				selectRect.origin.y += NSHeight(selectRect) - 1.0;
				selectRect.size.height = 1.0;
				NSRectFill(selectRect);
			}
			break;
		}
	}
}

@end

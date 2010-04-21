
#import "LNSSourceListCell.h"
#import "LNSSourceListView.h"
#import "GittyDocument.h"

@implementation LNSSourceListCell
@synthesize objectValue;

- (id) copyWithZone:(NSZone*) zone {
	LNSSourceListCell * newCell = [super copyWithZone:zone];
	[newCell->objectValue retain];
	[newCell clearFirstRect];
	return newCell;
}

- (void) clearFirstRect {
	firstRect = NSMakeRect(0,0,0,0);
}

- (void) setObjectValue:(id) value {
	[super setObjectValue:value];
	if(objectValue != value) {
		[objectValue release];
		objectValue = [value retain];
		if([objectValue isKindOfClass:[GTSourceListItem class]]) {
			[self setStringValue:[objectValue name]];
		}
		else [super setObjectValue:value];
	}
}

- (NSColor*) highlightColorWithFrame:(NSRect) cellFrame inView:(NSView*) controlView {
	//the table view does the highlighting.  Returning nil seems to stop the cell from
	//attempting th highlight the row.
	return nil;
}

- (void) drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	NSParameterAssert([controlView isKindOfClass:[LNSSourceListView class]]);
	//NSLog(@"cellFrame: x:%g, y:%g, w:%g, h:%g",cellFrame.origin.x,cellFrame.origin.y,cellFrame.size.width,cellFrame.size.height);
	
	NSString * title = [self stringValue];
	NSFontManager * fontManager = [NSFontManager sharedFontManager];
	NSMutableDictionary * attrs = [NSMutableDictionary dictionaryWithDictionary:[[self attributedStringValue] attributesAtIndex:0 effectiveRange:NULL]];
	NSFont * font = [attrs objectForKey:NSFontAttributeName];
	
	LNSSourceListView * slv = (LNSSourceListView*) controlView;
	NSScrollView * scv = (NSScrollView *) [slv superview];
	
	NSRect slvf = [slv frame];
	NSRect scvf = [scv frame];
	
	BOOL isScrollbarShown = false;
	if(slvf.size.height > scvf.size.height) isScrollbarShown=true;
	
	NSInteger row = [slv rowAtPoint:cellFrame.origin];
	NSWindow * window = [controlView window];
	GTSourceListItem * item = (GTSourceListItem *) [slv itemAtRow:row];
	NSString * itemName = [item name];
	BOOL highlighted = [self isHighlighted];
	BOOL isActiveBranch = [[[[slv gd] gitd] activeBranchName] isEqual:itemName];
	
	NSSize titleSize = [title sizeWithAttributes:attrs];
	NSRect inset = cellFrame;
	inset.origin.x = [item xdepth] * 28;
	if([item xdepth] > 1) inset.origin.x -= 16;
	inset.size.height = titleSize.height;
	inset.origin.y = NSMinY(cellFrame) + (NSHeight(cellFrame) - titleSize.height) / 2.0;
	
	if(highlighted) [attrs setValue:[fontManager convertFont:font toHaveTrait:NSBoldFontMask] forKey:NSFontAttributeName];
	[attrs setValue:[NSColor colorWithDeviceRed:.3 green:.3 blue:.3 alpha:1] forKey:NSForegroundColorAttributeName];
	[title drawInRect:inset withAttributes:attrs];
	
	if(highlighted) {
		inset.origin.y -= 1;
		[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		[title drawInRect:inset withAttributes:attrs];
	}
	
	if(isActiveBranch) {
		NSRect r = [slv convertRect:cellFrame toView:nil];
		NSImage * i = [NSImage imageNamed:@"currentBranch.png"];
		
		if([window firstResponder] == controlView && [window isMainWindow] && [window isKeyWindow] && highlighted) i = [NSImage imageNamed:@"currentBranchHighlighted.png"];
		else if(highlighted) i = [NSImage imageNamed:@"currentBranchNotFocused.png"];
		
		[i setFlipped:[controlView isFlipped]];
		
		float newx = cellFrame.origin.x + cellFrame.size.width - 26;
		float newy = [controlView frame].size.height - r.origin.y + 6;
		if(isScrollbarShown) newx += 4;
		//if(highlighted) newy += 1;
		[i drawAtPoint:NSMakePoint(newx,newy) fromRect:NSMakeRect(0,0,14,13) operation:NSCompositeSourceOver fraction:1];
	}
}

- (void) dealloc {
	GDRelease(objectValue);
	[super dealloc];
}

@end

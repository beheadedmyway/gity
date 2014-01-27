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

#import "GTDiffContentView.h"
#import "GittyDocument.h"
#import "GTDiffView.h"

@implementation GTDiffContentView
@synthesize webView;

- (void) awakeFromNib {
	color=[NSColor whiteColor];
	sourceColor=color;
	darkerColor=[NSColor colorWithDeviceRed:.88 green:.88 blue:.88 alpha:1];
	tileImage = [NSImage imageNamed:@"diagonalStripes2.png"];
	[self initWebView];
}

- (void) setGDRefs {
	[super setGDRefs];
	diffView=[gd diffView];
}

- (void) initWebView {
	if(webView) return;
	webView=[[WebView alloc] initWithFrame:[self frame]];
	[webView setUIDelegate:self];
	[webView setAutoresizingMask:[self autoresizingMask]];
}

- (void) useTiledBG {
	useTile=true;
	[self setNeedsDisplay:true];
}

- (void) useDarkColor {
	sourceColor=darkerColor;
	useTile=false;
	[self setNeedsDisplay:true];
}

- (void) useWhiteColor {
	sourceColor=color;
	useTile=false;
	[self setNeedsDisplay:true];
}

- (void) drawRect:(NSRect) dirtyRect {
	[NSGraphicsContext saveGraphicsState];
	NSGraphicsContext * context = [NSGraphicsContext currentContext];
	if(useTile) {
		CGContextRef cgcontext = (CGContextRef)[context graphicsPort];
		CGImageRef image = [tileImage CGImageForProposedRect:NULL context:context hints:nil];
		CGRect imageRect;
		imageRect.origin=CGPointMake(0.0,0.0);
		imageRect.size=CGSizeMake([tileImage size].width,[tileImage size].width);
		CGContextClipToRect(cgcontext,CGRectMake(0.0, 0.0,dirtyRect.size.width,dirtyRect.size.height));
		CGContextDrawTiledImage(cgcontext,imageRect,image);
		
	} else {
		[NSGraphicsContext saveGraphicsState];
		[sourceColor setFill];
		[NSBezierPath fillRect:[self bounds]];
		[NSGraphicsContext restoreGraphicsState];
	}
	[NSGraphicsContext restoreGraphicsState];
	[super drawRect:dirtyRect];
}

- (void) updateWebViewWithDiff:(GTGitDiff *) _diff {
	NSThread * c = [NSThread currentThread];
	if(![c isMainThread]) return;
	[[webView mainFrame] stopLoading];
	[[webView mainFrame] loadHTMLString:[_diff diffContent] baseURL:nil];
	[mainMenuHelper invalidateViewMenu];
}

- (void) showWebView {
	[self initWebView];
	if([webView superview]) return;
	NSRect f=[self frame];
	[webView setFrame:f];
	[self addSubview:webView];
}

- (void) clearDiffView {
	if(webView is nil) return;
	[webView removeFromSuperview];
	[diffView releaseDiffContent];
	webView=nil;
	[mainMenuHelper invalidateViewMenu];
}

- (NSArray *) webView:(WebView *) sender contextMenuItemsForElement:(NSDictionary *) element defaultMenuItems:(NSArray *) defaultMenuItems {
	return nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDiffContentView\n");
	#endif
	GDRelease(darkerColor);
	GDRelease(color);
	diffView=nil;
	sourceColor=nil;
}

@end

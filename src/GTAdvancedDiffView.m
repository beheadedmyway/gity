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

#import "GTAdvancedDiffView.h"
#import "GittyDocument.h"

@implementation GTAdvancedDiffView
@synthesize left;
@synthesize right;

- (void) awakeFromNib {
	diff = [[GTGitDiff alloc] init];
	[self initViews];
}

- (void) hide {
	GDRelease(webView);
}

- (void) initViews {
	[self showTileView];
}

- (void) showTileView {
	[tileView showInView:self];
}

- (void) hideTileView {
	[tileView hide];
}

- (void) setLeft:(NSString *) sha {
	GDRelease(left);
	left=[sha copy];
	[diff setLeft:left];
	[self attemptDiffLoad];
}

- (void) setRight:(NSString *) sha {
	GDRelease(right);
	right=[sha copy];
	[diff setRight:right];
	[self attemptDiffLoad];
}

- (void) attemptDiffLoad {
	NSLog(@"attemptDiffLoad");
	if(left && right) {
		NSLog(@"left && right");
		[gd showDifferView:nil];
		[self runDiff];
	}
}

- (void) runDiff {
	if([[gd gitd] diffTemplate] is nil) [[gd gitd] loadDiffTemplate];
	if(!webView) webView=[[WebView alloc] initWithFrame:NSMakeRect(0,0,1,1)];
	[diff setIsCommitDiff:true];
	[operations runAsyncDiffWithDiff:diff andTemplate:[[gd gitd] diffTemplate] withCallback:self action:@selector(onAsyncDiffComplete)];
}

- (void) onAsyncDiffComplete {
	[self performSelectorOnMainThread:@selector(updateWebViewWithDiff:) withObject:diff waitUntilDone:true];
}

- (void) showWebView {
	NSRect sf = [self frame];
	[webView setFrame:NSMakeRect(0,0,sf.size.width,sf.size.height)];
	[webView setAutoresizingMask:[self autoresizingMask]];
	[self addSubview:webView];
}

- (void) updateWebViewWithDiff:(GTGitDiff *) _diff {
	NSThread * c = [NSThread currentThread];
	if(![c isMainThread]) return;
	[self hideTileView];
	[self showWebView];
	[[webView mainFrame] stopLoading];
	[[webView mainFrame] loadHTMLString:[_diff diffContent] baseURL:nil];
	[[gd mainMenuHelper] invalidateViewMenu];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTAdvancedDiffView\n");
	#endif
	GDRelease(tileView);
	GDRelease(webView);
	GDRelease(diff);
	GDRelease(left);
	GDRelease(right);
}

@end


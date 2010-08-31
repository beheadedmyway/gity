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

#import "GTHistoryCommitDetailsView.h"
#import "GTHistoryView.h"
#import "GittyDocument.h"
#import "GTHistoryBarView.h"
#import "GTHistoryDetailsContainerView.h"

@implementation GTHistoryCommitDetailsView
@synthesize webView;

- (void) awakeFromNib {
	waitForLoad=false;
	reInvalidate=false;
	commitLoadInfo = [[GTGitCommitDetailLoadInfo alloc] init];
	[super awakeFromNib];
}

- (void) initWebView {
	if(webView) {
		[webView setUIDelegate:nil];
		[webView removeFromSuperview];
		[webView release];
	}
	webView=[[WebView alloc] initWithFrame:[self frame]];
	[webView setUIDelegate:self];
	[webView setAutoresizingMask:[self autoresizingMask]];
}

- (void) setGDRefs {
	[super setGDRefs];
	historyView = [gd historyView];
	historyDetailsContainerView = [gd historyDetailsContainerView];
}

- (void) setWebkitRefs {
	[[webView windowScriptObject] setValue:self forKey:@"historyDetailsView"];
}

- (void) showWebView {
	[self initWebView];
	if([webView superview]) return;
	NSRect f=[self frame];
	[webView setFrame:f];
	[self addSubview:webView];
}

- (NSArray *) webView:(WebView *) sender contextMenuItemsForElement:(NSDictionary *) element defaultMenuItems:(NSArray *) defaultMenuItems {
	return nil;
}

+ (BOOL) isSelectorExcludedFromWebScript:(SEL) aSelector {
	return false;
}

+ (BOOL) isKeyExcludedFromWebScript:(const char *) name {
	return false;
}

- (void) exportTar {
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) return;
	NSSavePanel * sp = [NSSavePanel savePanel];
	NSString * projectTitle = [gd displayName];
	NSString * projWithUn = [projectTitle stringByAppendingString:@"_"];
	NSString * suggest = [projWithUn stringByAppendingString:[[commit abbrevHash] stringByAppendingString:@".tar.gz"]];
	[sp setNameFieldStringValue:suggest];
	[sp beginSheetForDirectory:NULL file:NULL modalForWindow:[gd gtwindow] modalDelegate:self didEndSelector:@selector(savePanelDidEndForTar:returnCode:) contextInfo:nil];
}

- (void) savePanelDidEndForTar:(NSSavePanel *) _panel returnCode:(NSInteger) res {
	if(res == NSCancelButton) return;
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) return;
	NSString * file = [_panel filename];
	[operations runExportTar:file andCommit:[commit hash]];
}

- (void) exportZip {
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) return;
	NSSavePanel * sp = [NSSavePanel savePanel];
	NSString * projectTitle = [gd displayName];
	NSString * projWithUn = [projectTitle stringByAppendingString:@"_"];
	NSString * suggest = [projWithUn stringByAppendingString:[[commit abbrevHash] stringByAppendingString:@".zip"]];
	[sp setNameFieldStringValue:suggest];
	[sp beginSheetForDirectory:NULL file:NULL modalForWindow:[gd gtwindow] modalDelegate:self didEndSelector:@selector(savePanelDidEndForZip:returnCode:) contextInfo:nil];
}

- (void) savePanelDidEndForZip:(NSSavePanel *) _panel returnCode:(NSInteger) res {
	if(res == NSCancelButton) return;
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) return;
	NSString * file = [_panel filename];
	[operations runExportZip:file andCommit:[commit hash]];
}

- (void) loadParent:(NSString *) _commitHash {
	if(_commitHash is nil) {
		NSBeep();
		return;
	}
	[historyView selectCommitFromSHA:_commitHash];
}

- (void) loadTree:(NSString *) _treeHash {
	
}

- (void) loadRight:(NSString *) _hash {
	NSLog(@"%@",_hash);
	NSLog(@"%@",[gd advancedDiffView]);
	[[gd advancedDiffView] setRight:_hash];
}

- (void) loadLeft:(NSString *) _hash {
	NSLog(@"%@",_hash);
	[[gd advancedDiffView] setLeft:_hash];
}

- (BOOL) isHeadDetatched {
	if(!gd) return false;
	if(![gd gitd]) return false;
	return [[gd gitd] isHeadDetatched];
}

- (void) cherryPick:(NSString *) _hash {
	if([[gd gitd] isDirty]) {
		[[gd modals] runWorkingTreeDirtyForCherry];
		return;
	}
	NSUInteger res = [[gd modals] runCherryPickNotice:[[gd gitd] activeBranchName]];
	if(res == NSCancelButton) return;
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) {
		NSBeep();
		return;
	}
	GDCallback * cb = [[[GDCallback alloc] initWithTarget:self andAction:@selector(onCherryPickComplete)] autorelease];
	[cb setExecutesOnMainThread:true];
	[[gd operations] runCherryPickCommitWithSHA:[commit hash] withCallback:cb];
}

- (void) onCherryPickComplete {
	NSLog(@"onCherryPickComplete");
	[gd showHistory:nil];
}

- (NSMutableArray *) getRefs:(NSString *) sha {
	return [[gd gitd] getRefsForSHA:sha];
	//return [[gd gitd] refs];
}

- (void) newTag:(NSString *) _sha {
	if(_sha is nil) {
		NSBeep();
		return;
	}
	[gd gitNewTag:_sha];
}

- (void) loadCommitTemplate {
	NSString * path = [[NSBundle mainBundle] pathForResource:@"cancelOut" ofType:@"png" inDirectory:nil];
	NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:path];
	NSData * content = [fh readDataToEndOfFile];
	[fh closeFile];
	commitTemplate = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
}

- (void) clearCurSHA {
	GDRelease(curSHA);
}

- (void) invalidate {
	if(waitForLoad){
		reInvalidate=true;
		return;
	}
	if(commitTemplate is nil) [self loadCommitTemplate];
	GTGitCommit * commit = [historyView selectedItem];
	if(!commit) {
		wasCommitNil=true;
		[self clearCurSHA];
		return;
	}
	NSString * curRef = [historyView currentRef];
	if(lastRefName and ![lastRefName isEqual:curRef]) {
		GDRelease(lastRefName);
		lastRefName = [curRef copy];
		if(!wasCommitNil)[historyView selectFirstItem];
		commit=[historyView selectedItem];
	}
	if(lastRefName is nil) lastRefName = [curRef copy];
	if(!commit) return;
	wasCommitNil=false;
	if([[commit hash] isEqual:curSHA] && ![[historyDetailsContainerView barView] hasContextChanged]) return;
	[commitLoadInfo setContextValue:[[historyDetailsContainerView barView] contextValue]];
	GDCallback * cb = [[[GDCallback alloc] initWithTarget:self andAction:@selector(onCommitLoaded)] autorelease];
	waitForLoad=true;
	[operations runLoadCommitDetailsWithCommit:commit andCommitDetailsTemplate:commitTemplate andCommitDetailLoadInfo:commitLoadInfo withCallback:cb];
	curSHA=[[commit hash] copy];
}

- (void)loadHTMLString:(NSString *)html
{
	WebFrame *mainFrame = [webView mainFrame];
	[mainFrame loadHTMLString:html baseURL:nil];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	// this needs to be done on loadFinish otherwise, we end up with
	// an empty commit log.
	[self setWebkitRefs];
	[mainMenuHelper invalidateViewMenu];
	if(reInvalidate){
		reInvalidate=false;
		[self invalidate];
	}
}

- (void) onCommitLoaded {
	if(![webView superview]) [self showWebView];
	NSThread * c = [NSThread currentThread];
	waitForLoad=false;
	if(![c isMainThread]) return;
	[self showWebView];
	[webView setFrameLoadDelegate:self];
	[[webView mainFrame] performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:true];
	[self performSelectorOnMainThread:@selector(loadHTMLString:) withObject:[commitLoadInfo parsedCommitDetails] waitUntilDone:true];
}

- (void) sendCommitBugReport {
	[operations runReportCommitWithCommitContent:[commitLoadInfo parsedCommitDetails]];
}

- (void) disposeWebkit {
	[commitLoadInfo setParsedCommitDetails:nil];
	[webView removeFromSuperview];
	[webView release];
	webView=nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistoryCommitDetailsView\n");
	#endif
	GDRelease(commitTemplate);
	GDRelease(commitLoadInfo);
	GDRelease(webView);
	GDRelease(curSHA);
	historyView=nil;
	historyDetailsContainerView=nil;
	[super dealloc];
}

@end

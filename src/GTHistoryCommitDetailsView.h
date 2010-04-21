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
#import <WebKit/WebKit.h>
#import "GTGittyView.h"
#import "GTGitCommitDetailLoadInfo.h"
#import "GTGitCommit.h"
#import "GTOpShowStatusForDetailLoad.h"

@class GTHistoryView;
@class GTHistoryDetailsContainerView;

@interface GTHistoryCommitDetailsView : GTGittyView {
	BOOL wasCommitNil;
	BOOL waitForLoad;
	BOOL reInvalidate;
	NSTimer * statusTimer;
	NSString * commitTemplate;
	NSString * lastRefName;
	NSString * curSHA;
	NSTimer * showStatusTimer;
	WebView * webView;
	GTHistoryView * historyView;
	GTGitCommitDetailLoadInfo * commitLoadInfo;
	GTHistoryDetailsContainerView * historyDetailsContainerView;
	GTOpShowStatusForDetailLoad * detailLoadOp;
	NSAutoreleasePool * pool;
}

@property (readonly,nonatomic) WebView * webView;

- (void) clearCurSHA;
- (void) initWebView;
- (void) invalidate;
- (void) loadCommitTemplate;
- (void) exportTar;
- (void) exportZip;
- (void) loadParent:(NSString *) _commitHash;
- (void) setWebkitRefs;
- (void) disposeWebkit;
- (void) sendCommitBugReport;
- (void) newTag:(NSString *) _sha;
- (void) loadRight:(NSString *) _hash;
- (void) loadLeft:(NSString *) _hash;
- (BOOL) isHeadDetatched;

@end

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

#import "GittyDocument.h"
#import "GTDocumentController.h"

static BOOL started;
static GTDocumentController * doc;
static GTModalController * modals;
static NSFileManager * fileManager;
static NSNotificationCenter * center;
static NSUserDefaults * defaults;
static NSWindow * lastMainWindow;

@implementation GittyDocument
@synthesize isSourceListHidden;
@synthesize historyFilteredView;
@synthesize historyView;
@synthesize historyDetailsContainerView;
@synthesize isSearching;
@synthesize gtwindow;
@synthesize stateBarView;
@synthesize statusBarView;
@synthesize activeBranchView;
@synthesize advancedDiffView;
@synthesize customWindowTitleController;
@synthesize git;
@synthesize gitd;
@synthesize status;
@synthesize commit;
@synthesize operations;
@synthesize contextMenus;
@synthesize unknownError;
@synthesize mainMenuHelper;
@synthesize sourceListView;
@synthesize splitContentView;
@synthesize newRemote;
@synthesize singleInput;
@synthesize configView;
@synthesize newTrackBranch;
@synthesize remoteView;
@synthesize fetchTags;
@synthesize sounds;
@synthesize newSubmodule;
@synthesize commitAfterAdd;
@synthesize diffView;

#pragma mark initializations
- (void) awakeFromNib {
	isTerminatingFromSessionExpired=false;
	justLaunched=true;
	runningExpiredModal=false;
	gitd=[[GTGitDataStore alloc] initWithGD:self];
	sounds=[GTSoundController sharedInstance];
	contextMenus=[[GTContextMenuController alloc] initWithGD:self];
	mainMenuHelper=[[GTMainMenuHelper alloc] initWithGD:self];
	operations=[[GTOperationsController alloc] initWithGD:self];
	[gitd setRefs];
}

- (id) init {
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	self=[super init];
	if(doc is nil) doc=[GTDocumentController sharedDocumentController];
	if(fileManager is nil) fileManager=[NSFileManager defaultManager];
	if(modals is nil) modals=[GTModalController sharedInstance];
	if(center is nil) center=[NSNotificationCenter defaultCenter];
	if(defaults is nil) defaults=[NSUserDefaults standardUserDefaults];
	git=[[GTGitCommandExecutor alloc] init];
	[self initNotifications];
	return self;
}

- (void) initNotifications {
	[center addObserver:self selector:@selector(applicationWillBecomeActive) name:NSApplicationWillBecomeActiveNotification object:nil];
}

#pragma mark licensing / expiration methods.
- (void) expireSession {
	if(runningExpiredModal) return;
	isTerminatingFromSessionExpired=true;
	runningExpiredModal=true;
	[operations cancelAll];
	[operations cancelNetworkOperations];
	[modals runDocumentExpired];
	[[NSApplication sharedApplication] terminate:nil];
}

#pragma mark window, and application helpers
- (NSInteger) shouldCloseNow {
	if(isTerminatingFromSessionExpired) return true;
	if([gitd isHeadDetatched]) return true;
	if([[gitd commitsAhead] isEqual:@"0"]) return true;
	NSString * remote = [gitd defaultRemoteForBranch:[gitd activeBranchName]];
	if([[gitd commitsAhead] isEqual:@"1"]) return [modals runCloseCommitsAheadForSingleModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
	return [modals runCloseCommitsAheadModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
}

- (NSInteger) shouldQuitNow {
	if(isTerminatingFromSessionExpired) return true;
	if([gitd isHeadDetatched]) return true;
	if([[gitd commitsAhead] isEqual:@"0"]) return true;
	NSString * remote = [gitd defaultRemoteForBranch:[gitd activeBranchName]];
	if([[gitd commitsAhead] isEqual:@"1"]) return [modals runCommitsAheadForSingleModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
	return [modals runCommitsAheadModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
}

#pragma mark window delegate methods and other methods that wait or react to some window operation.
- (void) windowControllerDidLoadNib:(NSWindowController *) controller {
	[super windowControllerDidLoadNib:controller];
	[gtwindow setFrameUsingName:[git gitProjectPath]];
	[gtwindow setDelegate:self];
	[git setGitProjectPath:[[self fileURL] path]];
	[activeBranchView retain];
	[statusBarView retain];
	[splitContentView retain];
	[sourceListView retain];
	[diffView retain];
	[historyView retain];
	[historyDetailsContainerView retain];
	[advancedDiffView retain];
	[status lazyInitWithGD:self];
	[commit lazyInitWithGD:self];
	[singleInput lazyInitWithGD:self];
	[newRemote lazyInitWithGD:self];
	[newSubmodule lazyInitWithGD:self];
	[unknownError lazyInitWithGD:self];
	[newTrackBranch lazyInitWithGD:self];
	[fetchTags lazyInitWithGD:self];
	[historySearch lazyInitWithGD:self];
	[[modals cloneRepoController] lazyInitWithGD:self];
	[customWindowTitleController lazyInitWithGD:self];
	[contentHSplitView lazyInitWithGD:self];
	[diffView lazyInitWithGD:self];
	[splitContentView lazyInitWithGD:self];
	[sourceListView lazyInitWithGD:self];
	[stateBarView lazyInitWithGD:self];
	[statusBarView lazyInitWithGD:self];
	[activeBranchView lazyInitWithGD:self];
	[configView lazyInitWithGD:self];
	[historyView lazyInitWithGD:self];
	[historyDetailsContainerView lazyInitWithGD:self];
	[historySearch lazyInitWithGD:self];
	[historyFilteredView lazyInitWithGD:self];
	[advancedDiffView lazyInitWithGD:self];
	topSplitView = [contentHSplitView topView];
	bottomSplitView = [contentHSplitView bottomView];
	rightView = [splitContentView rightView];
	//[remoteView lazyInitWithGD:self];
	[splitContentView show];
	[sourceListView show];
	[stateBarView show];
	[activeBranchView show];
	[customWindowTitleController update];
	
	// Setup FSEvents so we know when files get changed.
	fileEvents = [[SCEvents alloc] init];
	fileEvents.delegate = self;
	fileEvents.ignoreEventsFromSubDirs = NO;
	fileEvents.notificationLatency = 1.0;
	fileEvents.excludedPaths = [NSArray arrayWithObject:[[[self fileURL] path] stringByAppendingPathComponent:@".git/vendor/gity/tmp/"]];
	[fileEvents startWatchingPaths:[NSArray arrayWithObject:[[self fileURL] path]]];
	
	[self waitForWindow];
}

- (void)pathWatcher:(SCEvents *)pathWatcher multipleEventsOccurred:(NSArray *)events
{
	[self updateAfterWindowFilesChanged];
}

- (BOOL) windowShouldClose:(id) sender {
	if([defaults boolForKey:kGTIgnoreCommitsAhead]) return true;
	NSInteger res = [self shouldCloseNow];
	if(res == NSCancelButton) return false;
	[self persistWindowState];
	return true;
}

- (void) windowWillClose:(NSNotification *) notification {
	[operations cancelAll];
	[historyView removeObservers];
	[sourceListView removeObservers];
}

- (void) windowDidBecomeMain:(NSNotification *) notification {
	if([gtwindow title] neq nilstring) {
		NSString * title = [[gtwindow title] copy];
		[gtwindow setRepresentedURL:nil];
		[gtwindow setTitle:nilstring];
		[[NSApplication sharedApplication] addWindowsItem:gtwindow title:title filename:false];
		[title release];
	}
	if(justLaunched) {
		justLaunched=false;
		return;
	}
	if(lastMainWindow == gtwindow) return;
	[mainMenuHelper invalidate];
	lastMainWindow=gtwindow;
	// we're using FSEvents now, this shouldn't be needed anymore.
	//[self updateAfterWindowBecameActive];
}

- (void) updateAfterWindowFilesChanged {
	// lets make sure this is on the main thread due to FSEvents
	if ([NSThread isMainThread]) {
		if([self isCurrentViewConfigView]) {
			if([configView isOnGlobalConfig]) 
				[operations runGetGlobalConfigs];
			else 
				[operations runGetConfigs];
		}
		else if([self isCurrentViewHistoryView]) {
			[historyView invalidate];
		} else {
			[operations runRefreshOperation];
		}
	} else {
		// lets call it on the main thread.
		[self performSelectorOnMainThread:@selector(updateAfterWindowFilesChanged) withObject:nil waitUntilDone:NO];
	}

}

- (void) waitForWindow {
	if(![gtwindow isVisible]) [NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(waitForWindow) userInfo:nil repeats:false];
	else [self windowReady];
}

- (void) windowReady {
	[GTOperationsController updateLicenseRunStatus:[[[GTDocumentController sharedDocumentController] registration] isRunningWithValidLicense]];
	[self runStartupOperation];
}

- (void) persistWindowState {
	[gtwindow saveFrameUsingName:[git gitProjectPath]];
	[sourceListView saveSizeToDefaults];
	[sourceListView persistViewState];
	[defaults synchronize];
}

- (void) adjustMinWindowSize {
	return;
	int h = 175;
	float s = [stateBarView getRequiredWidth];
	NSSize news = NSMakeSize([statusBarView getTotalButtonWidth]+125+s,h);
	[gtwindow setMinSize:news];
	NSRect frame = NSMakeRect([gtwindow frame].origin.x,[gtwindow frame].origin.y,news.width,[gtwindow frame].size.height);
	NSRect wframe = [gtwindow frame];
	if(wframe.size.width < frame.size.width) [gtwindow setFrame:frame display:true];
}

#pragma custom getters
- (GTModalController *) modals {
	return modals;
}

#pragma mark operations
- (void) runStartupOperation {
	[status showStartupIndicator];
	[operations runStartupOperation];
}

#pragma mark application notifications
- (void) applicationWillBecomeActive {
	if(!started) {
		started=true;
		return;
	}
	// we're using FSEvents now, this shouldn't be needed.
	//if(lastMainWindow==gtwindow) [self updateAfterWindowBecameActive];
}

#pragma mark view and document methods.
- (BOOL) isThisDocumentForURL:(NSURL *) proposedURL {
	return [[git gitProjectPathAsNSURL] isEqual:proposedURL];
}

- (BOOL) isCurrentViewActiveBranchView {
	return !([activeBranchView superview] == nil);
}

- (BOOL) isCurrentViewConfigView {
	return !([configView superview] == nil);
}

- (BOOL) isCurrentViewRemoteView {
	return !([remoteView superview] == nil);
}

- (BOOL) isCurrentViewHistoryView {
	return !([historyView superview] == nil);
}

- (void) focusOnSearch:(id) sender {
	[stateBarView focusOnSearch];
}

- (void) reload:(id) sender {
	if([self isCurrentViewActiveBranchView]) [operations runRefreshOperation];
	else if([self isCurrentViewConfigView]) [configView reload];
	else if([self isCurrentViewHistoryView]) [historyView invalidate];
}

- (void) showDifferView:(id) sender {
	NSLog(@"showDifferView");
	[activeBranchView hide];
	[historyView hide];
	[historyDetailsContainerView hide];
	[configView hide];
	[diffView hide];
	[statusBarView hide];
	[contentHSplitView removeFromSuperview];
	[advancedDiffView showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
}

- (void) showActiveBranch:(id) sender {
	[self showActiveBranchWithDiffUpdate:true forceIfAlreadyActive:false];
}

- (void) showActiveBranchWithDiffUpdate:(BOOL) _invalidateDiffView forceIfAlreadyActive:(BOOL) _force {
	if([self isCurrentViewActiveBranchView] && !_force) return;
	[advancedDiffView hide];
	[historyView hide];
	[historyDetailsContainerView hide];
	[configView hide];
	[activeBranchView activateTableView];
	if(isSourceListHidden) [contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0,22,0,-50)];
	else [contentHSplitView showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
	if([gitd isHeadDetatched]) [stateBarView showDetatchedHeadState];
	else [stateBarView showActiveBranchState];
	[statusBarView updateAfterViewChange];
	[activeBranchView showInView:topSplitView];
	[diffView showInView:bottomSplitView];
	[statusBarView invalidateSelfFrame];
	if(_invalidateDiffView) [diffView invalidate];
	[mainMenuHelper invalidate];
	[contextMenus invalidate];
}

- (void) showRemoteViewForRemote:(NSString *) remote {
	return;
	if([self isCurrentViewRemoteView]) return;
	[advancedDiffView hide];
	[remoteView showForRemote:remote];
	[stateBarView showRemoteStateForRemote:remote];
	[statusBarView hide];
	[mainMenuHelper invalidate];
	[contextMenus invalidate];
}

- (void) showHistory:(id) sender {
	if([gitd isHeadDetatched]) [self showHistoryFromRef:[gitd currentAbbreviatedSha]];
	else [self showHistoryFromRef:[gitd activeBranchName]];
}

- (void) showHistoryFromRef:(NSString *) _refName {
	if([sourceListView wasJustUpdated]) return;
	BOOL shouldInvalidateHistory = false;
	BOOL shouldDoShow = false;
	if(![[historyView currentRef] isEqual:_refName]) {
		[historyView setHistoryRefName:_refName];
		shouldInvalidateHistory=true;
	}
	if(![self isCurrentViewHistoryView]) shouldDoShow=true;
	if(shouldDoShow) {
		[advancedDiffView hide];
		[activeBranchView hide];
		[statusBarView hide];
		[diffView hide];
		[configView hide];
		if(isSourceListHidden) [contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0,22,0,-50)];
		else [contentHSplitView showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
		[stateBarView showHistoryStateWithRefName:_refName];
		[historyView showInView:topSplitView];
		[historyDetailsContainerView showInView:bottomSplitView];
		[mainMenuHelper invalidate];
		[contextMenus invalidate];
		[historyView activateTableView];
	}
	if(shouldInvalidateHistory) {
		if(!shouldDoShow) [stateBarView showHistoryStateWithRefName:_refName];
		[historyView invalidate];
	}
}

- (void) showConfig:(id) sender {
	[operations runGetConfigs];
}

- (void) showGlobalConfig:(id) sender {
	[operations runGetGlobalConfigs];
}

- (void) toggleSourceList:(id) sender {
	NSMenuItem * item = (NSMenuItem *) sender;
	if([[item title] isEqual:@"Show Source List"]) {
		[item setTitle:@"Hide Source List"];
		[self showSourceList];
	} else {
		[item setTitle:@"Show Source List"];
		[self hideSourceList];
	}
}

- (void) showSourceList {
	isSourceListHidden=false;
	[contentHSplitView removeFromSuperview];
	[[gtwindow contentView] addSubview:splitContentView];
	[stateBarView show];
	if([self isCurrentViewActiveBranchView]) {
		[self showActiveBranchWithDiffUpdate:false forceIfAlreadyActive:true];
	} else if([self isCurrentViewHistoryView]) {
		[self showHistory:nil];
	} else if([self isCurrentViewConfigView]) {
		[self showConfig:nil];
	}
}

- (void) hideSourceList {
	isSourceListHidden=true;
	[splitContentView removeFromSuperview];
	[contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0,22,0,-50)];
	[stateBarView showWithHiddenSourceList];
	if([self isCurrentViewConfigView]) {
		[configView show];
	}
}

#pragma mark operation result, and operation callback/complete methods.
- (void) unknownErrorFromOperation:(NSString *) error {
	if(![gtwindow isVisible] || [status isShowingSheet]) {
		GDRelease(_tmpUnknownError);
		_tmpUnknownError = [error copy];
		[self tryToShowUnknownError];
	} else {
		[unknownError showAsSheetWithError:error];
	}
}

- (void) tryToShowUnknownError {
	if(![gtwindow isVisible] || [status isShowingSheet]) {
		[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(tryToShowUnknownError) userInfo:nil repeats:false];
	} else {
		NSBeep();
		[unknownError showAsSheetWithError:_tmpUnknownError];
		GDRelease(_tmpUnknownError);
	}
}

- (void) onHistoryLoaded {
	[historyView update];
	[historyDetailsContainerView invalidate];
}

- (void) onNewSubmoduleComplete {
	[operations runNewSubmodule:[newSubmodule submoduleURL] inLocalDir:[newSubmodule submoduleDestination] withName:[newSubmodule submoduleName]];
}

- (void) onStatusBarFilesToggled {
	[activeBranchView updateFromStatusBarView];
	[diffView invalidate];
}

- (void) onActiveBranchViewSelectionChange {
	[mainMenuHelper invalidate];
	[contextMenus invalidateActiveBranchViewMenus];
	[diffView invalidate];
}

- (void) onHistoryViewSelectionChange {
	[historyDetailsContainerView invalidate];
}

- (void) onHistorySearch {
}

- (void) onStartupOperationComplete {
	[status hide];
	[self showActiveBranchWithDiffUpdate:true forceIfAlreadyActive:true];
	[sourceListView update];
	[activeBranchView update];
	[mainMenuHelper invalidate];
	[mainMenuHelper updateAutoEnableItems];
	[contextMenus invalidate];
	[operations runGetCommitsAheadWithoutSpinner];
	[self adjustMinWindowSize];
}

- (void) onRefreshOperationComplete {
	if([self isCurrentViewActiveBranchView]) {
		if([gitd isHeadDetatched]) [stateBarView showDetatchedHeadState];
		else [stateBarView showActiveBranchState];
	}
	[statusBarView update];
	[activeBranchView update];
	[diffView invalidate];
	[mainMenuHelper invalidate];
	[contextMenus invalidate];
	//[self adjustMinWindowSize];
	if(commitAfterAdd) {
		[commit focus];
		commitAfterAdd=false;
	}
	[sourceListView update];
	// update the history...
	[historyView invalidate];
}

- (void) onRefreshMetaOperationComplete {
	[sourceListView update];
	[activeBranchView update];
	[mainMenuHelper invalidate];
}

- (void) onGotLooseObjectsCount {
	NSInteger lc = [gitd looseObjects];
	if(lc > 1000) [modals runLooseObjectCountReminder];
}

- (void) onGetConfigsComplete {
	[activeBranchView hide];
	[historyDetailsContainerView hide];
	[historyView hide];
	[statusBarView hide];
	[stateBarView showConfigState];
	[configView show];
	[configView update];
	[mainMenuHelper invalidate];
}

- (void) onGetGlobalConfigsComplete {
	[activeBranchView hide];
	[historyDetailsContainerView hide];
	[historyView hide];
	[statusBarView hide];
	[stateBarView showGlobalConfigState];
	[configView show];
	[configView updateWithGlobalConfig];
	[mainMenuHelper invalidate];
}

- (void) onNewRemoteComplete {
	if([newRemote lastButtonValue] == NSCancelButton) return;
	[operations runNewRemote:[newRemote remoteNameValue] withURL:[newRemote remoteURLValue]];
}

- (void) onNewRemoteTrackBranchComplete {
}

- (void) onStashComplete {
	if([singleInput lastButtonValue] == NSCancelButton) return;
	[operations runNewStash:[singleInput inputValue]];
}

- (void) onNewEmptyBranchComplete {
	if([singleInput lastButtonValue] == NSCancelButton) return;
	[operations runNewEmptyBranch:[singleInput inputValue]];
}

- (void) onNewBranchComplete {
	if([singleInput lastButtonValue] == NSCancelButton) return;
	[operations runNewBranch:[singleInput inputValue] fromStartBranch:_tmpBranchStartName checkoutNewBranch:[singleInput wasCheckoutChecked]];
	[_tmpBranchStartName release];
}

- (void) onNewTagComplete {
	if([singleInput lastButtonValue] == NSCancelButton) return;
	[operations runNewTag:[singleInput inputValue] fromStart:_tmpTagStartPoint];
	[_tmpTagStartPoint release];
}

- (void) onGotRemoteBranches {
	[newTrackBranch updateRemoteBranchNames];
}

- (void) onGotRemoteTags {
	[fetchTags updateRemoteTagNames];
}

- (void) onFetchTagComplete {
}

- (void) onGitAddComplete {
	if(commitAfterAdd) [self gitCommit:nil];
}

#pragma mark search helper methods
- (void) search:(NSString *) term {
	isSearching=true;
	if([self isCurrentViewHistoryView]) [historyView search:term];
	if([self isCurrentViewActiveBranchView]) [activeBranchView search:term];
}

- (void) onSearch {
	[diffView invalidate];
}

- (void) clearSearch {
	isSearching=false;
	[historyView clearSearch];
	[activeBranchView clearSearch];
	if([self isCurrentViewHistoryView]) [historyDetailsContainerView invalidate];
}

- (void) onClearSearch {
	[diffView invalidate];
}

- (void) clearSearchField {
	[stateBarView clearSearchField];
}

- (void) clearSearchHistory:(id) sender {
	[historyFilteredView close];
}

- (void) searchHistory:(id) sender {
	[historySearch showAsSheet];
}

#pragma mark git* methods - these are methods that are called from other controllers, or from the main menu.
- (void) gitApplyPatch:(id) sender {
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:false];
	[op setCanChooseFiles:true];
	NSInteger res = [op runModalForTypes:[NSArray arrayWithObjects:@"patch",@"diff",nil]];
	if(res == NSCancelButton) return;
	NSString * patchFile = [[op filename] copy];
	[operations runPatchApplyWithFile:patchFile];
	[patchFile release];
}

- (void) gitGarbageCollect:(id) sender {
	[operations runGarbageCollect];
}

-(void) gitAggresiveGarbageCollect:(id) sender {
	[operations runAggressiveGarbageCollect];
}

- (void) gitAdd:(id) sender {
	if([activeBranchView selectedFilesCount] < 1) return;
	commitAfterAdd=false;
	[operations runAddFilesOperation];
}

- (void) gitAddAndCommit:(id) sender {
	if([activeBranchView selectedFilesCount] < 1) return;
	commitAfterAdd=true;
	[operations runAddFilesOperation];
}

- (void) gitPackRefs:(id) sender {
	[operations runPackRefs];
}

- (void) gitPackObjects:(id) sender {
	[operations runPackObjects];
}

- (void) gitCommit:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if([gitd stagedFilesCount] < 1 && !commitAfterAdd) {
		NSBeep();
		return;
	}
	[commit showAsSheet];
}

- (void) gitRemove:(id) sender {
	NSInteger verified = [modals verifyGitRemove];
	if(verified == NSCancelButton) return;
	[operations runRemoveFilesOperation];
}

- (void) gitHardReset:(id) sender {
	[sourceListView branchHardReset:sender];
}

- (void) gitSoftReset:(id) sender {
	[sourceListView branchDiscardNonStagedChanges:sender];
}

- (void) gitDiscardChanges:(id) sender {
	[operations runDiscardChangesOperation];
}

- (void) gitDestage:(id) sender {
	[operations runDestageOperation];
}

- (void) gitCheckout:(NSString *) branch {
	[operations runBranchCheckout:branch];
}

- (void) gitFetch:(id) sender {
	[operations runFetch];
}

- (void) gitIgnore:(id) sender {
	NSMutableArray * files = [activeBranchView selectedFiles];
	if(files is nil) {
		NSBeep();
		return;
	}
	[operations runIgnoreFiles:files];
}

- (void) gitIgnoreExtension:(id) sender {
	NSString * ext = [activeBranchView getSelectedFileExtension];
	if([ext isEqual:@""]) return;
	[operations runIgnoreExtension:ext];
}

- (void) gitIgnoreDir:(id) sender {
	NSMutableArray * files = [activeBranchView selectedFiles];
	if(files is nil) {
		NSBeep();
		return;
	}
	NSString * f = [[files objectAtIndex:0] stringByDeletingLastPathComponent];
	if([f isEmpty]) {
		NSBeep();
		return;
	}
	[operations runIgnoreFiles:[NSMutableArray arrayWithObject:[f stringByAppendingString:@"/"]]];
}

- (void) gitNewRemote:(id) sender {
	[newRemote showAsSheetWithCallback:self action:@selector(onNewRemoteComplete)];
}

- (void) gitNewSubmodule:(id) sender {
	[newSubmodule showAsSheetWithCallback:self action:@selector(onNewSubmoduleComplete)];
}

- (void) gitNewBranch:(NSString *) startBranch {
	_tmpBranchStartName = [startBranch copy];
	[singleInput setSheetTitleValue:@"New Branch"];
	[singleInput setInputLabelValue:@"Enter a name for the new branch (no spaces)"];
	[singleInput setShowsCheckoutCheckbox:true];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewBranchComplete)];
}

- (void) gitNewBranchFromActiveBranch:(id) sender {
	_tmpBranchStartName = [[gitd activeBranchName] copy];
	[singleInput setSheetTitleValue:@"New Branch"];
	[singleInput setInputLabelValue:@"Enter a name for the new branch (no spaces)"];
	[singleInput setShowsCheckoutCheckbox:true];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewBranchComplete)];
}

- (void) gitNewTag:(NSString *) startPoint {
	_tmpTagStartPoint = [startPoint copy];
	[singleInput setSheetTitleValue:@"New Tag"];
	[singleInput setInputLabelValue:@"Enter a name for the new tag (no spaces)"];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewTagComplete)];
}

- (void) gitNewTagFromActiveBranch:(id) sender {
	_tmpTagStartPoint = [[gitd activeBranchName] copy];
	[singleInput setSheetTitleValue:@"New Tag"];
	[singleInput setInputLabelValue:@"Enter a name for the new tag (no spaces)"];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewTagComplete)];
}

- (void) gitNewEmptyBranch:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if([gitd isDirty]) {
		[modals runDirIsDirtyForEmptyBranch];
		return;
	}
	[singleInput setSheetTitleValue:@"New Empty Branch"];
	[singleInput setInputLabelValue:@"Enter a name for the new empty branch (no spaces)"];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewEmptyBranchComplete)];
}

- (void) gitStashLocalChanges:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	[singleInput setAllowsSpaces:true];
	[singleInput setSheetTitleValue:@"Stash Local Changes"];
	[singleInput setInputLabelValue:@"Enter a short description for this stash"];
	[singleInput showAsSheetWithCallback:self action:@selector(onStashComplete)];
}

- (void) gitUpdateAllSubmodules:(id) sender {
	[operations runSubmoduleUpdateAll];
}

- (void) gitInitializeAllSubmodules:(id) sender {
	[operations runSubmoduleInitAll];
}

- (void) gitPushFromMenu:(id) sender {
	[sourceListView gitPushFromActiveBranch];
}

- (void) gitPullFromMenu:(id) sender {
	[sourceListView gitPullFromActiveBranch];
}

- (void) gitRebaseFromMenu:(id) sender {
	[sourceListView gitRebaseFromActiveBranch];
}

- (void) gitFetchTags:(id) sender {
	[fetchTags showAsSheetWithCallback:self action:@selector(onFetchTagComplete)];
}

#pragma mark other actions.
- (void) newRemoteTrackingBranch:(id) sender {
	[newTrackBranch showAsSheetWithCallback:self action:@selector(onNewRemoteTrackBranchComplete)];
}

- (void) resolveConflictsWithFileMerge:(id) sender {
	NSString * fle = [[activeBranchView selectedFiles] objectAtIndex:0];
	if([activeBranchView selectedFilesCount] == 0 || [activeBranchView selectedFilesCount] > 1) return;
	if(![fileManager fileExistsAtPath:@"/usr/bin/opendiff"]) {
		[modals runCantFindFileMerge];
		return;
	}
	[modals runRemindQuitFileMerge];
	fixingConflict=true;
	[operations runOpenFileMergeForFile:fle];
}

- (void) openProjectInTextmate:(id) sender {
	NSString * matePath = nil;
	if([fileManager fileExistsAtPath:@"/usr/local/bin/mate"]) matePath=@"/usr/local/bin/mate";
	else if([fileManager fileExistsAtPath:@"/usr/bin/mate"]) matePath=@"/usr/bin/mate";
	else if([fileManager fileExistsAtPath:@"/opt/local/bin/mate"]) matePath=@"/opt/local/bin/mate";
	else if([fileManager fileExistsAtPath:@"/bin/mate"]) matePath=@"/bin/mate";
	else if([fileManager fileExistsAtPath:@"/usr/X11/bin/mate"]) matePath=@"/usr/X11/bin/mate";
	if(matePath == nil) {
		[modals runCantFindTextmateBinary];
		return;
	}
	NSTask * task = [[NSTask alloc] init];
	NSMutableArray * args = [[NSMutableArray alloc] init];
	[args addObject:[git gitProjectPath]];
	[task setLaunchPath:matePath];
	[task setArguments:args];
	[task launch];
	[task waitUntilExit];
	[task release];
	task=nil;
	[args release];
}

- (void) openInFinder:(id) sender {
	NSMutableArray * files = [activeBranchView selectedFiles];
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
	NSString * fullPath = [[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]];
	[workspace selectFile:fullPath inFileViewerRootedAtPath:nil];
}

- (void) openContainingFolder:(id) sender {
	NSMutableArray * files = [activeBranchView selectedFiles];
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
	NSString * fullPath = [[[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]] stringByDeletingLastPathComponent];
	[workspace selectFile:fullPath inFileViewerRootedAtPath:nil];
}

- (void) moveToTrash:(id) sender {
	NSBeep();
	if([modals runMoveToTrashConfirmation] == NSCancelButton) return;
	NSMutableArray * trash = [activeBranchView selectedFiles];
	if(trash is nil) return;
	NSString * fs;
	NSString * fullPath;
	for(fs in trash) {
		fullPath = [[git gitProjectPath] stringByAppendingPathComponent:fs];
		[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation source:[fullPath stringByDeletingLastPathComponent] destination:nil files:[NSArray arrayWithObject:[fullPath lastPathComponent]] tag:NULL];
	}
	[operations runRefreshOperation];
}

- (void) toggleAllFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[statusBarView toggleAllFiles];
	[diffView invalidate];
}

- (void) toggleStagedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleStagedFiles];
}

- (void) toggleUntrackedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleUntrackedFiles];
}

- (void) toggleModifiedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleModifiedFiles];
}

- (void) toggleDeletedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleDeletedFiles];
}

- (void) toggleConflictedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleConflictedFiles];
}

- (void) moreContext:(id) sender {
	if([self isCurrentViewActiveBranchView]) [diffView moreContext];
	else [[historyDetailsContainerView barView] moreContext];
}

- (void) lessContext:(id) sender {
	if([self isCurrentViewActiveBranchView]) [diffView lessContext];
	else [[historyDetailsContainerView barView] lessContext];
}

- (void) commitDetails:(id) sender {
	NSLog(@"details");
}

- (void) commitTree:(id) sender {
	NSLog(@"tree");
}

#pragma mark NSDocument methods
- (NSString *) windowNibName {
	return @"GittyDocument";
}

- (BOOL) readFromFileWrapper:(NSFileWrapper *) fileWrapper ofType:(NSString *) typeName error:(NSError **) outError {
	BOOL passes = true;
	NSString * filename = [[self fileURL] path];
	NSString * realGitPath = [git gitProjectPathFromRevParse:filename];
	if(realGitPath is nil) passes = false;
	if(!passes) {
		if(outError is nil) return NO;
		NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
		[userInfo setObject:NSLocalizedStringFromTable(@"It doesn't appear to be a git repository.",@"Localized",@"not a git repo directory")
					 forKey:NSLocalizedRecoverySuggestionErrorKey];
		(*outError) = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:0 userInfo:userInfo];
		passes = FALSE;
	}
	if(passes) {
		NSURL * furl = [NSURL fileURLWithPath:realGitPath isDirectory:true];
		[self setFileURL:furl];
		[git setGitProjectPath:realGitPath];
	}
	return passes;
}

#pragma mark dealloc
- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GittyDocument\n");
	#endif
	[fileEvents stopWatchingPaths];
	[fileEvents release];
	if(lastMainWindow==gtwindow)lastMainWindow=nil;
	justLaunched=false;
	runningExpiredModal=false;
	[operations release];
	[contextMenus release];
	[mainMenuHelper release];
	[git release];
	[gitd release];
	[activeBranchView release];
	[sourceListView release];
	[splitContentView release];
	[statusBarView release];
	[diffView release];
	[historyDetailsContainerView release];
	[historyView release];
	[advancedDiffView release];
	[super dealloc];
}

@end

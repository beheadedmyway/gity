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
#import "GTQuickLookItem.h"
#import "GTActiveBranchTableView.h"
#import "GTCloneRepoController.h"

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
@synthesize remoteController;
@synthesize singleInput;
@synthesize configView;
@synthesize trackBranchController;
@synthesize remoteView;
@synthesize fetchTags;
@synthesize sounds;
@synthesize submoduleController;
@synthesize commitAfterAdd;
@synthesize diffView;

#pragma mark initializations

- (void) awakeFromNib {
	isTerminatingFromSessionExpired = false;
	justLaunched = true;
	runningExpiredModal = false;
	gitd = [[GTGitDataStore alloc] initWithGD:self];
	sounds = [GTSoundController sharedInstance];
	contextMenus = [[GTContextMenuController alloc] initWithGD:self];
	mainMenuHelper = [[GTMainMenuHelper alloc] initWithGD:self];
	operations = [[GTOperationsController alloc] initWithGD:self];
	
	[gitd setRefs];
}

- (id) init {
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	self = [super init];
		
	git = [[GTGitCommandExecutor alloc] init];
	
	[self initNotifications];
	
	return self;
}

- (void) initNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:NSApplicationWillBecomeActiveNotification object:nil];
}

#pragma mark licensing / expiration methods.

- (void) expireSession {
	if(runningExpiredModal) {
		return;
	}
	
	isTerminatingFromSessionExpired =true;
	runningExpiredModal=true;
	
	[operations cancelAll];
	[operations cancelNetworkOperations];
	[[GTModalController sharedInstance] runDocumentExpired];
	
	[[NSApplication sharedApplication] terminate:nil];
}

#pragma mark window, and application helpers

- (NSInteger) shouldCloseNow {
	if(isTerminatingFromSessionExpired) {
		return true;
	}
	
	if([gitd isHeadDetatched]) {
		return true;
	}
	
	if([[gitd commitsAhead] isEqual:@"0"]) {
		return true;
	}
	
	NSString *remote = [gitd defaultRemoteForBranch:[gitd activeBranchName]];
	
	if([[gitd commitsAhead] isEqual:@"1"]) {
		return [[GTModalController sharedInstance] runCloseCommitsAheadForSingleModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
	}
	
	return [[GTModalController sharedInstance] runCloseCommitsAheadModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
}

- (NSInteger) shouldQuitNow {
	if(isTerminatingFromSessionExpired) {
		return true;
	}
	
	if([gitd isHeadDetatched]) {
		return true;
	}
	
	if([[gitd commitsAhead] isEqual:@"0"]) {
		return true;
	}
	
	NSString *remote = [gitd defaultRemoteForBranch:[gitd activeBranchName]];
	
	if([[gitd commitsAhead] isEqual:@"1"]) {
		return [[GTModalController sharedInstance] runCommitsAheadForSingleModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
	}
	
	return [[GTModalController sharedInstance] runCommitsAheadModalWithCount:[gitd commitsAhead] andRemote:remote andBranch:[gitd activeBranchName]];
}

#pragma mark window delegate methods and other methods that wait or react to some window operation.

- (void) windowControllerDidLoadNib:(NSWindowController *) controller {
	[super windowControllerDidLoadNib:controller];
	
	[gtwindow setFrameAutosaveName:[git gitProjectPath]];
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
	[remoteController lazyInitWithGD:self];
	[submoduleController lazyInitWithGD:self];
	[unknownError lazyInitWithGD:self];
	[trackBranchController lazyInitWithGD:self];
	[fetchTags lazyInitWithGD:self];
	[historySearch lazyInitWithGD:self];
	[[[GTModalController sharedInstance] cloneRepoController] lazyInitWithGD:self];
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
	
	[splitContentView show];
	[sourceListView show];
	[stateBarView show];
	[activeBranchView show];
			
	[self waitForWindow];
}

- (void)pathWatcher:(SCEvents *)pathWatcher multipleEventsOccurred:(NSArray *)events
{
	[self updateAfterFilesChanged:nil];
}

- (BOOL) windowShouldClose:(id) sender {
	if([[NSUserDefaults standardUserDefaults] boolForKey:kGTIgnoreCommitsAhead]) {
		return true;
	}
	
	NSInteger res = [self shouldCloseNow];
	
	if(res == NSCancelButton) {
		return false;
	}
	
	return true;
}

- (void) windowWillClose:(NSNotification *) notification {
	[operations cancelAll];
	[historyView removeObservers];
	[sourceListView removeObservers];
}

- (void) windowDidBecomeMain:(NSNotification *) notification {
	if(justLaunched) {
		justLaunched = false;
		return;
	}
		
	[mainMenuHelper invalidate];
	
	// we're using FSEvents now, this shouldn't be needed anymore.
	
	[self updateAfterFilesChanged:nil];
}

- (IBAction) updateAfterFilesChanged:(id)sender {
	
	// lets make sure this is on the main thread due to FSEvents
	
	if ([NSThread isMainThread]) {
		needsFileUpdates = YES;
		
		if([self isCurrentViewConfigView]) {
			if([configView isOnGlobalConfig]) {
				[operations runGetGlobalConfigs];
			}
			else { 
				[operations runGetConfigs];
			}
		}
		else if([self isCurrentViewHistoryView]) {
			[historyView invalidate];
		} 
		else {
			[operations runRefreshOperation];
			needsFileUpdates = NO;
		}
	} 
	else {
		
		// lets call it on the main thread.
		
		[self performSelectorOnMainThread:@selector(updateAfterFilesChanged:) withObject:nil waitUntilDone:NO];
	}

}

- (void) waitForWindow {
	if(![gtwindow isVisible]) {
		[NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(waitForWindow) userInfo:nil repeats:false];
	}
	else {
		[self windowReady];
	}
}

- (void) windowReady {
	[self runStartupOperation];
}

- (void) adjustMinWindowSize {
	return;
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
	if ([[theItem itemIdentifier] isEqualToString:@"addIdentifier"] || [[theItem itemIdentifier] isEqualToString:@"addCommitIdentifier"] || [[theItem itemIdentifier] isEqualToString:@"commitIdentifier"]) {
		if([activeBranchView selectedFilesCount] < 1 || [gitd isHeadDetatched]) {
			return NO;
		}
	}
	
	return YES;
}

#pragma custom getters

- (GTModalController *) modals {
	return [GTModalController sharedInstance];
}

#pragma mark operations

- (void) runStartupOperation {
	[status showStartupIndicator];
	[operations runStartupOperation];
}

#pragma mark application notifications

- (void) applicationWillBecomeActive {
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

- (IBAction) focusOnSearch:(id) sender {
	[stateBarView focusOnSearch];
}

- (IBAction) reload:(id) sender {
	if([self isCurrentViewActiveBranchView]) {
		[operations runRefreshOperation];
	}
	else if([self isCurrentViewConfigView]) {
		[configView reload];
	}
	else if([self isCurrentViewHistoryView]) {
		[historyView invalidate];
	}
}

- (IBAction) showDifferView:(id) sender {
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

- (IBAction) showActiveBranch:(id) sender {
	[self showActiveBranchWithDiffUpdate:true forceIfAlreadyActive:false];
}

- (void) showActiveBranchWithDiffUpdate:(BOOL) _invalidateDiffView forceIfAlreadyActive:(BOOL) _force {
	if([self isCurrentViewActiveBranchView] && !_force) return;
	
	[sourceListView selectActiveBranch];
	[toolbar setSelectedItemIdentifier:@"changesIdentifier"];
	[advancedDiffView hide];
	[historyView hide];
	[historyDetailsContainerView hide];
	[configView hide];
	[activeBranchView activateTableView];
	
	if(isSourceListHidden) {
		[contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0, 22, 0, -50)];
	}
	else {
			[contentHSplitView showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
	}
	
	/*if([gitd isHeadDetatched]) {
		[stateBarView showDetatchedHeadState];
	}
	else {*/
		[stateBarView showActiveBranchState];
	//}
	
	[statusBarView updateAfterViewChange];
	[activeBranchView showInView:topSplitView];
	[diffView showInView:bottomSplitView];
	[statusBarView invalidateSelfFrame];
	
	if(_invalidateDiffView) {
		[diffView invalidate];
	}
	
	[mainMenuHelper invalidate];
	[contextMenus invalidate];
	
	if (needsFileUpdates) {
		[self updateAfterFilesChanged:nil];
	}
}

- (void) showRemoteViewForRemote:(NSString *) remote {
	return;
}

- (IBAction) showHistory:(id) sender {
	/*if([gitd isHeadDetatched]) {
		[self showHistoryFromRef:[gitd currentAbbreviatedSha]];
	}
	else {
		[self showHistoryFromRef:[gitd activeBranchName]];
	}*/
	GTSourceListItem *item = [sourceListView selectedItem];
	if (item.parent == sourceListView.rootItem || item.parent == sourceListView.tagsItem ||
		item.parent == sourceListView.branchesItem || item.parent == sourceListView.remotesItem)
		[self showHistoryFromRef:[sourceListView selectedItemName]];
}

- (void) showHistoryFromRef:(NSString *) _refName {
	if([sourceListView wasJustUpdated]) {
		return;
	}
	
	BOOL shouldInvalidateHistory = false;
	BOOL shouldDoShow = false;
	
	[toolbar setSelectedItemIdentifier:@"historyIdentifier"];
	
	if(![[historyView currentRef] isEqual:_refName]) {
		[historyView setHistoryRefName:_refName];
		
		shouldInvalidateHistory = true;
	}
	
	if(![self isCurrentViewHistoryView]) {
		shouldDoShow = true;
	}
	
	if(shouldDoShow) {
		[advancedDiffView hide];
		[activeBranchView hide];
		[statusBarView hide];
		[diffView hide];
		[configView hide];
		
		if(isSourceListHidden) {
			[contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0, 22, 0, -50)];
		}
		else {
			[contentHSplitView showInView:rightView withAdjustments:NSMakeRect(0, 0, 0, -28)];
		}
		
		[stateBarView showHistoryStateWithRefName:_refName];
		[historyView showInView:topSplitView];
		[historyDetailsContainerView showInView:bottomSplitView];
		[mainMenuHelper invalidate];
		[contextMenus invalidate];
		[historyView activateTableView];
	}
	
	if(shouldInvalidateHistory) {
		if(!shouldDoShow) {
			[stateBarView showHistoryStateWithRefName:_refName];
		}
		
		[historyView invalidate];
	}
}

- (IBAction) showConfig:(id) sender {
	[operations runGetConfigs];
}

- (IBAction) showGlobalConfig:(id) sender {
	[operations runGetGlobalConfigs];
}

- (IBAction) toggleSourceList:(id) sender {
	NSMenuItem *item = (NSMenuItem *) sender;
	
	if([[item title] isEqual:@"Show Source List"]) {
		[item setTitle:@"Hide Source List"];
		[self showSourceList];
	} 
	else {
		[item setTitle:@"Show Source List"];
		[self hideSourceList];
	}
}

- (void) showSourceList {
	isSourceListHidden = false;
	
	[contentHSplitView removeFromSuperview];
	[[gtwindow contentView] addSubview:splitContentView];
	[stateBarView show];
	
	if([self isCurrentViewActiveBranchView]) {
		[self showActiveBranchWithDiffUpdate:false forceIfAlreadyActive:true];
	} 
	else if([self isCurrentViewHistoryView]) {
		[self showHistory:nil];
	} 
	else if([self isCurrentViewConfigView]) {
		[self showConfig:nil];
	}
}

- (void) hideSourceList {
	isSourceListHidden = true;
	
	[splitContentView removeFromSuperview];
	[contentHSplitView showInView:[gtwindow contentView] withAdjustments:NSMakeRect(0, 22, 0, -50)];
	[stateBarView showWithHiddenSourceList];
	
	if([self isCurrentViewConfigView]) {
		[configView show];
	}
}

#pragma mark operation result, and operation callback/complete methods.

- (void) unknownErrorFromOperation:(NSString *) error {
    NSString *formattedError = [error stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
    
	if(![gtwindow isVisible] || [status isShowingSheet]) {
		GDRelease(_tmpUnknownError);
		
		_tmpUnknownError = [formattedError copy];
		
		[self tryToShowUnknownError];
	} 
	else {
		[unknownError showAsSheetWithError:formattedError];
	}
}

- (void) gitErrorFromOperation:(NSString *) error {
	if(![gtwindow isVisible] || [status isShowingSheet]) {
		GDRelease(_tmpUnknownError);
		
		_tmpUnknownError = [error copy];
		
		[self tryToShowUnknownError];
	}
	else {
		[unknownError showAsSheetWithError:error];
	}
}


- (void) tryToShowUnknownError {
	if(![gtwindow isVisible] || [status isShowingSheet]) {
		[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(tryToShowUnknownError) userInfo:nil repeats:false];
	} 
	else {
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
	[operations runNewSubmodule:[submoduleController submoduleURL] inLocalDir:[submoduleController submoduleDestination] withName:[submoduleController submoduleName]];
}

- (void) onStatusBarFilesToggled {
	[activeBranchView updateFromStatusBarView];
	[diffView invalidate];
}

- (void) onActiveBranchViewSelectionChange {
	[mainMenuHelper invalidate];
	[contextMenus invalidateActiveBranchViewMenus];
	[diffView invalidate];
	
	if ([[QLPreviewPanel sharedPreviewPanel] isVisible]) {
		[self quickLook:nil];
	}
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
    
    [self reload:nil];
}

- (void) onRefreshOperationComplete {
	if([self isCurrentViewActiveBranchView]) {
		/*if([gitd isHeadDetatched]) {
			[stateBarView showDetatchedHeadState];
		}
		else {*/
			[stateBarView showActiveBranchState];
		//}
	}
	
	[statusBarView update];
	[activeBranchView update];
	[diffView invalidate];
	[mainMenuHelper invalidate];
	[contextMenus invalidate];

	if (commit.addBeforeCommit) {
		[commit finishTwoStageCommit];
	}
	
	[sourceListView update];
	[operations runGetCommitsAheadWithoutSpinner];
	
	// update the history...
	
	[historyView invalidate];
}

- (void) onRefreshMetaOperationComplete {
	[sourceListView update];
	[activeBranchView update];
	[mainMenuHelper invalidate];
}

- (void) onGotLooseObjectsCount {
	if([gitd looseObjects] > 1000) {
		[[GTModalController sharedInstance] runLooseObjectCountReminder];
	}
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
	if([remoteController lastButtonValue] == NSCancelButton) {
		return;
	}
	
	[operations runNewRemote:[remoteController remoteNameValue] withURL:[remoteController remoteURLValue]];
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
	[trackBranchController updateRemoteBranchNames];
}

- (void) onGotRemoteTags {
	[fetchTags updateRemoteTagNames];
}

- (void) onFetchTagComplete {
}

- (void) onGitAddComplete {
}

#pragma mark search helper methods

- (void) search:(NSString *) term {
	isSearching = true;
	
	if([self isCurrentViewHistoryView]) {
		[historyView search:term];
	}
	
	if([self isCurrentViewActiveBranchView]) {
		[activeBranchView search:term];
	}
}

- (void) onSearch {
	[diffView invalidate];
}

- (void) clearSearch {
	isSearching = false;
	
	[historyView clearSearch];
	[activeBranchView clearSearch];
	
	if([self isCurrentViewHistoryView]) {
		[historyDetailsContainerView invalidate];
	}
}

- (void) onClearSearch {
	[diffView invalidate];
}

- (void) clearSearchField {
	[stateBarView clearSearchField];
}

- (IBAction) clearSearchHistory:(id) sender {
	[historyFilteredView close];
}

- (IBAction) searchHistory:(id) sender {
	[historySearch showAsSheet];
}

#pragma mark git* methods - these are methods that are called from other controllers, or from the main menu.

- (IBAction) gitApplyPatch:(id) sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	
	[op setCanChooseDirectories:false];
	[op setCanChooseFiles:true];
    
    [op setAllowedFileTypes:[NSArray arrayWithObjects:@"patch",@"diff",nil]];
	
	NSInteger res = [op runModal];
	
	if(res == NSCancelButton) {
		return;
	}
	
    NSURL *url = [op URL];
	NSString *patchFile = [[url path] copy];
	
	[operations runPatchApplyWithFile:patchFile];
	
	[patchFile release];
}

- (IBAction) gitGarbageCollect:(id) sender {
	[operations runGarbageCollect];
}

-(IBAction) gitAggresiveGarbageCollect:(id) sender {
	[operations runAggressiveGarbageCollect];
}

- (IBAction) gitAdd:(id) sender {
	if([activeBranchView selectedFilesCount] < 1) {
		return;
	}
	
	commitAfterAdd = false;
	
	[operations runAddFilesOperation];
}


- (IBAction) gitAddAndCommit:(id) sender {
	if([activeBranchView selectedFilesCount] < 1) {
        NSBeep();
        [[GTModalController sharedInstance] runSelectFilesFirst];
		return;
	}
    
	commit.addBeforeCommit = true;
	
	[self gitCommit:nil];
}

- (IBAction) gitPackRefs:(id) sender {
	[operations runPackRefs];
}

- (IBAction) gitPackObjects:(id) sender {
	[operations runPackObjects];
}

- (IBAction) gitCommit:(id) sender {
    
	if([gitd isConflicted]) {
		NSBeep();
		[[GTModalController sharedInstance] runConflictedStateForCheckout];
		return;
	}
	
	if([gitd stagedFilesCount] < 1 && !commit.addBeforeCommit) {
		[self gitAddAndCommit:nil];
		return;
	}
	
	[commit showAsSheet];
}

- (IBAction) gitRemove:(id) sender {
	if([[GTModalController sharedInstance] verifyGitRemove] == NSCancelButton) {
		return;
	}
	
	[operations runRemoveFilesOperation];
}

- (IBAction) gitHardReset:(id) sender {
	[sourceListView branchHardReset:sender];
}

- (IBAction) gitSoftReset:(id) sender {
	[sourceListView branchDiscardNonStagedChanges:sender];
}

- (IBAction) gitDiscardChanges:(id) sender {
	[operations runDiscardChangesOperation];
}

- (IBAction) gitDestage:(id) sender {
	[operations runDestageOperation];
}

- (void) gitCheckout:(NSString *) branch {
	[operations runBranchCheckout:branch];
}

- (IBAction) gitCheckoutCommit:(id) sender {
	GTGitCommit *selectedCommit = [historyView selectedItem];
	if (selectedCommit)
	{
		NSString *branch = selectedCommit.hash;
		if ([historyView selectedRow] == 0)
		{
			GTSourceListItem *selectedItem = [sourceListView selectedItem];
			if (selectedItem.parent == [sourceListView branchesItem])
				branch = [sourceListView selectedItemName];
		}
		[operations runBranchCheckout:branch];
	}
}

- (IBAction) gitFetch:(id) sender {
	[operations runFetch];
}

- (IBAction) gitIgnore:(id) sender {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if(files is nil) {
		NSBeep();
		return;
	}
	
	[operations runIgnoreFiles:files];
}

- (IBAction) gitIgnoreExtension:(id) sender {
	NSString *ext = [activeBranchView getSelectedFileExtension];
	
	if([ext isEqual:@""]) {
		return;
	}
	
	[operations runIgnoreExtension:ext];
}

- (IBAction) gitIgnoreDir:(id) sender {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if(files is nil) {
		NSBeep();
		return;
	}
	
	NSString *f = [[files objectAtIndex:0] stringByDeletingLastPathComponent];
	
	if([f isEmpty]) {
		NSBeep();
		return;
	}
	
	[operations runIgnoreFiles:[NSMutableArray arrayWithObject:[f stringByAppendingString:@"/"]]];
}

- (IBAction) gitNewRemote:(id) sender {
	[remoteController showAsSheetWithCallback:self action:@selector(onNewRemoteComplete)];
}

- (IBAction) gitNewSubmodule:(id) sender {
	[submoduleController showAsSheetWithCallback:self action:@selector(onNewSubmoduleComplete)];
}

- (void) gitNewBranch:(NSString *) startBranch {
	_tmpBranchStartName = [startBranch copy];
	
	[singleInput setSheetTitleValue:@"New Branch"];
	[singleInput setInputLabelValue:@"Enter a name for the new branch (no spaces)"];
	[singleInput setShowsCheckoutCheckbox:true];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewBranchComplete)];
}

- (IBAction) gitNewBranchFromActiveBranch:(id) sender {
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

- (IBAction) gitNewTagFromActiveBranch:(id) sender {
	_tmpTagStartPoint = [[gitd activeBranchName] copy];
	
	[singleInput setSheetTitleValue:@"New Tag"];
	[singleInput setInputLabelValue:@"Enter a name for the new tag (no spaces)"];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewTagComplete)];
}

- (IBAction) gitNewEmptyBranch:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[[GTModalController sharedInstance] runConflictedStateForCheckout];
		return;
	}
	
	if([gitd isDirty]) {
		[[GTModalController sharedInstance] runDirIsDirtyForEmptyBranch];
		return;
	}
	
	[singleInput setSheetTitleValue:@"New Empty Branch"];
	[singleInput setInputLabelValue:@"Enter a name for the new empty branch (no spaces)"];
	[singleInput showAsSheetWithCallback:self action:@selector(onNewEmptyBranchComplete)];
}

- (IBAction) gitStashLocalChanges:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[[GTModalController sharedInstance] runConflictedStateForCheckout];
		return;
	}

	[singleInput setAllowsSpaces:true];
	[singleInput setSheetTitleValue:@"Stash Local Changes"];
	[singleInput setInputLabelValue:@"Enter a short description for this stash"];
	[singleInput showAsSheetWithCallback:self action:@selector(onStashComplete)];
}

- (IBAction) gitUpdateAllSubmodules:(id) sender {
	[operations runSubmoduleUpdateAll];
}

- (IBAction) gitInitializeAllSubmodules:(id) sender {
	[operations runSubmoduleInitAll];
}

- (IBAction) gitPushFromMenu:(id) sender {
	[sourceListView gitPushFromActiveBranch];
}

- (IBAction) gitPullFromMenu:(id) sender {
	[sourceListView gitPullFromActiveBranch];
}

- (IBAction) gitRebaseFromMenu:(id) sender {
	[sourceListView gitRebaseFromActiveBranch];
}

- (IBAction) gitFetchTags:(id) sender {
	[fetchTags showAsSheetWithCallback:self action:@selector(onFetchTagComplete)];
}

#pragma mark other actions.

- (IBAction) newRemoteTrackingBranch:(id) sender {
	[trackBranchController showAsSheetWithCallback:self action:@selector(onNewRemoteTrackBranchComplete)];
}

- (IBAction) resolveConflictsWithFileMerge:(id) sender {
	NSString *fle = [[activeBranchView selectedFiles] objectAtIndex:0];
	
	if([activeBranchView selectedFilesCount] == 0 || [activeBranchView selectedFilesCount] > 1) {
		return;
	}
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/opendiff"]) {
		[[GTModalController sharedInstance] runCantFindFileMerge];
		return;
	}
	
	[[GTModalController sharedInstance] runRemindQuitFileMerge];
	
	fixingConflict = true;
	
	[operations runOpenFileMergeForFile:fle];
}

- (IBAction) openProjectInTextmate:(id) sender {
	NSString *matePath = nil;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/local/bin/mate"]) {
		matePath = @"/usr/local/bin/mate";
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/mate"]) {
		matePath = @"/usr/bin/mate";
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/opt/local/bin/mate"]) {
		matePath = @"/opt/local/bin/mate";
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/mate"]) {
		matePath = @"/bin/mate";
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/X11/bin/mate"]) {
		matePath = @"/usr/X11/bin/mate";
	}
	
	if(matePath == nil) {
		[[GTModalController sharedInstance] runCantFindTextmateBinary];
		
		return;
	}
	
	NSTask *task = [[NSTask alloc] init];
	NSMutableArray *args = [[NSMutableArray alloc] init];
	
	[args addObject:[git gitProjectPath]];
	
	[task setLaunchPath:matePath];
	[task setArguments:args];
	[task launch];
	[task waitUntilExit];
	[task release];
	
	task = nil;
	
	[args release];
}

- (IBAction) openFile:(id) sender {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	NSString *fullPath = [[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]];
	
	[workspace openFile:fullPath];
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
	return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if([files count] > 1 or [files count] < 1) {
		return [[[GTQuickLookItem alloc] initWithPath:nil] autorelease];;
	}
	
	NSString *fullPath = [[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]];
	
	return [[[GTQuickLookItem alloc] initWithPath:fullPath] autorelease];
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
	return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
}

- (IBAction) quickLook:(id) sender {
	if ([sender isKindOfClass:[GTActiveBranchTableView class]] && [[QLPreviewPanel sharedPreviewPanel] isVisible])
	{
		// if the quicklook panel is up, and they hit space in the branch view, dismiss it.
		[[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
		return;
	}
	
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	
	[[QLPreviewPanel sharedPreviewPanel] updateController];
	[[QLPreviewPanel sharedPreviewPanel] setDataSource:self];
	[[QLPreviewPanel sharedPreviewPanel] reloadData];
	[[QLPreviewPanel sharedPreviewPanel] refreshCurrentPreviewItem];
	[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
}

- (IBAction) openInFinder:(id) sender {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	NSString *fullPath = [[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]];
	
	[workspace selectFile:fullPath inFileViewerRootedAtPath:nil];
}

- (IBAction) openContainingFolder:(id) sender {
	NSMutableArray *files = [activeBranchView selectedFiles];
	
	if([files count] > 1 or [files count] < 1) {
		NSBeep();
		return;
	}
	
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	NSString *fullPath = [[[git gitProjectPath] stringByAppendingPathComponent:[files objectAtIndex:0]] stringByDeletingLastPathComponent];
	
	[workspace selectFile:fullPath inFileViewerRootedAtPath:nil];
}

- (IBAction) openInTerminal:(id)sender {
	TerminalApplication *terminal = [SBApplication applicationWithBundleIdentifier: @"com.apple.Terminal"];
	NSString *workingDirectory = [[git gitProjectPath] stringByAppendingString:@"/"];
	NSString *shellCommand = [NSString stringWithFormat: @"cd \"%@\"; clear; git status", workingDirectory];
	
	[terminal doScript:shellCommand in:nil];
	[NSThread sleepForTimeInterval: 0.1];
	[terminal activate];
}


- (IBAction) moveToTrash:(id) sender {
	NSBeep();
	
	if([[GTModalController sharedInstance] runMoveToTrashConfirmation] == NSCancelButton) {
		return;
	}
	
	NSMutableArray *trash = [activeBranchView selectedFiles];
	
	if(trash is nil) {
		return;
	}
	
	NSString *fs;
	NSString *fullPath;
	
	for(fs in trash) {
		fullPath = [[git gitProjectPath] stringByAppendingPathComponent:fs];
		[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation source:[fullPath stringByDeletingLastPathComponent] destination:nil files:[NSArray arrayWithObject:[fullPath lastPathComponent]] tag:NULL];
	}
	
	[operations runRefreshOperation];
}

- (IBAction) toggleAllFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[statusBarView toggleAllFiles];
	[diffView invalidate];
}

- (IBAction) toggleStagedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleStagedFiles];
}

- (IBAction) toggleUntrackedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleUntrackedFiles];
}

- (IBAction) toggleModifiedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleModifiedFiles];
}

- (IBAction) toggleDeletedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleDeletedFiles];
}

- (IBAction) toggleConflictedFiles:(id) sender {
	if(![self isCurrentViewActiveBranchView]) {
		NSBeep();
		return;
	}
	
	[mainMenuHelper invalidateViewMenu];
	[activeBranchView activateTableView];
	[statusBarView toggleConflictedFiles];
}

- (IBAction) moreContext:(id) sender {
	if([self isCurrentViewActiveBranchView]) {
		[diffView moreContext];
	}
	else {
		[[historyDetailsContainerView barView] moreContext];
	}
}

- (IBAction) lessContext:(id) sender {
	if([self isCurrentViewActiveBranchView]) {
		[diffView lessContext];
	}
	else {
		[[historyDetailsContainerView barView] lessContext];
	}
}

- (IBAction) commitDetails:(id) sender {
	NSLog(@"details");
}

- (IBAction) commitTree:(id) sender {
	NSLog(@"tree");
}

#pragma mark NSDocument methods

- (NSString *) windowNibName {
	return @"GittyDocument";
}

- (BOOL) readFromFileWrapper:(NSFileWrapper *) fileWrapper ofType:(NSString *) typeName error:(NSError **) outError {
	BOOL passes = true;
	NSString *filename = [[self fileURL] path];
	NSString *realGitPath = [git gitProjectPathFromRevParse:filename];
	
	if(realGitPath is nil) {
		passes = false;
	}
	
	if(!passes) {
		if(outError is nil) {
			return NO;
		}
		
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		
		[userInfo setObject:NSLocalizedStringFromTable(@"It doesn't appear to be a git repository.",@"Localized",@"not a git repo directory") forKey:NSLocalizedRecoverySuggestionErrorKey];
		(*outError) = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:0 userInfo:userInfo];
		passes = FALSE;
	}

	if(passes) {
		NSURL *furl = [NSURL fileURLWithPath:realGitPath isDirectory:true];
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
		
	justLaunched = false;
	runningExpiredModal = false;
	
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

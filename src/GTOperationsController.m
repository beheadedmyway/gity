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

#import "GTOperationsController.h"
#import "GTDocumentController.h"

static BOOL isRunningWithValidLicense = false;
static NSInteger maxOperationRunCount = 20;
static NSInteger operationRunCount = 0;

@implementation GTOperationsController

+ (void) updateLicenseRunStatus:(BOOL) _isRunningWithValidLicense {
	isRunningWithValidLicense = _isRunningWithValidLicense;
}

- (id) initWithGD:(GittyDocument *) _gd {
	self = [super initWithGD:_gd];
	showStatusForHistoryLoadMutex = [[NSObject alloc] init];
	status = [gd status];
	cancelables = [[NSMutableArray alloc] init];
	networkCancelables = [[NSMutableArray alloc] init];

	return self;
}

- (void) showStatusLoaderForHistoryLoading {
	@synchronized(showStatusForHistoryLoadMutex) {
		if(!showStatusForHistoryLoad) return;
		[status performSelectorOnMainThread:@selector(showStatusIndicator) withObject:nil waitUntilDone:false];
	}
}

- (void) hideStatusLoaderForHistoryLoading {
	@synchronized(showStatusForHistoryLoadMutex) {
		if(showStatusForHistoryLoad) [status performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:false];
		showStatusForHistoryLoad=false;
	}
}

- (void) incrementRunCount {
	#ifdef kGTGityNoLicenseRequired
	return;
	#endif
	if(isRunningWithValidLicense) return;
	if(operationRunCount == maxOperationRunCount) {
		[gd expireSession];
		return;
	}
	operationRunCount++;
}

- (void) runStartupOperation {
	if(isRunningStartup) return;
	if(allCanceled) return;
	isRunningStartup = true;
	NSOperation * op = [[NSOperation alloc] init];
	[op setCompletionBlock:^{
		[op release];
		[self onStartupOperationComplete];
	}];
	GTOpMetaStatus * meta = [[[GTOpMetaStatus alloc] initWithGD:gd] autorelease];
	GTOpGetFiles * allFiles = [[[GTOpGetFiles alloc] initWithGD:gd] autorelease];
	GTOpStatus * stat = [[[GTOpStatus alloc] initWithGD:gd] autorelease];
	GTOpGetActiveBranchName * activeBranchName = [[[GTOpGetActiveBranchName alloc] initWithGD:gd] autorelease];
	[op addDependency:allFiles];
	[op addDependency:stat];
	[op addDependency:meta];
	[op addDependency:activeBranchName];
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	[q addOperation:allFiles];
	[q addOperation:activeBranchName];
	[q addOperation:stat];
	[q addOperation:meta];
	[cancelables addObject:q];
	[q release];
}

- (void) runRefreshOperation {
	if(isRunningRefresh) return;
	if(allCanceled) return;
	isRunningRefresh = true;
	[status showSpinner];
	NSOperation * op = [[NSOperation alloc] init];
	[op setCompletionBlock:^{
		[op release];
		[self onRefreshOperationComplete];
	}];
	GTOpMetaStatus * meta = [[[GTOpMetaStatus alloc] initWithGD:gd] autorelease];
	GTOpGetFiles * allFiles = [[[GTOpGetFiles alloc] initWithGD:gd] autorelease];
	GTOpStatus * stat = [[[GTOpStatus alloc] initWithGD:gd] autorelease];
	GTOpGetActiveBranchName * activeBranchName = [[[GTOpGetActiveBranchName alloc] initWithGD:gd] autorelease];
	[op addDependency:stat];
	[op addDependency:allFiles];
	[op addDependency:meta];
	[op addDependency:activeBranchName];
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	[q addOperation:stat];
	[q addOperation:allFiles];
	[q addOperation:meta];
	[q addOperation:activeBranchName];
	[cancelables addObject:q];
	[q release];
}

- (void) runRefreshStatusOperation {
	if(isRunningRefresh) return;
	if(allCanceled) return;
	isRunningRefresh = true;
	[status showSpinner];
	NSOperation * op = [[NSOperation alloc] init];
	[op setCompletionBlock:^{
		[op release];
		[self onRefreshStatusComplete];
	}];
	GTOpGetFiles * allFiles = [[[GTOpGetFiles alloc] initWithGD:gd] autorelease];
	GTOpStatus * stat = [[[GTOpStatus alloc] initWithGD:gd] autorelease];
	[op addDependency:stat];
	[op addDependency:allFiles];
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	[q addOperation:stat];
	[q addOperation:allFiles];
	[cancelables addObject:q];
	[q release];
}

- (void) runRefreshMetaOperation {
	if(isRunningMetaRefresh) return;
	if(allCanceled) return;
	isRunningMetaRefresh = true;
	[status showSpinner];
	NSOperation * op = [[[NSOperation alloc] init] autorelease];
	[op setCompletionBlock:^{
		[self onRefreshMetaComplete];
	}];
	GTOpMetaStatus * meta = [[[GTOpMetaStatus alloc] initWithGD:gd] autorelease];
	GTOpGetActiveBranchName * activeBranchName = [[[GTOpGetActiveBranchName alloc] initWithGD:gd] autorelease];
	[op addDependency:meta];
	[op addDependency:activeBranchName];
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	[q addOperation:meta];
	[q addOperation:activeBranchName];
	[cancelables addObject:q];
	[q release];
}

- (NSOperationQueue *) newCancelableQueueWithOperation:(NSOperation *) op {
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	[cancelables addObject:q];
	return q;
}

- (void) removeOpQueueFromCancelables:(NSOperationQueue *) q {
	@synchronized(self)
	{
		if (cancelables)
			if ([cancelables containsObject:q])
				[cancelables removeObject:q];
	}
}

- (void) releaseAndRemoveQFromCancelables:(NSOperationQueue *) q {
	@synchronized(self)
	{
		if (cancelables)
			if ([cancelables containsObject:q])
				[cancelables removeObject:q];
		[q release];
	}
}

- (NSOperationQueue *) newCancelableQueueWithNetworkOperation:(NSOperation *) op {
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:op];
	@synchronized(self)
	{
		[cancelables addObject:q];
		[networkCancelables addObject:q];
	}
	return q;
}

- (void) removeOpQueueFromCancelablesAndNetworkCancelables:(NSOperationQueue *) q {
	@synchronized(self)
	{
		[cancelables removeObject:q];
		[networkCancelables removeObject:q];
	}
}

- (void) releaseAndRemoveQFromCancelablesAndNetworkCancelables:(NSOperationQueue *) q {
	@synchronized(self)
	{
		[networkCancelables removeObject:q];
		[q release];
	}
}

- (void) runAddFilesOperation {
	if(allCanceled) return;
	if(isRunningAddFiles) return;
	isRunningAddFiles=true;
	GTOpAddFiles * adds = [[[GTOpAddFiles alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:adds];
	[adds setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onAddFilesComplete];
	}];
}

- (void) runCommitOperationWithFiles:(NSArray *)files {
	if(allCanceled) return;
	if(isRunningCommit) return;
	isRunningCommit=true;
	[status showSpinner];
	GTOpCommit * commit = [[[GTOpCommit alloc] initWithGD:gd andFiles:files] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:commit];
	[commit setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCommitComplete];
	}];
}

- (void) runCommitOperation {
	if(allCanceled) return;
	if(isRunningCommit) return;
	isRunningCommit=true;
	[status showSpinner];
	GTOpCommit * commit = [[[GTOpCommit alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:commit];
	[commit setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCommitComplete];
	}];
}

- (void) runRemoveFilesOperation {
	if(allCanceled) return;
	if(isRunningRemove) return;
	isRunningRemove=true;
	GTOpRemove * remove = [[[GTOpRemove alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:remove];
	[remove setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onRemoveComplete];
	}];
}

- (void) runDestageOperation {
	if(allCanceled) return;
	if(isRunningDestage) return;
	isRunningDestage=true;
	GTOpDestage * destage = [[[GTOpDestage alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:destage];
	[destage setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDestageComplete];
	}];
}

- (void) runDiscardChangesOperation {
	if(allCanceled) return;
	if(isRunningDiscard) return;
	isRunningDiscard=true;
	GTOpDiscardChanges * discard = [[[GTOpDiscardChanges alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:discard];
	[discard setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDiscardComplete];
	}];
}

- (void) runStashApply:(NSInteger) stashIndex {
	if(allCanceled) return;
	[status showSpinner];
	GTOpStashApply * apply = [[[GTOpStashApply alloc] initWithGD:gd andStashIndex:stashIndex] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:apply];
	[apply setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onStashApplyComplete];
	}];
}

- (void) runStashPop:(NSInteger) stashIndex {
	if(allCanceled) return;
	[status showSpinner];
	GTOpStashPop * pop = [[[GTOpStashPop alloc] initWithGD:gd andStashIndex:stashIndex] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:pop];
	[pop setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onStashPopComplete];
	}];
}

- (void) runStashDelete:(NSInteger) stashIndex {
	if(allCanceled) return;
	[status showSpinner];
	GTOpStashDelete * delete = [[[GTOpStashDelete alloc] initWithGD:gd andStashIndex:stashIndex] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:delete];
	[delete setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onStashDeleteComplete];
	}];
}

- (void) runHardReset {
	if(allCanceled) return;
	[status showSpinner];
	GTOpHardReset * reset = [[[GTOpHardReset alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:reset];
	[reset setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onHardResetComplete];
	}];
}

- (void) runSoftReset {
	if(allCanceled) return;
	[status showSpinner];
	GTOpSoftReset * reset = [[[GTOpSoftReset alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:reset];
	[reset setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onSoftResetComplete];
	}];
}

- (void) runIgnoreFiles:(NSMutableArray *) files {
	if(allCanceled) return;
	[status showSpinner];
	GTOpIgnoreFiles * ignore = [[[GTOpIgnoreFiles alloc] initWithGD:gd andFiles:files] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:ignore];
	[ignore setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onIgnoreFilesComplete];
	}];
}

- (void) runBranchCheckout:(NSString *) branch {
	if(allCanceled) return;
	[status showSpinner];
	GTOpCheckout * checkout = [[[GTOpCheckout alloc] initWithGD:gd andBranchForCheckout:branch] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:checkout];
	[checkout setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCheckoutComplete];
	}];
}

- (void) runBranchDelete:(NSString *) branchName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpBranchDelete * delete = [[[GTOpBranchDelete alloc] initWithGD:gd andBranchName:branchName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:delete];
	[delete setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onBranchDeleteComplete];
	}];
}

- (void) runTagDelete:(NSString *) tagName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpTagDelete * delete = [[[GTOpTagDelete alloc] initWithGD:gd andTagName:tagName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:delete];
	[delete setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onTagDeleteComplete];
	}];
}

- (void) runNewEmptyBranch:(NSString *) branchName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpNewEmptyBranch * neb = [[[GTOpNewEmptyBranch alloc] initWithGD:gd andBranchName:branchName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:neb];
	[neb setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewEmptyBranchComplete];
	}];
}

- (void) runNewStash:(NSString *) stashName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpNewStash * stash = [[[GTOpNewStash alloc] initWithGD:gd andStashName:stashName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:stash];
	[stash setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewStashComplete];
	}];
}

- (void) runNewBranch:(NSString *) branchName fromStartBranch:(NSString *) startBranch checkoutNewBranch:(BOOL) checksOut {
	if(allCanceled) return;
	[status showSpinner];
	GTOpNewBranch * branch = [[[GTOpNewBranch alloc] initWithGD:gd andBranchName:branchName andStartBranchName:startBranch] autorelease];
	[branch setChecksOutBranch:checksOut];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:branch];
	[branch setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewBranchComplete];
	}];
}

- (void) runNewTag:(NSString *) tagName fromStart:(NSString *) start {
	if(allCanceled) return;
	[status showSpinner];
	GTOpNewTag * tag = [[[GTOpNewTag alloc] initWithGD:gd andTagName:tagName andTagStart:start] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:tag];
	[tag setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewTagComplete];
	}];
}

- (void) runNewRemote:(NSString *) _remoteName withURL:(NSString *) _url {
	if(allCanceled) return;
	[status showSpinner];
	GTOpNewRemote * remote = [[[GTOpNewRemote alloc] initWithGD:gd newRemoteName:_remoteName remoteURL:_url] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:remote];
	[remote setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewRemoteComplete];
	}];
}

- (void) runDeleteRemote:(NSString *) remoteName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpDeleteRemote * remote = [[[GTOpDeleteRemote alloc] initWithGD:gd andRemoteName:remoteName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:remote];
	[remote setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDeleteRemoteComplete];
	}];
}

- (void) runExportZip:(NSString *) path andCommit:(NSString *) commit {
	if(allCanceled) return;
	[status showSpinner];
	GTOpExportZip * export = [[[GTOpExportZip alloc] initWithGD:gd andPath:path andCommit:commit] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:export];
	[export setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onExportZipComplete];
	}];
}

- (void) runExportTar:(NSString *) path andCommit:(NSString *) commit {
	if(allCanceled) return;
	[status showSpinner];
	GTOpExportTar * export = [[[GTOpExportTar alloc] initWithGD:gd andPath:path andCommit:commit] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:export];
	[export setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onExportTarComplete];
	}];
}

- (void) runMergeWithBranch:(NSString *) branchName {
	if(allCanceled) return;
	[status showSpinner];
	GTOpMerge * merge = [[[GTOpMerge alloc] initWithGD:gd andBranchName:branchName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:merge];
	[merge setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onMergeComplete];
	}];
}

- (void) runPushBranchTo:(NSString *) branch toRemote:(NSString *) remote {
	if(allCanceled) return;
	networkOpsCancelled = false;
	[status showStatusIndicatorWithLabel:[NSString stringWithFormat:@"Push: %@ -> %@",branch,remote]];
	GTOpPushTo * push = [[[GTOpPushTo alloc] initWithGD:gd andBranchName:branch andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:push];
	[push setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onPushBranchToComplete];
	}];
}

- (void) runPullBranchFrom:(NSString *) branch toRemote:(NSString *) remote {
	if(allCanceled) return;
	networkOpsCancelled = false;
	[status showStatusIndicatorWithLabel:[NSString stringWithFormat:@"Pull: %@ <- %@",branch,remote]];
	GTOpPullFrom * pull = [[[GTOpPullFrom alloc] initWithGD:gd andBranchName:branch andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:pull];
	[pull setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
        
        // if there are submodules, lets update them too.
        if ([gitd submodules] && [[gitd submodules] count] > 0 && !allCanceled && !networkOpsCancelled)
        {
            [status hide];
            [status showStatusIndicatorWithLabel:@"Updating submodules"];
            GTOpUpdateSubs * o = [[[GTOpUpdateSubs alloc] initWithGD:gd] autorelease];
            NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
            [o setCompletionBlock:^{
                [self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
                [self onSubmoduleUpdateAllComplete];
            }];
        }
        else
            [self onPullFromComplete];
	}];
}

- (void) runSetDefaultRemote:(NSString *) remote forBranch:(NSString *) branch {
	if(allCanceled) return;
	[status showSpinner];
	GTOpSetDefaultRemote * dr = [[[GTOpSetDefaultRemote alloc] initWithGD:gd andBranchName:branch andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:dr];
	[dr setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onSetDefaultRemoteComplete];
	}];
}

- (void) runGetConfigs {
	if(allCanceled) return;
	if(isRunningGetConfig) return;
	isRunningGetConfig = true;
	[status showSpinner];
	GTOpGetConfigs * configs = [[[GTOpGetConfigs alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:configs];
	[configs setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGetConfigsComplete];
	}];
}

- (void) runGetGlobalConfigs {
	if(allCanceled) return;
	if(isRunningGetConfig) return;
	isRunningGetConfig = true;
	[status showSpinner];
	GTOpGetGlobalConfigs * configs = [[[GTOpGetGlobalConfigs alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:configs];
	[configs setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGetGlobalConfigsComplete];
	}];
}

- (void) runWriteConfigForKey:(NSString *) key andValue:(NSString *) value isGlobal:(BOOL) _global {
	if(allCanceled) return;
	[status showSpinner];
	GTOpWriteConfig * write = [[[GTOpWriteConfig alloc] initWithGD:gd andKey:key andValue:value isGlobal:_global] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:write];
	[write setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onWriteConfigComplete];
	}];
}

- (void) runGarbageCollect {
	if(allCanceled) return;
	[status showStatusIndicator];
	GTOpGarbageCollect * gc = [[[GTOpGarbageCollect alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:gc];
	[gc setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGarbageCollectComplete];
	}];
}

- (void) runAggressiveGarbageCollect {
	if(allCanceled) return;
	[status showNonCancelableStatusIndicatorWithLabel:@"Aggressive GC - Please Wait"];
	GTOpGarbageCollect * gc = [[[GTOpGarbageCollect alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:gc];
	[gc setIsAggressive:true];
	[gc setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGarbageCollectComplete];
	}];
}

- (void) runNewTrackingBranchWithLocalBranch:(NSString *) _localBranch andRemoteBranch:(NSString *) _remoteBranch andRemote:(NSString *) _remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpAddTrackingBranch * b = [[[GTOpAddTrackingBranch alloc] initWithGD:gd andBranchName:_localBranch andRemoteName:_remote andRemoteBranchName:_remoteBranch] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewTrackingBranchComplete];
	}];
}

- (void) runGetRemoteBranchNamesFromRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpGetRemoteBranches * b = [[[GTOpGetRemoteBranches alloc] initWithGD:gd andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGetRemoteBranchesComplete];
	}];
}

- (void) runGetRemoteTagNamesFromRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpGetRemoteTags * b = [[[GTOpGetRemoteTags alloc] initWithGD:gd andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGetRemoteTagsComplete];
	}];
}

- (void) runFetchTag:(NSString *) tag fromRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpFetchTag * b = [[[GTOpFetchTag alloc] initWithGD:gd andRemoteName:remote andTagName:tag] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onFetchTagComplete];
	}];
}

- (void) runPushTag:(NSString *) tag toRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpPushTagTo * b = [[[GTOpPushTagTo alloc] initWithGD:gd andRemoteName:remote andTagName:tag] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onPushTagToComplete];
	}];
}

- (void) runUnsetConfigForKey:(NSString *) key isGlobal:(BOOL) _isGlobal {
	if(allCanceled) return;
	[status showSpinner];
	GTOpUnsetConfig * b = [[[GTOpUnsetConfig alloc] initWithGD:gd andKey:key isGlobal:_isGlobal] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onUnsetConfigComplete];
	}];
}

- (void) runPackRefs {
	if(allCanceled) return;
	[status showSpinner];
	GTOpPackRefs * b = [[[GTOpPackRefs alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onPackRefsComplete];
	}];
}

- (void) runPackObjects {
	if(allCanceled) return;
	[status showSpinner];
	GTOpPackObjects * b = [[[GTOpPackObjects alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onPackObjectsComplete];
	}];
}

- (void) runSendErrorEmail:(NSString *) error {
	if(allCanceled) return;
	[status showSpinner];
	GTOpErrorEmail * b = [[[GTOpErrorEmail alloc] initWithGD:gd andErrors:error] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onSendEmailComplete];
	}];
}

- (void) runInitRepoInDir:(NSString *) _dir {
	if(allCanceled) return;
	[status showSpinner];
	GTOpInitRepo * b = [[[GTOpInitRepo alloc] initWithTargetDir:_dir] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:b];
	[b setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onInitComplete];
	}];
}

- (void) runGetCommitsAhead {
	if(allCanceled) return;
	[status showSpinner];
	GTOpCommitsAhead * ca = [[[GTOpCommitsAhead alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:ca];
	[ca setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCommitsAheadComplete];
	}];
}

- (void) runGetCommitsAheadWithoutSpinner {
	if(allCanceled) return;
	GTOpCommitsAhead * ca = [[[GTOpCommitsAhead alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:ca];
	[ca setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCommitsAheadCompleteWithoutSpinner];
	}];
}

- (void) runDeleteBranch:(NSString *) branch atRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpDeleteBranchAt * o = [[[GTOpDeleteBranchAt alloc] initWithGD:gd andBranchName:branch andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDeleteBranchAtComplete];
	}];
}

- (void) runDeleteBranchAtAllRemotes:(NSString *) branch {
	if(allCanceled) return;
	networkOpsCancelled=false;
	[status showStatusIndicatorWithLabel:@"Deleting at remotes, please wait"];
	GTOpBranchDeleteAtAllRemotes * o = [[[GTOpBranchDeleteAtAllRemotes alloc] initWithGD:gd andBranchName:branch] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onDeleteBranchAtAllRemotesComplete];
	}];
}

- (void) runDeleteTag:(NSString *) tag atRemote:(NSString *) remote {
	if(allCanceled) return;
	[status showSpinner];
	GTOpDeleteTagAt * o = [[[GTOpDeleteTagAt alloc] initWithGD:gd andRemoteName:remote andTagName:tag] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDeleteTagAtComplete];
	}];
}

- (void) runDeleteTagAtAllRemotes:(NSString *) tag {
	if(allCanceled)return;
	networkOpsCancelled=false;
	[status showStatusIndicatorWithLabel:@"Deleting at remotes, please wait"];
	GTOpTagDeleteAllRemotes * o = [[[GTOpTagDeleteAllRemotes alloc] initWithGD:gd andTagName:tag] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onDeleteTagAtAllRemotesComplete];
	}];
}

- (void) runIgnoreExtension:(NSString *) ext {
	if(allCanceled) return;
	[status showSpinner];
	GTOpIgnoreExtension * o = [[[GTOpIgnoreExtension alloc] initWithGD:gd andExtension:ext] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onIgnoreExtensionComplete];
	}];
}

- (void) runNewSubmodule:(NSString *) _submoduleURL inLocalDir:(NSString *) _localDir withName:(NSString *) _submoduleName {
	if(allCanceled || networkOpsCancelled) return;
	[status showSpinner];
	GTOpNewSubmodule * o = [[[GTOpNewSubmodule alloc] initWithGD:gd andSubmoduleURL:_submoduleURL andLocalDir:_localDir andName:_submoduleName] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onNewSubmoduleComplete];
	}];
}

- (void) runSubmoduleUpdateForSubmodule:(NSString *) _submodule {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Updating submodule"];
	GTOpSubmoduleUpdate * o = [[[GTOpSubmoduleUpdate alloc] initWithGD:gd andSubmodule:_submodule] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmoduleUpdateComplete];
	}];
}

- (void) runSubmoduleSyncForSubmodule:(NSString *) _submodule {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Syncing submodule"];
	GTOpSubmoduleSync * o = [[[GTOpSubmoduleSync alloc] initWithGD:gd andSubmodule:_submodule] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmoduleSyncComplete];
	}];
}

- (void) runSubmodulePushForSubmodule:(NSString *) _submodule {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Pushing submodule"];
	GTOpSubmodulePush * o = [[[GTOpSubmodulePush alloc] initWithGD:gd andSubmodule:_submodule] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmodulePushComplete];
	}];
}

- (void) runSubmodulePullForSubmodule:(NSString *) _submodule {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Pulling submodule"];
	GTOpSubmodulePull * o = [[[GTOpSubmodulePull alloc] initWithGD:gd andSubmodule:_submodule] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmodulePullComplete];
	}];
}

- (void) runSubmoduleUpdateAll {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Updating submodules"];
	GTOpUpdateSubs * o = [[[GTOpUpdateSubs alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmoduleUpdateAllComplete];
	}];
}

- (void) runSubmoduleInitAll {
	if(allCanceled || networkOpsCancelled) return;
	[status showStatusIndicatorWithLabel:@"Initializing submodules"];
	GTOpInitializeSubs * o = [[[GTOpInitializeSubs alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmoduleInitAllComplete];
	}];
}

- (void) runDeleteSubmodule:(NSString *) _submodule {
	if(allCanceled || networkOpsCancelled) return;
	[status showSpinner];
	GTOpSubmoduleDelete * o = [[[GTOpSubmoduleDelete alloc] initWithGD:gd andSubmodule:_submodule] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onSubmoduleDeleteComplete];
	}];
}

- (void) runRebaseFrom:(NSString *) remote withBranch:(NSString *) branch {
	if(allCanceled || networkOpsCancelled) return;
	networkOpsCancelled=false;
	[status showStatusIndicatorWithLabel:[NSString stringWithFormat:@"Rebase: %@ <- %@",branch,remote]];
	GTOpRebaseFrom * o = [[[GTOpRebaseFrom alloc] initWithGD:gd andBranchName:branch andRemoteName:remote] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithNetworkOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelablesAndNetworkCancelables:q];
		[self onRebaseFromComplete];
	}];
}

- (void) runOpenFileMergeForFile:(NSString *) _file {
	if(allCanceled) return;
	[status showSpinner];
	GTOpOpenFileMerge * o = [[[GTOpOpenFileMerge alloc] initWithGD:gd andFileForFileMerge:_file] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onOpenFileMergeComplete];
	}];
}

- (void) runGetLooseObjects {
	if(allCanceled) return;
	[status showSpinner];
	GTOpCountObjects * o = [[[GTOpCountObjects alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onGetLooseObjectsComplete];
	}];
}

- (void) runPrepareDiffing {
	if(allCanceled) return;
	[status showSpinner];
	GTOpPrepareDiffing * o = [[[GTOpPrepareDiffing alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onPrepareDiffingComplete];
	}];
}

- (void) runDiff {
	if(allCanceled) return;
	GTOpDiff * o = [[[GTOpDiff alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDiffComplete];
	}];
}

- (void) runDiffWithDiff:(GTGitDiff *) diff {
	if(allCanceled) return;
	GTOpDiff * o = [[[GTOpDiff alloc] initWithGD:gd] autorelease];
	[o setDiff:diff];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onDiffComplete];
	}];
}

- (void) runDiffWithDiff:(GTGitDiff *) _diff andTemplate:(NSString *) _template withCallback:(id) _target action:(SEL) _action {
	NSTask * task=[[gd git] newGitBashTask];
	NSMutableArray * args=[[NSMutableArray alloc] init];
	if([_diff isWorkingTreeChangesMode]) [args addObject:@"diff"];
	if([_diff isStagedChangesMode]) {
		[args addObject:@"diff"];
		[args addObject:@"--cached"];
	}
	if([_diff isStageVSWorkingTreeMode]) [args addObject:@"diff-files"];
	[args addObject:[NSString stringWithFormat:@"-U%@",[_diff contextValueAsString]]];
	NSMutableArray * files=[_diff filePaths];
	if(files) {
		NSString * file;
		for(file in files) [args addObject:[NSString stringWithFormat:@"%@",file]];
	}
	files=nil;
	[task setArguments:args];
	[task launch];
	NSFileHandle * output = [[task standardOutput] fileHandleForReading];
	NSData * content = [output readDataToEndOfFile];
	[output closeFile];
	[task waitUntilExit];
	NSString * diffContent = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
	NSString * replaced1 = [diffContent stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	NSString * replaced2 = [replaced1 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	NSArray * parts = [_template componentsSeparatedByString:@"@content@"];
	NSString * diffHTML = [parts componentsJoinedByString:replaced2];
	[_diff setDiffContent:diffHTML];
	[diffContent release];
	[args release];
	[task release];
	[_target performSelector:_action withObject:nil];
}

- (void) runAsyncDiffWithDiff:(GTGitDiff *) _diff andTemplate:(NSString *) _template withCallback:(id) _target action:(SEL) _action {
	if(allCanceled) return;
	GTOpDirectDiff * o = [[[GTOpDirectDiff alloc] initWithGD:gd andDiff:_diff andTemplate:_template] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[_target performSelector:_action];
	}];
}

- (void) runReportDiffWithDiffContent:(NSString *) _diffContent {
	if(allCanceled) return;
	GTOpReportDiff * o = [[[GTOpReportDiff alloc] initWithGD:gd andDiffContent:_diffContent] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onReportDiffComplete];
	}];
}

- (void) runPatchApplyWithFile:(NSString *) _patchFilePath {
	if(allCanceled) return;
	[status showSpinner];
	GTOpApplyPatch * o = [[[GTOpApplyPatch alloc] initWithGD:gd andDiffFilePath:_patchFilePath] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onPatchApplyComplete];
	}];
}

- (void) runLoadHistoryWithLoadInfo:(GTGitCommitLoadInfo *) _loadInfo {
	if(allCanceled) return;
	showStatusForHistoryLoad=true;
	[NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(showStatusLoaderForHistoryLoading) userInfo:nil repeats:false];
	GTOpLoadHistory * o = [[[GTOpLoadHistory alloc] initWithGD:gd andLoadInfo:_loadInfo] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self performSelectorOnMainThread:@selector(hideStatusLoaderForHistoryLoading) withObject:nil waitUntilDone:false];
		[self releaseAndRemoveQFromCancelables:q];
		[self onLoadHistoryComplete];
	}];
}

- (void) runFetchRemoteBranch:(NSString *) _remoteBranch {
	if(allCanceled) return;
	[status showStatusIndicatorWithLabel:[@"Fetching " stringByAppendingString:_remoteBranch]];
	GTOpFetchRemoteBranch * o = [[[GTOpFetchRemoteBranch alloc] initWithGD:gd andRemoteBranch:_remoteBranch] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onFetchRemoteBranchComplete];
	}];
}

- (void) runMergeRemoteBranch:(NSString *) _remoteBranch {
	if(allCanceled) return;
	[status showSpinner];
	GTOpMergeRemoteBranch * o = [[[GTOpMergeRemoteBranch alloc] initWithGD:gd andRemoteBranch:_remoteBranch] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onMergeRemoteBranchComplete];
	}];
}

- (void) runFetch {
	if(allCanceled) return;
	[status showStatusIndicatorWithLabel:@"Fetching"];
	GTOpFetch * o = [[[GTOpFetch alloc] initWithGD:gd] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onFetchComplete];
	}];
}

- (void) runLoadCommitDetailsWithCommit:(GTGitCommit *) _commit andCommitDetailsTemplate:(NSString *) _template andCommitDetailLoadInfo:(GTGitCommitDetailLoadInfo *) _loadInfo withCallback:(GDCallback *) _callback {
	if(allCanceled) return;
	[_callback retain];
	[status showSpinner];
	GTOpLoadCommitDetails * o = [[[GTOpLoadCommitDetails alloc] initWithGD:gd andCommit:_commit andCommitLoadInfo:_loadInfo andTemplate:_template] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		if([o isCancelled]) return;
		[self releaseAndRemoveQFromCancelables:q];
		[self onLoadCommitDetailsComplete:_callback];
		[_callback release];
	}];
}

- (void) runReportCommitWithCommitContent:(NSString *) _commitContent {
	if(allCanceled) return;
	GTOpReportCommit * o = [[[GTOpReportCommit alloc] initWithGD:gd andCommitContent:_commitContent] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onReportCommitComplete];
	}];
}

- (void) runCherryPickCommitWithSHA:(NSString *) _sha withCallback:(GDCallback *) _callback {
	if(allCanceled) return;
	[_callback retain];
	[status showSpinner];
	GTOpCherryPick * o = [[[GTOpCherryPick alloc] initWithGD:gd andHash:_sha] autorelease];
	NSOperationQueue * q = [self newCancelableQueueWithOperation:o];
	[o setCompletionBlock:^{
		[self releaseAndRemoveQFromCancelables:q];
		[self onCherryPickComplete];
		[_callback execute];
		[_callback release];
	}];
}

- (void) onCherryPickComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onReportCommitComplete {
}

- (void) onLoadCommitDetailsComplete:(GDCallback *) _callback {
	if(allCanceled) return;
	[status hideSpinner];
	[_callback executeOnMainThread];
}

- (void) onLoadHistoryComplete {
	if(allCanceled) return;
	[self incrementRunCount];
	[gd performSelectorOnMainThread:@selector(onHistoryLoaded) withObject:nil waitUntilDone:false];
}

- (void) onFetchComplete {
	if(allCanceled) return;
	[sounds pop];
	[status hide];
	[self runRefreshOperation];
}

- (void) onMergeRemoteBranchComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onFetchRemoteBranchComplete {
	if(allCanceled) return;
	[sounds pop];
	[status hide];
	[self runRefreshOperation];
}

- (void) onPatchApplyComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onReportDiffComplete {
}

- (void) onDiff2Complete {
}

- (void) onDiffComplete {
	if(allCanceled) return;
}

- (void) onPrepareDiffingComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGotLooseObjectsCount) withObject:nil waitUntilDone:false];
}

- (void) onGetLooseObjectsComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGotLooseObjectsCount) withObject:nil waitUntilDone:false];
}

- (void) onOpenFileMergeComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onSubmoduleDeleteComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hideSpinner];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmoduleInitAllComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmoduleUpdateAllComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmodulePullComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmodulePushComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmoduleSyncComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onSubmoduleUpdateComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onRebaseFromComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
}

- (void) onFindCommitIDComplete {
	if(allCanceled) return;
	[sounds pop];
}

- (void) onNewSubmoduleComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onIgnoreExtensionComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onDeleteTagAtAllRemotesComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshMetaOperation];
}

- (void) onDeleteBranchAtAllRemotesComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshMetaOperation];
}

- (void) onDeleteTagAtComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onDeleteBranchAtComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onCommitsAheadComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onCommitsAheadCompleteWithoutSpinner {
	if(allCanceled) return;
}

-(void) onPackObjectsComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onSendEmailComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
}

- (void) onPackRefsComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onUnsetConfigComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onPushTagToComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
	[self runRefreshMetaOperation];
}

- (void) onFetchTagComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onGetRemoteTagsComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGotRemoteTags) withObject:nil waitUntilDone:false];
}

- (void) onGetRemoteBranchesComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGotRemoteBranches) withObject:nil waitUntilDone:false];
}

- (void) onNewTrackingBranchComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onGarbageCollectComplete {
	if(allCanceled) return;
	[status hide];
	[sounds pop];
}

- (void) onWriteConfigComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onGetGlobalConfigsComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGetGlobalConfigsComplete) withObject:nil waitUntilDone:true];

	isRunningGetConfig = false;
}

- (void) onGetConfigsComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onGetConfigsComplete) withObject:nil waitUntilDone:true];

	isRunningGetConfig = false;
}

- (void) onSetDefaultRemoteComplete {
	if(allCanceled) return;
	[status hideSpinner];
}

- (void) onPullFromComplete {
	if(allCanceled || networkOpsCancelled) return;
	[status hide];
	[sounds pop];
	[self runRefreshOperation];
}

- (void) onPushBranchToComplete {
	if(allCanceled || networkOpsCancelled) return;
	[sounds pop];
	[status hide];
	[self runRefreshOperation];
}

- (void) onMergeComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onRefreshMetaComplete {
	if(allCanceled) return;
	[status hideSpinner];
	isRunningMetaRefresh=false;
	[gd performSelectorOnMainThread:@selector(onRefreshMetaOperationComplete) withObject:nil waitUntilDone:false];
	[self incrementRunCount];
}

- (void) onExportTarComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
}

- (void) onExportZipComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
}

- (void) onDeleteRemoteComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onNewRemoteComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onNewTagComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshMetaOperation];
}

- (void) onNewBranchComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onNewStashComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onNewEmptyBranchComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onTagDeleteComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
	[self runRefreshMetaOperation];
}

- (void) onBranchDeleteComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[sounds pop];
	[self runRefreshMetaOperation];
}

- (void) onStashDeleteComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onCheckoutComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onIgnoreFilesComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onSoftResetComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onHardResetComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onStashPopComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onStashApplyComplete {
	if(allCanceled) return;
	[status hideSpinner];
	[self runRefreshOperation];
}

- (void) onStartupOperationComplete {
	if(allCanceled) return;
	isRunningStartup = false;
	[gd performSelectorOnMainThread:@selector(onStartupOperationComplete) withObject:nil waitUntilDone:false];
	[self runGetCommitsAhead];
}

- (void) onRefreshStatusComplete {
	if(allCanceled) return;
	isRunningRefresh = false;
	[status hideSpinner];
	[self incrementRunCount];
}

- (void) onRefreshOperationComplete {
	if(allCanceled) return;
	isRunningRefresh = false;
	[status hideSpinner];
	[gd performSelectorOnMainThread:@selector(onRefreshOperationComplete) withObject:nil waitUntilDone:false];
	[self runGetCommitsAhead];
	[self incrementRunCount];
}

- (void) onAddFilesComplete {
	if(allCanceled) return;
	isRunningAddFiles=false;
	[self runRefreshOperation];
	[gd performSelectorOnMainThread:@selector(onGitAddComplete) withObject:nil waitUntilDone:false];
}

- (void) onCommitComplete {
	if(allCanceled) return;
	isRunningCommit=false;
	[status hideSpinner];
	[self runRefreshOperation];
	[self runGetLooseObjects];
}

- (void) onRemoveComplete {
	if(allCanceled) return;
	isRunningRemove = false;
	[self runRefreshOperation];
}

- (void) onDestageComplete {
	if(allCanceled) return;
	isRunningDestage = false;
	[self runRefreshOperation];
}

- (void) onDiscardComplete {
	if(allCanceled) return;
	isRunningDiscard=false;
	[self runRefreshOperation];
}

- (void) onInitComplete {
}

- (void) cancelAll {
	allCanceled=true;
	for(int i = 0;i<[cancelables count];i++) {
		[[cancelables objectAtIndex:i] cancelAllOperations];
	}
	// this will get taken care of in dealloc.
	//GDRelease(cancelables);
}

- (void) cancelNetworkOperations {
	networkOpsCancelled=true;
	for(int i = 0;i<[networkCancelables count];i++) {
		[[networkCancelables objectAtIndex:i] cancelAllOperations];
	}
	// this will get taken care of in dealloc.
	//GDRelease(networkCancelables);
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOperationsController\n");
	#endif
	GDRelease(cancelables);
	GDRelease(networkCancelables);
	GDRelease(showStatusForHistoryLoadMutex);
	networkOpsCancelled=false;
	isRunningStartup=false;
	isRunningRefresh=false;
	isRunningMetaRefresh=false;
	isRunningAddFiles=false;
	isRunningCommit=false;
	isRunningRemove=false;
	isRunningDestage=false;
	isRunningDiscard=false;
	isRunningGetConfig=false;
	status=nil;
	gd=nil;
	allCanceled=false;
	[super dealloc];
}

@end

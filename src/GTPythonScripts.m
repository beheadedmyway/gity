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

#import "GTPythonScripts.h"


@implementation GTPythonScripts

+ (NSString *) getCloneRepoScript {
	return [[NSBundle mainBundle] pathForResource:@"clonerepo" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getCurrentBranchScript {
	return [[NSBundle mainBundle] pathForResource:@"currentbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getBranchNamesScript {
	return [[NSBundle mainBundle] pathForResource:@"branches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getTagNamesScript {
	return [[NSBundle mainBundle] pathForResource:@"tags" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) allFilesScript {
	return [[NSBundle mainBundle] pathForResource:@"allfiles" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) addFilesScript {
	return [[NSBundle mainBundle] pathForResource:@"add" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) commitScript {
	return [[NSBundle mainBundle] pathForResource:@"commit" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) removeScript {
	return [[NSBundle mainBundle] pathForResource:@"remove" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) destageScript {
	return [[NSBundle mainBundle] pathForResource:@"destage" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) discardChangesScript {
	return [[NSBundle mainBundle] pathForResource:@"discardchanges" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) statusScript {
	return [[NSBundle mainBundle] pathForResource:@"status" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) remoteTrackingBranchesScript {
	return [[NSBundle mainBundle] pathForResource:@"remotetrackbranches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) remotesScript {
	return [[NSBundle mainBundle] pathForResource:@"remotes" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) savedStashesScript {
	return [[NSBundle mainBundle] pathForResource:@"stashes" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashApplyScript {
	return [[NSBundle mainBundle] pathForResource:@"stashapply" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashPopScript {
	return [[NSBundle mainBundle] pathForResource:@"stashpop" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashDeleteScript {
	return [[NSBundle mainBundle] pathForResource:@"stashdelete" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) hardResetScript {
	return [[NSBundle mainBundle] pathForResource:@"hardreset" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) softResetScript {
	return [[NSBundle mainBundle] pathForResource:@"softreset" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) ignoreFilesScript {
	return [[NSBundle mainBundle] pathForResource:@"ignorefiles" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) checkoutScript {
	return [[NSBundle mainBundle] pathForResource:@"checkoutbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) branchDeleteScript {
	return [[NSBundle mainBundle] pathForResource:@"deletebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) tagDeleteScript {
	return [[NSBundle mainBundle] pathForResource:@"deletetag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewEmptyBranch {
	return [[NSBundle mainBundle] pathForResource:@"emptybranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewStash {
	return [[NSBundle mainBundle] pathForResource:@"newstash" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewBranch {
	return [[NSBundle mainBundle] pathForResource:@"newbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewTag {
	return [[NSBundle mainBundle] pathForResource:@"newtag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewRemote {
	return [[NSBundle mainBundle] pathForResource:@"newremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteRemote {
	return [[NSBundle mainBundle] pathForResource:@"deleteremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) exportZip {
	return [[NSBundle mainBundle] pathForResource:@"exportzip" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) exportTar {
	return [[NSBundle mainBundle] pathForResource:@"exporttar" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) metaStatus {
	return [[NSBundle mainBundle] pathForResource:@"metastatus" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) merge {
	return [[NSBundle mainBundle] pathForResource:@"merge" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pushTo {
	return [[NSBundle mainBundle] pathForResource:@"pushto" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pullFrom {
	return [[NSBundle mainBundle] pathForResource:@"pullfrom" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) setDefaultRemote {
	return [[NSBundle mainBundle] pathForResource:@"setdefaultremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) configs {
	return [[NSBundle mainBundle] pathForResource:@"configs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) globalConfigs {
	return [[NSBundle mainBundle] pathForResource:@"globalconfigs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) writeConfig {
	return [[NSBundle mainBundle] pathForResource:@"writeconfig" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) garbageCollect {
	return [[NSBundle mainBundle] pathForResource:@"garbagecollect" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewTrackingBranch {
	return [[NSBundle mainBundle] pathForResource:@"newtrackbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getRemoteBranchNames {
	return [[NSBundle mainBundle] pathForResource:@"getremotebranches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getRemoteTagNames {
	return [[NSBundle mainBundle] pathForResource:@"getremotetags" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetchTag {
	return [[NSBundle mainBundle] pathForResource:@"fetchtag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pushTagTo {
	return [[NSBundle mainBundle] pathForResource:@"pushtagto" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) unsetConfig {
	return [[NSBundle mainBundle] pathForResource:@"unsetconfig" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) packRefs {
	return [[NSBundle mainBundle] pathForResource:@"packrefs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) emailErrorsScript {
	return [[NSBundle mainBundle] pathForResource:@"erroremail" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) initRepoScript {
	return [[NSBundle mainBundle] pathForResource:@"initrepo" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) packObjectsScript {
	return [[NSBundle mainBundle] pathForResource:@"packobjects" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) commitsAhead {
	return [[NSBundle mainBundle] pathForResource:@"commitsahead" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteBranchAt {
	return [[NSBundle mainBundle] pathForResource:@"deletebranchat" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteTagAt {
	return [[NSBundle mainBundle] pathForResource:@"deletetagat" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) ignoreExtension {
	return [[NSBundle mainBundle] pathForResource:@"ignoreextension" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewSubmodule {
	return [[NSBundle mainBundle] pathForResource:@"submoduleadd" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) findCommitFromArchive {
	return [[NSBundle mainBundle] pathForResource:@"findcommitfromarchive" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) rebaseFrom {
	return [[NSBundle mainBundle] pathForResource:@"rebasefrom" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleUpdate {
	return [[NSBundle mainBundle] pathForResource:@"submoduleupdate" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleSync {
	return [[NSBundle mainBundle] pathForResource:@"submodulesync" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submodulePush {
	return [[NSBundle mainBundle] pathForResource:@"submodulepush" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submodulePull {
	return [[NSBundle mainBundle] pathForResource:@"submodulepull" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleUpdateAll {
	return [[NSBundle mainBundle] pathForResource:@"submoduleupdateall" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleInitAll {
	return [[NSBundle mainBundle] pathForResource:@"submoduleinitall" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleDelete {
	return [[NSBundle mainBundle] pathForResource:@"submoduledelete" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) openFileMerge {
	return [[NSBundle mainBundle] pathForResource:@"openfilemerge" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) countObjects {
	return [[NSBundle mainBundle] pathForResource:@"looseobjects" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) prepareDiffing {
	return [[NSBundle mainBundle] pathForResource:@"preparediffing" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) diff {
	return [[NSBundle mainBundle] pathForResource:@"diff" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) reportDiff {
	return [[NSBundle mainBundle] pathForResource:@"diffreport" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) reportCommit {
	return [[NSBundle mainBundle] pathForResource:@"commitreport" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) applyPatch {
	return [[NSBundle mainBundle] pathForResource:@"patchapply" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) mergeRemoteBranch {
	return [[NSBundle mainBundle] pathForResource:@"mergeremotebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetchRemoteBranch {
	return [[NSBundle mainBundle] pathForResource:@"fetchremotebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetch {
	return [[NSBundle mainBundle] pathForResource:@"fetch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) cherryPickCommit {
	return [[NSBundle mainBundle] pathForResource:@"cherrypick" ofType:@"pyc" inDirectory:@"python"];
}

@end

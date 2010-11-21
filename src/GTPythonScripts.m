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

static NSBundle * bundle;

@implementation GTPythonScripts

+ (void) initMainBundle {
	bundle = [NSBundle mainBundle];
}

+ (NSString *) getCloneRepoScript {
	return [bundle pathForResource:@"clonerepo" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getCurrentBranchScript {
	return [bundle pathForResource:@"currentbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getBranchNamesScript {
	return [bundle pathForResource:@"branches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getTagNamesScript {
	return [bundle pathForResource:@"tags" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) allFilesScript {
	return [bundle pathForResource:@"allfiles" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) addFilesScript {
	return [bundle pathForResource:@"add" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) commitScript {
	return [bundle pathForResource:@"commit" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) removeScript {
	return [bundle pathForResource:@"remove" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) destageScript {
	return [bundle pathForResource:@"destage" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) discardChangesScript {
	return [bundle pathForResource:@"discardchanges" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) statusScript {
	return [bundle pathForResource:@"status" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) remoteTrackingBranchesScript {
	return [bundle pathForResource:@"remotetrackbranches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) remotesScript {
	return [bundle pathForResource:@"remotes" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) savedStashesScript {
	return [bundle pathForResource:@"stashes" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashApplyScript {
	return [bundle pathForResource:@"stashapply" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashPopScript {
	return [bundle pathForResource:@"stashpop" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) stashDeleteScript {
	return [bundle pathForResource:@"stashdelete" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) hardResetScript {
	return [bundle pathForResource:@"hardreset" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) softResetScript {
	return [bundle pathForResource:@"softreset" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) ignoreFilesScript {
	return [bundle pathForResource:@"ignorefiles" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) checkoutScript {
	return [bundle pathForResource:@"checkoutbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) branchDeleteScript {
	return [bundle pathForResource:@"deletebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) tagDeleteScript {
	return [bundle pathForResource:@"deletetag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewEmptyBranch {
	return [bundle pathForResource:@"emptybranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewStash {
	return [bundle pathForResource:@"newstash" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewBranch {
	return [bundle pathForResource:@"newbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewTag {
	return [bundle pathForResource:@"newtag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewRemote {
	return [bundle pathForResource:@"newremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteRemote {
	return [bundle pathForResource:@"deleteremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) exportZip {
	return [bundle pathForResource:@"exportzip" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) exportTar {
	return [bundle pathForResource:@"exporttar" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) metaStatus {
	return [bundle pathForResource:@"metastatus" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) merge {
	return [bundle pathForResource:@"merge" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pushTo {
	return [bundle pathForResource:@"pushto" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pullFrom {
	return [bundle pathForResource:@"pullfrom" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) setDefaultRemote {
	return [bundle pathForResource:@"setdefaultremote" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) configs {
	return [bundle pathForResource:@"configs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) globalConfigs {
	return [bundle pathForResource:@"globalconfigs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) writeConfig {
	return [bundle pathForResource:@"writeconfig" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) garbageCollect {
	return [bundle pathForResource:@"garbagecollect" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewTrackingBranch {
	return [bundle pathForResource:@"newtrackbranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getRemoteBranchNames {
	return [bundle pathForResource:@"getremotebranches" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) getRemoteTagNames {
	return [bundle pathForResource:@"getremotetags" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetchTag {
	return [bundle pathForResource:@"fetchtag" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) pushTagTo {
	return [bundle pathForResource:@"pushtagto" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) unsetConfig {
	return [bundle pathForResource:@"unsetconfig" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) packRefs {
	return [bundle pathForResource:@"packrefs" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) emailErrorsScript {
	return [bundle pathForResource:@"erroremail" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) initRepoScript {
	return [bundle pathForResource:@"initrepo" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) packObjectsScript {
	return [bundle pathForResource:@"packobjects" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) commitsAhead {
	return [bundle pathForResource:@"commitsahead" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteBranchAt {
	return [bundle pathForResource:@"deletebranchat" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) deleteTagAt {
	return [bundle pathForResource:@"deletetagat" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) ignoreExtension {
	return [bundle pathForResource:@"ignoreextension" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) performNewSubmodule {
	return [bundle pathForResource:@"submoduleadd" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) findCommitFromArchive {
	return [bundle pathForResource:@"findcommitfromarchive" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) rebaseFrom {
	return [bundle pathForResource:@"rebasefrom" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleUpdate {
	return [bundle pathForResource:@"submoduleupdate" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleSync {
	return [bundle pathForResource:@"submodulesync" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submodulePush {
	return [bundle pathForResource:@"submodulepush" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submodulePull {
	return [bundle pathForResource:@"submodulepull" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleUpdateAll {
	return [bundle pathForResource:@"submoduleupdateall" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleInitAll {
	return [bundle pathForResource:@"submoduleinitall" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) submoduleDelete {
	return [bundle pathForResource:@"submoduledelete" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) openFileMerge {
	return [bundle pathForResource:@"openfilemerge" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) countObjects {
	return [bundle pathForResource:@"looseobjects" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) prepareDiffing {
	return [bundle pathForResource:@"preparediffing" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) diff {
	return [bundle pathForResource:@"diff" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) reportDiff {
	return [bundle pathForResource:@"diffreport" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) reportCommit {
	return [bundle pathForResource:@"commitreport" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) applyPatch {
	return [bundle pathForResource:@"patchapply" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) mergeRemoteBranch {
	return [bundle pathForResource:@"mergeremotebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetchRemoteBranch {
	return [bundle pathForResource:@"fetchremotebranch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) fetch {
	return [bundle pathForResource:@"fetch" ofType:@"pyc" inDirectory:@"python"];
}

+ (NSString *) cherryPickCommit {
	return [bundle pathForResource:@"cherrypick" ofType:@"pyc" inDirectory:@"python"];
}

@end

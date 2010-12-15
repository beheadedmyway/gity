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

@interface GTPythonScripts : NSObject {
}

+ (NSString *) getCurrentBranchScript;
+ (NSString *) getBranchNamesScript;
+ (NSString *) getTagNamesScript;
+ (NSString *) allFilesScript;
+ (NSString *) getCloneRepoScript;
+ (NSString *) addFilesScript;
+ (NSString *) commitScript;
+ (NSString *) removeScript;
+ (NSString *) destageScript;
+ (NSString *) discardChangesScript;
+ (NSString *) statusScript;
+ (NSString *) remoteTrackingBranchesScript;
+ (NSString *) remotesScript;
+ (NSString *) savedStashesScript;
+ (NSString *) stashApplyScript;
+ (NSString *) stashPopScript;
+ (NSString *) stashDeleteScript;
+ (NSString *) hardResetScript;
+ (NSString *) softResetScript;
+ (NSString *) ignoreFilesScript;
+ (NSString *) checkoutScript;
+ (NSString *) branchDeleteScript;
+ (NSString *) tagDeleteScript;
+ (NSString *) performNewEmptyBranch;
+ (NSString *) performNewStash;
+ (NSString *) performNewBranch;
+ (NSString *) performNewTag;
+ (NSString *) performNewRemote;
+ (NSString *) deleteRemote;
+ (NSString *) exportZip;
+ (NSString *) exportTar;
+ (NSString *) metaStatus;
+ (NSString *) merge;
+ (NSString *) pushTo;
+ (NSString *) pullFrom;
+ (NSString *) setDefaultRemote;
+ (NSString *) configs;
+ (NSString *) globalConfigs;
+ (NSString *) writeConfig;
+ (NSString *) garbageCollect;
+ (NSString *) performNewTrackingBranch;
+ (NSString *) getRemoteBranchNames;
+ (NSString *) getRemoteTagNames;
+ (NSString *) fetchTag;
+ (NSString *) pushTagTo;
+ (NSString *) unsetConfig;
+ (NSString *) packRefs;
+ (NSString *) emailErrorsScript;
+ (NSString *) initRepoScript;
+ (NSString *) packObjectsScript;
+ (NSString *) commitsAhead;
+ (NSString *) deleteTagAt;
+ (NSString *) deleteBranchAt;
+ (NSString *) ignoreExtension;
+ (NSString *) performNewSubmodule;
+ (NSString *) findCommitFromArchive;
+ (NSString *) rebaseFrom;
+ (NSString *) submoduleUpdate;
+ (NSString *) submoduleSync;
+ (NSString *) submodulePull;
+ (NSString *) submoduleUpdateAll;
+ (NSString *) submoduleInitAll;
+ (NSString *) submodulePush;
+ (NSString *) submoduleDelete;
+ (NSString *) openFileMerge;
+ (NSString *) countObjects;
+ (NSString *) prepareDiffing;
+ (NSString *) diff;
+ (NSString *) reportDiff;
+ (NSString *) applyPatch;
+ (NSString *) mergeRemoteBranch;
+ (NSString *) fetchRemoteBranch;
+ (NSString *) fetch;
+ (NSString *) reportCommit;
+ (NSString *) cherryPickCommit;

@end

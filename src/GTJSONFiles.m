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

#import "GTJSONFiles.h"

@implementation GTJSONFiles

+ (NSString *) allFiles {
	return @"/.git/vendor/gity/tmp/allfiles.json";
}

+ (NSString *) untrackedFiles {
	return @"/.git/vendor/gity/tmp/untrackedfiles.json";
}

+ (NSString *) modifiedFiles {
	return @"/.git/vendor/gity/tmp/modifiedfiles.json";
}

+ (NSString *) deletedFiles {
	return @"/.git/vendor/gity/tmp/deletedfiles.json";
}

+ (NSString *) stageModifiedFiles {
	return @"/.git/vendor/gity/tmp/stagemodifiedfiles.json";
}

+ (NSString *) stageAddedFiles {
	return @"/.git/vendor/gity/tmp/stageaddedfiles.json";
}

+ (NSString *) stageDeletedFiles {
	return @"/.git/vendor/gity/tmp/stagedeletedfiles.json";
}

+ (NSString *) stageRenamedFiles {
	return @"/.git/vendor/gity/tmp/stagerenamedfiles.json";
}

+ (NSString *) statusFile {
	return @"/.git/vendor/gity/tmp/status.json";
}

+ (NSString *) metaStatusFile {
	return @"/.git/vendor/gity/tmp/metastatus.json";
}

+ (NSString *) configsFile {
	return @"/.git/vendor/gity/tmp/configs.json";
}

+ (NSString *) globalConfigsFile {
	return @"/.git/vendor/gity/tmp/globalconfigs.json";
}

+ (NSString *) diff {
	return @"/.git/vendor/gity/tmp/diff.html";
}

+ (NSString *) diffReport {
	return @"/.git/vendor/gity/tmp/diffreport";
}

+ (NSString *) commitReport {
	return @"/.git/vendor/gity/tmp/commitreport";
}

@end

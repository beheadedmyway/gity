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
	return @"/vendor/gity/tmp/allfiles.json";
}

+ (NSString *) untrackedFiles {
	return @"/vendor/gity/tmp/untrackedfiles.json";
}

+ (NSString *) modifiedFiles {
	return @"/vendor/gity/tmp/modifiedfiles.json";
}

+ (NSString *) deletedFiles {
	return @"/vendor/gity/tmp/deletedfiles.json";
}

+ (NSString *) stageModifiedFiles {
	return @"/vendor/gity/tmp/stagemodifiedfiles.json";
}

+ (NSString *) stageAddedFiles {
	return @"/vendor/gity/tmp/stageaddedfiles.json";
}

+ (NSString *) stageDeletedFiles {
	return @"/vendor/gity/tmp/stagedeletedfiles.json";
}

+ (NSString *) stageRenamedFiles {
	return @"/vendor/gity/tmp/stagerenamedfiles.json";
}

+ (NSString *) statusFile {
	return @"/vendor/gity/tmp/status.json";
}

+ (NSString *) metaStatusFile {
	return @"/vendor/gity/tmp/metastatus.json";
}

+ (NSString *) configsFile {
	return @"/vendor/gity/tmp/configs.json";
}

+ (NSString *) globalConfigsFile {
	return @"/vendor/gity/tmp/globalconfigs.json";
}

+ (NSString *) diff {
	return @"/vendor/gity/tmp/diff.html";
}

+ (NSString *) diffReport {
	return @"/vendor/gity/tmp/diffreport";
}

+ (NSString *) commitReport {
	return @"/vendor/gity/tmp/commitreport";
}

@end

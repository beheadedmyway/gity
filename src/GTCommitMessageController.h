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
#import "GTBaseExternalNibController.h"
#import "GTScale9Control.h"
#import "GTSpecialTextField.h"

@class GittyDocument;
@class GTDocumentController;

@interface GTCommitMessageController : GTBaseExternalNibController <NSTextFieldDelegate,NSTextViewDelegate,NSTextViewDelegate> {
	//IBOutlet GTSpecialTextField * messageField;
	IBOutlet NSTextView * messageField;
	IBOutlet NSTextField * label;
	IBOutlet NSButton * signoff;
	NSString * commitMessageValue;
	BOOL addBeforeCommit;
	NSArray * fileSelection;
}

@property (readonly,nonatomic) NSString * commitMessageValue;
@property (assign, nonatomic) BOOL addBeforeCommit;

- (void) focus;
- (BOOL) shouldSignoff;
- (void) updateMessageFieldAttributes;
- (void) finishTwoStageCommit;

@end

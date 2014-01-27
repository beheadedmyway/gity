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
#import "GTGradientView.h"
#import "GTDiffBarDiffStateView.h"
#import "GTDiffBarSelectStateView.h"
#import "GTDiffBarLoadCommitsProgressView.h"

@interface GTDiffBarView : GTGradientView {
	IBOutlet GTDiffBarDiffStateView * __weak diffStateView;
	IBOutlet GTDiffBarSelectStateView * selectorStateView;
	IBOutlet GTDiffBarLoadCommitsProgressView * loadCommitsProgressView;
	GTInsetLabelView * leftLabel;
}

@property (weak, readonly,nonatomic) GTDiffBarDiffStateView * diffStateView;

- (void) showDiffState;
- (void) showDiffSelectState;
- (void) initViews;
- (void) invalidate;

@end

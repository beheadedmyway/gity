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

#import "GTCloneRepoController.h"
#import "GTDocumentController.h"

static NSFileManager * fileman;

@implementation GTCloneRepoController

- (void) awakeFromNib {
	if(repoURL is nil) return;
	[self initButtons];
	[repoURL setDelegate:self];
	if(modals is nil) modals=[GTModalController sharedInstance];
	if(fileman is nil) fileman=[NSFileManager defaultManager];
}

- (void) show {
	if(cloneRepoWindow is nil) [NSBundle loadNibNamed:@"CloneRepository" owner:self];
	if(!isCloning) [self reset];
	[cloneRepoWindow makeKeyAndOrderFront:self];
}

- (void) reset {
	[destination setStringValue:@""];
	[repoURL setStringValue:@""];
}

- (void) initButtons {
	NSPoint	tl = NSMakePoint(8,10);
	NSPoint tr = NSMakePoint(10,8);
	chooseDestination =  [[GTScale9Control alloc] initWithFrame:NSMakeRect(372,110,32,27)];
	[chooseDestination sendsActionOnMouseUp:true];
	[chooseDestination setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[chooseDestination setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[chooseDestination setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[chooseDestination setTopLeftPoint:tl];
	[chooseDestination setBottomRightPoint:tr];
	[chooseDestination setIcon:[NSImage imageNamed:@"folderIcon.png"]];
	[chooseDestination setIconPosition:NSMakePoint(8,7)];
	[chooseDestination setTarget:self];
	[chooseDestination setAction:@selector(choosedir:)];
	[[cloneRepoWindow contentView] addSubview:chooseDestination];
	
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(342,20,62,27)];
	[ok sendsActionOnMouseUp:true];
	[ok setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[ok setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[ok setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[ok setTopLeftPoint:tl];
	[ok setBottomRightPoint:tr];
	[ok setAttributedTitle:[GTStyles getButtonString:@"Clone!"]];
	[ok setAttributedTitleDown:[GTStyles getDownButtonString:@"Clone!"]];
	[ok setAttributedTitlePosition:NSMakePoint(12,6)];
	[ok setAction:@selector(clone:)];
	[ok setTarget:self];
	[[cloneRepoWindow contentView] addSubview:ok];
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(276,20,62,27)];
	[cancel sendsActionOnMouseUp:true];
	[cancel setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[cancel setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[cancel setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[cancel setTopLeftPoint:tl];
	[cancel setBottomRightPoint:tr];
	[cancel setAttributedTitle:[GTStyles getButtonString:@"Cancel"]];
	[cancel setAttributedTitleDown:[GTStyles getDownButtonString:@"Cancel"]];
	[cancel setAttributedTitlePosition:NSMakePoint(12,6)];
	[cancel setAction:@selector(cancel:)];
	[cancel setTarget:self];
	[[cloneRepoWindow contentView] addSubview:cancel];
	
	[helpButton setAction:@selector(onHelpButton)];
	[helpButton setTarget:self];
}

- (void) onHelpButton {
	NSString * v = [repoURL stringValue];
	if([v isEmpty]) [repoURL setStringValue:@"git://git.server.com/project.git"];
	if([v isEqual:@"git://git.server.com/project.git"]) [repoURL setStringValue:@"git@127.0.0.1:project.git"];
	else if([v isEqual:@"git@127.0.0.1:project.git"]) [repoURL setStringValue:@"http://git.server.com/project.git"];
	else if([v isEqual:@"http://git.server.com/project.git"]) [repoURL setStringValue:@"git://git.server.com/project.git"];
}

- (void) cancel:(id) sender {
	[cloneRepoWindow orderOut:self];
	GDRelease(destinationPath);
}

- (void) clone:(id) sender {
	if(destinationPath is nil) {
		NSBeep();
		return;
	}
	if([[repoURL stringValue] length] is 0) {
		NSBeep();
		return;
	}
	BOOL isdir = false;
	if(![fileman fileExistsAtPath:destinationPath isDirectory:&isdir]) {
		if(!isdir) [modals runCloneDestinationNotExist];
		else [modals runCloneDestinationNotDirectory];
	}
	[self startCloning];
}

- (void) choosedir:(id) sender {
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:YES];
	[op setCanCreateDirectories:true];
	[op beginSheetForDirectory:NULL file:NULL modalForWindow:cloneRepoWindow modalDelegate:self didEndSelector:@selector(openDidEnd:returnCode:) contextInfo:nil];
}

- (void) openDidEnd:(id) sender returnCode:(int) code {
	NSOpenPanel * op = (NSOpenPanel *) sender;
	if(code is NSCancelButton) return;
	destinationPath = [[op filename] copy];
	[destination setStringValue:destinationPath];
}

- (void) startCloning {
	isCloning=true;
	NSString * cloneURL=[repoURL stringValue];
	[statusProgress setUsesThreadedAnimation:true];
	[statusProgress startAnimation:nil];
	[[NSApplication sharedApplication] beginSheet:statusWindow modalForWindow:cloneRepoWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
	cloneRepo=[[GTOpCloneRepo alloc] initWithRepoURL:cloneURL inDir:destinationPath];
	NSOperationQueue * q = [[NSOperationQueue alloc] init];
	[cloneRepo setCloneController:self];
	[cloneRepo setCompletionBlock:^{
		[q release];
		[self cloneComplete];
	}];
	[q setMaxConcurrentOperationCount:25];
	[q addOperation:cloneRepo];
	[NSTimer scheduledTimerWithTimeInterval:216000 target:self selector:@selector(onTimeout) userInfo:nil repeats:false];
}

- (void) onTimeout {
	if(!isCloning)return;
	[cloneRepo cancel];
	[cloneRepo release];
	[statusWindow orderOut:nil];
	[statusProgress stopAnimation:self];
	[modals runCloneTimedOut];
}

- (void) onCloneError:(NSInteger) code {
	errored=true;
	[statusWindow orderOut:nil];
	[statusProgress stopAnimation:self];
	[modals runModalFromCode:code];
}

- (void) cloneComplete {
	isCloning=false;
	[[NSApplication sharedApplication] endSheet:statusWindow];
	[statusWindow orderOut:nil];
	[statusProgress stopAnimation:self];
	openPath=[cloneRepo pathToOpen];
	if(!errored) {
		[cloneRepoWindow orderOut:nil];
		NSURL * u = [NSURL fileURLWithPath:openPath isDirectory:true];
		[[GTDocumentController sharedDocumentController] openDocumentWithContentsOfURL:u display:true error:nil];
	}
	[cloneRepo release];
	openPath=nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTCloneRepoController\n");
	#endif
	isCloning=false;
	errored=false;
	modals=nil;
	GDRelease(chooseDestination);
	GDRelease(destinationPath);
	[super dealloc];
}

@end

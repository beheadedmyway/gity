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

#import "GTModalController.h"
#import "GTNewBranchController.h"
#import "GTCloneRepoController.h"
#import "GTDeleteTagAccessoryView.h"
#import "GTDeleteBranchAccessoryView.h"
#import "GTDontAskCommitsAheadView.h"
#import "GTDontAskToCloseCommitsAheadView.h"
#import "GTRemindQuitFileMerge.h"
#import "GTAlertDeleteAccessoryView.h"
#import "GTCherryPickAccessoryView.h"
#import "GTUnknownErrorController.h"
#import "GittyDocument.h"

static GTModalController * inst = nil;

@implementation GTModalController
@synthesize cloneRepoController;

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id inst = nil;
    dispatch_once(&pred, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

- (id) init {
	if(self = [super init]) {
		cloneRepoController = [[GTCloneRepoController alloc] init];
		
		[NSBundle loadNibNamed:@"AlertAccessoryViews" owner:self];
	}
	return self;
}

- (void) cloneRepo {
	[cloneRepoController show];
}

- (void)runErrorSheet:(GittyDocument *)document titleMessage:(NSString *)titleMessage errorMessage:(NSString *)errorMessage
{
    GTUnknownErrorController *controller = [[GTUnknownErrorController alloc] initWithGD:document];
    [controller showAsSheetWithTitle:titleMessage error:errorMessage];
    errorSheetController = controller;
}

- (void)runSheetForError:(NSDictionary *)dictionary
{
    GittyDocument *document = [dictionary objectForKey:@"document"];
    if(![document.gtwindow isVisible] || [document.status isShowingSheet]) {
        [self performSelector:@selector(runSheetForError:) withObject:dictionary afterDelay:0.3];
    }
    else
    {
        NSBeep();
        NSString *errorMessage = [dictionary objectForKey:@"message"];
        NSString *title = [dictionary objectForKey:@"title"];
        if (!title)
            title = NSLocalizedStringFromTable(@"Git has reported an error.",@"Localized",@"unknown error msg");
        NSString *formattedError = [errorMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
        [self runErrorSheet:document titleMessage:title errorMessage:formattedError];
    }
}

- (void) runModalForError:(NSString *) errorMessage {
    NSString *formattedError = [errorMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"];
    NSRunAlertPanel(NSLocalizedStringFromTable(@"Git has reported an error.",@"Localized",@"unknown error msg"),
					formattedError,
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);	
}

- (void) runModalFromCode:(NSInteger)code message:(NSString *)message document:(GittyDocument *)document
{
    NSString *title = NSLocalizedStringFromTable(@"Git has reported an error.",@"Localized",@"unknown error msg");
    
	switch (code)
    {
		case 85:
            title = NSLocalizedStringFromTable(@"Remote Repo Not Available",@"Localized",@"remote repo not available msg");
            message = NSLocalizedStringFromTable(@"Either you're not connected to the internet, or the server hung up unexpectedly.",@"Localized",@"remote repo not available msg description");
			break;
		case 86:
            title = NSLocalizedStringFromTable(@"Server Not Available",@"Localized",@"server not available msg");
            message = NSLocalizedStringFromTable(@"The server couldn't be connected to.",@"Localized",@"server not available msg description");
			break;
		case 87:
			[self runPermissionDeniedForClone];
			break;
		case 88:
			[self runHostVerificationFailed];
			break;
		case 89:
            title = NSLocalizedStringFromTable(@"Merge Error",@"Localized",@"merge error msg");
            message = NSLocalizedStringFromTable(@"The branch I tried to merge doesn't point to a commit, nothing was merged.",@"Localized",@"merge error msg description");
			break;
		case 90:
            title = NSLocalizedStringFromTable(@"Push Error",@"Localized",@"push error msg");
            message = NSLocalizedStringFromTable(@"This remote can't be pushed to.",@"Localized",@"push error msg description");
			break;
		case 91:
            title = NSLocalizedStringFromTable(@"Push Error",@"Localized",@"push error msg"),
            message = NSLocalizedStringFromTable(@"This remote can't be pushed to.  Please merge the remote changes before pushing again. ",@"Localized",@"push newer error msg description");
			break;
        case 92:
            title = NSLocalizedStringFromTable(@"Checkout Aborted",@"Localized",@"would overwrite msg");
            message = NSLocalizedStringFromTable(@"Your local changes would be overwritten by checkout.  Commit or stash your changes and try again.",@"Localized",@"would overwrite msg description");
            break;
        case 93:
            // fall through with the defaults
		default:
			break;
	}
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", document, @"document", title, @"title", nil];
    [self runSheetForError:userInfo];
}

- (void) runModalFromCode:(NSInteger)code message:(NSString *)message
{
	switch (code)
    {
		case 85:
			[self runRemoteEndHungUp];
			break;
		case 86:
			[self runServerUnreachable];
			break;
		case 87:
			[self runPermissionDeniedForClone];
			break;
		case 88:
			[self runHostVerificationFailed];
			break;
		case 89:
			[self runBranchDoesntPointToCommit];
			break;
		case 90:
			[self runCantPushToRemote];
			break;
		case 91:
			[self runCantPushToNewerRemote];
			break;
        case 92:
            [self runWouldOverwriteChanges];
            break;
		default:
			break;
	}
}


- (void) runWouldOverwriteChanges {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Checkout Aborted",@"Localized",@"would overwrite msg"),
					NSLocalizedStringFromTable(@"Your local changes would be overwritten by checkout.  Commit or stash your changes and try again.",@"Localized",@"would overwrite msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runHasRemoteAlready {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Remote Already Exists",@"Localized",@"dup remote msg"),
					NSLocalizedStringFromTable(@"You already have a remote by that name.",@"Localized",@"dup remote msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runCantPushToRemote {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Push Error",@"Localized",@"push error msg"),
					NSLocalizedStringFromTable(@"This remote can't be pushed to.",@"Localized",@"push error msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runCantPushToNewerRemote {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Push Error",@"Localized",@"push error msg"),
					NSLocalizedStringFromTable(@"This remote can't be pushed to.  Please merge the remote changes before pushing again. ",@"Localized",@"push newer error msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runBranchDoesntPointToCommit {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Merge Error",@"Localized",@"merge error msg"),
						NSLocalizedStringFromTable(@"The branch I tried to merge doesn't point to a commit, nothing was merged.",@"Localized",@"merge error msg description"),
						NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						nil,
						nil);
}

- (NSInteger) runShouldCheckForUpdates {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Check For Updates?",@"Localized",@"check for updates msg"),
					NSLocalizedStringFromTable(@"Do you want Gity to check for updates on startup?",@"Localized",@"check for updates msg description"),
					NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
					NSLocalizedStringFromTable(@"No",@"Localized",@"no button label"),
					nil);
}

- (void) runCantFindTextmateBinary {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"No Textmate Binary Found",@"Localized",@"no textmate binary msg"),
					NSLocalizedStringFromTable(@"I couldn't find the Textmate binary, please install it from Textmate.",@"Localized",@"no textmate binary msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runInstalledTMBundle {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Success!",@"Localized",@"textmate success msg"),
					NSLocalizedStringFromTable(@"You'll need to restart Textmate.",@"Localized",@"textmate success msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runHostVerificationFailed {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Remote Host Not Verified",@"Localized",@"remote host not verified msg"),
					NSLocalizedStringFromTable(@"The remote host's public key must be verified and present in ~/.ssh/knownhosts.",@"Localized",@"remote host not verified msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runPermissionDeniedForClone {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Permission Denied",@"Localized",@"permission denied msg"),
					NSLocalizedStringFromTable(@"Permission was denied, make sure ssh is setup correctly.",@"Localized",@"permission denied msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runCloneDestinationNotExist {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Invalid Destination",@"Localized",@"invalid destination msg"),
					NSLocalizedStringFromTable(@"The destination does not exist.",@"Localized",@"invalid destination msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runCloneDestinationNotDirectory {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Invalid Destination",@"Localized",@"invalid destination msg"),
					NSLocalizedStringFromTable(@"The destination is not a directory.",@"Localized",@"invalid destination msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runSavedLicenseInvalid {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Invalid License",@"Localized",@"license expired msg"),
					NSLocalizedStringFromTable(@"Your license for Gity is no longer valid.",@"Localized",@"license expired msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (void) runDocumentExpired {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Session Expired",@"Localized",@"session expired msg"),
					NSLocalizedStringFromTable(@"This session has expired; purchase Gity to stop session expirations. You can restart Gity to continue using it.",@"Localized",@"session expired msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,
					nil);
}

- (NSInteger) runReportDiffBugNotice {
	NSBeep();
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Report Diff To Mac Endeavor?",@"Localized",@"report diff msg"),
					NSLocalizedStringFromTable(@"If this diff is rendered incorrectly, or if there is something else wrong with it, this will send it to Mac Endeavor to look at.",@"Localized",@"report diff msg description"),
					NSLocalizedStringFromTable(@"Send",@"Localized",@"send button label"),
					NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),
					nil);
}

- (NSInteger) runReportCommitBugNotice {
	NSBeep();
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Report Commit To Mac Endeavor?",@"Localized",@"report commit msg"),
						   NSLocalizedStringFromTable(@"If this commit is rendered incorrectly, or if there is something else wrong with it, this will send it to Mac Endeavor to look at.",@"Localized",@"report commit msg description"),
						   NSLocalizedStringFromTable(@"Send",@"Localized",@"send button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),
						   nil);
}

- (void) runCloneTimedOut {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Clone Timed Out",@"Localized",@"default remote msg"),
					NSLocalizedStringFromTable(@"The repository took more than 60 minutes to clone, something either went wrong or it's huge. Please clone it from the commandline.",@"Localized",@"default remote msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (NSInteger) runCommitsAheadForSingleModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch {
	NSString * msg = [NSString stringWithFormat:@"You're ahead by %@ commit.",aheadByCount];
	NSString * msg2;
	if(remote is nil) msg2 = [NSString stringWithFormat:@"%@ is ahead of the remote branch by %@ commit, do you really want to quit now?",branch,aheadByCount];
	else msg2 = [NSString stringWithFormat:@"%@ is ahead of %@/%@ by %@ commit, do you really want to quit now?",branch,remote,branch,aheadByCount];
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:msg];
	[alert setInformativeText:msg2];
	[alert addButtonWithTitle:@"Yes, Quit Now"];
	[alert addButtonWithTitle:@"No, Don't Quit Yet"];
	[dontAskForCommitsAhead reset];
	[alert setAccessoryView:dontAskForCommitsAhead];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([dontAskForCommitsAhead isChecked]) {
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:kGTIgnoreCommitsAhead];
	}
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (NSInteger) runCommitsAheadModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch {
	NSString * msg = [NSString stringWithFormat:@"You're ahead by %@ commits.",aheadByCount];
	NSString * msg2;
	if(remote is nil) msg2 = [NSString stringWithFormat:@"%@ is ahead of the remote branch by %@ commits, do you really want to quit now?",branch,aheadByCount];
	else msg2 = [NSString stringWithFormat:@"%@ is ahead of %@/%@ by %@ commits, do you really want to quit now?",branch,remote,branch,aheadByCount];
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:msg];
	[alert setInformativeText:msg2];
	[alert addButtonWithTitle:@"Yes, Quit Now"];
	[alert addButtonWithTitle:@"No, Don't Quit Yet"];
	[dontAskForCommitsAhead reset];
	[alert setAccessoryView:dontAskForCommitsAhead];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([dontAskForCommitsAhead isChecked]) {
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:kGTIgnoreCommitsAhead];
	}
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (NSInteger) runCloseCommitsAheadForSingleModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch {
	NSString * msg = [NSString stringWithFormat:@"You're ahead by %@ commit",aheadByCount];
	NSString * msg2;
	if(remote is nil) msg2 = [NSString stringWithFormat:@"%@ is ahead of the remote branch by %@ commit, do you really want to close this window now?",branch,aheadByCount];
	else msg2 = [NSString stringWithFormat:@"%@ is ahead of %@/%@ by %@ commit, do you really want to close this window now?",branch,remote,branch,aheadByCount];
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:msg];
	[alert setInformativeText:msg2];
	[alert addButtonWithTitle:@"Yes, Close Anyway"];
	[alert addButtonWithTitle:@"No, Keep It Open"];
	[dontAskToCloseForCommitsAhead reset];
	[alert setAccessoryView:dontAskToCloseForCommitsAhead];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([dontAskToCloseForCommitsAhead isChecked]) {
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:kGTIgnoreCommitsAhead];
	}
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (NSInteger) runCloseCommitsAheadModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch {
	NSString * msg = [NSString stringWithFormat:@"You're ahead by %@ commits",aheadByCount];
	NSString * msg2;
	if(remote is nil) msg2 = [NSString stringWithFormat:@"%@ is ahead of the remote branch by %@ commits, do you really want to close this window now?",branch,aheadByCount];
	else msg2 =[NSString stringWithFormat:@"%@ is ahead of %@/%@ by %@ commits, do you really want to close this window now?",branch,remote,branch,aheadByCount];
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:msg];
	[alert setInformativeText:msg2];
	[alert addButtonWithTitle:@"Yes, Close Anyway"];
	[alert addButtonWithTitle:@"No, Keep It Open"];
	[dontAskToCloseForCommitsAhead reset];
	[alert setAccessoryView:dontAskToCloseForCommitsAhead];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([dontAskToCloseForCommitsAhead isChecked]) {
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:kGTIgnoreCommitsAhead];
	}
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (void) runRemindQuitFileMerge {
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"kGTRemindToQuitFileMerge"] == true) return;
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"Quit FileMerge"];
	[alert setInformativeText:@"Make sure you quit FileMerge when you're done. Quitting FileMerge will cleanup temporary files."];
	[alert addButtonWithTitle:@"OK"];
	[remindQuitFileMerge reset];
	[alert setAccessoryView:remindQuitFileMerge];
	[alert runModal];
	if([remindQuitFileMerge isChecked]) {
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"kGTRemindToQuitFileMerge"];
	}
}

- (NSInteger) runDeleteTag {
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"Are you sure?"];
	[alert setInformativeText:@"Do you really want delete this tag?"];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[deleteTagView reset];
	[alert setAccessoryView:deleteTagView];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([deleteTagView isChecked]) return kGTAccessoryViewDeleteAll;
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (void) runLooseObjectCountReminder {
	if([[NSUserDefaults standardUserDefaults] boolForKey:kGTWarnAboutLooseObjects]) return;
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"GC Your Git Repository"];
	[alert setInformativeText:@"This repository has over 1000 loose objects, you should probably run gc. (Repo > GC)"];
	[alert addButtonWithTitle:@"OK"];
	[looseObjectsReminderView reset];
	[alert setAccessoryView:looseObjectsReminderView];
	NSInteger res = [alert runModal];
	if(res==100){}
	if([looseObjectsReminderView isChecked]) [[NSUserDefaults standardUserDefaults] setBool:true forKey:kGTWarnAboutLooseObjects];
}

- (NSInteger) runDeleteBranch {
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"Are you sure?"];
	[alert setInformativeText:@"Do you really want delete this branch? It will be deleted irrespective of any un-merged changes."];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[deleteBranchView reset];
	[alert setAccessoryView:deleteBranchView];
	NSInteger res = [alert runModal];
	if(res == NSAlertSecondButtonReturn) return NSCancelButton;
	if([deleteBranchView isChecked]) return kGTAccessoryViewDeleteAll;
	if(res == NSAlertFirstButtonReturn) return NSOKButton;
	return NSCancelButton;
}

- (NSUInteger) runCherryPickNotice:(NSString *) _currentBranch {
	//if([[NSUserDefaults standardUserDefaults] boolForKey:@"kGTPromptForCherryPick"] == true) return NSOKButton;
	NSBeep();
	NSString * msg = [NSString stringWithFormat:@"This creates a new commit on the current branch (%@), and applies a patch of the commit. \n\nSee \"git help cherry-pick\" for more information.",_currentBranch];
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Cherry Pick This Commit?",@"Localized",@"cherry pick msg"),
						   msg,
						   NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (void) runCantFindFileMerge {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Cannot Find FileMerge",@"Localized",@"cant find file merge msg"),
					NSLocalizedStringFromTable(@"The command required (opendiff) to launch FileMerge was not found. Install Apple Developer Tools",@"Localized",@"cant find file merge description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (NSInteger) runDeleteSubmodule {
	NSBeep();
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"delete submodule msg"),
						   NSLocalizedStringFromTable(@"Do you really want delete this submodule?",@"Localized",@"delete submodule msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (void) runSubmoduleDestinationIncorrect {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Submodule Destination Incorrect",@"Localized",@"submodule dest incorrect msg"),
					NSLocalizedStringFromTable(@"Submodules need to be anywhere inside of this git project's directory.",@"Localized",@"submodule dest incorrect msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runConfigNeedsSectionError {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Config Key Incorrect",@"Localized",@"config key incorrect msg"),
					NSLocalizedStringFromTable(@"Config keys must contain a section and name. (section.varname)",@"Localized",@"config key incorrect msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runSelectFilesFirst {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"No Files Selected",@"Localized",@"resolve conflicts msg"),
					NSLocalizedStringFromTable(@"You've got to select some files if you want to commit them. :D",@"Localized",@"select files msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runConflictedStateForCheckout {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Resolve Conflicts First",@"Localized",@"resolve conflicts msg"),
					NSLocalizedStringFromTable(@"The current branch cannot be in a conflicted state.",@"Localized",@"resolve conflicts msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runRemoteEndHungUp {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Remote Repo Not Available",@"Localized",@"remote repo not available msg"),
					NSLocalizedStringFromTable(@"Either you're not connected to the internet, or the server hung up unexpectedly.",@"Localized",@"remote repo not available msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runServerUnreachable {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Server Not Available",@"Localized",@"server not available msg"),
					NSLocalizedStringFromTable(@"The server couldn't be connected to.",@"Localized",@"server not available msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runNoDefaultRemote {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Default Remote Not Set",@"Localized",@"default remote msg"),
						NSLocalizedStringFromTable(@"A default remote needs to be set for this branch. You can set the default remote in the branch's context menu.",@"Localized",@"default remote msg description"),
						NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						nil,nil);
}

- (NSInteger) runMergeBranch {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"merge branch msg"),
						   NSLocalizedStringFromTable(@"Do you really want to merge this branch onto the current branch?",@"Localized",@"merge branch msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runDeleteRemoteDoubleCheck {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you absolutely sure?",@"Localized",@"remote delete msg"),
						   NSLocalizedStringFromTable(@"I noticed this is the origin remote, are you really sure?",@"Localized",@"remote delete msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runDeleteStash {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"stash delete msg"),
						   NSLocalizedStringFromTable(@"Do you really want to delete this stash?",@"Localized",@"stash delete msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runStashSavedFromDifferentBranch {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Stash From Different Branch",@"Localized",@"stash diff branch msg"),
						   NSLocalizedStringFromTable(@"This stash was originally saved from a different branch, do you still want to continue?",@"Localized",@"stash diff branch msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runDeleteRemote {
	NSBeep();
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"delete remote msg"),
						   NSLocalizedStringFromTable(@"Do you really want delete this remote?",@"Localized",@"delete remote msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runDeleteBranchAt:(NSString *) remote {
	NSBeep();
	NSString * msg = [NSString stringWithFormat:@"Do you really want to delete this branch @ %@",remote];
	return NSRunAlertPanel(@"Are you sure?",msg,
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runDeleteTagAt:(NSString *) remote {
	NSBeep();
	NSString * msg = [NSString stringWithFormat:@"Do you really want to delete this tag @ %@",remote];
	return NSRunAlertPanel(@"Are you sure?",msg,
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runSoftResetConfirmation {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"discard msg"),
						   NSLocalizedStringFromTable(@"Do you really want to discard unstaged changes?",@"Localized",@"discard msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (NSInteger) runHardResetConfirmation {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"reset msg"),
						   NSLocalizedStringFromTable(@"Do you really want to reset the repo back to HEAD? You will lose all staged and non-staged changes.",@"Localized",@"reset msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (void) runStageAllChangesBeforeContinueing {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Stage Your Changes Before Continuing",@"Localized",@"stage changes"),
					NSLocalizedStringFromTable(@"You must stage (add) all of you local changes before continuing",@"Localized",@"stage changes msg directory"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runDirIsDirtyForRebase {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Your Working Directory is Dirty",@"Localized",@"dirty working dir"),
					NSLocalizedStringFromTable(@"You can't pull with rebase until your working directory is clean.",@"Localized",@"dirty working dir msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runDirIsDirtyForCheckout {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Your Working Directory is Dirty",@"Localized",@"dirty working dir"),
						NSLocalizedStringFromTable(@"You can't checkout a branch until your working directory is clean",@"Localized",@"dirty working dir msg description"),
						NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						nil,nil);
}

- (void) runDirIsDirtyForEmptyBranch {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Your Working Directory is Dirty",@"Localized",@"dirty working dir"),
					NSLocalizedStringFromTable(@"You need a clean working directory before creating an empty branch.",@"Localized",@"dirty working dir msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (NSInteger) runMoveToTrashConfirmation {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"mv files to trash"),
						   NSLocalizedStringFromTable(@"Do you really want to move these files to the trash?",@"Localized",@"move files to trash msg description"),
						   NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
}

- (void) runWorkingTreeDirtyForCherry {
	NSBeep();
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Your working directory is dirty",@"Localized",@"dirty working for cherry"),
						NSLocalizedStringFromTable(@"You need a clean working directory before you can cherry pick a commit.",@"Localized",@"dirty working for cherry msg description"),
						NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						nil,nil);
}

- (NSUInteger) runWorkingTreeDirty {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Your working directory is dirty",@"Localized",@"dirty working dir"),
						   NSLocalizedStringFromTable(@"Commit, or reset to head before branching.",@"Localized",@"dirty working dir msg description"),
						   NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						   nil,nil);
}

- (NSUInteger) runWorkingDirInConflict {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Your working directory is now in conflict",@"Localized",@"working dir conflicts"),
						   NSLocalizedStringFromTable(@"Resolve your conflicts before going any further",@"Localized",@"working dir conflicts msg description"),
						   NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
						   nil,nil);
}

- (void) runNotAGitRepoAlert {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Cannot Open Directory",@"Localized",@"not a git repo"),
					NSLocalizedStringFromTable(@"It appears this directory is not a git repository",@"Localized",@"not a git repo msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (void) runAlreadyAGitRepoAlert {
	NSRunAlertPanel(NSLocalizedStringFromTable(@"Already A Git Repository",@"Localized",@"already a git repository"),
					NSLocalizedStringFromTable(@"It appears this directory is already a git repository",@"Localized",@"already a git repo msg description"),
					NSLocalizedStringFromTable(@"OK",@"Localized",@"ok button label"),
					nil,nil);
}

- (NSUInteger) runCantFindGitExecAlert {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Gity Can't Find Your Git Executable",@"Localized",@"cant find git"),
						   NSLocalizedStringFromTable(@"I searched in common places and couldn't find the git executable, please tell me where it is",@"Localized",@"cant find git msg description"),
						   NSLocalizedStringFromTable(@"Choose",@"Localized",@"choose button label"),
						   NSLocalizedStringFromTable(@"Cancel",@"Localized",@"cancel button label"),nil);
	
}

- (NSInteger) verifyGitRemove {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"git remove"),
						   NSLocalizedStringFromTable(@"Do you really want to remove these files from the git repository?",@"Localized",@"git remove msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"No",@"Localized",@"no button label"),
						   nil);
}

- (NSInteger) verifyGitDiscard {
	return NSRunAlertPanel(NSLocalizedStringFromTable(@"Are you sure?",@"Localized",@"git discard"),
						   NSLocalizedStringFromTable(@"Do you really want to discard local changes?",@"Localized",@"git discard msg description"),
						   NSLocalizedStringFromTable(@"Yes",@"Localized",@"yes button label"),
						   NSLocalizedStringFromTable(@"No",@"Localized",@"no button label"),
						   nil);
}

+ (id)allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *) zone {
	return self;
}

@end

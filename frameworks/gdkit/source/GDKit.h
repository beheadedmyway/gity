//copyright 2009 aaronsmith

/**
 * @file GDKit.h
 *
 * Framework header. Link against <b>GDKit.framework</b>
 * and <b>#import <GDKit/GDKit.h></b>.
 */

#import <CoreServices/CoreServices.h>

//macros and definitions
#import "macros.h"

//accesibility
#import "GDAccessibilityManager.h"
#import "GDAccessibilityNotification.h"
#import "GDAccessibilityObserver.h"
#import "GDAccessibilityOperationResult.h"

//system
#import "GDASLLog.h"
#import "GDASLLogManager.h"
#import "GDULimit.h"

//carbon
#import "GDCarbonEvent.h"
#import "GDCarbonEventManager.h"

//quartz
#import "GDQuartzDisplay.h"

//additions
#import "NSFileManager+Additions.h"
#import "NSUserDefaults+Additions.h"
#import "NSStatusItem+Additions.h"
#import "NSWorkspace+Additions.h"
#import "NSView+Additions.h"
#import "NSFileHandle+Additions.h"

//licensing
#import "GDAppExpiration.h"
#import "GDRegistration.h"

//applications
#import "GDAlertAccessoryView.h"
#import "GDApplicationController.h"
#import "GDApplicationInfo.h"
#import "GDBaseNSTaskOperation.h"
#import "GDBaseObject.h"
#import "GDExternalNibController.h"
#import "GDBaseOperation.h"
#import "GDBaseResponder.h"
#import "GDBaseSheetWindow.h"
#import "GDBaseView.h"
#import "GDCallback.h"
#import "GDDocument.h"
#import "GDDocumentController.h"
#import "GDMainMenuController.h"
#import "GDModalController.h"
#import "GDOperationsController.h"
#import "GDSoundController.h"
#import "GDViewController.h"
#import "GDWindowController.h"
#import "GDModel.h"
#import "GDDrawerController.h"
#import "GDContextMenuController.h"

//cli
#import "GDCliProxy.h"
#import "GDCliProxyConnector.h"

//helpers
#import "GDResponderHelper.h"

//crash
#import "GDCrashReporter.h"
#import "GDCrashReporterDelegate.h"

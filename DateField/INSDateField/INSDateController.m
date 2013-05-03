//
//  INSDateController.m
//  dateField
//
//  Created by Massimo Moiso on 03/05/13.
//

#import "INSDateController.h"

@interface INSDateController ()

@property (nonatomic,strong) NSWindow *calWindow;
@property (nonatomic,strong) id<NSWindowDelegate> oldDelegate;
@property (nonatomic,strong) NSWindow *ownerWindow;
@property (nonatomic,assign) NSRect callerRect;
@property (nonatomic,strong) NSDate *oldDate;

- (NSButton *)buildButtonWithFrame:(NSRect)rect withTitle:(NSString *)title andAction:(SEL)action toObject:(id)obj;
- (void)okReturned:(id)sender;
- (void)cancelReturned:(id)sender;
- (void)noDateReturned:(id)sender;
- (void)calendarDidEnd:(NSWindow *)sheet returnCode:(NSInteger)code contextInfo:(void *)context;

@end

/* ------------------------------------------------ */

@implementation INSDateController

// --------------------------------
//	It creates the sheet and all objects inside it
// --------------------------------
- (id)init
{
	self = [super init];
	if (self) {
		self.calWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 179, 236) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
		[self.calWindow setHasShadow:YES];
		NSView *content = [self.calWindow contentView];
		
		self.calPicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(20, 68, 139, 148)];
		[self.calPicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
		[self.calPicker setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
		[self.calPicker setBordered:NO];
		[content addSubview:self.calPicker];
		
		NSButton *okBtn = [self buildButtonWithFrame:NSMakeRect(93, 43, 66, 17) withTitle:NSLocalizedString(@"OK", @"") andAction:@selector(okReturned:) toObject:self];
		[content addSubview:okBtn];
		NSButton *cancelBtn = [self buildButtonWithFrame:NSMakeRect(20, 43, 66, 17) withTitle:NSLocalizedString(@"Cancel", @"") andAction:@selector(cancelReturned:) toObject:self];
		[content addSubview:cancelBtn];
		NSButton *noDateBtn = [self buildButtonWithFrame:NSMakeRect(20, 19, 139, 17) withTitle:NSLocalizedString(@"No Date", @"no date btn") andAction:@selector(noDateReturned:) toObject:self];
		[noDateBtn bind:@"enabled" toObject:self withKeyPath:@"noDateBtnEnabled" options:nil];
		[content addSubview:noDateBtn];
		
	}
	return self;
}

// --------------------------------
//	Called to start the sheet
//		theDate:	the starting date shown in the calendar
//		theWindow:	the sheet will be attached to this window
//		theRect:	frame of the DateField (the sheet will appear here)
// --------------------------------
- (void)dialogWithDate:(NSDate *)theDate attachedTo:(NSWindow *)theWindow startRect:(NSRect)theRect
{
	[self.calPicker setDateValue:theDate];		// set the starting date
	self.oldDate = theDate;						// store the starting date in case of 'Cancel'
	self.ownerWindow = theWindow;				// store the main window (we need to set its delegate)
	self.oldDelegate = [theWindow delegate];	// store the present delegate, to be restored
	theWindow.delegate = self;					// set me as the window delegate
	self.callerRect = theRect;					// store the position of the caller
	//now fire the sheet
	[NSApp beginSheet:self.calWindow modalForWindow:self.ownerWindow modalDelegate:self didEndSelector:@selector(calendarDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

// --------------------------------
//	Ok button pressed: update the dateNew property
// --------------------------------
- (void)okReturned:(id)sender
{
	self.dateNew = [self.calPicker dateValue];
	[NSApp endSheet:self.calWindow];
}

// --------------------------------
//	Cancel button pressed: restore the old date
// --------------------------------
- (void)cancelReturned:(id)sender
{
	self.dateNew = self.oldDate;
	[NSApp endSheet:self.calWindow];
}

// --------------------------------
//	NoDate button pressed: put the date to nil
// --------------------------------
- (void)noDateReturned:(id)sender
{
	self.dateNew = nil;
	[NSApp endSheet:self.calWindow];
}


// --------------------------------
//	Callback from end sheet
//	Hide the sheet, restore the old delegate of the window
//	Post the 'didEnd' notification
// --------------------------------
- (void)calendarDidEnd:(NSWindow *)sheet returnCode:(NSInteger)code contextInfo:(void *)context
{
	[sheet orderOut:self];
	[self.ownerWindow setDelegate:self.oldDelegate];
	[[NSNotificationCenter defaultCenter] postNotificationName:calendarSheetDidEndNotification object:self userInfo:nil];
}

// --------------------------------
//	By now, I am the delegate of this window:
//	So I will position the sheet beneath the caller
// --------------------------------
- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
	rect.origin = self.callerRect.origin;
	rect.size.width = self.callerRect.size.width;
	return rect;
}

// --------------------------------
//	Convenient method to build the various buttons
// --------------------------------
- (NSButton *)buildButtonWithFrame:(NSRect)rect withTitle:(NSString *)title andAction:(SEL)action toObject:(id)obj
{
	NSButton *myBtn = [[NSButton alloc] initWithFrame:rect];
	[myBtn setTitle:title];
	[myBtn setBezelStyle:NSRoundRectBezelStyle];
	[myBtn setButtonType:NSMomentaryPushInButton];
	[[myBtn cell] setControlSize:NSSmallControlSize];
	[[myBtn cell] setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
	[myBtn setTarget:obj];
	[myBtn setAction:action];
	return myBtn;
}



@end
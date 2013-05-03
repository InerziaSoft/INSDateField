//
//  INSDateField.m
//  dateField
//
//  Created by Massimo Moiso on 02/05/13.
//

#import "INSDateField.h"
#import "INSDateController.h"

@interface INSDateField ()

@property (nonatomic,strong) INSDateController *dateCtrl;	//object managing the sheet
@property (nonatomic,strong) NSWindow *myMainWindow;		//sheet is attached to this window
- (void)calendarDidClose:(NSNotification *)notif;
- (void)updateBinding;

@end


@implementation INSDateField

// --------------------------------
//	Used to expose bindings
//	similar to those of NSDatePicker
// --------------------------------
+ (void)initialize
{
	[self exposeBinding:@"minimumDate"];
	[self exposeBinding:@"maximumDate"];
	[self exposeBinding:@"noDateEnabled"];
}

// --------------------------------
//	With this trick, the field appears to be enabled
//	even if it's not
// --------------------------------
- (void)drawRect:(NSRect)dirtyRect
{
	[self setEnabled:YES];
	[super drawRect:dirtyRect];
	[self setEnabled:NO];
}

// --------------------------------
//	All is ready, so do some mandatory task
// --------------------------------
- (void)awakeFromNib
{
	// if the formatter is not linked in IB (or if it's not a NSDateFormatter,
	// then we create one with some default data
	// We must have a DateFormatter because this is just a TextField
	
	if ( ![self.formatter isKindOfClass:[NSDateFormatter class]]  ) {
		NSDateFormatter *theDateFormat = [[NSDateFormatter alloc] init];
		[theDateFormat setDateStyle:NSDateFormatterMediumStyle];
		[theDateFormat setTimeStyle:NSDateFormatterNoStyle];
		self.formatter = theDateFormat;
	}
	
	// if the outlet is not linked, then the window to attach the sheet to
	// is set to the NSWindow (or NSPanel) containing the TextField
	
	self.myMainWindow = ( self.mainWindow != nil ) ? self.mainWindow : [self window];
	
	// if I am enabled, than a click on me will not be recorded as a mouseUp
	// but only as an edit event, so I disable me
	
	[self setEnabled:NO];
}

// --------------------------------
//	Here is where the magic happens
// --------------------------------
- (void)mouseUp:(NSEvent *)theEvent
{
	if (!self.dateCtrl) {
		self.dateCtrl = [[INSDateController alloc] init]; //for safety: dateCtrl should always be nil
	}
	[self.dateCtrl.calPicker setMinDate:self.minimumDate];	//set the minimum date of the DatePicker
	[self.dateCtrl.calPicker setMaxDate:self.maximumDate];	//the maximum date
	self.dateCtrl.noDateBtnEnabled = self.noDateEnabled;	//and the possibility to set a nil date
	
	// prepare the TextEdit content (the present date as a string) to be passed on to the sheet
	
	NSDate *theDate = self.objectValue;
	
	// before passing control to the sheet, set me as observer of the special notification
	// to be ready to accept the end of dialog
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarDidClose:) name:calendarSheetDidEndNotification object:self.dateCtrl];
	
	//call the starting method
	
	[self.dateCtrl dialogWithDate:theDate attachedTo:self.myMainWindow startRect:[self frame]];
}

// --------------------------------
//	The sheet closed - do some housekeeping
// --------------------------------
- (void)calendarDidClose:(NSNotification *)notif
{
	// remove me as observer of the notification (otherwise dateCtrl will not be released
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:calendarSheetDidEndNotification object:self.dateCtrl];
	
	NSDate *theNewDate = [self.dateCtrl dateNew];	// read the obtained date from dateCtrl
	self.dateCtrl = nil;							// set the property to nil, so it will be released
	
	// use the formatter to obtain a string from the new date
	// but if the date is nil, then set it to the empty string
	
	if (theNewDate)
		self.stringValue = [[self formatter] stringFromDate:theNewDate];
	else
		self.stringValue = @"";
	
	[self updateBinding];	// update the model
}

// --------------------------------
//	We can't directly write the date string into the TextField as the binding will not see the change
//	We ask info on binding for the Value key (NSValueBinding)
//	and use that info to obtain the object and keyPath to which the field is bound
//	Then update that value (and the field content will update too)
// --------------------------------
- (void)updateBinding
{
	NSDictionary *bindingInfo = [self infoForBinding:NSValueBinding];
	if (bindingInfo) {
		NSObject *boundObject = [bindingInfo valueForKey:NSObservedObjectKey];
		NSString *keyPath = [bindingInfo valueForKey:NSObservedKeyPathKey];
		if ( [self.stringValue isEqualToString:@""] ) {		//if the string is empty, the date is nil
			[boundObject setValue:nil forKeyPath:keyPath];
		} else {
			[boundObject setValue:[[self formatter] dateFromString:self.stringValue]  forKeyPath:keyPath];
		}
	}
}


@end

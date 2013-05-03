//
//  INSDateController.h
//  dateField
//
//  Created by Massimo Moiso on 03/05/13.
//

#import <Foundation/Foundation.h>

/*
 This object will build, manage and close the sheet.
 It must follows the NSWindowDelegate because it will have to position the sheet
 under the DateField, so it will be for a short time the delegate of the window
 */

@interface INSDateController : NSObject <NSWindowDelegate>

// The calendar view contained in the window
@property (nonatomic,strong) NSDatePicker *calPicker;

// the new date from the DatePicker
@property (nonatomic,strong) NSDate *dateNew;

// enable/disable the 'noDate' button
@property (nonatomic,assign) BOOL noDateBtnEnabled;

- (void)dialogWithDate:(NSDate *)theDate attachedTo:(NSWindow *)theWindow startRect:(NSRect)theRect;


// the notification posted when the sheet is closed
#define calendarSheetDidEndNotification		@"calendarSheetDidEnd"

@end
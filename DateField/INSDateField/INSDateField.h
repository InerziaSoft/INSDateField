//
//  INSDateField.h
//  DateField
//
//  Created by Massimo Moiso on 03/05/13.
//

/*
	This NSTextField subclass manages a date; when clicked a sheet will come out
	form beneath it, to edit the date value.
 
	If a NSDateFormatter is not supplied in Interface Builder, it will be created and used
	with some general date settings. Supply your own if you want to change it by connecting
	to the outlet in IB.
 
	If a window is not connected to its outlet (code below), the window containing the field
	will be used to present the sheet.
 
	The three properties below are avaialble for binding to the model.
	The final date value will be reflected to the model through the existing binding.
	If the field is not bound to any model, you can use the property 'objectValue' to access the date
 
 */



#import <Cocoa/Cocoa.h>

@interface INSDateField : NSTextField

// outlet to window that will present the sheet
// if not connected, the window associated to INSDateField will be used
@property (assign) IBOutlet NSWindow *mainWindow;

// the following are available to be bound
@property (nonatomic,strong) NSDate *maximumDate;	//max allowable date
@property (nonatomic,strong) NSDate *minimumDate;	//min allowable date
@property (nonatomic,assign) BOOL noDateEnabled;	//if YES, the 'No Date' button will be enabled


@end
//
//  INSAppDelegate.h
//  dateField
//
//  Created by Massimo Moiso on 02/05/13.
//

#import <Cocoa/Cocoa.h>

@interface INSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *myWindow;
@property (assign) IBOutlet NSTextField *dateField;
@property (nonatomic,strong) NSDate *myDate;
@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSDate *maxDate;
@property (nonatomic,assign) BOOL noDateButton;

@end

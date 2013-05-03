//
//  INSAppDelegate.m
//  dateField
//
//  Created by Massimo Moiso on 02/05/13.
//  Copyright (c) 2013 InerziaSoft. All rights reserved.
//

#import "INSAppDelegate.h"

@implementation INSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.myDate = [[NSDate alloc] initWithTimeIntervalSinceNow:2*24*60*60];
	[self.dateField bind:@"minimumDate" toObject:self withKeyPath:@"minDate" options:nil];
	[self.dateField bind:@"maximumDate" toObject:self withKeyPath:@"maxDate" options:nil];
	[self.dateField bind:@"noDateEnabled" toObject:self withKeyPath:@"noDateButton" options:nil];
}



@end

//
//  AppDelegate.m
//  MacLocker
//
//  Created by Stefan Lage on 10/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    lockerItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [lockerItem setMenu:self.lockerMenu];
    [lockerItem setImage:[NSImage imageNamed:@"locker"]];
    [lockerItem setHighlightMode:YES];
}

// Check if the device selected is reachable
// If not show an alert
-(void)checkReachability{
    IOBluetoothDevice *device = [[Singleton manager] getDeviceSelected];
    [device openConnection];
    if(![device isConnected]){
        NSString *msg = [NSString stringWithFormat:@"%@'s not reachable !", device.name];
        NSRunAlertPanel( @"Error", msg, @"OK", nil, nil );
    }
}

@end

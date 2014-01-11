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

-(void)deviceSelected:(BOOL)value{
    if(value){
        if([self checkReachability])
            [self beginLockerProcess];
    }
}

// Check if the device selected is reachable
// If not show an alert
-(BOOL)checkReachability{
    IOBluetoothDevice *device = [[Singleton manager] getDeviceSelected];
    [device openConnection];
    if(![device isConnected]){
        NSString *msg = [NSString stringWithFormat:@"%@'s not reachable !", device.name];
        NSRunAlertPanel( @"Error", msg, @"OK", nil, nil );
        return NO;
    }else
        return YES;
}

#pragma Locker process
-(void)beginLockerProcess{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        IOBluetoothDevice *device = [[Singleton manager] getDeviceSelected];
        BOOL isLocked = NO;
        while (YES) {
            // be sure to be connected
            [device openConnection];
            if([device isConnected]){
                if([device rawRSSI] < -60 && !isLocked){
                    // Low signal -> lock the Mac
                    [self screenSaver: YES];
                    isLocked = YES;
                }
                else{
                    if(isLocked){
                        [self screenSaver: NO];
                        isLocked = NO;
                    }
                }
            }
            sleep(1);
        }
    });
}

// Activate or not the screenSaver
- (void)screenSaver:(BOOL)activate
{
    NSDictionary* errorDict;
    NSString *action;
    if(activate)
        action = @"activate";
    else
        action = @"quit";
    NSAppleEventDescriptor* returnDescriptor = NULL;
    // Call ScreenSaver using AppelScript
    NSString *scriptString=[NSString stringWithFormat:
                            @"tell application \"ScreenSaverEngine\"\n"
                            @"%@\n"
                            @"end tell\n", action];
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:scriptString];
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
}

@end

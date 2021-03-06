//
//  AppDelegate.m
//  MacLocker
//
//  Created by Stefan Lage on 10/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "AppDelegate.h"

#define TURN_MSG        @"Turn Locker %@"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.menuDevices checkExisting];
}

-(void)awakeFromNib{
    lockerItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [lockerItem setMenu:self.lockerMenu];
    [lockerItem setImage:[self imageResized:[NSImage imageNamed:@"locker"] size:NSMakeSize(18, 18)]];
    [lockerItem setHighlightMode:YES];
}

// Resize an NSImage
-(NSImage *)imageResized:(NSImage*)image size:(NSSize)size{
    NSImage *sourceImage = image;
    [sourceImage setScalesWhenResized:YES];
    NSImage *smallImage = [[NSImage alloc] initWithSize: size];
    [smallImage lockFocus];
    [sourceImage setSize: size];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, size.width, size.height) operation:NSCompositeCopy fraction:1.0];
    [smallImage unlockFocus];
    return smallImage;
}

// Check if the device selected is reachable
// If not show an alert
-(BOOL)checkReachability{
    IOBluetoothDevice *device = [[Singleton manager] getDeviceSelected];
    [device openConnection];
    if(![device isConnected]){
        NSString *msg = [NSString stringWithFormat:@"%@'s not reachable !", device.name];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Display the alert in the main thread to be safe
            NSRunAlertPanel( @"Error", msg, @"OK", nil, nil );
        });
        return NO;
    }else
        return YES;
}

- (IBAction)turnOn:(id)sender {
    if(isTurnOn){
        isTurnOn = NO;
        [self.lockSwitch setTitle:[NSString stringWithFormat:TURN_MSG, @"On"]];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            if([self checkReachability]){
                // Turn it on
                isTurnOn = YES;
                [self.lockSwitch setTitle:[NSString stringWithFormat:TURN_MSG, @"Off"]];
                [self beginLockerProcess];
            }
        });
    }
}

- (IBAction)quit:(id)sender {
    isTurnOn = NO;
    exit(0);
}

#pragma Locker process
-(void)beginLockerProcess{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        IOBluetoothDevice *device = [[Singleton manager] getDeviceSelected];
        BOOL isLocked = NO;
        while (isTurnOn) {
            if(device == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Call function of main to stop the process
                    [self turnOn:nil];
                });
                return;
            }
            // be sure to be connected
            [device openConnection];
            if([device isConnected]){
                if([device rawRSSI] < -70 && !isLocked){
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


#pragma NSManagedObjectContext

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

#pragma NSManagedObjectModel

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

#pragma NSPersistentStoreCoordinator

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Model.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
    }
    return _persistentStoreCoordinator;
}

// return path of application documents
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end

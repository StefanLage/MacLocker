//
//  AppDelegate.h
//  MacLocker
//
//  Created by Stefan Lage on 10/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSMenuDevices.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem * lockerItem;
    BOOL isTurnOn;
}

@property (weak) IBOutlet NSMenu *lockerMenu;
@property (weak) IBOutlet NSMenuDevices *menuDevices;
@property (weak) IBOutlet NSMenuItem *lockSwitch;
// ManagedObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(BOOL)checkReachability;
- (IBAction)turnOn:(id)sender;
- (IBAction)quit:(id)sender;

@end

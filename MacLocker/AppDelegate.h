//
//  AppDelegate.h
//  MacLocker
//
//  Created by Stefan Lage on 10/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSMenuDevices.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDevicesDelegate>{
    NSStatusItem * lockerItem;
}

@property (weak) IBOutlet NSMenu *lockerMenu;
-(void)checkReachability;

@end

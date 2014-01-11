//
//  AppDelegate.h
//  MacLocker
//
//  Created by Stefan Lage on 10/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem * lockerItem;
    BOOL isTurnOn;
}

@property (weak) IBOutlet NSMenu *lockerMenu;
-(BOOL)checkReachability;
- (IBAction)turnOn:(id)sender;

@end

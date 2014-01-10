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
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:self.statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"locker"]];
    [statusItem setHighlightMode:YES];
}

@end

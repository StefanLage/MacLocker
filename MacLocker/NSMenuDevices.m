//
//  NSMenuDevices.m
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "NSMenuDevices.h"

#define ClassMajor [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]

@implementation NSMenuDevices

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        devices = [[NSMutableArray alloc] init];
        tagItemSelected = 0;
        int i = 0;
        // We add all devices paired
        for(IOBluetoothDevice *device in [IOBluetoothDevice pairedDevices]){
            if([ClassMajor containsObject:[NSNumber numberWithInt:device.deviceClassMajor]]){
                // Check if we got a right type of device
                NSMenuItem *item = [[NSMenuItem alloc] init];
                [item setTitle:device.name];
                [item setTarget:self];
                [item setAction:@selector(selectDevice:)];
                [item setTag:i];
                [self addItem:item];
                [devices addObject:device];
                i++;
            }
        }
    }
    return self;
}

// Select a device
-(void)selectDevice:(id)sender{
    [self deselectDevice];
    NSMenuItem *item = (NSMenuItem*)sender;
    // Set it on
    [item setState:1];
    [item setOnStateImage:[NSImage imageNamed:@"check"]];
    tagItemSelected = (int)item.tag;
    //IOBluetoothDevice *device = [devices objectAtIndex:item.tag];
}

-(void)deselectDevice{
    NSMenuItem *item = [self itemWithTag:tagItemSelected];
    if([item state] == 1){
        // Is it On ?
        [item setState:0];
    }
}

@end

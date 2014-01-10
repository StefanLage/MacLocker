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
        // We add all devices paired
        for(IOBluetoothDevice *device in [IOBluetoothDevice pairedDevices]){
            if([ClassMajor containsObject:[NSNumber numberWithInt:device.deviceClassMajor]]){
                // Check if we got a right type of device
                NSMenuItem *item = [[NSMenuItem alloc] init];
                [item setTitle:device.name];
                [self addItem:item];
            }
        }
    }
    return self;
}

@end

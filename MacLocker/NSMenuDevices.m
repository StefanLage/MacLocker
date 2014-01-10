//
//  NSMenuDevices.m
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "NSMenuDevices.h"

@implementation NSMenuDevices

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        // We add all devices paired
        for(IOBluetoothDevice *device in [IOBluetoothDevice pairedDevices]){
            NSMenuItem *item = [[NSMenuItem alloc] init];
            [item setTitle:device.name];
            [self addItem:item];
        }
    }
    return self;
}

@end

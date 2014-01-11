//
//  NSMenuDevices.h
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>
#import "Device.h"

@interface NSMenuDevices : NSMenu{
    NSMutableArray *devices;
    int tagItemSelected;
    Device *device;
}

-(void)checkExisting;

@end

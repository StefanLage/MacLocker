//
//  NSMenuDevices.h
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@protocol NSMenuDevicesDelegate <NSObject>
-(void)deviceSelected:(BOOL)value;
@end

@interface NSMenuDevices : NSMenu{
    NSMutableArray *devices;
    int tagItemSelected;
}

// Delegate
@property (retain, nonatomic) id<NSMenuDevicesDelegate> delegate;

@end

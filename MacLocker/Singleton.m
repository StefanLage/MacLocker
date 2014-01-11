//
//  Singleton.m
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "Singleton.h"

static Singleton * unique = nil;

@implementation Singleton

#pragma mark Singleton
+ (Singleton *) manager
{
    @synchronized(self){
        if(unique == nil){
            unique = [[Singleton alloc] init];
        }
    }
    return unique;
}

+(AppDelegate *) app{
    return  [[NSApplication sharedApplication] delegate];
}

#pragma Device Selected
-(void)setDeviceSelected:(IOBluetoothDevice*)device{
    deviceSelected = device;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        [[Singleton app] checkReachability];
    });
}

-(IOBluetoothDevice*)getDeviceSelected{
    return deviceSelected;
}

@end

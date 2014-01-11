//
//  Singleton.h
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "AppDelegate.h"

@interface Singleton : NSObject{
    IOBluetoothDevice *deviceSelected;
}

+(Singleton *) manager;
+(AppDelegate *) app;
-(void)setDeviceSelected:(IOBluetoothDevice*)device;
-(IOBluetoothDevice*)getDeviceSelected;
-(NSManagedObjectContext *) managedObjectContext;

@end

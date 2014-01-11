//
//  Singleton.h
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>

@interface Singleton : NSObject

+(Singleton *) manager;
@property (strong, nonatomic) IOBluetoothDevice *deviceSelected;

@end

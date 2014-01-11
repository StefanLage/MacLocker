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

@end

//
//  NSMenuDevices.m
//  MacLocker
//
//  Created by Stefan Lage on 11/01/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "NSMenuDevices.h"

#define ClassMajor [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]
#define ITEM_ON     1
#define ITEM_OFF    0

@implementation NSMenuDevices

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        devices = [[NSMutableArray alloc] init];
        tagItemSelected = 0;
        int i = 0;
        // We add all devices paired
        for(IOBluetoothDevice *devicePaired in [IOBluetoothDevice pairedDevices]){
            if([ClassMajor containsObject:[NSNumber numberWithInt:devicePaired.deviceClassMajor]]){
                // Check if we got a right type of device
                NSMenuItem *item = [[NSMenuItem alloc] init];
                [item setTitle:devicePaired.name];
                [item setTarget:self];
                [item setAction:@selector(selectDevice:)];
                [item setTag:i];
                [self addItem:item];
                [devices addObject:devicePaired];
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
    [item setState:ITEM_ON];
    [item setOnStateImage:[NSImage imageNamed:@"check"]];
    tagItemSelected = (int)item.tag;
    [[Singleton manager] setDeviceSelected:[devices objectAtIndex:item.tag]];
    // save index in CD
    [self setDevice:item.tag];
}

-(void)deselectDevice{
    NSMenuItem *item = [self itemWithTag:tagItemSelected];
    if([item state] == ITEM_ON){
        // Is it On ?
        [item setState:ITEM_OFF];
    }
}

-(void)getDeviceExisting{
    if(device){
        int index = [device.index intValue];
        [[Singleton manager] setDeviceSelected:[devices objectAtIndex:index]];
        NSMenuItem *item = [self itemAtIndex:index];
        // Set it on
        [item setState:ITEM_ON];
        [item setOnStateImage:[NSImage imageNamed:@"check"]];
        tagItemSelected = index;
    }
}

-(BOOL)isExisting{
    // Initializing a NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device"
                                              inManagedObjectContext:[Singleton manager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedDevice = [[Singleton manager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Something wrong happened ?
    if(error){
        NSLog(@"error loading device entity: %@", error.description);
        return NO;
    }
    if([fetchedDevice count] > 0){
        // save it
        device = [fetchedDevice firstObject];
        return YES;
    }
    else
        return NO;
}

-(void)setDevice:(NSInteger)index{
    if(!device)
        device = [NSEntityDescription insertNewObjectForEntityForName:@"Device"
                                                       inManagedObjectContext:[Singleton manager].managedObjectContext];
    // Device default name = device name like 'My iPhone'
    device.index = [NSNumber numberWithInteger:index];
    // Save it
    NSError *error;
    if (![[Singleton manager].managedObjectContext save:&error])
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
}

-(void)checkExisting{
    // Check that user has already selected a device
    if([self isExisting])
        [self getDeviceExisting];
}

@end

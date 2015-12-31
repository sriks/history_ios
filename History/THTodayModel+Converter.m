//
//  THTodayModel+Converter.m
//  History
//
//  Created by totaramudu on 17/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

@import CoreData;
#import "THCoreConstants.h"
#import "THTodayModel+Converter.h"

@implementation THTodayModel (Converter)

- (NSManagedObject*)convertToNSManagedObjectInEntityDescription:(NSEntityDescription*)entityDescription withManagedObjectContext:(NSManagedObjectContext*)moc {
 
    NSManagedObject* managedObj = [[NSManagedObject alloc]
                                   initWithEntity:entityDescription
                   insertIntoManagedObjectContext:moc];

    [managedObj setValue:[NSNumber numberWithInt:kTypeToday] forKey:kKeyType];
    [managedObj setValue:self.title forKey:kKeyTitle];
    // The exact event date
    [managedObj setValue:self.date forKey:kKeyDate];
    [managedObj setValue:self.data forKey:kKeyData];
    [managedObj setValue:self.objId forKey:kObjId];
    // Timestamp when this entry was added. For future purpose. 
    [managedObj setValue:[NSDate date] forKey:kKeyCreatedAt];
    return managedObj;
}

@end

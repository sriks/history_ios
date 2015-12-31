//
//  THTodayModel+Converter.h
//  History
//
//  Created by totaramudu on 17/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import "THTodayModel.h"

@class NSManagedObject;
@class NSEntityDescription;
@class NSManagedObjectContext;
@interface THTodayModel (Converter)

- (NSManagedObject*)convertToNSManagedObjectInEntityDescription:(NSEntityDescription*)entityDescription withManagedObjectContext:(NSManagedObjectContext*)moc;

@end

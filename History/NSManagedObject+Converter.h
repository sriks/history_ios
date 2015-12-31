//
//  NSManagedObject+Helper.h
//  History
//
//  Created by totaramudu on 15/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import <CoreData/CoreData.h>

@class THTodayModel;
@interface NSManagedObject (Converter)

- (THTodayModel*)convertToTodayModel;

@end

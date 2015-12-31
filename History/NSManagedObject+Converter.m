//
//  NSManagedObject+Helper.m
//  History
//
//  Created by totaramudu on 15/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import "NSManagedObject+Converter.h"
#import "THTodayModel.h"
#import "THCoreConstants.h"

@implementation NSManagedObject (Converter)

- (THTodayModel*)convertToTodayModel {
    NSDictionary* dict = [self valueForKey:kKeyData];
    return [[THTodayModel alloc] initWithDictionary:dict];
}
@end

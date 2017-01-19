//
//  THPushManager.m
//  History
//
//  Created by Srikanth Sombhatla on 18/01/17.
//  Copyright © 2017 Srikanth Sombhatla. All rights reserved.
//

#import "THPushManager.h"
#import "THUrbanAirship.h"

@implementation THPushManager

+ (id<THPushProtocol>)sharedInstance {
    static id<THPushProtocol> inst = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        inst = [THUrbanAirship new];
    });
    return inst;
}

@end

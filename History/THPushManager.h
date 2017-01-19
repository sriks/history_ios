//
//  THPushManager.h
//  History
//
//  Created by Srikanth Sombhatla on 18/01/17.
//  Copyright © 2017 Srikanth Sombhatla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPushProtocol.h"

/**
 The push manager responsible for registering push notifications. 
 This should be invoked from app lifecycle methods. 
 **/
@interface THPushManager : NSObject

+ (id<THPushProtocol>)sharedInstance;

@end

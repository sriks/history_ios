//
//  THDataManager.h
//  History
//
//  Created by totaramudu on 15/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THDataManagerProtocol.h"

@interface THDataManager : NSObject <THDataManagerProtocol>

+(THDataManager*) sharedInstance;

@end

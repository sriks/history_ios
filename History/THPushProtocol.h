//
//  THPushProtocol.h
//  History
//
//  Created by Srikanth Sombhatla on 18/01/17.
//  Copyright © 2017 Srikanth Sombhatla. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Push protocol. These methods are mapped to the relevant app life cycle methods.
 **/
@protocol THPushProtocol <NSObject>
@required
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end

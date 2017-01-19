//
//  THUrbanAirship.m
//  History
//
//  Created by Srikanth Sombhatla on 18/01/17.
//  Copyright © 2017 Srikanth Sombhatla. All rights reserved.
//

#import "THUrbanAirship.h"
#import <AirshipKit/AirshipKit.h>

@implementation THUrbanAirship

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UAirship takeOff];
    [UAirship push].userPushNotificationsEnabled = YES;
    [[UAirship push] addTag:@"all_development"];
    [[UAirship push] updateRegistration];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

@end

//
//  THCoreLogic.h
//  History
//
//  Created by totaramudu on 28/12/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

/*!
 Core logic engine. 
 **/
#import <Foundation/Foundation.h>
#import "THTodayModel.h"
#import "THDataSourceProtocol.h"
#import "THCoreConstants.h"

typedef void(^THFetchTodayContentBlock)(THTodayModel* todayModel, NSError* error);
@interface THCoreLogic : NSObject

+ (THCoreLogic*)sharedInstance;
- (THTodayModel*)cachedTodayModel;

#pragma mark - Today content
- (void)invalidateCachedTodayModel;
- (void)fetchTodayContentWithCompletionBlock:(THFetchTodayContentBlock)completionBlock;
- (BOOL)addToFavorites:(THTodayModel*)model error:(NSError**)err;
- (BOOL)removeFromFavorites:(THTodayModel*)model error:(NSError**)err;
- (BOOL)isTodayModelFavorited:(THTodayModel*)model;
- (id<THDataSourceProtocol>) dataSourceForFavorites;

#pragma mark - UIApplication lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application;

#pragma mark - Push Notifications
- (BOOL)shouldShowPushNotificationBuildup;
- (void)showPushNotificationRequest;
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
@end

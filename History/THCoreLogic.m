//
//  THCoreLogic.m
//  History
//
//  Created by totaramudu on 28/12/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import "THCoreLogic.h"
#import "THDataManager.h"
#import "THServerManager.h"
#import "THServerProtocol.h"

#import <Foundation/NSKeyedArchiver.h>

// NSUserDefaults keys
static NSString* const kUserDefaultsKeySuiteName = @"group.com.deviceworks.History.Extensions";
static NSString* const kUserDefaultsKeyPushNotificationAcceptanceStatus	=	@"com.deviceworks.pnacceptancestatus";

// Push notification acceptance type
typedef enum : NSUInteger {
	// Not yet requested
	PushNotificationAcceptanceNone = 0,
	// User denied request
	PushNotificationAcceptanceDenied,
	// User accepted request
	PushNotificationAcceptanceAccepted
} PushNotificationAcceptanceStatus;


@interface THCoreLogic ()
@property (strong, readwrite, nonatomic) THTodayModel* todayModel;
@property (weak, readwrite, nonatomic) id<THDataManagerProtocol> dataManager;
@property (weak, readwrite, nonatomic) id<THServerProtocol> serverManager;
@end

@implementation THCoreLogic

+ (THCoreLogic*) sharedInstance {
    static dispatch_once_t token;
    static THCoreLogic* inst = nil;
    dispatch_once(&token, ^{
        inst = [[THCoreLogic alloc] init];
    });
    return inst;
}

- (id)init {
    self = [super init];
    [self setServerManager:[THServerManager sharedInstance]];
    [self setDataManager:[THDataManager sharedInstance]];
    return self;
}

#pragma mark - Today content

- (THTodayModel*)cachedTodayModel {
    return self.todayModel;
}

- (void)invalidateCachedTodayModel {
    self.todayModel = nil;
}

- (void)fetchTodayContentWithCompletionBlock:(THFetchTodayContentBlock)completionBlock {
    if(self.todayModel) {
        completionBlock(self.todayModel, nil);
    } else {
        __weak THCoreLogic* welf = self;
        [self.serverManager fetchTodayWithCompletionBlock:^(THTodayModel *model, NSError *error) {
            if (error) {
                NSLog(@"fetchTodayContentWithCompletionBlock error: %@", error);
            }
                
            if(model) {
                [welf updateInSharedDefaults:model];
                self.todayModel = model;
            }
            completionBlock(model, error);
        }];
    }
}

- (BOOL)addToFavorites:(THTodayModel*)model error:(NSError**)err {
    return [self.dataManager favoriteTodayModel:model error:err];
}

- (BOOL)removeFromFavorites:(THTodayModel*)model error:(NSError**)err {
    return [self.dataManager unFavoriteTodayModel:model error:err];
}

- (BOOL)isTodayModelFavorited:(THTodayModel*)model {
    return [self.dataManager isTodayModelFavorited:model];
}

- (id<THDataSourceProtocol>) dataSourceForFavorites {
    return [self.dataManager dataSourceForFavorites];
}

#pragma mark - UIApplication lifecycle

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// User can provide/revoke PN from settings. So check when app gains focus.
	if ([self pushNotificationAcceptanceStatus] != PushNotificationAcceptanceNone) {
		PushNotificationAcceptanceStatus status = [application isRegisteredForRemoteNotifications]?(PushNotificationAcceptanceAccepted):(PushNotificationAcceptanceDenied);
		[self setPushNotificationAcceptanceStatus:status];
	}
}

#pragma mark - Push Notifications

- (BOOL)shouldShowPushNotificationBuildup {
	return ([self pushNotificationAcceptanceStatus] != PushNotificationAcceptanceAccepted);
}

- (void)showPushNotificationRequest {
	PushNotificationAcceptanceStatus status = [self pushNotificationAcceptanceStatus];
	if (PushNotificationAcceptanceNone == status) {
		// New request
		UIApplication* application = [UIApplication sharedApplication];
		UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
														UIUserNotificationTypeBadge |
														UIUserNotificationTypeSound);
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
																				 categories:nil];
		[application registerUserNotificationSettings:settings];
		[application registerForRemoteNotifications];
	} else if (PushNotificationAcceptanceDenied == status) {
		// Present app settings
		NSURL* appSettingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		[[UIApplication sharedApplication] openURL:appSettingsUrl];
	}
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[self.serverManager handlePushNotificationDeviceToken:deviceToken];
	[self setPushNotificationAcceptanceStatus:PushNotificationAcceptanceAccepted];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	[self setPushNotificationAcceptanceStatus:PushNotificationAcceptanceDenied];
}

#pragma mark Private

- (void)setPushNotificationAcceptanceStatus:(PushNotificationAcceptanceStatus)status {
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:status] forKey:kUserDefaultsKeyPushNotificationAcceptanceStatus];
}

- (PushNotificationAcceptanceStatus)pushNotificationAcceptanceStatus {
	NSNumber* value = [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsKeyPushNotificationAcceptanceStatus];
	return [value integerValue];
}

- (BOOL)updateInSharedDefaults:(THTodayModel*)model {
    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultsKeySuiteName];
    NSDictionary* dict = @{@"formatted_date": [model formattedDate],
                           @"title": model.title};
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [defaults setObject:data forKey:@"today"];
    BOOL status = [defaults synchronize];
    return status;
}

- (void)fetchTodayModelWithCompletionBlock:(THFetchTodayContentBlock)completionBlock {
    // TODO: Check content age and read from local store.
    if(self.todayModel) {
        completionBlock(self.todayModel, nil);
    } else {
    }
}

//- (void)fetchPosterImageForTodayModel:(THTodayModel*)todayModel
//                  withCompletionBlock:(void(^)(UIImage* image, NSError* error))completionBlock {
//    NSURL* imgURL = [self posterImageURLFromModel:todayModel];
//    if(imgURL) {
//        [self loadPosterImage:imgURL withCompletionBlock:completionBlock];
//    } else {
//        completionBlock(nil, [[NSError alloc]
//                              initWithDomain:@"Not found"
//                              code:NSNotFound
//                              userInfo:nil]);
//    }
//}
//
///*!
// Returns poster image url from model.
// **/
//- (NSURL*)posterImageURLFromModel:(THTodayModel*)model {
//    int count = model.linkedItemsCount;
//    for(int i=0;i<count;++i) {
//        THLinkedItemModel* linkedModel = [model linkedItemModelAtIndex:i];
//        if(linkedModel.thumbnailURL) {
//            return linkedModel.thumbnailURL;
//        }
//    }
//    return nil;
//}
//
///*/
// Loads poster image and invokes the completion block.
// **/
//- (void)loadPosterImage:(NSURL*)imageURL withCompletionBlock:(void(^)(UIImage* image, NSError* error)) completionBlock {
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadWithURL:imageURL
//                     options:0
//                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                       completionBlock(image, error);
//                   }];
//}

@end

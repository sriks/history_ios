#import "THParseServer.h"
#import "THTodayModel.h"
#import "THCoreConstants.h"
#import "PFObject+Additions.h"

#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>

// Parse DB Constants
NSString* const kClassNameToday         =       @"today";

@implementation THParseServer

- (id)init {
    self = [super init];
    [Parse setApplicationId:@"TGlDuEnH9uCRTirxJxzqWSjEth7sBfrY9wxpfw5f"
                  clientKey:@"3SBtlKniguv766oEcx07lBLjgCtmYu2f0sbaZyML"];
    return self;
}

#pragma mark THServerProtocol
- (void)fetchTodayWithCompletionBlock:(void (^)(THTodayModel *, NSError *))completionBlock {
    PFQuery* query = [PFQuery queryWithClassName:kClassNameToday];
    [query setLimit:1];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects && objects.count) {
            THTodayModel* todayModel = [objects.firstObject todayModel];
            completionBlock(todayModel, nil);
        } else {
            completionBlock(nil, error);
        }
    }];
}

- (void)handlePushNotificationDeviceToken:(NSData*)deviceToken {
	PFInstallation* installation = [PFInstallation currentInstallation];
	[installation setDeviceTokenFromData:deviceToken];
	[installation saveEventually];
}

@end

#import "THServerManager.h"
#import "THAWSServer.h"

@implementation THServerManager

/*!
 Provides appropriate server implementation.
 **/
+ (id<THServerProtocol>)sharedInstance {
    static id<THServerProtocol> inst = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        inst = [THAWSServer new];
    });
    return inst;
}

@end

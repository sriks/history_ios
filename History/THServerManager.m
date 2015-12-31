#import "THServerManager.h"
#import "THParseServer.h"

@implementation THServerManager

/*!
 Provides appropriate server implementation.
 **/
+ (id<THServerProtocol>)sharedInstance {
    static id<THServerProtocol> inst = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        inst = [[THParseServer alloc] init];
    });
    return inst;
}

@end

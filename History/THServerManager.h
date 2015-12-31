/*!
 Factory class providing the implementation of Server manager
 **/
#import <Foundation/Foundation.h>
#import "THServerProtocol.h"

@interface THServerManager : NSObject

+ (id<THServerProtocol>)sharedInstance;

@end

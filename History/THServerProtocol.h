/*!
A protocol defining server access.
**/

#import <Foundation/Foundation.h>

@class THTodayModel;
@class NSError;
@protocol THServerProtocol <NSObject>
@required
- (void)fetchTodayWithCompletionBlock:(void(^)(THTodayModel* model, NSError* error))completionBlock;
@end

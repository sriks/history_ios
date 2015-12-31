/*!
A model representing
**/

#import <Foundation/Foundation.h>

@class THLinkedItemModel;
@interface THTodayModel : NSObject

- (id)initWithDictionary:(NSDictionary*)dict;
- (int)linkedItemsCount;
- (THLinkedItemModel*)linkedItemModelAtIndex:(NSInteger)index;

@property (strong, readonly, nonatomic) NSDictionary* data;
@property (copy, readonly, nonatomic) NSDate* date;
@property (copy, readonly, nonatomic) NSString* title;
@property (copy, readonly, nonatomic) NSAttributedString* content;
@property (copy, readonly, nonatomic) NSString* unformattedContent;
@property (copy, readonly, nonatomic) NSString* objId;
@property (readonly, nonatomic) NSString* formattedDate;
@property (readonly, nonatomic) NSURL* pictureURL;

@end

#import <Foundation/Foundation.h>

/*!
 Represents a linked item model.
 **/
@interface THLinkedItemModel : NSObject

@property (copy, readonly, nonatomic) NSString* title;
@property (copy, readonly, nonatomic) NSString* content;
@property (copy, readonly, nonatomic) NSString* geo;
@property (strong, readonly, nonatomic) NSURL* wikiURL;
@property (strong, readonly, nonatomic) NSURL* thumbnailURL;

- (id)initWithDictionary:(NSDictionary*)data;
@end

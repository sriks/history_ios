#import "THLinkedItemModel.h"
#import "THCoreConstants.h"

@interface THLinkedItemModel ()

@property (strong, readwrite, nonatomic) NSDictionary* data; // the complete data
@property (copy, readwrite, nonatomic) NSString* title;
@property (copy, readwrite, nonatomic) NSString* content;
@property (copy, readwrite, nonatomic) NSString* geo;
@property (strong, readwrite, nonatomic) NSURL* wikiURL;
@property (strong, readwrite, nonatomic) NSURL* thumbnailURL;
@end

@implementation THLinkedItemModel

- (id)initWithDictionary:(NSDictionary*)data {
    self = [super init];
    if(self) {
        [self setData:data];
        [self setGeo: data[kGeo]];
        [self setTitle:data[kText]];
        [self setContent:data[kAbstract]];
        [self setWikiURL: [NSURL URLWithString:data[kWiki]]];
        [self setThumbnailURL:[NSURL URLWithString:data[kThumbnail]]];
    }
    return self;
}

@end

#import "THTodayModel.h"
#import "THLinkedItemModel.h"
#import "THCoreConstants.h"
#import "DCTheme.h"

@interface THTodayModel ()

@property (copy, readwrite, nonatomic) NSString* objId;
@property (strong, readwrite, nonatomic) NSDictionary* data;
@property (copy, readwrite, nonatomic) NSDate* date;
@property (copy, readwrite, nonatomic) NSString* title;
@property (copy, readwrite, nonatomic) NSAttributedString* content;
@property (copy, readwrite, nonatomic) NSString* unformattedContent;
@property (strong, readwrite, nonatomic) NSMutableArray* linkedItems;
@end

@implementation THTodayModel

// Designated initializer
- (id)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    
    [self setData:dict];
    NSString* tmp = dict[kTitle];
    NSArray* comps = [tmp componentsSeparatedByString:@": "];
    NSString* dateString = [comps firstObject];
    NSString* title = [comps lastObject];
    
    // Facing issue when creating with NSDateFormatterLongStyle
    // http://www.cocoawithlove.com/2009/05/simple-methods-for-date-formatting-and.html
    NSString* dateFormat = @"MMMMM dd, yyyy";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSDate* date = [dateFormatter dateFromString:dateString];
    [self setDate:date];
    [self setTitle:title];
    [self setObjId:dict[kObjId]];
    [self setContent:dict[kContent]];
    [self setUnformattedContent:dict[kContextRawText]];
	
#ifndef TEST_WIHTOUT_LINKEDDATA
	[self setLinkedItems:[[NSMutableArray alloc] init]];
    NSArray* linkedItemsData = dict[kLinkedData];
    for (NSDictionary* linkedDataDict in linkedItemsData) {
        THLinkedItemModel* model = [[THLinkedItemModel alloc] initWithDictionary:linkedDataDict];
        if(model.content)
            [[self linkedItems] addObject: model];
    }
#endif
	
    return self;
}

- (int)linkedItemsCount {
    return (int)self.linkedItems.count;
}

- (THLinkedItemModel*)linkedItemModelAtIndex:(NSInteger)index {
    return [self.linkedItems objectAtIndex:index];
}

- (NSString*) formattedDate {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self.date];
}

- (NSURL*)pictureURL {
    THLinkedItemModel* linkedItemModel = (THLinkedItemModel*)self.linkedItems.firstObject;
    return linkedItemModel.thumbnailURL;
}

@end

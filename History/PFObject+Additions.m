//
//  PFObject+Additions.m
//  History
//
//  Created by totaramudu on 15/01/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import "PFObject+Additions.h"
#import "NSString+Additions.h"
#import "THCoreConstants.h"
#import "THTodayModel.h"
#import "DCTheme.h"

@implementation PFObject (Additions)

- (THTodayModel*)todayModel {
    PFObject* obj = self;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSArray* intrestedKeys = @[kTitle, kLinkedData];
    for (NSString* key in intrestedKeys)
        dict[key] = [obj valueForKey:key];
    dict[kObjId] = [obj objectId];
    NSString* content = [obj valueForKey:kContent];
    dict[kContextRawText] = content;
    // This is an expensive op since it requires spinning a webview. So doing it once before preparing the model.
    // TODO: See if model preparation can be done in Logic ?
    dict[kContent] = [content attributedStringWithFont:[DCTheme fontForBody]];
    return [[THTodayModel alloc] initWithDictionary:dict];
}

@end

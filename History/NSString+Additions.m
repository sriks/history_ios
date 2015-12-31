//
//  NSString+Additions.m
//  History
//
//  Created by totaramudu on 14/01/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSAttributedString*)attributedStringWithFont:(UIFont*)font {
    __block NSMutableAttributedString* attrString = nil;
    
    // Should always run on main thread because this involves spinning a webview.
    [self runOnMainThreadWithoutDeadlock: ^{
        attrString =
        [[NSMutableAttributedString alloc]
         initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
              options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
         documentAttributes:nil
         error:nil];
        
        NSRange range = NSMakeRange(0, attrString.length);
        [attrString addAttribute:NSFontAttributeName
                           value:font
                           range:range];
        
//        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 1.75;
//        [attrString addAttribute:NSParagraphStyleAttributeName
//                           value:paragraphStyle
//                           range:range];
    }];
    
    return attrString;
}

// Just not to cause deadlock.
// See http://stackoverflow.com/questions/5662360/gcd-to-perform-task-in-main-thread
- (void)runOnMainThreadWithoutDeadlock:(void(^)(void))block {
    if([NSThread mainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end

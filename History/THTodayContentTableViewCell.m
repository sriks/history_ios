//
//  THTodayContentTableViewCell.m
//  History
//
//  Created by totaramudu on 04/01/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import "THTodayContentTableViewCell.h"
#import "THTodayModel.h"
#import "THTheme.h"
#import "NSString+Additions.h"

@implementation THTodayContentTableViewCell

- (void)configure:(THTodayModel*)model {
    [self.title setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.date.text = [model.formattedDate uppercaseString];
  
#ifdef TEST_SHOW_LARGE_TITLE
    self.title.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", model.title, model.title, model.title, model.title, model.title];
#else
    self.title.text = model.title;
#endif
    self.content.attributedText = model.content;
    self.content.textColor = [THTheme primaryTextColor];
    self.content.font = [UIFont systemFontOfSize:18];
}

@end

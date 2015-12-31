//
//  THSavedItemCell.m
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import "THSavedItemCell.h"
#import "THTodayModel.h"
#import "THTheme.h"

@interface THSavedItemCell ()
@property (weak, nonatomic) IBOutlet UIView *yearDecorationView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@end

@implementation THSavedItemCell

- (void)configure:(THTodayModel*)model {
#ifdef TEST_SHOW_LARGE_TITLE
    NSString* longTitle = [NSString stringWithFormat:@"%@ %@ %@", model.title, model.title, model.title];
    self.titleLabel.text = longTitle;
#else
    self.titleLabel.text = model.title;
#endif
    self.eventDateLabel.text = model.formattedDate;
    NSDateComponents* comps = [[NSCalendar currentCalendar]
                               components:NSCalendarUnitYear
                               fromDate:model.date];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[comps year]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.yearDecorationView.layer.cornerRadius = self.yearDecorationView.frame.size.width/2;
    self.yearDecorationView.clipsToBounds = YES;
    self.yearDecorationView.layer.borderWidth = 1;
    self.yearDecorationView.layer.borderColor = [[THTheme primaryTextColor] CGColor];
    self.yearDecorationView.backgroundColor = [UIColor clearColor];
}

@end

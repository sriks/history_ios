//
//  THTodayContentTableViewCell.h
//  History
//
//  Created by totaramudu on 04/01/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THTodayModel;
@interface THTodayContentTableViewCell : UITableViewCell

@property (weak, readwrite, nonatomic) IBOutlet UILabel* date;
@property (weak, readwrite, nonatomic) IBOutlet UILabel* title;
@property (weak, readwrite, nonatomic) IBOutlet UILabel* content;

- (void)configure:(THTodayModel*)model;

@end

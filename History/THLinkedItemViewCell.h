//
//  THLinkedItemViewCell.h
//  History
//
//  Created by totaramudu on 03/08/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLinkedItemModel;
@interface THLinkedItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *wikiButton;

- (void)configure:(THLinkedItemModel*)model;

@end

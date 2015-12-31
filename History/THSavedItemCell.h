//
//  THSavedItemCell.h
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THTodayModel;
@interface THSavedItemCell : UITableViewCell

- (void)configure:(THTodayModel*)model;

@end

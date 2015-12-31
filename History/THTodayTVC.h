//
//  THTodayTVC.h
//  History
//
//  Created by Srikanth Sombhatla on 7/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THTodayModel;
@interface THTodayTVC : UITableViewController
@property (nonatomic) THTodayModel* model;
@property (nonatomic, assign) BOOL presentAsSavedItem;
@end

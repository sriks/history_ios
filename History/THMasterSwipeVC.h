//
//  THMasterSwipeVCViewController.h
//  History
//
//  Created by Srikanth Sombhatla on 5/1/16.
//  Copyright © 2016 Srikanth Sombhatla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THMasterSwipeInteractionDelegate.h"

@class THTodayModel;
@interface THMasterSwipeVC : UIViewController <THMasterSwipeInteractionDelegate>

@property (nonatomic) THTodayModel* model;

@end

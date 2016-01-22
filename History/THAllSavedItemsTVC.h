//
//  THAllSavedItemsTVC.h
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THMasterSwipeInteractionDelegate.h"

@interface THAllSavedItemsTVC : UITableViewController
@property (nonatomic, weak) id<THMasterSwipeInteractionDelegate> interactionDelegate;
@end

//
//  THMasterSwipeInteractionDelegate.h
//  History
//
//  Created by Srikanth Sombhatla on 6/1/16.
//  Copyright © 2016 Srikanth Sombhatla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THTodayModel;
@protocol THMasterSwipeInteractionDelegate <NSObject>

@required
- (void)showFavoritesHint;
- (void)didSaveItem:(THTodayModel*)model;
- (void)didSelectSavedItem:(THTodayModel*)model;
- (void)returnFromSavedItemViewController:(UIViewController*)vc;
@end

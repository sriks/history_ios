//
//  THViewControllerCreator.h
//  History
//
//  Created by Srikanth Sombhatla on 5/1/16.
//  Copyright © 2016 Srikanth Sombhatla. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THTodayTVC;
@interface THViewControllerCreator : NSObject

+ (instancetype)sharedInstance;

- (THTodayTVC*)todayViewController;

@end

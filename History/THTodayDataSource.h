//
//  THTodayDataSource.h
//  History
//
//  Created by totaramudu on 22/09/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THTodayModel;
@protocol THTodayDataSource <NSObject>
@required
- (THTodayModel*)todayModel;
@end

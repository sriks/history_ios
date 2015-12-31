//
//  THDataManagerProtocol.h
//  History
//
//  Created by totaramudu on 15/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

/*!
 The protocol for data manager
 **/

#import <Foundation/Foundation.h>
#import "THDataSourceProtocol.h"

@class THTodayModel;
@class NSFetchedResultsController;

@protocol THDataManagerProtocol <NSObject>

@required
- (BOOL)isTodayModelFavorited:(THTodayModel*)todayModel;
- (int)countOfFavorites;
- (BOOL)favoriteTodayModel:(THTodayModel*)todayModel error:(NSError**)error;
- (BOOL)unFavoriteTodayModel:(THTodayModel*)todayModel error:(NSError**)error;
- (id<THDataSourceProtocol>)dataSourceForFavorites;

@end

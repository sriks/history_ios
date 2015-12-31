//
//  THDataSourceCD.h
//  History
//
//  Created by totaramudu on 14/02/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "THDataSourceProtocol.h"

@interface THDataSourceCD : NSObject <THDataSourceProtocol, NSFetchedResultsControllerDelegate>

- (instancetype)initWithFetechedResultsController:(NSFetchedResultsController*)frc;
- (void)updateWithFetchedResultsController:(NSFetchedResultsController*)frc;

@property (nonatomic, readonly) NSFetchedResultsController* fetchedResultsController;

@end

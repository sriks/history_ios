//
//  THDataSourceCD.m
//  History
//
//  Created by totaramudu on 14/02/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//


// TODO: Relook and simplify. See if this can be directly attached to tableview.

#import "THDataSourceCD.h"
#import "NSManagedObject+Converter.h"

NSString* const kKeyPathSavedItemsChanged   = @"savedItemsChanged";
NSString* const kKeyPathSavedItemsAdded     = @"savedItemsAdded";
NSString* const kKeyPathSavedItemsRemoved   = @"savedItemsRemoved";

@interface THDataSourceCD ()
@property (nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic) BOOL savedItemsChanged;
@property (nonatomic) BOOL savedItemsAdded;
@property (nonatomic) BOOL savedItemsRemoved;
@end

@implementation THDataSourceCD

- (instancetype)initWithFetechedResultsController:(NSFetchedResultsController*)frc {
    self = [super init];
    [self updateWithFetchedResultsController:frc];
    return self;
}

- (void)updateWithFetchedResultsController:(NSFetchedResultsController*)frc {
    [self setFetchedResultsController:frc];
    [self fetchedResultsController].delegate = self;
    NSError* error;
    if(![frc performFetch:&error]) {
        [NSException raise:@"Perform fetch failed" format:@"%@",error];
    }
}

#pragma mark THDataSourceProtocol

- (int)savedItemsCount {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    NSUInteger count = [sectionInfo numberOfObjects];
    return (int)count;
}

- (id)savedItemModelAtIndex:(NSInteger)index {
    id mob = self.fetchedResultsController.fetchedObjects[index];
    return [mob convertToTodayModel];
}

- (void)addContentChangeObserver:(NSObject*)observer
                         context:(void *)context {
    // Add all content change observers.
    [self addContentChangeObserver:observer forKeyPath:kKeyPathSavedItemsChanged context:context];
}

- (void)addContentChangeObserver:(NSObject*)observer
                      forKeyPath:(NSString*)keyPath
                         context:(void *)context {
    [self addObserver:observer forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:context];
}

- (void)removeContentChangeObserver:(NSObject*)observer
                         forKeyPath:(NSString*)keyPath
                            context:(void *)context {
    [self removeObserver:observer forKeyPath:keyPath context:context];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return false;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self willChangeValueForKey:kKeyPathSavedItemsAdded];
            [self didChangeValueForKey:kKeyPathSavedItemsAdded];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self willChangeValueForKey:kKeyPathSavedItemsRemoved];
            [self didChangeValueForKey:kKeyPathSavedItemsRemoved];
            break;
        }
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self willChangeValueForKey:kKeyPathSavedItemsChanged];
    [self didChangeValueForKey:kKeyPathSavedItemsChanged];
}

@end

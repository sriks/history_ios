//
//  THDataManager.m
//  History
//
//  Created by totaramudu on 15/10/14.
//  Copyright (c) 2014 Deviceworks. All rights reserved.
//

/*!
 Central datamanager backed by CoreData.
 References
 http://www.cimgf.com/2011/01/07/passing-around-a-nsmanagedobjectcontext-on-the-iphone/ 
 */

@import CoreData;
#import "THDataManager.h"
#import "THDataManagerProtocol.h"
#import "THTodayModel.h"
#import "THTodayModel+Converter.m"
#import "NSManagedObject+Converter.h"
#import "THDataSourceCD.h"

NSString* const kDataSourceFavorites    =   @"favorites";

@interface THDataManager ()

@property (strong, readwrite, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic) NSMutableDictionary* dataSources;
@end

@implementation THDataManager

+ (THDataManager*)sharedInstance {
    static THDataManager* inst = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        inst = [[THDataManager alloc] init];
    });
    
    return inst;
}

- (id)init {
    self = [super init];
    [self setUpCoreDataStack];
    [self setDataSources:[NSMutableDictionary dictionary]];
    return self;
}

/*!
 Prepares CoreData Stack
 **/
- (void)setUpCoreDataStack {
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSURL *url = [self documentURL];
    NSDictionary *options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:url
                                                       options:options
                                                         error:&error];
    if (!store) {
        NSLog(@"Error adding persistent store. Error %@",error);
        NSError *deleteError = nil;
        if ([[NSFileManager defaultManager] removeItemAtURL:url error:&deleteError]) {
            error = nil;
            store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                      configuration:nil
                                                URL:url
                                            options:options
                                              error:&error];
        }
        
        if (!store) {
            // Also inform the user...
            NSLog(@"Failed to create persistent store. Error %@. Delete error %@",error,deleteError);
            abort();
        }
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = psc;
}

#pragma mark Internal Helpers

- (NSURL*)documentURL {
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"History.sqlite"];
    return url;
}

/*!
 Provides entity description for today favorites.
 **/
- (NSEntityDescription*)entityDescriptionForTodayFavorites {
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:kTableNameFavorites
                                                  inManagedObjectContext:self.managedObjectContext];
    return entityDesc;
}


#pragma mark THDataManagerProtocol

- (BOOL)favoriteTodayModel:(THTodayModel*)todayModel error:(NSError**)error {
    if([self isTodayModelFavorited:todayModel])
        return true;
    NSManagedObject* newFav = [todayModel convertToNSManagedObjectInEntityDescription:[self entityDescriptionForTodayFavorites]
                                                             withManagedObjectContext:self.managedObjectContext];
    (void)newFav; // to supress warning
    BOOL saveStaus = [self saveContext:error];
    return saveStaus;
}

- (BOOL)unFavoriteTodayModel:(THTodayModel*)todayModel error:(NSError**)error {
    NSManagedObject* objToDelete = [self managedObjectForTodayModel:todayModel error:error];
    if(!objToDelete)
        return NO;
    [self.managedObjectContext deleteObject:objToDelete];
    return [self saveContext:error];
}

- (BOOL)isTodayModelFavorited:(THTodayModel*)todayModel {
#ifdef TEST_ADD_DUPLICATE_FAVS
    return NO;
#else
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", kObjId, todayModel.objId];
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:kTableNameFavorites];
    fr.predicate = predicate;
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fr error:&error];
    if(error || results.count)
        return YES;
    else
        return NO;
#endif
}

- (int)countOfFavorites {
    return [[self dataSourceForFavorites] savedItemsCount];
}

- (id<THDataSourceProtocol>)dataSourceForFavorites {
    id<THDataSourceProtocol> dataSource = self.dataSources[kDataSourceFavorites];
    if(!dataSource) {
        NSFetchedResultsController* frc = [self fetchedResultsControllerForFavorites];
        dataSource = [[THDataSourceCD alloc] initWithFetechedResultsController:frc];
        self.dataSources[kDataSourceFavorites] = dataSource;
    }
    return dataSource;
}

# pragma mark Helpers

- (NSFetchedResultsController*)fetchedResultsControllerForFavorites {
    NSFetchRequest* fetchReq = [self fetchRequestForAllFavorites];
    NSFetchedResultsController* fetchedController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchReq
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil cacheName:nil];
    return fetchedController;
}

- (NSFetchRequest*)fetchRequestForAllFavorites {
    NSFetchRequest* fetchReq = [[NSFetchRequest alloc]
                                initWithEntityName:kTableNameFavorites];
    [fetchReq setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:kKeyCreatedAt ascending:NO]]];
    return fetchReq;
}

- (NSManagedObject*)managedObjectForTodayModel:(THTodayModel*)todayModel
                                          error:(NSError**)error {
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", kObjId, todayModel.objId];
    NSFetchRequest* fr = [NSFetchRequest fetchRequestWithEntityName:kTableNameFavorites];
    fr.predicate = predicate;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fr error:error];
    return [results firstObject];
}

- (NSArray*)todayModelsFromFetchResult:(NSArray*)fetchResult {
    if(!fetchResult)
        return nil;
    
    NSMutableArray* favs = [NSMutableArray array];
    for (NSManagedObject* managedObj in fetchResult) {
        THTodayModel* model = [managedObj convertToTodayModel];
        if(model)
            [favs addObject:model];
    }
    return favs;
}

- (BOOL)saveContext:(NSError**)error {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved Coredata error %@, %@", *error, [*error userInfo]);
#ifdef DEBUG
            abort();
#else
            return false;
#endif
        } else {
            // All is good.
            return true;
        }

    } else {
#ifdef DEBUG
        abort();
#else
        NSLog(@"Invalid managed object context nil");
        return false;
#endif
    }
}

@end


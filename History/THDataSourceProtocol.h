//
//  THDataSourceProtocol.h
//  History
//
//  Created by totaramudu on 14/02/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

/*!
 Data source protocol for providing models.
 The listener who is interested in data source changes should implement KVO and set itself
 using addContentChangeObserver:context. Should remove itself using removeContentChangeObserver:context.
 Data changes are notified using observeValueForKeyPath:
 */
#import <Foundation/Foundation.h>

/*!
 The property name on which content changed KVO is performed.
 The implementor should define the property and also provide
 declaration for this NSString.
 **/
extern NSString* const kKeyPathSavedItemsChanged;
extern NSString* const kKeyPathSavedItemsAdded;
extern NSString* const kKeyPathSavedItemsRemoved;

@protocol THDataSourceProtocol <NSObject>
@required

/*!
 @return The count of models
 */
- (int)savedItemsCount;

/*!
 @param path The indexpath at which the model is required.
 @return The model at the index path.
 */
- (id)savedItemModelAtIndex:(NSInteger)index;

/*!
 Adds observer for content change. Internally this uses KVO for property change observation.
 When the content changes KVO's observeValueForKeyPath: will be invoked on observer with
 kKeyPathContentChanged as the keypath.
 @param observer The observer object intrested in content change.
 @param context Same as KVO context
 */
- (void)addContentChangeObserver:(NSObject*)observer
                         context:(void *)context;

/*!
 Adds observer for content change for keypath. Internally this uses KVO for property change observation.
 When the content changes KVO's observeValueForKeyPath: will be invoked on observer with
 kKeyPathContentChanged as the keypath.
 @param observer The observer object intrested in content change.
 @param context Same as KVO context
 */
- (void)addContentChangeObserver:(NSObject*)observer
                      forKeyPath:(NSString*)keyPath
                         context:(void *)context;

/*!
 Removes the content change observer for keypath. Internally this uses KVO for property change observation.
 @param observer The observer to be removed.
 @param keyPath The keypath to remove.
 @param context Any context specific to this observation. Can be nil. See KVO.
 */
- (void)removeContentChangeObserver:(NSObject*)observer
                         forKeyPath:(NSString*)keyPath
                            context:(void *)context;

@end




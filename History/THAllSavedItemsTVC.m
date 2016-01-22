//
//  THAllSavedItemsTVC.m
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import "THAllSavedItemsTVC.h"
#import "THTodayModel.h"
#import "THCoreLogic.h"
#import "THTodayTVC.h"
#import "THSavedItemCell.h"
#import "THTheme.h"

static const int TAG_ADD_CURRENT_TO_FAVS     =   101;
static NSString* const REUSE_ID_TITLE        =   @"saved_items_page_title";
static NSString* const REUSE_ID_SAVED_ITEM   =   @"saved_item";
static NSString* const REUSE_ID_NO_ITEM      =   @"zero_favorites";
static NSString* const SEGUE_SHOW_SAVED_ITEM =   @"show_saved_item";

typedef enum : NSUInteger {
    SECTION_TITLE = 0,
    SECTION_ADD_CURRENT,
    SECTION_SAVED_ITEMS,
    SECTIONS_COUNT // This should be last item.
} SectionIndexes;

@interface THAllSavedItemsTVC ()
@property (nonatomic) THCoreLogic* core;
@end

@implementation THAllSavedItemsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.core = [THCoreLogic sharedInstance];
    [self.core.dataSourceForFavorites addContentChangeObserver:self
                                                    forKeyPath:kKeyPathSavedItemsAdded
                                                       context:nil];
    [self.core.dataSourceForFavorites addContentChangeObserver:self
                                                    forKeyPath:kKeyPathSavedItemsRemoved
                                                       context:nil];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = YES;
    self.clearsSelectionOnViewWillAppear = YES;
    
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(didSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeGesture];
    self.tableView.backgroundColor = [THTheme primaryBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.core.dataSourceForFavorites removeContentChangeObserver:self forKeyPath:kKeyPathSavedItemsAdded context:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONS_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_TITLE:
            return 1;
        case SECTION_ADD_CURRENT:
            return ([self.core.dataSourceForFavorites savedItemsCount])?(0):(1);
        case SECTION_SAVED_ITEMS:
            return [self.core.dataSourceForFavorites savedItemsCount];
        default:
            NSLog(@"THAllSavedItemsTVC unhandled section index %ld", section);
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_TITLE) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_TITLE  forIndexPath:indexPath];
        cell.tintColor = [UIColor whiteColor];
        return cell;
    }
    
    else if (indexPath.section == SECTION_ADD_CURRENT) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_NO_ITEM];
        UIButton* addToFavsButton = (UIButton*)[cell viewWithTag:TAG_ADD_CURRENT_TO_FAVS];
        [THTheme themeButtonWithDecoration:addToFavsButton];
        [addToFavsButton addTarget:self action:@selector(onAddCurrentEventToFavorites:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    else if (indexPath.section == SECTION_SAVED_ITEMS) {
        THSavedItemCell *cell = (THSavedItemCell*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_SAVED_ITEM
                                                                                  forIndexPath:indexPath];
        THTodayModel* model = [self.core.dataSourceForFavorites savedItemModelAtIndex:(int)indexPath.row];
        [cell configure:model];
        return cell;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_SAVED_ITEMS && self.interactionDelegate) {
		THTodayModel* model = [self.core.dataSourceForFavorites savedItemModelAtIndex:(int)indexPath.row];
		[self.interactionDelegate didSelectSavedItem:model];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_SHOW_SAVED_ITEM]) {
        THTodayTVC* todayTVC = (THTodayTVC*)segue.destinationViewController;
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        todayTVC.model = [self.core.dataSourceForFavorites savedItemModelAtIndex:(int)indexPath.row];
        todayTVC.presentAsSavedItem = YES;
    }
}

#pragma mark - Gestures

- (void)didSwipe:(UIGestureRecognizer*)gesture {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
  [self.tableView reloadData];
}

#pragma mark - Button clicks

- (void)onAddCurrentEventToFavorites:(id)sender {
    THTodayModel* model = [self.core cachedTodayModel];
    if (model) {
        [self.core addToFavorites:model error:nil];
    }
}

@end

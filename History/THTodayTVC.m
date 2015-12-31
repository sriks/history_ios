//
//  THTodayTVC.m
//  History
//
//  Created by Srikanth Sombhatla on 7/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import "THTodayTVC.h"
#import "THTodayModel.h"
#import "THTodayContentTableViewCell.h"
#import "THLinkedItemViewCell.h"
#import "THCoreLogic.h"
#import "THTheme.h"

static const int TAG_TITLE_LEVEL_1          =   65;
static const int TAG_TITLE_LEVEL_2          =   66;
static const int TAG_PUSH_NOTIF_YES         =   121;
static const int TAG_PUSH_NOTIF_NO         =    122;

static NSString* const REUSE_ID_CONTENT             =   @"today";
static NSString* const REUSE_ID_LINKEDITEMS_TITLE   =   @"linkeditems_title";
static NSString* const REUSE_ID_LINKEDITEM          =   @"linkeditem";
static NSString* const REUSE_ID_PUSH_NOTIF          =   @"push_notif";

static NSString* const SEGUE_ID_SHOW_SAVED_ITEMS    =   @"show_saved_items";

typedef NS_ENUM(NSUInteger, THContentSectionIndex) {
    SECTION_CONTENT = 0,
	SECTION_CONTENT_WITHOUT_LINKEDDATA = SECTION_CONTENT,
    SECTION_LINKEDDATA_HEADING,
    SECTION_LINKEDDATA,
	SECTION_PUSH_NOTIF,
    // This should always be last item.
    TOTAL_SECTIONS
};

@interface THTodayTVC () <UIScrollViewDelegate>
@property (nonatomic) THCoreLogic* core;
@property (nonatomic, assign) CGFloat hostViewHeight;
@property (nonatomic, assign) CGFloat lastScrollYPosition;
@property (nonatomic, assign) BOOL showPNBuildup;
@end

@implementation THTodayTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.core = [THCoreLogic sharedInstance];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(didDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(didSwipe:)];
    swipeGesture.direction = ((self.presentAsSavedItem)?(UISwipeGestureRecognizerDirectionRight):(UISwipeGestureRecognizerDirectionLeft));
    [self.tableView addGestureRecognizer:doubleTapGesture];
    [self.tableView addGestureRecognizer:swipeGesture];
    self.tableView.backgroundColor = [THTheme primaryBackgroundColor];
	self.showPNBuildup = [self.core shouldShowPushNotificationBuildup];
}

- (void)viewWillAppear:(BOOL)animated {
    self.hostViewHeight = self.tableView.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model.linkedItemsCount) {
        return TOTAL_SECTIONS;
    } else {
        return SECTION_CONTENT_WITHOUT_LINKEDDATA + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SECTION_LINKEDDATA == section) {
        return self.model.linkedItemsCount;
    } else if (SECTION_PUSH_NOTIF == section) {
		return self.showPNBuildup?1:0;
	} else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SECTION_CONTENT == indexPath.section) {
        THTodayContentTableViewCell *cell = (THTodayContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_CONTENT forIndexPath:indexPath];
        [cell configure:self.model];
        if (self.presentAsSavedItem) {
            UILabel* level1 = (UILabel*)[cell viewWithTag:TAG_TITLE_LEVEL_1];
            level1.text = @"YOUR";
            UILabel* level2 = (UILabel*)[cell viewWithTag:TAG_TITLE_LEVEL_2];
            level2.text = @"FAVORITE";
        }
        return cell;
    } else if (SECTION_LINKEDDATA_HEADING == indexPath.section) {
        return [tableView dequeueReusableCellWithIdentifier:REUSE_ID_LINKEDITEMS_TITLE];
    } else if (SECTION_LINKEDDATA == indexPath.section) {
        THLinkedItemViewCell* cell = (THLinkedItemViewCell*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_LINKEDITEM forIndexPath:indexPath];
        [cell configure:[self.model linkedItemModelAtIndex:indexPath.row]];
        return cell;
    } else if (SECTION_PUSH_NOTIF == indexPath.section) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_PUSH_NOTIF forIndexPath:indexPath];
        UIButton* button = (UIButton*)[cell viewWithTag:TAG_PUSH_NOTIF_YES];
        [THTheme themeButtonWithDecoration:button];
        button = (UIButton*)[cell viewWithTag:TAG_PUSH_NOTIF_NO];
        [THTheme themeButton:button];
        return cell;
    }
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Empty for now.
}

#pragma mark - Gesture handlers

- (void)didDoubleTap:(UIGestureRecognizer*)gesture {
    NSError* err;
    if (self.presentAsSavedItem)
        return;
    
    [self.core addToFavorites:self.model error:&err];
    if (err) {
        NSLog(@"Error adding to favorites: %@",err);
    }
    // TODO: Show feedback animation. 
}

- (void)didSwipe:(UIGestureRecognizer*)gesture {
    UISwipeGestureRecognizer* theGesture = (UISwipeGestureRecognizer*)gesture;
    if (self.presentAsSavedItem && theGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (!self.presentAsSavedItem && theGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self performSegueWithIdentifier:SEGUE_ID_SHOW_SAVED_ITEMS sender:nil];
    }
}

#pragma mark - Push notification request handlers

- (IBAction)didAllowPushNotification:(id)sender {
	[self removePushNotificationRequestSection];
	[self.core showPushNotificationRequest];
}

- (IBAction)didDeclinePushNotification:(id)sender {
	[self removePushNotificationRequestSection];
}

- (void)removePushNotificationRequestSection {
	self.showPNBuildup = NO;
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SECTION_PUSH_NOTIF]
				  withRowAnimation:UITableViewRowAnimationAutomatic];
}

//#pragma mark ScrollViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.lastScrollYPosition = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if(scrollView.contentOffset.y < self.lastScrollYPosition) {
//        CGFloat scrollLengthSoFar = fabsf(scrollView.contentOffset.y);
//        NSLog(@"scrolling dir DOWN %f %f", scrollView.contentOffset.y, self.lastScrollYPosition);
//    } else {
//        NSLog(@"scrolling dir UP %f %f", scrollView.contentOffset.y, self.lastScrollYPosition);
//    }
//}


@end

//
//  THTodayTVC.m
//  History
//
//  Created by Srikanth Sombhatla on 7/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

// TODO: Doing a hell lot of stuff here (read massive MVC). Refactor please.

#import "THTodayTVC.h"
#import "THTodayModel.h"
#import "THTodayContentTableViewCell.h"
#import "THLinkedItemViewCell.h"
#import "THCoreLogic.h"
#import "THTheme.h"
#import <MBProgressHUD/MBProgressHUD.h>

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
    SECTION_DELETE,
    // This should always be last item.
    TOTAL_SECTIONS
};

@interface THTodayTVC () <UIScrollViewDelegate>
@property (nonatomic) THCoreLogic* core;
@property (nonatomic, assign) CGFloat lastScrollYPosition;
@property (nonatomic, assign) BOOL showPNBuildup;
@end

@implementation THTodayTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.core = [THCoreLogic sharedInstance];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(didDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:doubleTapGesture];
    self.tableView.backgroundColor = [THTheme primaryBackgroundColor];
	self.showPNBuildup = [self.core shouldShowPushNotificationBuildup];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.presentAsSavedItem && [self.core favoritesCount]) {
        [self.interactionDelegate showFavoritesHint];
    } else {
        if ([self.core shouldShowNavigationTutorial] && !self.presentAsSavedItem) {
            [self presentNavigationTutorial];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model.linkedItemsCount) {
        return TOTAL_SECTIONS;
    } else {
        // 1: Only push notification
        // 2: Push notification + Delete
        if (self.presentAsSavedItem) {
            return SECTION_CONTENT_WITHOUT_LINKEDDATA + 2;
        } else {
            return SECTION_CONTENT_WITHOUT_LINKEDDATA + 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SECTION_LINKEDDATA == section) {
        return self.model.linkedItemsCount;
    } else if (SECTION_PUSH_NOTIF == section) {
		return self.showPNBuildup?1:0;
    } else if (SECTION_DELETE == section) {
        return self.presentAsSavedItem?1:0;
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
    } else if (SECTION_DELETE == indexPath.section) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Delete this favorite";
        cell.backgroundColor = [THTheme primaryBackgroundColor];
        cell.textLabel.textColor = [THTheme primaryTextColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (SECTION_DELETE == indexPath.section) {
        
        // TODO: Move this to view presenter.
        UIAlertController* confirmDeleteAlert = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:nil
                                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action)
        {
            NSError* error;
            if([self.core removeFromFavorites:self.model error:&error]) {
                [self.interactionDelegate returnFromSavedItemViewController:self];
            } else {
                NSLog(@"error deleting favorite:%@",error);
                UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"History"
                                                                     message:@"Cannot delete"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                [errorAlert show];
            }
        }];
        
        [confirmDeleteAlert addAction:deleteAction];
        [confirmDeleteAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:confirmDeleteAlert animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Empty for now.
}

#pragma mark - Gesture handlers

- (void)didDoubleTap:(UIGestureRecognizer*)gesture {
    // TODO: Move to view presenter
    NSError* err;
    if (self.presentAsSavedItem)
        return;

    NSUInteger hudsFound = [MBProgressHUD allHUDsForView:self.view].count;
    MBProgressHUD* hud = nil;
    if (hudsFound == 0) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    [self.core addToFavorites:self.model error:&err];
    if (err) {
        NSLog(@"Error adding to favorites: %@",err);
        hud.detailsLabelText = @"Sorry, something went wrong!";
    } else {
        hud.labelText = @"Added to favorites!";
        hud.detailsLabelText = @"Swipe to see your favorites.";
    }
    hud.mode = MBProgressHUDModeText;
    hud.dimBackground = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:2.5];
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

#pragma mark - Navigation tutorial

- (void)presentNavigationTutorial {
    NSString* message = @"Double tap on home screen to add to your favorites.\n\nSwipe to left to see your favorites.";
    UIAlertController* tutorial = [UIAlertController alertControllerWithTitle:@"History"
                                                                      message:message
                                                               preferredStyle:UIAlertControllerStyleAlert];
    [tutorial addAction:[UIAlertAction actionWithTitle:@"Got it!" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action)
    {
        [self.core didPresentNavigationTutorial];
    }]];
    [self presentViewController:tutorial animated:YES completion:nil];
}

@end

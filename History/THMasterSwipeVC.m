//
//  THMasterSwipeVCViewController.m
//  History
//
//  Created by Srikanth Sombhatla on 5/1/16.
//  Copyright © 2016 Srikanth Sombhatla. All rights reserved.
//

#import "THMasterSwipeVC.h"
#import "THTodayTVC.h"
#import "THAllSavedItemsTVC.h"
#import "THTheme.h"

static NSString* const kStoryboardNameToday			=		@"Today";
static NSString* const kStoryboardIdToday				=		@"today";
static NSString* const kStoryboardIdSavedItems			=		@"all_saved_items";

@interface THMasterSwipeVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIViewController* visibleSavedItem;
@end

@implementation THMasterSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [THTheme primaryBackgroundColor];
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    // Make sure to remove subviews.
    NSArray* children = self.childViewControllers;
    for (UIViewController* child in children) {
        [self removeChild:child animate:NO];
    }
    [self prepareChildren];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.visibleSavedItem && [[self visibleViewController] isKindOfClass:[THAllSavedItemsTVC class]]) {
        [self popSavedItemWithAnimation:NO];
    }
}

#pragma mark - THMasterSwipeInteractionDelegate

- (void)showFavoritesHint {
    CGFloat width = CGRectGetWidth(self.view.frame);
    width = width/4;
    CGPoint newPoint = CGPointMake(width, 0);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.scrollView.contentOffset = newPoint;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            self.scrollView.contentOffset = CGPointZero;
        }];
    }];
}

- (void)didSaveItem:(THTodayModel*)model {}

- (void)didSelectSavedItem:(THTodayModel*)model {
    [self pushSavedItem:model];
}

- (void)returnFromSavedItemViewController:(UIViewController*)vc {
    [self popSavedItemWithAnimation:YES];
}

#pragma mark - Private

- (void)prepareChildren {
	THTodayTVC* todayTVC = [self todayViewControllerForModel:self.model isSavedItem:NO];
	[self addChild:todayTVC];
	
	THAllSavedItemsTVC* savedItemsVC = [self savedItemsViewController];
	[self addChild:savedItemsVC];
}

- (void)addChild:(UIViewController*)child {
	UIView* childView = child.view;
	CGRect newRect = childView.bounds;
	newRect.size.width = CGRectGetWidth(self.view.bounds);
	newRect.origin.x = newRect.size.width * self.scrollView.subviews.count;
	childView.frame = newRect;
	
	[self addChildViewController:child];
	[child didMoveToParentViewController:self];
	[self.scrollView addSubview:childView];
	[self updateContentSize];
}

- (void)removeChild:(UIViewController*)child animate:(BOOL)animate {
    if ([self.scrollView.subviews containsObject:child.view]) {
        [child willMoveToParentViewController:nil];
        [child.view removeFromSuperview];
        [child removeFromParentViewController];
        [child didMoveToParentViewController:nil];
        [self updateContentSize];
    } else {
        NSLog(@"%s  Cannot find child %p", __func__, child);
    }
}

- (void)makeChildVisible:(UIViewController*)child animate:(BOOL)animate {
    if([self.scrollView.subviews containsObject:child.view]) {
        CGPoint newOffset = child.view.frame.origin;
        [self.scrollView setContentOffset:newOffset animated:animate];
    } else {
        NSLog(@"%s  Cannot find child %p", __func__, child);
    }
}

- (UIViewController*)visibleViewController {
    CGFloat widthOfView = CGRectGetWidth(self.scrollView.bounds);
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    int probableIndex = contentOffsetX/widthOfView;
    if ((probableIndex >= 0) && (probableIndex <= self.childViewControllers.count)) {
        return self.childViewControllers[probableIndex];
    } else {
        return nil;
    }
}

- (void)pushSavedItem:(THTodayModel*)model {
    UIViewController* vc = [self todayViewControllerForModel:model isSavedItem:YES];
    [self addChild:vc];
    [self makeChildVisible:vc animate:YES];
    self.visibleSavedItem = vc;
}

- (void)popSavedItemWithAnimation:(BOOL)animate {
    [self removeChild:self.visibleSavedItem animate:animate];
    self.visibleSavedItem = nil;
}

- (void)updateContentSize {
	CGSize newContentSize = self.scrollView.contentSize;
	newContentSize.width = CGRectGetWidth(self.view.bounds) * self.scrollView.subviews.count;
	self.scrollView.contentSize = newContentSize;
}

- (THTodayTVC*)todayViewControllerForModel:(THTodayModel*)model isSavedItem:(BOOL)isSavedItem {
	THTodayTVC* todayTVC = (THTodayTVC*)[[UIStoryboard storyboardWithName:kStoryboardNameToday bundle:nil]
					 instantiateViewControllerWithIdentifier:kStoryboardIdToday];
	todayTVC.model = self.model;
	todayTVC.interactionDelegate = self;
    todayTVC.presentAsSavedItem = isSavedItem;
	return todayTVC;
}

- (THAllSavedItemsTVC*)savedItemsViewController {
	THAllSavedItemsTVC* vc = (THAllSavedItemsTVC*)
	[[UIStoryboard storyboardWithName:kStoryboardNameToday bundle:nil]
	 instantiateViewControllerWithIdentifier:kStoryboardIdSavedItems];
	vc.interactionDelegate = self;
	return vc;
}

@end

//
//  THLaunchScreenVC.m
//  History
//
//  Created by Srikanth Sombhatla on 7/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import "THLaunchScreenVC.h"
#import "THCoreLogic.h"
#import "THTheme.h"

static NSString* const SEGUE_SHOW_TODAY =   @"show_today";
static NSString* const SEGUE_SHOW_MASTER_SWIPE = @"show_master_swipe";

@interface THLaunchScreenVC ()
@property (nonatomic) THTodayModel* todayModel;
@end

@implementation THLaunchScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [THTheme primaryBackgroundColor];
    
    // Fetch today content.
    __weak THLaunchScreenVC* welf = self;
    [[THCoreLogic sharedInstance] fetchTodayContentWithCompletionBlock:^(THTodayModel *todayModel, NSError *error) {
        if (todayModel) {
            welf.todayModel = todayModel;
            [welf performSegueWithIdentifier:SEGUE_SHOW_MASTER_SWIPE sender:nil];
        } else {
            // TODO: Show error dialog and navigate to saved items.
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_SHOW_MASTER_SWIPE]) {
        // Using performSelector for loose coupling. Ideal is to let destination implement a protocol.
        UIViewController* dest = segue.destinationViewController;
        SEL modelSetter = NSSelectorFromString(@"setModel:");
        [dest performSelector:modelSetter withObject:self.todayModel];
    }
}

@end

//
//  THViewControllerCreator.m
//  History
//
//  Created by Srikanth Sombhatla on 5/1/16.
//  Copyright © 2016 Srikanth Sombhatla. All rights reserved.
//

#import "THViewControllerCreator.h"
#import "THTodayTVC.h"
#import "THCoreLogic.h"

NSString* const kStoryboardNameToday			=		@"Today";

@implementation THViewControllerCreator

+ (instancetype)sharedInstance {
	static id theInstance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^{
		theInstance = [THViewControllerCreator new];
	});
	return theInstance;
}

- (THTodayTVC*)todayViewController {
	THTodayTVC* vc = (THTodayTVC*)[[UIStoryboard storyboardWithName:kStoryboardNameToday bundle:nil] instantiateInitialViewController];
	//vc.model = [THCoreLogic sharedInstance]
	
	return vc;
}

@end

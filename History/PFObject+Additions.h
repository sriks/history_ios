//
//  PFObject+Additions.h
//  History
//
//  Created by totaramudu on 15/01/15.
//  Copyright (c) 2015 Deviceworks. All rights reserved.
//

#import <Parse/Parse.h>

@class THTodayModel;
@interface PFObject (Additions)

/*!
 Creates a today model from PFObject.
 This creates attributes string content as well. 
 Always use this to create today model from PFObject.
 */
- (THTodayModel*)todayModel;

@end

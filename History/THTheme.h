//
//  THTheme.h
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THTheme : NSObject

+ (UIColor*)primaryTextColor;
+ (UIColor*)primaryBackgroundColor;
+ (void)themeButtonWithDecoration:(UIButton*)button;
+ (void)themeButton:(UIButton*)button;
@end

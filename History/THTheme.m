//
//  THTheme.m
//  History
//
//  Created by Srikanth Sombhatla on 9/11/15.
//  Copyright © 2015 Srikanth Sombhatla. All rights reserved.
//

#import "THTheme.h"
#import "DCTheme.h"

@implementation THTheme

+ (UIColor*)primaryTextColor {
    return [DCTheme colorWithName:@"primary_text"];
}

+ (UIColor*)primaryBackgroundColor {
    return [DCTheme colorWithName:@"primary_background"];
}

+ (UIColor*)allFavoritesBackgroundColor {
    return [DCTheme colorWithName:@"all_favs_background"];
}

+ (UIColor*)aFavoriteBackgroundColor {
    return [DCTheme colorWithName:@"a_fav_background"];
}

+ (void)themeButtonWithDecoration:(UIButton*)button {
    [THTheme themeButton:button];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [THTheme primaryTextColor].CGColor;
}

+ (void)themeButton:(UIButton*)button {
    button.tintColor = [THTheme primaryTextColor];
}

@end
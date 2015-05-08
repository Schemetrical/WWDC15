//
//  ThemeController.h
//  Pixel
//
//  Created by Yichen Cao on 11/29/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Theme) {
    ThemeGraceful
};

@interface ThemeController : NSObject

@property (nonatomic) Theme theme;

@property (strong, nonatomic) UIFont *pickerViewFont;

@property (strong, nonatomic) UIFont *actionViewFont;

@property (readonly, strong, nonatomic) NSArray *themeItems;
@property (readonly, strong, nonatomic) NSArray *premiumThemeItems;

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

- (NSAttributedString *)attributedColorTextStringWithString:(NSString *)string;
- (NSAttributedString *)attributedColorTextStringWithString:(NSString *)string scale:(CGFloat)scale;
- (UIFont *)colorTextFontWithTheme:(Theme)theme scale:(CGFloat)scale;

@end

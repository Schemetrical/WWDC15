//
//  ThemeController.m
//  Pixel
//
//  Created by Yichen Cao on 11/29/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "ThemeController.h"

@implementation ThemeController

+ (instancetype)sharedInstance {
    static ThemeController *_sharedInstance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [ThemeController new];
        _sharedInstance.theme = ThemeGraceful;
    });
    return _sharedInstance;
}

- (UIFont *)colorTextFontWithTheme:(Theme)theme scale:(CGFloat)scale {
    switch (theme) {
        case ThemeGraceful:
            return [UIFont fontWithName:@"GillSans-Light" size:40.0 * scale];
    }
}

- (UIFont *)pickerViewFontWithTheme:(Theme)theme scale:(CGFloat)scale {
    switch (theme) {
        case ThemeGraceful:
            return [UIFont fontWithName:@"HelveticaNeue-Thin" size:40.0 * scale];
    }
}

- (UIFont *)actionViewFontWithTheme:(Theme)theme scale:(CGFloat)scale {
    switch (theme) {
        case ThemeGraceful:
            return [UIFont fontWithName:@"Avenir-Roman" size:20.0 * scale];
    }
}

- (NSDictionary *)attributesForTheme:(Theme)theme scale:(CGFloat)scale {
    switch (theme) {
        case ThemeGraceful: {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineHeightMultiple = 1.0;
            return @{NSParagraphStyleAttributeName:paragraphStyle,
                     NSFontAttributeName:[self colorTextFontWithTheme:self.theme scale:scale],
                     NSBaselineOffsetAttributeName:@0};
        }
    }
}

- (NSAttributedString *)attributedColorTextStringWithString:(NSString *)string {
    return [self attributedColorTextStringWithString:string scale:1.0];
}

- (NSAttributedString *)attributedColorTextStringWithString:(NSString *)string scale:(CGFloat)scale {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:[self attributesForTheme:self.theme scale:scale]];
    return attrString;
}

@end

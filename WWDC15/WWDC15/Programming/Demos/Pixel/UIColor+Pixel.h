//
//  UIColor+Pixel.h
//  Pixel
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//
//  Partly taken from Color Pack by Erica Sadun
//

#import <UIKit/UIKit.h>

@interface UIColor (Pixel)

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;

@property (nonatomic, readonly) CGFloat hue;
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;

@property (nonatomic, readonly) CGFloat cyanChannel;
@property (nonatomic, readonly) CGFloat magentaChannel;
@property (nonatomic, readonly) CGFloat yellowChannel;
@property (nonatomic, readonly) CGFloat blackChannel;

@property (nonatomic, readonly) CGFloat luminance;
@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly, copy) UIColor *contrastingColor;
@property (nonatomic, readonly, copy) UIColor *notContrastingColor;
@property (nonatomic, readonly, copy) NSString *hexStringValue;

+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithCyan:(CGFloat)c magenta:(CGFloat)m yellow:(CGFloat)y black:(CGFloat)k;

- (UIColor *)colorByAdding:(CGFloat)f;

@end

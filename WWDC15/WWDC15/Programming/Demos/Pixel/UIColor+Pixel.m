//
//  UIColor+Pixel.m
//  Pixel
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//
//  Dependencies run downwards ▼
//

#import "UIColor+Pixel.h"

@implementation UIColor (Pixel)

#pragma mark C functions and Preprocessor Macros

static CGFloat cgfmin(CGFloat a, CGFloat b) { return (a < b) ? a : b;}
static CGFloat cgfmax(CGFloat a, CGFloat b) { return (a > b) ? a : b;}
static CGFloat cgfunitclamp(CGFloat f) {return cgfmax(0.0, cgfmin(1.0, f));}

#define MAKEBYTE(_VALUE_) (int)(_VALUE_ * 0xFF) & 0xFF

#pragma mark Init

+ (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srand48(time(0));
    }
    return [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *string = stringToConvert.copy;
    if ([string hasPrefix:@"#"])
        string = [string substringFromIndex:1];
    while (string.length < 6) {
        string = [string stringByAppendingString:@"0"];
    }
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(uint32_t)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (UIColor *)colorWithCyan:(CGFloat)c magenta:(CGFloat)m yellow:(CGFloat)y black:(CGFloat)k {
    CGFloat r = (1.0f - c) * (1.0f - k);
    CGFloat g = (1.0f - m) * (1.0f - k);
    CGFloat b = (1.0f - y) * (1.0f - k);
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

#pragma mark Relative Colors

- (UIColor *)contrastingColor {
    return (self.luminance > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
}

- (UIColor *)notContrastingColor {
    return (self.luminance <= 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
}

#pragma mark Arithemetic

- (UIColor *)colorByAdding:(CGFloat)f {
    return [self colorByAddingRed:f green:f blue:f alpha:self.alpha];
}

- (UIColor *)colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use arithmetic operations");
    CGFloat r, g, b, a;
    if (![self getRed: &r green: &g blue: &b alpha: &a]) return nil;
    return [UIColor colorWithRed:cgfunitclamp(r + red) green:cgfunitclamp(g + green) blue:cgfunitclamp(b + blue) alpha:cgfunitclamp(a + alpha)];
}

#pragma mark Computed Properties

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    CGFloat r = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getRed:&r green:NULL blue:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&r alpha:NULL];
        default:
            break;
    }
    return r;
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    CGFloat g = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:&g blue:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&g alpha:NULL];
        default:
            break;
    }
    return g;
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    CGFloat b = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:NULL blue:&b alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&b alpha:NULL];
        default:
            break;
    }
    return b;
}

- (CGFloat)hue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -hue");
    CGFloat h = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getHue: &h saturation:NULL brightness:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&h alpha:NULL];
        default:
            break;
    }
    return h;
}

- (CGFloat)saturation {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -saturation");
    CGFloat s = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getHue:NULL saturation: &s brightness:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&s alpha:NULL];
        default:
            break;
    }
    return s;
}

- (CGFloat)brightness {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -brightness");
    CGFloat v = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getHue:NULL saturation:NULL brightness: &v alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&v alpha:NULL];
        default:
            break;
    }
    return v;
}

- (CGFloat)cyanChannel {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -cyanChannel");
    CGFloat c = 0.0f;
    [self toC:&c toM:NULL toY:NULL toK:NULL];
    return c;
}

- (CGFloat)magentaChannel {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -magentaChannel");
    CGFloat m = 0.0f;
    [self toC:NULL toM:&m toY:NULL toK:NULL];
    return m;
}

- (CGFloat)yellowChannel {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -yellowChannel");
    CGFloat y = 0.0f;
    [self toC:NULL toM:NULL toY:&y toK:NULL];
    return y;
}

- (CGFloat)blackChannel {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blackChannel");
    CGFloat k = 0.0f;
    [self toC:NULL toM:NULL toY:NULL toK:&k];
    return k;
}

- (CGFloat)luminance {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use -luminance");
    CGFloat r, g, b;
    if (![self getRed: &r green: &g blue: &b alpha:NULL])
        return 0.0f;
    return r * 0.2126f + g * 0.7152f + b * 0.0722f;
}

- (CGFloat)white {
    NSAssert(self.usesMonochromeColorspace, @"Must be a Monochrome color to use -white");
    CGFloat w;
    [self getWhite:&w alpha:NULL];
    return w;
}

- (CGFloat) alpha {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -alpha");
    CGFloat a = 0.0f;
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:NULL blue:NULL alpha:&a];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:NULL alpha:&a];
        default:
            break;
    }
    return a;
}

- (NSString *) hexStringValue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -hexStringValue");
    NSString *result;
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB: {
            CGFloat r, g, b;
            [self getRed:&r green:&g blue:&b alpha:nil];
            if (r > 0.9998) r = 1.0;
            if (g > 0.9998) g = 1.0;
            if (b > 0.9998) b = 1.0;
            result = [NSString stringWithFormat:@"%02X%02X%02X", MAKEBYTE(r), MAKEBYTE(g), MAKEBYTE(b)];
            break;
        }
        case kCGColorSpaceModelMonochrome: {
            int white = MAKEBYTE(self.white);
            result = [NSString stringWithFormat:@"%1$02X%1$02X%1$02X", white]; // crikey this string
            break;
        }
        default:
            result = nil;
    }
    return result;
}

#pragma mark Utilities

- (void)toC:(CGFloat *)cyan toM:(CGFloat *)magenta toY:(CGFloat *)yellow toK:(CGFloat *)black{
    CGFloat r, g, b;
    
    [self getRed:&r green:&g blue:&b alpha:NULL];
    
    CGFloat k = 1.0f - fmaxf(fmaxf(r, g), b);
    CGFloat dK = 1.0f - k;
    
    CGFloat c = (1.0f - (r + k)) / dK;
    CGFloat m = (1.0f - (g + k)) / dK;
    CGFloat y = (1.0f - (b + k)) / dK;
    
    if (isnan(c)) c = 0.0;
    if (isnan(m)) m = 0.0;
    if (isnan(y)) y = 0.0;
    if (isnan(k)) k = 0.0;
    
    if (cyan) *cyan = c;
    if (magenta) *magenta = m;
    if (yellow) *yellow = y;
    if (black) *black = k;
}

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}
- (BOOL)usesMonochromeColorspace {
    return self.colorSpaceModel == kCGColorSpaceModelMonochrome;
}

@end

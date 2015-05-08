//
//  ColorTextController.m
//  Pixel
//
//  Created by Yichen Cao on 11/27/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "ColorTextController.h"

// Localisation
#define CODE_ITEM_NONE NSLocalizedStringFromTable(@"CODE_ITEM_NONE", @"PixelViewText", @"Picker text for no themes, use shortest word for 'none'")
#define CODE_ITEM_HEX NSLocalizedStringFromTable(@"CODE_ITEM_HEX", @"PixelViewText", @"Picker text for CSS Hex")
#define CODE_ITEM_NAME NSLocalizedStringFromTable(@"CODE_ITEM_NAME", @"PixelViewText", @"Picker text for color names, 'names' is an appropriate choice too")

#define RGB_FORMAT_STRING NSLocalizedStringFromTable(@"RGB_FORMAT_STRING", @"PixelViewText", @"Appropriate short format string for RGB")
#define HSB_FORMAT_STRING NSLocalizedStringFromTable(@"HSB_FORMAT_STRING", @"PixelViewText", @"Appropriate short format string for HSB")
#define CMYK_FORMAT_STRING NSLocalizedStringFromTable(@"CMYK_FORMAT_STRING", @"PixelViewText", @"Appropriate short format string for CMYK")

#define RGB_LONG_FORMAT_STRING NSLocalizedStringFromTable(@"RGB_LONG_FORMAT_STRING", @"PixelViewText", @"Appropriate full format string for RGB")
#define HSB_LONG_FORMAT_STRING NSLocalizedStringFromTable(@"HSB_LONG_FORMAT_STRING", @"PixelViewText", @"Appropriate full format string for HSB")
#define CMYK_LONG_FORMAT_STRING NSLocalizedStringFromTable(@"CMYK_LONG_FORMAT_STRING", @"PixelViewText", @"Appropriate full format string for CMYK")

@implementation ColorTextController {
    NSDictionary *_colorNames;
    NSString *_currentColorDictionary;
    NSNumberFormatter *_numberFormatter;
}

- (instancetype)init {
    if (self = [super init]) {
        self.codeItems = @[@[CODE_ITEM_NONE],
                           @[CODE_ITEM_HEX, @"Pantone™"],
                           @[@"RGB", @"HSB", @"CMYK", @"YUV"],
                           @[CODE_ITEM_NAME]];
        self.codeMapping = @[@[@(ColorLabelModeNone)],
                             @[@(ColorLabelModeCSSHex), @(ColorLabelModePantone)],
                             @[@(ColorLabelModeRGB), @(ColorLabelModeHSB), @(ColorLabelModeCMYK), @(ColorLabelModeYUV)],
                             @[@(ColorLabelModeColorNameWikipedia)]];
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatter.usesSignificantDigits = NO;
        _numberFormatter.minimumFractionDigits = 3;
        _numberFormatter.maximumFractionDigits = 3;
    }
    return self;
}

- (NSString *)textForColor:(UIColor *)color {
    return [self textForColor:color mode:self.colorLabelMode];
}

- (NSString *)textForColor:(UIColor *)color mode:(ColorLabelMode)mode {
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    switch (mode) {
        case ColorLabelModeNone:
            return nil;
        case ColorLabelModeCSSHex:
            return [NSString stringWithFormat:@"#%@", [color hexStringValue]];
        case ColorLabelModePantone:
            return [self closestColor:color inDictionary:@"Pantone"];
        case ColorLabelModeColorNameWikipedia:
            return [self closestColor:color inDictionary:@"Names"];
        case ColorLabelModeRGB:
        case ColorLabelModeRGBTutorial:
            return [NSString stringWithFormat:
                    mode == ColorLabelModeRGB ? RGB_FORMAT_STRING : RGB_LONG_FORMAT_STRING,
                    [_numberFormatter stringFromNumber:@(r)],
                    [_numberFormatter stringFromNumber:@(g)],
                    [_numberFormatter stringFromNumber:@(b)]];
        case ColorLabelModeHSB:
        case ColorLabelModeHSBTutorial: {
            CGFloat h, s, v;
            [color getHue:&h saturation:&s brightness:&v alpha:nil];
            return [NSString stringWithFormat:
                    mode == ColorLabelModeHSB ? HSB_FORMAT_STRING : HSB_LONG_FORMAT_STRING,
                    h * 360,
                    [_numberFormatter stringFromNumber:@(s)],
                    [_numberFormatter stringFromNumber:@(v)]];
        }
        case ColorLabelModeCMYK:
        case ColorLabelModeCMYKTutorial: {
            CGFloat k = 1.0f - fmaxf(fmaxf(r, g), b);
            CGFloat dK = 1.0f - k;
            
            CGFloat c = (1.0f - (r + k)) / dK;
            CGFloat m = (1.0f - (g + k)) / dK;
            CGFloat y = (1.0f - (b + k)) / dK;
            
            if (isnan(c)) c = 0.0;
            if (isnan(m)) m = 0.0;
            if (isnan(y)) y = 0.0;
            if (isnan(k)) k = 0.0;
            
            return [NSString stringWithFormat:
                    mode == ColorLabelModeCMYK ? CMYK_FORMAT_STRING : CMYK_LONG_FORMAT_STRING,
                    c < 0 ? 0 : [_numberFormatter stringFromNumber:@(c)],
                    m < 0 ? 0 : [_numberFormatter stringFromNumber:@(m)],
                    y < 0 ? 0 : [_numberFormatter stringFromNumber:@(y)],
                    [_numberFormatter stringFromNumber:@(k)]];
        }
        case ColorLabelModeYUV: {
            CGFloat y, u, v;
            y = 0.299   * r + 0.587  * g + 0.114  * b;
            u = -0.1687 * r - 0.3313 * g + 0.5    * b;
            v = 0.5     * r - 0.4187 * g - 0.813  * b;
            return [NSString stringWithFormat:
                    @"Y \t%@%@\nU \t%@%@\nV \t%@%@",
                    y >= 0 ? @" " : @"",
                    [_numberFormatter stringFromNumber:@(y)],
                    u >= 0 ? @" " : @"",
                    [_numberFormatter stringFromNumber:@(u)],
                    v >= 0 ? @" " : @"",
                    [_numberFormatter stringFromNumber:@(v)]];
        }
    }
}

- (NSString *)closestColor:(UIColor *)color inDictionary:(NSString *)dictionaryName {
    if (!_colorNames || ![_currentColorDictionary isEqualToString:dictionaryName]) {
        _currentColorDictionary = dictionaryName;
        NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:dictionaryName ofType:@"txt"]
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        [self setDictionaryForColor:color inFile:content];
    }
    
    NSString *hexIndexLetter = [[color hexStringValue] substringToIndex:1];
    CGFloat bestScore = MAXFLOAT;
    NSString *bestKey;
    
    for (NSString *colorHex in [_colorNames[hexIndexLetter] allKeys]) {
        UIColor *comparisonColor = [UIColor colorWithHexString:colorHex];
        if (!comparisonColor)
            continue;
        
        CGFloat r, g, b, cR, cG, cB;
        [color getRed:&r green:&g blue:&b alpha:nil];
        [comparisonColor getRed:&cR green:&cG blue:&cB alpha:nil];
        
        CGFloat dR = r - cR;
        CGFloat dG = g - cG;
        CGFloat dB = b - cB;
        
        CGFloat score = /*sqrtf(*/dR * dR + dG * dG + dB * dB/*)*/; // I wonder why its necessary.
        
        if (score < bestScore) {
            bestScore = score;
            bestKey = colorHex;
        }
    }
    
    return _colorNames[hexIndexLetter][bestKey];
}

- (void)setDictionaryForColor:(UIColor *)color inFile:(NSString *)content {
    NSMutableDictionary *indexedNames = [NSMutableDictionary new];
    for (int keyValue = 0; keyValue <= 15; keyValue++) {
        indexedNames[[NSString stringWithFormat:@"%X", keyValue]] = [NSMutableDictionary new];
    }
    NSArray *colorPairs = [content componentsSeparatedByString:@"\n"];
    for (NSString *colorPairString in colorPairs) {
        NSArray *colorPair = [colorPairString componentsSeparatedByString:@"\t"];
        (indexedNames[[colorPairString substringToIndex:1]])[colorPair[0]] = colorPair[1];
    }
    _colorNames = indexedNames;
}

- (void)setColorLabelMode:(ColorLabelMode)colorLabelMode {
    _colorLabelMode = colorLabelMode;
    [self.delegate setColorLabelText];
}

#pragma mark - Help Text

- (NSString *)helpText {
    switch (self.colorLabelMode) {
        case ColorLabelModeNone:
            return @"Empty color label";
        case ColorLabelModeCSSHex:
            return @"Closest hexadecimal Red Green Blue color code, commonly used in CSS and web design.";
        case ColorLabelModePantone:
            return @"Closest Pantone™ C color code, commonly used for uniform accurate colors.";
        case ColorLabelModeColorNameWikipedia:
            return @"Closest color name from Wikipedia.";
        /*case ColorLabelModeColorNameXKCD:
            return @"Closest color name from the popular webcomic xkcd.";
        case ColorLabelModeColorNameCrayon:
            return @"Closest crayon color name.";
        case ColorLabelModeColorNameMoroney:
            return @"Closest Moroney color name.";*/
        case ColorLabelModeRGB:
        case ColorLabelModeRGBTutorial:
            return @"The Red Green Blue decimal values.";
        case ColorLabelModeHSB:
        case ColorLabelModeHSBTutorial:
            return @"The Hue degree and the Saturation and Brightness decimal values.";
        case ColorLabelModeCMYK:
        case ColorLabelModeCMYKTutorial:
            return @"The Cyan Magenta Yellow Key decimal values.";
        case ColorLabelModeYUV:
            return @"The YUV decimal values. Y is brightness based on human perception.";
    }
}

- (NSTextAlignment)textAlignment {
    switch (self.colorLabelMode) {
        case ColorLabelModeNone:
        case ColorLabelModeCSSHex:
        case ColorLabelModePantone:
        case ColorLabelModeColorNameWikipedia:/*
        case ColorLabelModeColorNameXKCD:
        case ColorLabelModeColorNameCrayon:
        case ColorLabelModeColorNameMoroney:*/
            return NSTextAlignmentCenter;
        case ColorLabelModeRGBTutorial:
        case ColorLabelModeHSBTutorial:
        case ColorLabelModeCMYKTutorial:
        case ColorLabelModeRGB:
        case ColorLabelModeHSB:
        case ColorLabelModeCMYK:
        case ColorLabelModeYUV:
            return NSTextAlignmentLeft;
    }
}

@end

//
//  ColorTextController.h
//  Pixel
//
//  Created by Yichen Cao on 11/27/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Pixel.h"

typedef NS_ENUM(NSUInteger, ColorLabelMode) {
    ColorLabelModeNone,
    ColorLabelModeCSSHex,
    ColorLabelModePantone,
    ColorLabelModeColorNameWikipedia,
    ColorLabelModeRGB,
    ColorLabelModeHSB,
    ColorLabelModeCMYK,
    ColorLabelModeYUV,
    ColorLabelModeRGBTutorial,
    ColorLabelModeHSBTutorial,
    ColorLabelModeCMYKTutorial
};

@protocol ColorTextControllerDelegate;

@interface ColorTextController : NSObject

@property (nonatomic) ColorLabelMode colorLabelMode;

@property (weak, nonatomic) id <ColorTextControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *codeItems;
@property (strong, nonatomic) NSArray *codeMapping;

@property (readonly) NSString *helpText;
@property (readonly) NSTextAlignment textAlignment;

- (NSString *)textForColor:(UIColor *)color;
- (NSString *)textForColor:(UIColor *)color mode:(ColorLabelMode)mode;

@end

@protocol ColorTextControllerDelegate <NSObject>

- (void)setColorLabelText;

@end

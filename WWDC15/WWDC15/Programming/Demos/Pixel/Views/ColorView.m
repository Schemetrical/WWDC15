//
//  ColorView.m
//  Pixel
//
//  Created by Yichen Cao on 2/28/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import "ColorView.h"

#define BORDER_WIDTH_FORMULA(saturation, value) 1.8 * CUSTOM_BRIGHTNESS_FORMULA(saturation, value)
#define CUSTOM_BRIGHTNESS_FORMULA(saturation, value) ((1 - saturation) * value * 6 - 5)

@implementation ColorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SQUARE_CORNER_RADIUS;
        self.layer.borderWidth = 1.8;
        self.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:1.0].CGColor;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    CGFloat s, v;
    [backgroundColor getHue:nil saturation:&s brightness:&v alpha:nil];
    self.layer.borderWidth = BORDER_WIDTH_FORMULA(s, v);
    self.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:CUSTOM_BRIGHTNESS_FORMULA(s, v)].CGColor;
    
}

@end

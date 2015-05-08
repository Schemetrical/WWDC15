//
//  PixelView.h
//  Pixel
//
//  Created by ycao on 8/24/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureLayout/PureLayout.h>
#import "UIColor+Pixel.h"

#define HUE_HANDLE_RADIUS ([UIScreen mainScreen].bounds.size.width / 80 + 6.0)
#define HUE_HANDLE_INSET [UIScreen mainScreen].bounds.size.width / 80 + 6.0

#define SQUARE_INSET 20.0
#define CIRCLE_INSET (HUE_HANDLE_INSET + HUE_HANDLE_RADIUS) * 2

// Animation
#define STANDARD_ANIMATION_TIME 0.3
#define SHORT_ANIMATION_TIME STANDARD_ANIMATION_TIME / 2
#define LONG_ANIMATION_TIME STANDARD_ANIMATION_TIME * 2
#define LONGLONG_ANIMATION_TIME STANDARD_ANIMATION_TIME * 3


typedef NS_ENUM(NSInteger, PixelShape) {
    PixelShapeCircle,
    PixelShapeUndefined = -1
};

@interface PixelView : UIView

@property (nonatomic) PixelShape pixelShape;

- (BOOL)containsPoint:(CGPoint)point;
- (void)setPixelShape:(PixelShape)pixelShape animated:(BOOL)animated;
- (CGPoint)locationOfTouch:(UITouch *)touch;

@end

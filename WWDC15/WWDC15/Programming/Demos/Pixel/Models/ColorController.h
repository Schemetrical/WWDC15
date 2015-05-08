//
//  ColorController.h
//  Pixel
//
//  Created by Yichen Cao on 11/27/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PixelView.h"

typedef NS_ENUM(NSUInteger, PixelMode) {
    PixelModeHSB,
};

@protocol ColorControllerDataSource, ColorControllerDelegate;

@interface ColorController : NSObject

@property (weak, nonatomic) id <ColorControllerDataSource> dataSource;
@property (weak, nonatomic) id <ColorControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *modeItems;
@property (strong, nonatomic) NSArray *modeMapping;

@property (readonly) NSString *helpText;

@property (strong, nonatomic) UIColor *color;

@property (nonatomic) PixelMode pixelMode;

- (void)touchesBegan:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesCancelled;

@end

@protocol ColorControllerDelegate <NSObject>

@optional

- (void)colorChanged:(UIColor *)color;
- (void)didTap;
- (void)shouldAddHueHandle;
- (void)shouldHideHueHandle;

@end

@protocol ColorControllerDataSource

- (BOOL)pixelViewContainsPoint:(CGPoint)point;
- (CGPoint)locationOfTouchInPixelView:(UITouch *)touch;

@property (strong, nonatomic) PixelView *pixelView;

@end

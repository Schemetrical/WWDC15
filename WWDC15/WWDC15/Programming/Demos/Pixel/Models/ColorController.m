//
//  ColorController.m
//  Pixel
//
//  Created by Yichen Cao on 11/27/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "ColorController.h"

@implementation ColorController {
    // Tracks the touches
    NSMutableDictionary *_allTouches /*<UITouch *>*/;
    // Tracks the last touch point
    NSMutableDictionary *_lastPoint /*<CGPoint>*/;
    // Tracks if its a tap or drag
    BOOL _moved;
    UIBezierPath *_path;
}

- (instancetype)init {
    if (self = [super init]) {
        _allTouches = [NSMutableDictionary new];
        _lastPoint = [NSMutableDictionary new];
        
        self.modeItems = @[@[@"HSB"]];
        self.modeMapping = @[@[@(PixelModeHSB)]];
    }
    return self;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches {
    for (UITouch *touch in touches) {
        CGPoint touchedPoint = [self.dataSource locationOfTouchInPixelView:touch];
        if ([self.dataSource pixelViewContainsPoint:touchedPoint]) {
            NSUInteger totalSectors;
            switch (self.pixelMode) {
                case PixelModeHSB:
                    totalSectors = 1;
                    break;
            }
            NSUInteger sector = [self sectorOfPoint:touchedPoint inBounds:self.dataSource.pixelView.bounds totalSectors:totalSectors];
            if (!_allTouches[@(sector)]) {
                _allTouches[@(sector)] = touch;
                _lastPoint[@(sector)] = [NSValue valueWithCGPoint:touchedPoint];
            }
            _moved = NO;
            return;
        } else if (self.pixelMode == PixelModeHSB) {
            // Special case for HSB
            if (!_path) {
                CGRect originalRect = self.dataSource.pixelView.layer.bounds;
                CGRect extendedRect = CGRectMake(originalRect.origin.x - CIRCLE_INSET,
                                                 originalRect.origin.y - CIRCLE_INSET,
                                                 originalRect.size.width + 2 * CIRCLE_INSET,
                                                 originalRect.size.height + 2 * CIRCLE_INSET);
                _path = [UIBezierPath bezierPathWithRoundedRect:extendedRect
                                                                cornerRadius:self.dataSource.pixelView.layer.cornerRadius + CIRCLE_INSET];
            }
            if ([_path containsPoint:touchedPoint]) {
                _allTouches[@1] = touch;
                return;
            }
        }
        // The rest of the cases fall here (not touching in the hue handle ring or the pixel view)
        /*
        [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
        [self.pixelView removeConstraints:self.pixelView.constraints];
        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:self.pixelView attachedToAnchor:touchedPoint];
        behavior.damping = 0.5;
        behavior.length = 20;
        [animator addBehavior:behavior];*/
    }
    _moved = YES; // Just so that touching white areas wont do anything
}

- (void)touchesEnded:(NSSet *)touches {
    if (touches && !_moved) {
//        if ([self.delegate respondsToSelector:@selector(didTap)])
//            [self.delegate didTap];
    }
    [_allTouches removeAllObjects];
    [_lastPoint removeAllObjects];
}

- (void)touchesMoved:(NSSet *)touches {
    _moved = YES;
    for (UITouch *touch in touches) {
        if ([_allTouches.allValues containsObject:touch]) {
            CGPoint touchedPoint = [self.dataSource locationOfTouchInPixelView:touch];
            NSUInteger sector = [[_allTouches allKeysForObject:touch][0] unsignedIntegerValue];
            CGPoint oldPoint = [_lastPoint[@(sector)] CGPointValue];
            CGPoint diff = CGPointMake(touchedPoint.x - oldPoint.x, touchedPoint.y - oldPoint.y);
            CGSize scaleFactor = self.dataSource.pixelView.frame.size;
            UIColor *newColor;
            CGFloat r, g, b, a;
            [self.color getRed:&r green:&g blue:&b alpha:&a];
            switch (self.pixelMode) {
                case PixelModeHSB: {
                    CGFloat h, s, b, a;
                    [self.color getHue:&h saturation:&s brightness:&b alpha:&a];
                    CGFloat newHue = atanf((touchedPoint.y - (scaleFactor.height / 2)) / (touchedPoint.x - (scaleFactor.width / 2))) / M_PI;
                    newHue = (newHue + 0.5) / 2;
                    if (touchedPoint.x - (scaleFactor.width / 2) < 0) {
                        newHue += 0.5;
                    }
                    if (newHue > 1) {
                        newHue -= 1;
                    }
                    CGFloat newSaturation = s + (sector == 0 ? diff.x / scaleFactor.width : 0);
                    CGFloat newBrightness = b - (sector == 0 ? diff.y / scaleFactor.height : 0);
                    newColor = [UIColor colorWithHue:sector == 1 && !isnan(newHue) ? newHue : h
                                          saturation:newSaturation < 0.0001 ? 0.0001 : newSaturation
                                          brightness:newBrightness < 0.0001 ? 0.0001 : newBrightness
                                               alpha:a];
                    break;
                }
            }
            self.color = newColor;
            _lastPoint[@(sector)] = [NSValue valueWithCGPoint:touchedPoint];
        }
    }
}

- (void)touchesCancelled {
    [_allTouches removeAllObjects];
    [_lastPoint removeAllObjects];
}

- (NSUInteger)sectorOfPoint:(CGPoint)point inBounds:(CGRect)bounds totalSectors:(NSUInteger)sectors {
    CGFloat sectorWidth = bounds.size.width / sectors;
    for (CGFloat sector = 0; sector < sectors; sector++) {
        if (point.x < (sector + 1) * sectorWidth) {
            return sector;
        }
    }
    return UINT16_MAX; // error
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self.delegate colorChanged:color];
}

- (void)setPixelMode:(PixelMode)pixelMode {
    _pixelMode = pixelMode;
    [self touchesEnded:nil];
    if (_pixelMode == PixelModeHSB) {
        if ([self.delegate respondsToSelector:@selector(shouldAddHueHandle)])
            [self.delegate shouldAddHueHandle];
    } else {
        if ([self.delegate respondsToSelector:@selector(shouldHideHueHandle)])
            [self.delegate shouldHideHueHandle];
    }
}

@end

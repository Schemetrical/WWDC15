//
//  PixelView.m
//  Pixel
//
//  Created by ycao on 8/24/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "PixelView.h"
#import "ColorView.h"


@implementation PixelView {
    UIBezierPath *_path;
    ColorView *_colorView;
    UIView *_hueHandleView;
    NSArray *_edgeInsetConstraints;
}

- (instancetype)initForAutoLayout {
    if (self = [super initForAutoLayout]) {
        _pixelShape = PixelShapeUndefined;
        [self configureColorView];
    }
    return self;
}

- (void)configureColorView {
    _colorView = [[ColorView alloc] initForAutoLayout];
    [self addSubview:_colorView];
    [_colorView autoCenterInSuperview];
    [_colorView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_colorView];
}

- (void)setPixelShape:(PixelShape)pixelShape {
    [self setPixelShape:pixelShape animated:NO];
}

- (void)setPixelShape:(PixelShape)pixelShape animated:(BOOL)animated {
    if (_pixelShape == pixelShape || pixelShape == PixelShapeUndefined) {
        return;
    }
    if (pixelShape == PixelShapeCircle) {
        [self showHueHandle];
    } else {
        [self hideHueHandle];
    }
    if (animated) {
        [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
            [self setConstraintsWithPixelShape:pixelShape];
        }];
        if (!(_pixelShape != PixelShapeCircle && pixelShape != PixelShapeCircle)) {
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            basicAnimation.fromValue = pixelShape != PixelShapeCircle ? @(_colorView.frame.size.width / 2) : @SQUARE_CORNER_RADIUS;
            basicAnimation.toValue = pixelShape == PixelShapeCircle ? @(_colorView.frame.size.width / 2) : @SQUARE_CORNER_RADIUS;
            basicAnimation.duration = STANDARD_ANIMATION_TIME;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_colorView.layer addAnimation:basicAnimation forKey:@"cornerRadius"];
                _colorView.layer.cornerRadius = pixelShape == PixelShapeCircle ? _colorView.frame.size.width / 2 : SQUARE_CORNER_RADIUS;
            });
        }
    } else {
        [self setConstraintsWithPixelShape:pixelShape];
        _colorView.layer.cornerRadius = pixelShape == PixelShapeCircle ? _colorView.frame.size.width / 2 : SQUARE_CORNER_RADIUS;
    }
    _pixelShape = pixelShape;
}

- (void)showHueHandle {
    if (!_hueHandleView) {
        [self addHueHandle];
    }
    [self moveHueHandleWithHue:self.backgroundColor.hue];
    [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
        _hueHandleView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)addHueHandle {
    _hueHandleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HUE_HANDLE_RADIUS * 2, HUE_HANDLE_RADIUS * 2)];
    _hueHandleView.layer.cornerRadius = HUE_HANDLE_RADIUS;
    _hueHandleView.backgroundColor = _colorView.backgroundColor;
    _hueHandleView.transform = CGAffineTransformMakeScale(0, 0);
    [self addSubview:_hueHandleView];
}

- (void)hideHueHandle {
    [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
        _hueHandleView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }];
}

- (void)moveHueHandleWithHue:(CGFloat)hue {
    static CGFloat radius = 0;
    if (!radius) {
        radius = (self.superview.frame.size.width - CIRCLE_INSET) / 2;
    }
    CGFloat y = cosf(hue * 2 * M_PI) * radius;
    CGFloat x = sinf(hue * 2 * M_PI) * radius;
    _hueHandleView.center = CGPointMake(x + self.bounds.size.width / 2, -y + self.bounds.size.height / 2);
}

- (void)setConstraintsWithPixelShape:(PixelShape)pixelShape {
    [self removeConstraints:_edgeInsetConstraints];
    switch (pixelShape) {
            break;
        case PixelShapeCircle:
            _edgeInsetConstraints = @[[_colorView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:CIRCLE_INSET]];
            break;
        default:
            break;
    }
    [self addConstraints:_edgeInsetConstraints];
    [self layoutIfNeeded];
}

- (BOOL)containsPoint:(CGPoint)point {
    if (!_path) {
        _path = [UIBezierPath bezierPathWithRoundedRect:_colorView.layer.bounds
                                           cornerRadius:_colorView.layer.cornerRadius];
    }
    return [_path containsPoint:point];
}

#pragma mark - Getters and Setters

- (UIColor *)backgroundColor {
    return _colorView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _colorView.backgroundColor = backgroundColor;
    _hueHandleView.backgroundColor = backgroundColor;
    [self moveHueHandleWithHue:backgroundColor.hue];
}

- (CGRect)frame {
    return _colorView.frame;
}

- (CALayer *)layer {
    return _colorView.layer;
}

- (CGPoint)locationOfTouch:(UITouch *)touch {
    return [touch locationInView:_colorView];
}

@end

//
//  PixelViewController.m
//  Pixel
//
//  Created by Yichen Cao on 1/2/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import "PixelDemoViewController.h"
#import "NSUserDefaults+Subscripting.h"

// Views
#import "ColorLabel.h"

NSString *const kHSBPaletteTutorialKey = @"didShowHSBPaletteTutorial";

@interface PixelDemoViewController ()

// Views
@property (strong, nonatomic) ColorLabel *colorLabel;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation PixelDemoViewController {
    NSArray *_tutorialViews;
    UILabel *_tutorialLabel;
    NSInteger _tutorialLevel;
    BOOL _shouldContinueTutorial;
    BOOL _viewPresented;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [NSUserDefaults standardUserDefaults][kHSBPaletteTutorialKey] = @NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews];
    [self addControllers];
    
    self.colorController.pixelMode = PixelModeHSB;
    [self.pixelView setPixelShape:PixelShapeCircle animated:NO];
    
    self.colorTextController.colorLabelMode = ColorLabelModeColorNameWikipedia;

    _viewPresented = YES;
    if ([self shouldShowTutorial]) {
        [self makeTutorial];
    }
    
    self.colorTextController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:@"ThemeDidChangeNotification" object:nil];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setTitle:@"back" forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
    self.backButton.frame = CGRectMake(10, 10, 70, 35);
    self.backButton.layer.cornerRadius = 5;
    [self.backButton addTarget:self action:@selector(dismissDemo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    
    [self.backButton setTitleColor:self.colorController.color.contrastingColor forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.colorController.color = [UIColor randomColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self shouldShowTutorial]) {
        [self startTutorial];
        [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
            self.colorLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.colorLabel.hidden = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViews {
    self.pixelView = [[PixelView alloc] initForAutoLayout];
    [self.view addSubview:self.pixelView];
    [self autoLayoutPixelView];
    
    self.colorLabel = [[ColorLabel alloc] initForAutoLayout];
    [self.view addSubview:self.colorLabel];
    [self autoLayoutColorLabel];
}

- (void)addControllers {
    self.colorTextController = [[ColorTextController alloc] init];
    self.colorTextController.delegate = self;
    
    self.colorController = [[ColorController alloc] init];
    self.colorController.dataSource = self;
    self.colorController.delegate = self;
    
    // Starting Color
    self.colorController.color = [UIColor randomColor];    
}

- (void)autoLayoutPixelView {
    [self.pixelView autoCenterInSuperview];
    [self.pixelView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
    [self.pixelView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.pixelView];
}

- (void)autoLayoutColorLabel {
    [self.colorLabel autoCenterInSuperview];
    [self.view addConstraints:@[[self.colorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.pixelView
                                                  withOffset:CIRCLE_INSET relation:NSLayoutRelationGreaterThanOrEqual],
                                [self.colorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.pixelView
                                                  withOffset:-CIRCLE_INSET relation:NSLayoutRelationLessThanOrEqual]]];
}

#pragma mark Color Handling

- (void)setPixelViewBackgroundColor:(UIColor *)color {
    self.pixelView.backgroundColor = color;
    self.backButton.backgroundColor = color;
}

- (void)setColorLabelTextWithColor:(UIColor *)color animated:(BOOL)animated {
    NSString *text = [self.colorTextController textForColor:color];
    if (animated) {
        [UIView transitionWithView:self.colorLabel duration:SHORT_ANIMATION_TIME options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.colorLabel.attributedText = text ? [[ThemeController sharedInstance] attributedColorTextStringWithString:text] : nil;
            self.colorLabel.textAlignment = self.colorTextController.textAlignment;
        } completion:nil];
    } else {
        self.colorLabel.attributedText = text ? [[ThemeController sharedInstance] attributedColorTextStringWithString:text] : nil;
        self.colorLabel.textAlignment = self.colorTextController.textAlignment;
    }
    UIColor *contrastingColor = color.contrastingColor;
    if (![self.colorLabel.textColor isEqual:contrastingColor]) {
        self.colorLabel.textColor = contrastingColor;
        [self.backButton setTitleColor:contrastingColor forState:UIControlStateNormal];
    }
}

#pragma mark - Color Text Controller Delegate

- (void)setColorLabelText {
    [self setColorLabelTextWithColor:self.pixelView.backgroundColor animated:YES];
}

#pragma mark - Color Controller Data Source

- (BOOL)pixelViewContainsPoint:(CGPoint)point {
    return [self.pixelView containsPoint:point];
}

- (CGPoint)locationOfTouchInPixelView:(UITouch *)touch {
    return [self.pixelView locationOfTouch:touch];
}

#pragma mark Color Controller Delegate

- (void)colorChanged:(UIColor *)color {
    [self setPixelViewBackgroundColor:color];
    [self setColorLabelTextWithColor:color animated:NO];
    if (_tutorialViews) {
        [self updateTutorialViews];
    }
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [super touchesBegan:touches withEvent:event];
    [self.colorController touchesBegan:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [super touchesEnded:touches withEvent:event];
    [self.colorController touchesEnded:touches];
    if (_shouldContinueTutorial) {
        _shouldContinueTutorial = NO;
        [self continueTutorial];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [super touchesMoved:touches withEvent:event];
    [self.colorController touchesMoved:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [super touchesCancelled:touches withEvent:event];
    [self.colorController touchesCancelled];
}

- (void)didTap {
    if ([self shouldShowTutorial]) {
        self.colorLabel.hidden = NO;
        self.colorLabel.alpha = 0.0;
        [UIView animateWithDuration:SHORT_ANIMATION_TIME animations:^{
            self.colorLabel.alpha = 1.0;
            for (NSArray *views in _tutorialViews) {
                for (UIView *view in views) {
                    view.alpha = 0.0;
                }
            }
            _tutorialLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

#pragma mark - Notifications

- (void)themeDidChange {
    [self colorChanged:self.colorController.color];
}

#pragma mark - Tutorial

- (void)prepareForTutorialView {
    [self makeTutorial];
    [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
        self.colorLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self startTutorial];
        self.colorLabel.hidden = YES;
    }];
}

- (void)makeTutorial {
    switch (self.colorController.pixelMode) {
        case PixelModeHSB: {
            // Tracks
            UIView *hueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - CIRCLE_INSET, self.view.frame.size.width - CIRCLE_INSET)];
            hueView.layer.cornerRadius = hueView.frame.size.width / 2;
            hueView.layer.borderWidth = 2.0;
            [self.view insertSubview:hueView belowSubview:self.pixelView];
            
            UIView *saturationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pixelView.frame.size.height - 20, 2.0)];
            [self.view insertSubview:saturationView aboveSubview:self.pixelView];
            
            UIView *brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.0, self.pixelView.frame.size.height - 20)];
            [self.view insertSubview:brightnessView aboveSubview:self.pixelView];
            
            // Indicators
            UIView *saturationIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            saturationIndicator.layer.cornerRadius = saturationIndicator.frame.size.width / 2;
            [self.view insertSubview:saturationIndicator aboveSubview:saturationView];
            
            UIView *brightnessIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            brightnessIndicator.layer.cornerRadius = brightnessIndicator.frame.size.width / 2;
            [self.view insertSubview:brightnessIndicator aboveSubview:brightnessView];
            
            // Tutorial Label
            UILabel *tutorialLabel = [[UILabel alloc] initForAutoLayout];
            tutorialLabel.font = [ThemeController sharedInstance].actionViewFont;
            [self.view addSubview:tutorialLabel];
            [tutorialLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [tutorialLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:self.pixelView.frame.size.height / 2 + 60];
            
            _tutorialViews = @[@[hueView], @[saturationView, saturationIndicator], @[brightnessView, brightnessIndicator]];
            // Position
            for (NSArray *views in _tutorialViews) {
                [views[0] setCenter:self.view.center];
                for (UIView *view in views) {
                    view.alpha = 0.0;
                }
            }
            _tutorialLabel = tutorialLabel;
            _tutorialLevel = -1;
            [self updateTutorialViews];
            // Shapes library maybe?
            break;
        }
    }
}

- (void)startTutorial {
    _tutorialLevel = -1;
    _tutorialLabel.textColor = [self tutorialTextColorForPixelMode:self.colorController.pixelMode level:0];
    [self continueTutorial];
}

- (void)continueTutorial {
    _tutorialLevel++;
    if (_tutorialLevel >= _tutorialViews.count) {
        [self endTutorial];
        return;
    }
    [UIView transitionWithView:_tutorialLabel duration:STANDARD_ANIMATION_TIME options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _tutorialLabel.text = [self tutorialTextForPixelMode:self.colorController.pixelMode];
        _tutorialLabel.textColor = [self tutorialTextColorForPixelMode:self.colorController.pixelMode level:_tutorialLevel];
    } completion:nil];
    [UIView animateWithDuration:STANDARD_ANIMATION_TIME animations:^{
        _tutorialLabel.alpha = 1.0;
        for (UIView *view in _tutorialViews[_tutorialLevel]) {
            view.alpha = 1.0;
        }
        if (_tutorialLevel > 0) {
            for (UIView *view in _tutorialViews[_tutorialLevel - 1]) {
                view.alpha = 0.1;
            }
        }
    }];
}

- (void)endTutorial {
    self.colorLabel.hidden = NO;
    self.colorLabel.alpha = 0.0;
    [UIView animateWithDuration:LONG_ANIMATION_TIME animations:^{
        self.colorLabel.alpha = 1.0;
        for (NSArray *views in _tutorialViews) {
            for (UIView *view in views) {
                view.alpha = 0.0;
            }
        }
        _tutorialLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        for (NSArray *views in _tutorialViews) {
            for (UIView *view in views) {
                [view removeFromSuperview];
            }
        }
        _tutorialViews = nil;
        [_tutorialLabel removeFromSuperview];
        _tutorialLabel = nil;
        _tutorialLevel = -1;
        [self setShouldShowTutorial:NO forMode:self.colorController.pixelMode];
    }];
}

- (void)updateTutorialViews {
    if (_tutorialLevel >= 0) {
        _tutorialLabel.text = [self tutorialTextForPixelMode:self.colorController.pixelMode];
    }
    switch (self.colorController.pixelMode) {
        case PixelModeHSB: {
            UIView *hueView = _tutorialViews[0][0];
            hueView.layer.borderColor = self.colorController.color.CGColor;
            UIView *saturationIndicator = _tutorialViews[1][1];
            UIView *brightnessIndicator = _tutorialViews[2][1];
            if (![saturationIndicator.backgroundColor isEqual:self.colorLabel.textColor]) {
                for (NSArray *views in _tutorialViews) {
                    if (views.count > 1) {
                        for (UIView *view in views) {
                            view.backgroundColor = self.colorLabel.textColor;
                        }
                    }
                }
            }
            saturationIndicator.center = CGPointMake(CIRCLE_INSET + 10 + self.colorController.color.saturation * (self.pixelView.frame.size.height - 20), self.view.center.y);
            
            brightnessIndicator.center = CGPointMake(self.view.center.x, (self.view.frame.size.height + self.pixelView.frame.size.height) / 2 - 10 - self.colorController.color.brightness * (self.pixelView.frame.size.height - 20));
            UIColor *newColor = [self tutorialTextColorForPixelMode:self.colorController.pixelMode level:_tutorialLevel];
            BOOL changed = NO;
            switch (_tutorialLevel) {
                case 0:
                    changed = fabs(_tutorialLabel.textColor.hue - newColor.hue) > DBL_EPSILON;
                    break;
                    
                case 1:
                    changed = fabs(_tutorialLabel.textColor.saturation - newColor.saturation) > DBL_EPSILON;
                    break;
                    
                case 2:
                    changed = fabs(_tutorialLabel.textColor.brightness - newColor.brightness) > DBL_EPSILON;
                    break;
                    
                default:
                    break;
            }
            if (changed && _tutorialLevel >= 0) {
                _shouldContinueTutorial = YES;
            }
            _tutorialLabel.textColor = newColor;
            break;
        }
    }
}

- (NSString *)tutorialTextForPixelMode:(PixelMode)mode {
    ColorLabelMode labelMode;
    switch (mode) {
        case PixelModeHSB:
            labelMode = ColorLabelModeHSBTutorial;
            break;
    }
    return [[[self.colorTextController textForColor:self.colorController.color mode:labelMode] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]][_tutorialLevel] uppercaseString];
}

- (UIColor *)tutorialTextColorForPixelMode:(PixelMode)mode level:(NSInteger)level {
    switch (mode) {
        case PixelModeHSB: {
            switch (level) {
                case 0: return [UIColor colorWithHue:self.colorController.color.hue saturation:1.0 brightness:1.0 alpha:1.0]; break;
                case 1: return [UIColor colorWithHue:self.colorController.color.hue saturation:self.colorController.color.saturation brightness:1.0 alpha:1.0]; break;
                case 2: return [UIColor colorWithHue:0.0 saturation:0.0 brightness:self.colorController.color.brightness alpha:1.0]; break;
                default: return nil;
            }
        }
    }
}

- (BOOL)shouldShowTutorial {
    switch (self.colorController.pixelMode) {
        case PixelModeHSB:
            return ![[NSUserDefaults standardUserDefaults][kHSBPaletteTutorialKey] boolValue];
    }
}

- (void)setShouldShowTutorial:(BOOL)shouldShowTutorial forMode:(PixelMode)mode {
    switch (mode) {
        case PixelModeHSB:
            [NSUserDefaults standardUserDefaults][kHSBPaletteTutorialKey] = @(!shouldShowTutorial);
            break;
    }
}

- (void)dismissDemo {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

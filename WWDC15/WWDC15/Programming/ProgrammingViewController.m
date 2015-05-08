//
//  ProgrammingViewController.m
//  WWDC15App
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "ProgrammingViewController.h"
#import "WWDC15-swift.h"
#import "MZFormSheetPresentationController.h"
#import "DemoDescriptionViewController.h"
#import "PixelDemoViewController.h"
#import "SmileDemoViewController.h"
#import "QRDemoViewController.h"

#define ICON_SIZE 100
#define ICON_DISTANCE 10

@interface ProgrammingViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *appNames; // They 'magically' coincide with image names :D
@property (strong, nonatomic) NSArray *appDescriptions;

@property (strong, nonatomic) UIScrollView *introScrollView;
@property (strong, nonatomic) UIImageView *continueArrow;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *connectingLabels; // Size of 4, contains the connecting text
@property (strong, nonatomic) NSArray *textImageViews;

@end

@implementation ProgrammingViewController {
    BOOL _didShowIntro;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) { // Hm, swift influenced me to use inits
        self.appNames = @[@"·pixel·", @"smile", @"– Counting +", @"RegEspresso", @"WeSnap", @"QuickResponse"];
        self.appDescriptions = @[
                                 @"pixel is a delightfully simple color finder. \nThis app took one year to develop and has taught me how simplicity is challenging.",
                                 @"smile is an app to encourage joyfulness. It takes pictures when someone smiles toward the camera. Built for internal use in school.",
                                 @"Counting is a simple counter app to count score, people, and more. It has a timestamped CSV exporter. Try out the watch app on your watch! ⌚️", // haha that watch emoji really screwed up line spacing
                                 @"RegEspresso is a very simple RegEx app that highlights matches on the fly. Great for developers to do testing on.",
                                 @"WeSnap is an app to split photos with friends. I made the watch app for WeSnap using WatchKit.",
                                 @"QuickResponse is a simple QR and bar code scanner. Its clean, responsive, and has minimal loading time."];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"Programming";
        self.titleLabel.alpha = 0.0;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45];
        [self.titleLabel sizeToFit];
        
        NSArray *connectingLabelStrings = @[@"is an", @"in\nwhich\nyou create", @"through", @"while minimizing"];
        NSMutableArray *labels = [NSMutableArray new];
        [connectingLabelStrings enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
            UILabel *label = [[UILabel alloc] init];
            label.text = string;
            if (idx == 1) {
                label.numberOfLines = 3;
            }
            label.font = [UIFont fontWithName:@"Avenir-Light" size:20];
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            [labels addObject:label];
        }];
        NSArray *imageNames = @[@"artform", @"function", @"structure", @"complexity"];
        NSArray *tintColors = @[[UIColor colorWithRed:0.66 green:0.09 blue:0.25 alpha:1],
                                [UIColor colorWithRed:0.16 green:0.3 blue:0.31 alpha:1],
                                [UIColor colorWithWhite:0.3 alpha:1],
                                [UIColor colorWithRed:0.47 green:0.08 blue:0.02 alpha:1]];
        NSMutableArray *imageViews = [NSMutableArray new];
        [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            image.tintColor = tintColors[idx];
            [imageViews addObject:image];
        }];
        
        self.connectingLabels = labels;
        self.textImageViews = imageViews;
        self.continueArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        self.continueArrow.alpha = 0.0;
        self.continueArrow.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutViews];
    if (!_didShowIntro) {
        [self makeIntro];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_didShowIntro) {
        [self beginIntro];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)adjustedCenterY:(NSUInteger)screen {
    return self.view.center.y + self.view.frame.size.height * screen;
}

- (void)layoutViews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Apps";
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.view.center.x, (self.view.center.y - 150) / 2);
    [self.view addSubview:titleLabel];
    
    NSMutableArray *mutableIconArray = [NSMutableArray new];
    [self.appNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 100, 100);
        button.tag = idx;
        [button addTarget:self action:@selector(tappedAppIcon:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [mutableIconArray addObject:button];
    }];
    [mutableIconArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = self.view.center.x + (idx % 2 ? (ICON_SIZE + ICON_DISTANCE) / 2 : -(ICON_SIZE + ICON_DISTANCE) / 2);
        CGFloat y = self.view.center.y + ((int)idx / 2 == 1 ? 0 : (int)idx / 2 == 0 ? -ICON_SIZE - ICON_DISTANCE : ICON_SIZE + ICON_DISTANCE);
        obj.center = CGPointMake(x, y);
    }];
}

- (void)makeIntro {
    [self.view addSubview:self.introScrollView];
    self.introScrollView.delegate = self;
    
    self.titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 15);
    [self.introScrollView addSubview:self.titleLabel];
    
    self.continueArrow.center = CGPointMake(self.view.frame.size.width - 15, self.view.frame.size.height - 75);
    [self.introScrollView addSubview:self.continueArrow];
    
    NSArray *connectingLabelOffsets = @[@0, @35, @0, @25];
    [self.connectingLabels enumerateObjectsUsingBlock:^(UILabel *connectingLabel, NSUInteger idx, BOOL *stop) {
        [connectingLabel setCenter:CGPointMake(self.view.center.x, [self adjustedCenterY:idx + 1] + [connectingLabelOffsets[idx] floatValue])];
        [self.introScrollView addSubview:connectingLabel];
    }];
    
    NSArray *textImageViews = @[@50, @110, @60, @105];
    [self.textImageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        CGFloat width = self.view.frame.size.width - 40;
        imageView.frame = CGRectMake(0, 0, width, width / imageView.image.size.width * imageView.image.size.height);
        [self.introScrollView addSubview:imageView];
        [imageView setCenter:CGPointMake(self.view.center.x, [self adjustedCenterY:idx + 1] + [textImageViews[idx] floatValue])];
    }];
}

- (void)beginIntro {
    [UIView animateWithDuration:1.0 animations:^{
        self.titleLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.introScrollView.scrollEnabled = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.continueArrow.alpha = 1.0;
        }];
    }];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset >= 0) {
        NSUInteger screen = offset / self.view.frame.size.height;
        CGFloat progress = (offset - screen * self.view.frame.size.height) / self.view.frame.size.height;
        [self animateScreensWithOffset:offset screen:screen progress:progress];
    }
    self.continueArrow.center = CGPointMake(self.continueArrow.center.x, self.view.frame.size.height - 75 + offset);
}

- (UIScrollView *)introScrollView {
    if (!_introScrollView) {
        _introScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _introScrollView.pagingEnabled = YES;
        _introScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 6);
        _introScrollView.backgroundColor = [UIColor whiteColor];
        _introScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
        _introScrollView.scrollEnabled = NO;
        _introScrollView.showsVerticalScrollIndicator = NO;
    }
    return _introScrollView;
}

#define FIRST_VIEW_OFFSET -95
#define THIRD_VIEW_OFFSET -95

- (void)animateScreensWithOffset:(CGFloat)offset screen:(NSUInteger)screen progress:(CGFloat)progress {
    // Switch statements have too much indent, use this instead lel
    if (screen == 0) {
        self.titleLabel.center = CGPointMake(self.view.center.x, MAX(self.view.center.y + offset - 15 - 25 * (screen + progress), self.view.center.y - 15));
    } else {
        self.titleLabel.center = CGPointMake(self.view.center.x, MIN(self.view.center.y + offset - 40 + FIRST_VIEW_OFFSET * (screen + progress - 1), self.view.center.y + self.view.frame.size.height * 2 - 40 + FIRST_VIEW_OFFSET));
        [self.connectingLabels[0] setCenter:CGPointMake(self.view.center.x, MIN(self.view.center.y + offset + FIRST_VIEW_OFFSET * (screen + progress - 1), self.view.center.y + self.view.frame.size.height * 2 + FIRST_VIEW_OFFSET))];
        [self.textImageViews[0] setCenter:CGPointMake(self.view.center.x, MIN(self.view.center.y + offset + 50 + FIRST_VIEW_OFFSET * (screen + progress - 1), self.view.center.y + self.view.frame.size.height * 2 + 50 + FIRST_VIEW_OFFSET))];
    }
    if (screen == 2) {
        [self.textImageViews[1] setCenter:CGPointMake(self.view.center.x, self.view.center.y + offset + 110 - 160 * progress)];
    }
    if (screen >= 3) {
        [self.textImageViews[1] setCenter:CGPointMake(self.view.center.x, MIN(self.view.center.y + offset - 50 + THIRD_VIEW_OFFSET * progress, self.view.center.y + self.view.frame.size.height * 4 - 50 + THIRD_VIEW_OFFSET))];
        [self.textImageViews[2] setCenter:CGPointMake(self.view.center.x, MIN(self.view.center.y + offset + 60 + THIRD_VIEW_OFFSET * progress, self.view.center.y + self.view.frame.size.height * 4 + 60 + THIRD_VIEW_OFFSET))];
        [self.connectingLabels[2] setCenter:CGPointMake(self.view.center.x, MIN(self.view.center.y + offset + THIRD_VIEW_OFFSET * progress, self.view.center.y + self.view.frame.size.height * 4 + THIRD_VIEW_OFFSET))];
    }
    
    self.introScrollView.alpha = screen >= 4 ? 1 - (progress + (screen - 4) * 1.0) : 1.0;
    if (screen == 5) {
        [self.introScrollView removeFromSuperview];
        self.connectingLabels = nil;
        self.introScrollView = nil;
        self.titleLabel = nil;
        self.textImageViews = nil;
    }
}

#pragma mark - Button Actions

- (void)tappedAppIcon:(UIButton *)sender {
    [[SoundManager sharedInstance] soundNotes:sender.tag];
    DemoDescriptionViewController *viewController = [[DemoDescriptionViewController alloc] initWithName:self.appNames[sender.tag]
                                                                                            description:self.appDescriptions[sender.tag]
                                                                                                   demo:[self viewControllerForDemoAtIndex:sender.tag]
                                                                                                    URL:[self urlForAppAtIndex:sender.tag]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    MZFormSheetPresentationController *presentationController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    presentationController.contentViewSize = CGSizeMake(300, 300);
    presentationController.shouldCenterVertically = YES;
    presentationController.shouldDismissOnBackgroundViewTap = YES;
    presentationController.shouldApplyBackgroundBlurEffect = YES;
    presentationController.blurEffectStyle = UIBlurEffectStyleDark;
    [self presentViewController:presentationController animated:YES completion:nil];
}

- (NSURL *)urlForAppAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [NSURL URLWithString:@"http://itunes.apple.com/app/id936267373"];
        case 2:
            return [NSURL URLWithString:@"http://itunes.apple.com/app/id984747827"];
        case 3:
            return [NSURL URLWithString:@"http://itunes.apple.com/app/id903640131"];
        case 4:
            return [NSURL URLWithString:@"http://itunes.apple.com/app/id932467051"];
        default:
            return nil;
    }
}

- (UIViewController *)viewControllerForDemoAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [[PixelDemoViewController alloc] init];
        case 1:
            return [[SmileDemoViewController alloc] init];
        case 5:
            return [[QRDemoViewController alloc] init];
        default:
            return nil;
    }
}

@end

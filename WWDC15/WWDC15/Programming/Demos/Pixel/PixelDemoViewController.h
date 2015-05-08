//
//  PixelViewController.h
//  Pixel
//
//  Created by Yichen Cao on 1/2/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>

// Views
#import "PixelView.h"

// Controllers
#import "ColorController.h"
#import "ColorTextController.h"
#import "ThemeController.h"

@interface PixelDemoViewController : UIViewController <ColorControllerDataSource, ColorControllerDelegate, ColorTextControllerDelegate>

// Views
@property (strong, nonatomic) PixelView *pixelView;

// Controllers
@property (strong, nonatomic) ColorTextController *colorTextController;
@property (strong, nonatomic) ColorController *colorController;

- (void)prepareForTutorialView;
- (void)continueTutorial;
- (void)didTap;

@end

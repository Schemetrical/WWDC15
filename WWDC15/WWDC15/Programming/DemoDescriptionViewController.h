//
//  DemoDescriptionViewController.h
//  WWDC15
//
//  Created by Yichen Cao on 4/19/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoDescriptionViewController : UIViewController

@property (strong, nonatomic) UIViewController *demoViewController;
@property (strong, nonatomic) NSURL *appStoreURL;

- (instancetype)initWithName:(NSString *)name description:(NSString *)description demo:(UIViewController *)demoVC URL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

@end

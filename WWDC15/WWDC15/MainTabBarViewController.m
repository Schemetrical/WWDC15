//
//  MainTabBarViewController.m
//  WWDC15App
//
//  Created by Yichen Cao on 4/15/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "WWDC15-swift.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController {
    BOOL _welcomeUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.hidden = YES;
//    _welcomeUser = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_welcomeUser) {
        _welcomeUser = YES; // You are now welcomed ;-)
        WelcomeViewController *mainLoginVC = [[WelcomeViewController alloc] init];
        mainLoginVC.view.backgroundColor = [UIColor whiteColor];
        mainLoginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.viewControllers[0] presentViewController:mainLoginVC animated:NO completion:^{
            self.view.hidden = NO;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

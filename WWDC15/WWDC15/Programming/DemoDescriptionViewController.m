//
//  DemoDescriptionViewController.m
//  WWDC15
//
//  Created by Yichen Cao on 4/19/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "DemoDescriptionViewController.h"

@interface DemoDescriptionViewController ()

@end

@implementation DemoDescriptionViewController {
    CGFloat _bottomInsets;
    NSString *_description;
}

- (instancetype)initWithName:(NSString *)name description:(NSString *)description demo:(UIViewController *)demoVC URL:(NSURL *)url {
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0, 300, 300);
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = name;
        self.demoViewController = demoVC;
        self.appStoreURL = url;
        _description = description;
        
        _bottomInsets = 10.0;
        if (self.appStoreURL) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"View on App Store" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
            [button sizeToFit];
            button.center = CGPointMake(self.view.center.x, self.view.frame.size.height - _bottomInsets - button.frame.size.height / 2);
            [button addTarget:self action:@selector(openAppStoreURL) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            _bottomInsets += button.frame.size.height - 10;
        }
        if (self.demoViewController) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"Try Demo" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
            [button sizeToFit];
            button.center = CGPointMake(self.view.center.x, self.view.frame.size.height - _bottomInsets - button.frame.size.height / 2);
            [button addTarget:self action:@selector(presentDemo) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            _bottomInsets += button.frame.size.height - 10;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + self.navigationController.toolbar.frame.size.height, self.view.frame.size.width - 40, self.view.frame.size.height - _bottomInsets - 40 - self.navigationController.toolbar.frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    label.numberOfLines = 0;
    label.text = _description;
    [self.view addSubview:label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentDemo {
    [self presentViewController:self.demoViewController animated:YES completion:nil];
}

- (void)openAppStoreURL {
    [[UIApplication sharedApplication] openURL:self.appStoreURL];
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

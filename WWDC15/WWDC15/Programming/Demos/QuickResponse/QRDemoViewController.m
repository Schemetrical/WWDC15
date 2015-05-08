//
//  ViewController.m
//  QuickResponse
//
//  Created by ycao on 8/9/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "QRDemoViewController.h"

@interface QRDemoViewController ()

@property (nonatomic, strong) SRQuickResponseView *qrView;

@end

@implementation QRDemoViewController

typedef enum stringTypes {
    URL,
    String,
    Undefined,
} StringType;
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.layer.borderColor = [[UIColor colorWithHue:0.55 saturation:1 brightness:0.33 alpha:1] CGColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.qrView = [[SRQuickResponseView alloc] initWithFrame:self.view.frame];
    self.qrView.highlightsMatch = YES;
    self.qrView.delegate = self;
    [self.view addSubview:self.qrView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"back" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
    button.frame = CGRectMake(10, 10, 70, 35);
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(dismissDemo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.qrView.reading = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedResponse:(NSString *)response type:(NSString *)type; {
    self.qrView.reading = NO;
    NSLog(@"%@",response);
    NSString *continueButton;
    switch ([self typeOfString:response]) {
        case URL:
            continueButton = @"Open Link";
            break;
            
        case String:
            continueButton = @"Copy";
            break;
            
        case Undefined:
            continueButton = nil;
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scanned:"
                                                    message:response ? response : @"Empty QR Code"
                                                   delegate:self
                                          cancelButtonTitle:@"Scan Again"
                                          otherButtonTitles:continueButton, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *stringOfButtonChosen = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *message = alertView.message;
    if ([stringOfButtonChosen isEqualToString:@"Scan Again"]) {
        self.qrView.reading = YES;
    } else if ([stringOfButtonChosen isEqualToString:@"Open Link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message]];
    } else if ([stringOfButtonChosen isEqualToString:@"Copy"]) {
        [[UIPasteboard generalPasteboard] setString:message];
        [self animateBorders];
        self.qrView.reading = YES;
    }
}

- (void)animateBorders {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.fromValue = @0.0;
    animation.toValue = @10.0;
    animation.duration = 0.5;
    [self.view.layer addAnimation:animation forKey:@"borderWidth"];
    self.view.layer.borderWidth = 10.0;
    [self performSelector:@selector(animateBordersBack)
               withObject:nil
               afterDelay:0.6];
}

- (void)animateBordersBack {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    animation.fromValue = @10.0;
    animation.toValue = @0.0;
    animation.duration = 0.5;
    [self.view.layer addAnimation:animation forKey:@"borderWidth"];
    self.view.layer.borderWidth = 0.0;
}

- (StringType)typeOfString:(NSString *)string {
    if (!string) {
        return Undefined;
    }
    
    NSRange range = NSMakeRange(0, string.length);
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    if ([linkDetector numberOfMatchesInString:string
                                        options:0
                                        range:range] != 1) {
        return String;
    }
    
    NSTextCheckingResult *checkingResult = [linkDetector firstMatchInString:string
                                                                    options:0
                                                                      range:range];
    
    return (checkingResult.resultType == NSTextCheckingTypeLink && NSEqualRanges(checkingResult.range, range)) ? URL : String;
}

- (void)dismissDemo {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

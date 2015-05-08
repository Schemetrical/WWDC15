//
//  ViewController.m
//  smile
//
//  Created by Yichen Cao on 3/27/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "SmileDemoViewController.h"
#import "SmileRecogniserView.h"
//#import "TMAPIClient.h" No upload to tumblr for you :p
#import "PHLibraryManager.h"

@interface SmileDemoViewController () <SmileRecogniserViewDelegate>

@property (strong, nonatomic) SmileRecogniserView *videoView;
@property (strong, nonatomic) CIDetector *detector;

@end

@implementation SmileDemoViewController {
    BOOL _error;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];
    self.videoView = [[SmileRecogniserView alloc] initWithFrame:self.view.frame error:^{
        _error = YES;
    }];
    self.videoView.delegate = self;
    [self.view addSubview:self.videoView];
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                       context:nil
                                       options:@{CIDetectorAccuracy : CIDetectorAccuracyLow}];
    
    /*[[TMAPIClient sharedInstance] authenticate:@"smile" callback:^(NSError *error) {
        // You are now authenticated (if !error)
        if (error) {
            NSLog(@"%@", error);
        } else {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"Select Image To Share" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(presentPicker) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [button sizeToFit];
            button.center = self.view.center;
        }
     }];*/
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"back" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
    button.frame = CGRectMake(10, 10, 70, 35);
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(dismissDemo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to Access Camera" message:@"Please check your camera settings" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)discoveredFace:(UIImage *)image {
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [self.detector featuresInImage:ciImage options:@{CIDetectorSmile : @(YES)}];
    BOOL smile = NO;
    for (CIFaceFeature *feature in features) {
        if (feature.hasSmile)  {
            smile = YES;
            break;
        }
    }
    if (smile) {
        NSLog(@"smile");
        [PHLibraryManager saveImage:image toAlbum:@"Smiles" errorHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* disable

- (void)retrieveInfo {
    [[TMAPIClient sharedInstance] blogInfo:@"smile-cam.tumblr.com" callback:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            
        } else {
            NSLog(@"success, %@", response);
        }
    }];
}

- (void)submitPhoto:(NSString *)path {
    [[TMAPIClient sharedInstance] photo:@"smile-cam.tumblr.com" filePathArray:@[path] contentTypeArray:nil fileNameArray:@[@":-)"] parameters:nil callback:^(id response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            
        } else {
            NSLog(@"success, %@", response);
        }
    }];
}

 */

- (void)dismissDemo {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

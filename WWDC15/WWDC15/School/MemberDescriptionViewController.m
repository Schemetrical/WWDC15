//
//  MemberDescriptionViewController.m
//  WWDC15
//
//  Created by Yichen Cao on 4/23/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "MemberDescriptionViewController.h"

@interface MemberDescriptionViewController ()

@end

@implementation MemberDescriptionViewController

- (instancetype)initWithName:(NSString *)name description:(NSString *)description {
    if (self = [super init]) {
        self.view.frame = CGRectMake(0, 0, 300, 300);
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = name;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:scrollView];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.hyphenationFactor = 1.0;
        paragraphStyle.paragraphSpacingBefore = 16;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 0)];
        label.attributedText = [[NSAttributedString alloc] initWithString:description attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        label.font = [UIFont fontWithName:@"Avenir" size:16];
        label.numberOfLines = 0;
        [label sizeToFit];
        [scrollView addSubview:label];
        
        scrollView.contentSize = label.frame.size;
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top + 10, 0, 10, 0);
        scrollView.contentOffset = CGPointMake(0, -10);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

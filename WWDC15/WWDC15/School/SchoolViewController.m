//
//  SchoolViewController.m
//  WWDC15App
//
//  Created by Yichen Cao on 4/14/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "SchoolViewController.h"
#import "WWDC15-swift.h"
#import "MemberDescriptionViewController.h"
#import "MZFormSheetPresentationController.h"

#define RADIUS 105 // radius = width + spacing

@interface SchoolViewController ()

@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSArray *descriptions;
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *ageLabels;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation SchoolViewController {
    BOOL _animationDidFinish;
    BOOL _welcomeDidComplete;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(welcomeDidComplete) name:@"welcomeDidComplete" object:nil];
    
    self.names = @[@"Connor Chen", @"Leo Li", @"William Xu", @"Yichen Cao", @"Claire Ye", @"Jonathan Chan"];
    
    self.descriptions = @[
                          @"I’m 12 and attending 6th grade in Shanghai American School Pudong Campus. \nMy interests are programming, unity, and javascript. I got introduced to programming when I was playing video games and I thought I’d give it a shot and I did. I made a first person shooter game in unity watching youtube videos. \nI wanted to try to apply for WWDC but I am too young.",
                          @"I’m 13, an Italian born Chinese that’s influenced by my brother’s technical skills, my mother’s creative talents, and my father’s strong analytical abilities. \nI had always been ahead in math class, so while seeking for new challenges, I got interested in programming. I started programming in 6th grade, and now I’m active member of Programming Club. \nI love competition, and I see technology as an immeasurable passion and a way of reaching self actualization.",
                          @"I'm 14 and attending 9th grade in Shanghai American School Pudong Campus. \nEngineering, physics and chemistry are my highly preferred topics because it's interesting to see the amazing properties of existing materials pushed to it's limites.",
                          @"I'm 15, Chinese Canadian, sophomore and CTO of Programming Club. \nI believe that clubs like this can take what we learn in school and apply them to useful situations. Throughout this app, you'll see examples of math being used everywhere. \nI hope that I can affect some of our club members' programming career by bringing them to WWDC. You may see some of their applications roll in 😁!",
                          @"I’m 16, and I am an American born Chinese in Shanghai. \nOutside of my academics, I participate in Quiz Bowl, Roots and Shoots, and Programming Club. \nMy dream for the future is to make neuroprosthetics for the handicapped.",
                          @"I’m 17, and I help Yichen run Programming Club. \nAbove everything I learn and teach about programming, I firmly believe in applying programming skills and knowledge to improve my surroundings. I make things that can help people around me. \nI automated the sign-up process for our National Honor Society’s Relay For Life, and I am currently making a wireless buzzer app for my Quiz Bowl team and a curriculum manager for an educational community service team. \nProgramming is very powerful, and I believe in not just being a user, but also a creator."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_welcomeDidComplete && !_animationDidFinish) {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            [UIView animateWithDuration:1.0 delay:idx * 0.1 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
            [UIView animateWithDuration:1.0 delay:0.5 + idx * 0.1 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                ((UILabel *)self.ageLabels[idx]).transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:nil];
        }];
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.titleLabel.alpha = 1.0;
        } completion:nil];
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.subtitleLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            if ([self.subtitleLabel.layer.presentationLayer opacity] == 1.0) {
                _animationDidFinish = finished; // make sure the animation is really finished
            }
        }];
    }
}

- (void)welcomeDidComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        _welcomeDidComplete = YES;
        [self.tabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!_animationDidFinish) {
        self.titleLabel.alpha = 0.0;
        self.subtitleLabel.alpha = 0.0;
        for (UIView *subview in self.view.subviews) {
            [subview.layer removeAllAnimations];
        }
        for (UIView *view in self.buttons) {
            view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        }
        for (UIView *view in self.ageLabels) {
            view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        }
    }
}

- (void)layoutViews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"School";
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45];
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.view.center.x, (self.view.center.y - 150) / 2);
    self.titleLabel.alpha = 0.0;
    [self.view addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"In the Eyes of Programming Club.";
    self.subtitleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    [self.subtitleLabel sizeToFit];
    self.subtitleLabel.center = CGPointMake(self.view.center.x, (self.view.frame.size.height - (self.view.center.y + 125) - self.tabBarController.tabBar.frame.size.height) / 2 + (self.view.center.y + 125));
    self.subtitleLabel.alpha = 0.0;
    [self.view addSubview:self.subtitleLabel];
    
    NSMutableArray *mutableButtons = [NSMutableArray new];
    NSMutableArray *mutableAgeLabels = [NSMutableArray new];
    NSArray *imageNames = @[@"connor", @"leo", @"william", @"yichen", @"claire", @"jonathan"];
    [imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button sizeToFit];
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
        button.clipsToBounds = YES;
        button.tag = idx;
        [button addTarget:self action:@selector(selectedPerson:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        CGFloat angle = M_PI / 3;
        button.center = CGPointMake(self.view.center.x + RADIUS * cos(idx * angle + M_PI / 3 * 2), self.view.center.y - 15 + RADIUS * sin(idx * angle + M_PI / 3 * 2)); // rcosθ, rsinθ, but oh no its flipped lol
        button.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [mutableButtons addObject:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        label.text = [NSString stringWithFormat:@"%lu", (unsigned long)idx + 12];
        label.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = label.frame.size.width / 2;
        label.clipsToBounds = YES;
        label.center = CGPointMake(self.view.center.x + RADIUS / 2.5 * cos(idx * angle + M_PI / 3 * 2), self.view.center.y - 15 + RADIUS / 2.5 * sin(idx * angle + M_PI / 3 * 2));
        label.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [mutableAgeLabels addObject:label];
        [self.view addSubview:label];
    }];
    self.buttons = mutableButtons;
    self.ageLabels = mutableAgeLabels;
}

- (void)selectedPerson:(UIButton *)sender {
    [[SoundManager sharedInstance] soundNotes:sender.tag];
    MemberDescriptionViewController *viewController = [[MemberDescriptionViewController alloc] initWithName:self.names[sender.tag]description:self.descriptions[sender.tag]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    MZFormSheetPresentationController *presentationController = [[MZFormSheetPresentationController alloc] initWithContentViewController:navigationController];
    presentationController.contentViewSize = CGSizeMake(300, 300);
    presentationController.shouldCenterVertically = YES;
    presentationController.shouldDismissOnBackgroundViewTap = YES;
    presentationController.shouldApplyBackgroundBlurEffect = YES;
    presentationController.blurEffectStyle = UIBlurEffectStyleDark;
    [self presentViewController:presentationController animated:YES completion:nil];
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

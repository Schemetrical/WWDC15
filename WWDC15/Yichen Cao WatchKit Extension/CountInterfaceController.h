//
//  CountInterfaceController.h
//  Counting
//
//  Created by Yichen Cao on 11/19/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import "Countee.h"

@protocol CountInterfaceControllerDelegate <NSObject>

- (IBAction)deleteItemAtIndex:(NSUInteger)index sender:(id)sender;

@end

@interface CountInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *countLabel;

@property (strong, nonatomic) Countee *countObject;

@property (weak, nonatomic) IBOutlet WKInterfaceButton *plusButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *minusButton;

@property (weak, nonatomic) id <CountInterfaceControllerDelegate> delegate;

- (IBAction)countUp;
- (IBAction)countDown;

- (IBAction)editName;
- (IBAction)deleteCount;

@end

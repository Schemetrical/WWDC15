//
//  CountTableRowController.h
//  Counting
//
//  Created by Yichen Cao on 11/19/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKInterfaceLabel;

@interface CountTableRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *countLabel;

@end

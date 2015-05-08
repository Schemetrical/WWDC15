//
//  InterfaceController.h
//  Counting WatchKit Extension
//
//  Created by Yichen Cao on 11/19/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

- (IBAction)addItem;
- (IBAction)deleteAllItems;
- (IBAction)sortByName;
- (IBAction)sortByCount;

@end

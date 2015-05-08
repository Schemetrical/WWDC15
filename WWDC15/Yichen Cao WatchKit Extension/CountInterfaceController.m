//
//  CountInterfaceController.m
//  Counting
//
//  Created by Yichen Cao on 11/19/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import "CountInterfaceController.h"

#define COUNT_LIMIT 1000000000

@implementation CountInterfaceController {
    NSInteger rowIndex;
    NSUserDefaults *sharedDefaults;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.countObject = context[0];
    rowIndex = [context[1] integerValue];
    sharedDefaults = context[2];
    self.delegate = context[3];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)setCountObject:(Countee *)countObject {
    _countObject = countObject;
    [self.titleLabel setText:self.countObject.title];
    [self.countLabel setText:[NSString stringWithFormat:@"%li", self.countObject.count]];
}

- (IBAction)countUp {
    self.countObject.count++;
    if (self.countObject.count >= COUNT_LIMIT) {
        self.countObject.count = COUNT_LIMIT;
        [self.plusButton setEnabled:NO];
    }
    if (self.countObject.count > -COUNT_LIMIT) {
        [self.plusButton setEnabled:YES];
    }
    [self.countLabel setText:[NSString stringWithFormat:@"%li", self.countObject.count]];
    
    [self saveItems];
}

- (IBAction)countDown {
    self.countObject.count -= 1;
    if (self.countObject.count <= -COUNT_LIMIT) {
        self.countObject.count = -COUNT_LIMIT;
        [self.plusButton setEnabled:NO];
    }
    if (self.countObject.count < COUNT_LIMIT) {
        [self.plusButton setEnabled:YES];
    }
    [self.countLabel setText:[NSString stringWithFormat:@"%li", self.countObject.count]];
    
    [self saveItems];
}

- (IBAction)editName {
    [self presentTextInputControllerWithSuggestions:@[@"Counter", @"Edited Counter"]
                                   allowedInputMode:WKTextInputModeAllowEmoji
                                         completion:^(NSArray *results) {
                                             self.countObject.title = results.firstObject;
                                             [self.titleLabel setText:self.countObject.title];
                                             [self saveItems];
                                         }];
}

- (IBAction)deleteCount {
    [self.delegate deleteItemAtIndex:rowIndex sender:self];
}

- (void)saveItems {
    NSData *data = [sharedDefaults objectForKey:@"Counts"];
    NSMutableArray *countObjects = data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : [[NSMutableArray alloc] init];
    countObjects[rowIndex] = self.countObject;
    [sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:countObjects] forKey:@"Counts"];
}

@end

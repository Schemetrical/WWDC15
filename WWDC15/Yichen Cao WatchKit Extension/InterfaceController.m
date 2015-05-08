//
//  InterfaceController.m
//  Counting WatchKit Extension
//
//  Created by Yichen Cao on 11/19/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import "InterfaceController.h"
#import "CountTableRowController.h"
#import "CountInterfaceController.h"

@interface InterfaceController () <CountInterfaceControllerDelegate>

@property (weak, nonatomic) IBOutlet WKInterfaceTable *countingInterfaceTable;
@property (strong, nonatomic) NSMutableArray *countObjects;
@property (strong, nonatomic) NSUserDefaults *sharedDefaults;

@end

@implementation InterfaceController {
    BOOL selected;
    NSUInteger selectedIndex;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.sharedDefaults = [NSUserDefaults standardUserDefaults];
    [self readItems];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    if (selected) {
        [[[self.countingInterfaceTable rowControllerAtIndex:selectedIndex] countLabel] setText:[NSString stringWithFormat:@"%li", (unsigned long)[self.countObjects[selectedIndex] count]]];
        selected = NO;
    }
    [self readItems];
    [self loadTableData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)loadTableData {
    [self.countingInterfaceTable setNumberOfRows:self.countObjects.count withRowType:@"Controller"];
    [self.countObjects enumerateObjectsUsingBlock:^(NSString *rowTitle, NSUInteger index, BOOL *stop) {
        CountTableRowController *row = [self.countingInterfaceTable rowControllerAtIndex:index];
        
        Countee *countObject = self.countObjects[index];
        [row.titleLabel setText:countObject.title];
        [row.countLabel setText:[NSString stringWithFormat:@"%li", countObject.count]];
    }];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    selectedIndex = rowIndex;
    [self pushControllerWithName:@"count" context:@[[self.countObjects objectAtIndex:rowIndex], @(rowIndex), self.sharedDefaults, self]];
}

#pragma mark - Saving and Reading data

- (void)saveItems {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.countObjects];
    [self.sharedDefaults setObject:data forKey:@"Counts"];
}

- (void)readItems {
    NSData *data = [self.sharedDefaults objectForKey:@"Counts"];
    BOOL addDemoData = NO;
    if (data) {
        self.countObjects = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!self.countObjects.count) {
            addDemoData = YES;
        }
    } else {
        addDemoData = YES;
    }
    if (addDemoData) {
        // Hack in some data
        NSMutableArray *sampleData = [NSMutableArray new];
        NSArray *names = @[@"Besticles", @"Big or Small, Save 'Em All", @"Cancer Crush", @"Cancer Never Sleeps", @"Finding Chemo", @"Jimin's Problems", @"Lords of Radiation", @"One Love 3.0", @"Ova Nova", @"Peach Please", @"Planet of Apes", @"Prancers Against Cancer", @"Rekt 'Em", @"Swole Mates", @"Team Jing", @"The Grace in Our Stars", @"The TUMORnaters", @"Tumor Slayerz", @"Too Inspired to Be Tired", @"We De-Liver", @"Wei Chieh's Water Buffaloes", @"XDream"];
        NSArray *points = @[@11, @74, @32, @79, @4, @73, @92, @100, @82, @55, @49, @4, @23, @2, @9, @20, @84, @1, @61, @88, @81, @60];
        [names enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            Countee *countObject = [[Countee alloc] init];
            countObject.title = names[idx];
            countObject.count = [points[idx] longValue];
            [sampleData addObject:countObject];
        }];
        self.countObjects = sampleData;
        [self saveItems];
    }
}

- (IBAction)addItem {
    [self presentTextInputControllerWithSuggestions:@[@"New Counter", [NSString stringWithFormat:@"Counter %lu", (unsigned long)self.countObjects.count + 1]]
                                   allowedInputMode:WKTextInputModeAllowEmoji
                                         completion:^(NSArray *results) {
                                             if (results) {
                                                 Countee *countObject = [[Countee alloc] init];
                                                 countObject.title = results.firstObject;
                                                 [self.countObjects insertObject:countObject atIndex:0];
                                                 [self.countingInterfaceTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0]
                                                                                      withRowType:@"Controller"];
                                                 [[[self.countingInterfaceTable rowControllerAtIndex:0] titleLabel] setText:countObject.title];
                                                 [[[self.countingInterfaceTable rowControllerAtIndex:0] countLabel] setText:[NSString stringWithFormat:@"%li", (unsigned long)[self.countObjects[0] count]]];
                                                 [self saveItems];
                                                 selected = YES;
                                             }
                                         }];
}

- (void)deleteItemAtIndex:(NSUInteger)index sender:(id)sender {
    [sender popController];
    [self.countObjects removeObjectAtIndex:index];
    [self.countingInterfaceTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    [self saveItems];
}

- (IBAction)deleteAllItems {
    [self.countingInterfaceTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.countObjects.count)]];
    self.countObjects = [NSMutableArray new];
    [self saveItems];
}

- (IBAction)sortByName {
    [self sortUsingStyle:0];
}

- (IBAction)sortByCount {
    [self sortUsingStyle:1];
}

- (void)sortUsingStyle:(NSInteger)style {
    switch (style) {
        case 0: {
            self.countObjects = [[self.countObjects sortedArrayUsingComparator:^NSComparisonResult(Countee *obj1, Countee *obj2) {
                return [obj1.title localizedCaseInsensitiveCompare:obj2.title];
            }] mutableCopy];
            break;
        }
        case 1: {
            self.countObjects = [[self.countObjects sortedArrayUsingComparator:^NSComparisonResult(Countee *obj1, Countee *obj2) {
                return obj1.count == obj2.count ? [obj1.title localizedCaseInsensitiveCompare:obj2.title] : obj1.count > obj2.count ? NSOrderedAscending : NSOrderedDescending;
            }] mutableCopy];
            break;
        }
        default:
            break;
    }
    [self saveItems];
    [self loadTableData];
}

@end




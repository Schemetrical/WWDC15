//
//  Countee.h
//  Counting
//
//  Created by Yichen Cao on 10/14/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountEvent.h"

@interface Countee : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (nonatomic) long count;
@property (strong, nonatomic) NSMutableArray /*CountEvents*/ *countEvents;

@end

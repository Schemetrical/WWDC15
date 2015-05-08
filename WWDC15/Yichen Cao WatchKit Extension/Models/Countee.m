//
//  Countee.m
//  Counting
//
//  Created by Yichen Cao on 10/14/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import "Countee.h"

@implementation Countee

- (instancetype)init {
    if (self = [super init]) {
        self.countEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setCount:(long)count {
    _count = count;
//    [self.countEvents addObject:[CountEvent eventWithCount:count]]; not for demo
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"Title"];
        self.count = [aDecoder decodeIntegerForKey:@"Count"];
        self.countEvents = [aDecoder decodeObjectForKey:@"CountEvents"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"Title"];
    [aCoder encodeInteger:self.count forKey:@"Count"];
    [aCoder encodeObject:self.countEvents forKey:@"CountEvents"];
}

@end

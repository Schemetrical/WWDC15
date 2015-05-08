//
//  CountEvent.m
//  Counting
//
//  Created by Yichen Cao on 10/14/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import "CountEvent.h"

@implementation CountEvent

+ (CountEvent *)eventWithCount:(long)count {
    CountEvent *event = [[CountEvent alloc] init];
    event.count = count;
    event.date = [NSDate date];
    return event;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.count = [aDecoder decodeInt32ForKey:@"EventCount"];
        self.date = [aDecoder decodeObjectForKey:@"Date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.count forKey:@"EventCount"];
    [aCoder encodeObject:self.date forKey:@"Date"];
}

@end

//
//  CountEvent.h
//  Counting
//
//  Created by Yichen Cao on 10/14/14.
//  Copyright (c) 2014 Schemetrical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountEvent : NSObject <NSCoding>

@property (nonatomic) long count;
@property (strong, nonatomic) NSDate *date;

+ (CountEvent *)eventWithCount:(long)count;

@end

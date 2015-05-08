//
//  NSUserDefaults+Subscripting.m
//  Pixel
//
//  Created by Yichen Cao on 4/1/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import "NSUserDefaults+Subscripting.h"

@implementation NSUserDefaults (Subscripting)

- (id)objectForKeyedSubscript:(NSString *)defaultName {
    return [self objectForKey:defaultName];
}

- (void)setObject:(id)value forKeyedSubscript:(NSString *)defaultName {
    [self setObject:value forKey:defaultName];
}

@end

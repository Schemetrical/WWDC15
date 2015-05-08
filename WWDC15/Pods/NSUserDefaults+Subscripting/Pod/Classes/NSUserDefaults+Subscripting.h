//
//  NSUserDefaults+Subscripting.h
//  Pixel
//
//  Created by Yichen Cao on 4/1/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Subscripting)

- (id)objectForKeyedSubscript:(NSString *)defaultName;
- (void)setObject:(id)value forKeyedSubscript:(NSString *)defaultName;

@end

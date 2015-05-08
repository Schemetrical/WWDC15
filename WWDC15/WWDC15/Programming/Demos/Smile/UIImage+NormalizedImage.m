//
//  UIImage+NormalizedImage.m
//  smile
//
//  Created by Yichen Cao on 3/30/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "UIImage+NormalizedImage.h"

@implementation UIImage (NormalizedImage)

- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end

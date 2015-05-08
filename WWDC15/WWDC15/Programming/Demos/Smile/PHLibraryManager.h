//
//  PHLibraryManager.h
//  Pixel
//
//  Created by Yichen Cao on 3/30/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHLibraryManager : NSObject

+ (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName errorHandler:(void (^)(NSError *error))errorHandler;

@end

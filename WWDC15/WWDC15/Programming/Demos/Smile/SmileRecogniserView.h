//
//  SmileRecogniserView.h
//  smile
//
//  Created by Yichen Cao on 3/27/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SmileRecogniserViewDelegate <NSObject>

@optional

- (void)discoveredFace:(UIImage *)image;

@end

@interface SmileRecogniserView : UIView <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL reading;

@property (strong, nonatomic) id <SmileRecogniserViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame error:(void (^)())error NS_DESIGNATED_INITIALIZER;

@end

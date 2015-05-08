//
//  SRQuickResponseView.h
//  QuickResponse
//
//  Created by ycao on 8/9/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/*!
 * @protocol SRQuickResponseViewDelegate
 * @abstract
 * Defines an interface for delegates of SRQuickResponseViewDelegate to receive scanned data.
 */
@protocol SRQuickResponseViewDelegate <NSObject>

@optional

/*!
 * @method receivedResponse:
 * @abstract
 * Called whenever an AVCaptureMetadataOutput instance emits a QR object.
 * @param response
 * The content of the scanned barcode.
 * @param type
 * An identifier for the metadata object.
 */
- (void)receivedResponse:(NSString *)response type:(NSString *)type;

@end

/*!
 * @class SRQuickResponseView
 * @abstract
 * SRQuickResponseView is a subclass of UIView that loads the camera when initialized 
 *          and detects QR codes and forwards them to the delegate.
 * @discussion
 * Camera will show error message if it has no permission, so do prompt the user.
 */

@interface SRQuickResponseView : UIView <AVCaptureMetadataOutputObjectsDelegate>

/*!
 * @property reading
 * @abstract
 * BOOL value to start or stop the camera reading QR codes.
 * @discussion
 * If no input, abort. Do check if there's permission to a camera before you load this.
 */
@property (nonatomic) BOOL reading;

/*!
 * @property delegate
 * @abstract
 * The receiver’s delegate or nil if it doesn’t have a delegate.
 * @discussion
 * There's absolutely no point using this if you aren't going to have a delegate.
 */
@property (strong, nonatomic) id <SRQuickResponseViewDelegate> delegate;

/*!
 * @property highlightsMatch
 * @abstract
 * A boolean to toggle match highlights on or off.
 */
@property (nonatomic) BOOL highlightsMatch;

@end

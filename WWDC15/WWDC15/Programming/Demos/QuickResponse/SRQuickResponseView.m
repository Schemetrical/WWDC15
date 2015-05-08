//
//  SRQuickResponseView.m
//  QuickResponse
//
//  Created by ycao on 8/9/14.
//  Copyright (c) 2014 schemetrical. All rights reserved.
//

#import "SRQuickResponseView.h"

@implementation SRQuickResponseView {
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    AVAudioPlayer *audioPlayer;
    NSArray *metadataObjectTypes;
    
    UIView *highlightView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.reading = YES;
        highlightView = [[UIView alloc] init];
        highlightView.layer.borderColor = [UIColor greenColor].CGColor;
        highlightView.layer.borderWidth = 3.0;
        [self addSubview:highlightView];
    }
    return self;
}

// MARK: Capture

- (void)setReading:(BOOL)reading {
    if (_reading == reading) {
        return;
    }
    _reading = reading;
    if (reading) {
        highlightView.frame = CGRectZero;
        NSError *error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Access Camera"
                                                            message:@"Please check your camera settings"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Done"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        if (!input) {
            NSString *errorMessage = [NSString stringWithFormat:@"Camera Unavailable\n%@", [error localizedDescription]];
            NSLog(@"%@", errorMessage);
            UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
            label.textColor = [UIColor whiteColor];
            label.text = errorMessage;
            label.font = [UIFont fontWithName:@"Avenir Light" size:30];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [self addSubview:label];
            return;
        }
        
        if (!captureSession) {
            captureSession = [[AVCaptureSession alloc] init];
            [captureSession addInput:input];
            
            AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [captureSession addOutput:captureMetadataOutput];
            
            [captureMetadataOutput setMetadataObjectsDelegate:self
                                                        queue:dispatch_get_main_queue()];
            metadataObjectTypes = @[AVMetadataObjectTypeAztecCode,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode39Mod43Code,
                                    AVMetadataObjectTypeCode93Code,
                                    AVMetadataObjectTypeDataMatrixCode,
                                    AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeITF14Code,
                                    AVMetadataObjectTypeInterleaved2of5Code,
                                    AVMetadataObjectTypePDF417Code,
                                    AVMetadataObjectTypeQRCode,
                                    AVMetadataObjectTypeUPCECode]/*[captureMetadataOutput availableMetadataObjectTypes]*/;
            captureMetadataOutput.metadataObjectTypes = metadataObjectTypes;
        }
        
        if (!videoPreviewLayer) {
            videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
            [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [videoPreviewLayer setFrame:self.layer.bounds];
            [self.layer addSublayer:videoPreviewLayer];
        }
        
        // Start video capture.
        [captureSession startRunning];
    } else {
        // Stop video capture.
        [captureSession stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count]) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if (self.reading) {
            highlightView.frame = self.highlightsMatch ? [videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObjects[0]].bounds : CGRectZero;
            if ([self.delegate respondsToSelector:@selector(receivedResponse:type:)]) {
                [self.delegate receivedResponse:[metadataObj stringValue] type:[metadataObj type]];
            }
        }
    }
    /* For Fun
    if (self.highlightsMatch) {
        if (!metadataObjects.count) {
            highlightView.frame = CGRectZero;
            return;
        }
        for (AVMetadataObject *metadata in metadataObjects) {
            highlightView.frame = [videoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata].bounds;
        }
    }*/
}

@end

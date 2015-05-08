//
//  SmileRecogniserView.m
//  smile
//
//  Created by Yichen Cao on 3/27/15.
//  Copyright (c) 2015 Schemetrical. All rights reserved.
//

#import "SmileRecogniserView.h"
#import "UIImage+NormalizedImage.h"

@implementation SmileRecogniserView {
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    AVAudioPlayer *audioPlayer;
    NSArray *metadataObjectTypes;
    AVCaptureStillImageOutput *stillImageOutput;
    NSTimer *rateLimiterTimer;
    AVCaptureConnection *videoCaptureConnection;
    BOOL allowOutput;
    
    void (^errorHandler)();
}

- (instancetype)initWithFrame:(CGRect)frame error:(void (^)())error {
    if (self = [super initWithFrame:frame]) {
        errorHandler = error;
        self.reading = YES;
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
        rateLimiterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(allowOutput) userInfo:nil repeats:YES];
        NSError *error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (error) {
            errorHandler();
        }
        
        if (!input) {
            NSString *errorMessage = [NSString stringWithFormat:@"Camera Unavailable\n%@", [error localizedDescription]];
            NSLog(@"%@", errorMessage);
            UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
            label.textColor = [UIColor blackColor];
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
            captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
            
            stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
            [captureSession addOutput:stillImageOutput];
            
            for (AVCaptureConnection *connection in stillImageOutput.connections) {
                for (AVCaptureInputPort *port in [connection inputPorts]) {
                    if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                        videoCaptureConnection = connection;
                        break;
                    }
                }
                if (videoCaptureConnection) break;
            }
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
        [rateLimiterTimer invalidate];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (allowOutput && [metadataObjects count]) {
        allowOutput = NO;
        /*// Get rid of sound haha
        static SystemSoundID soundID = 0;
        if (soundID == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        }
        AudioServicesPlaySystemSound(soundID);*/
        // Capture image
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoCaptureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self.delegate discoveredFace:image.normalizedImage];
        }];
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

- (void)allowOutput {
    allowOutput = YES;
}

@end

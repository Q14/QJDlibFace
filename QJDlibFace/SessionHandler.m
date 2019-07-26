//
//  SessionHandler.m
//  QJDlibFace
//
//  Created by Q14 on 2019/7/26.
//  Copyright © 2019 Gengmei. All rights reserved.
//
#import "DlibWrapper.h"
#import "SessionHandler.h"
@interface SessionHandler()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>{
    dispatch_queue_t _sampleQueue;
    dispatch_queue_t _faceQueue;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) DlibWrapper *wrapper;
@property (nonatomic, strong) NSMutableArray *currentMetadata;
@property (nonatomic, strong)  AVCaptureDevice *device;
//dispatchque
@end

@implementation SessionHandler
- (instancetype)init {
    if (self = [super init]) {
       _sampleQueue = dispatch_queue_create("GM.QJDlibFace.sampleQueue", nil);
        _faceQueue = dispatch_queue_create("GM.QJDlibFace.sampleQueue", nil);
        _currentMetadata = [NSMutableArray array];
        _layer = [[AVSampleBufferDisplayLayer alloc] init];
        self.wrapper = [[DlibWrapper alloc] init];
    }
    return self;
}

- (void)openSession {
   
    NSArray *devices = AVCaptureDevice.devices;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            self.device = device;
        }
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;

    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:NULL];

    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoOutput setAlwaysDiscardsLateVideoFrames:NO];
    [videoOutput setSampleBufferDelegate:self queue:_sampleQueue];
    
    AVCaptureMetadataOutput *metaOutput = [[AVCaptureMetadataOutput alloc] init];
    [metaOutput setMetadataObjectsDelegate:self queue:_faceQueue];
    [self.captureSession beginConfiguration];
    
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    }
    
    if ([self.captureSession canAddOutput:videoOutput]) {
        [self.captureSession addOutput:videoOutput];
    }
    
    if ([self.captureSession canAddOutput:metaOutput]) {
        [self.captureSession addOutput:metaOutput];
    }
    [self.captureSession commitConfiguration];
    
    NSDictionary *outputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};

    videoOutput.videoSettings = outputSettings;
    metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    [self.wrapper prepare];
    [self.captureSession startRunning];

}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    if (!self.captureSession.isRunning) {
//        return;
//    }
    
//    if (_currentMetadata.count > 0) {
//        NSMutableArray *boundsArray = [NSMutableArray array];
//        for (AVMetadataObject *faceObj in _currentMetadata) {
//            AVMetadataObject *convertedObject = [captureOutput transformedMetadataObjectForMetadataObject:faceObj connection:connection];
//            [boundsArray addObject:convertedObject];
//        }
//        [_wrapper doWorkOnSampleBuffer:sampleBuffer inRects:boundsArray];
//    }
    [self.layer enqueueSampleBuffer:sampleBuffer];
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"DidDropSampleBuffer");
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    _currentMetadata = (NSMutableArray *)metadataObjects;

}
@end

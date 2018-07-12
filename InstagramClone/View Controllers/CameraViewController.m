//
//  CameraViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <AVCapturePhotoCaptureDelegate>
// Outlet Definitions
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

// Instance Properties //
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCapturePhotoOutput* output;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic) BOOL backCamera;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set rounded edges
    self.takePictureButton.layer.borderWidth = 14;
    self.takePictureButton.layer.borderColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:255].CGColor;
    self.takePictureButton.layer.cornerRadius = 40;
    
    // disable share
    self.shareButton.enabled = NO;
    self.backCamera = YES;

    // set up camera
    [self setupCamera];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupCamera {
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // capture devices
    AVCaptureDevice* cameraDevice = nil;
    if(self.backCamera)
    {
        cameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    else
    {
        cameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    
    // set up capture device input to link session to camera device we are using
    NSError* error;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&error];
    
    if(error != nil)
    {
        NSLog(@"Failed to set up camera");
        return;
    }
    
    // if we get here, then the device is available
    if(self.session != nil && [self.session canAddInput:input])
    {
        [self.session addInput:input];
    }
    
    // set output
    self.output = [AVCapturePhotoOutput new];
    if([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // create the preview layer
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    if(self.previewLayer != nil)
    {
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.cameraView.layer addSublayer:self.previewLayer];
        [self.session startRunning];
    }
    
    self.previewLayer.frame = self.cameraView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)takePictureClicked:(id)sender {
    // animate
    [UIView animateWithDuration:0.1 animations:^{
        self.takePictureButton.alpha = 1;
    }];
    
    // actually take the picture
    AVCapturePhotoSettings* settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    [self.output capturePhotoWithSettings:settings delegate:self];
    
    // show flashing animation
    [UIView animateWithDuration:0.1 animations:^{
        self.cameraView.alpha = 0.0;
    }];
    
    // show the preview image and show option to take another picture
    self.previewView.hidden = NO;
    [self.cancelButton setTitle:@"Retake"];
}

- (IBAction)takePictureDown:(id)sender {
    // animate
    [UIView animateWithDuration:0.1 animations:^{
        self.takePictureButton.alpha = 0.2;
    }];
}

- (void)captureOutput:(AVCapturePhotoOutput*)output didFinishProcessingPhoto:(AVCapturePhoto*)photo error:(nullable NSError*)error {
    NSData* data = photo.fileDataRepresentation;
    
    // set the preview image and enable share
    [self.previewImage setImage:[UIImage imageWithData:data]];
    self.shareButton.enabled = YES;
    
    // animate back
    [UIView animateWithDuration:0.1 animations:^{
        self.cameraView.alpha = 1;
    }];
}

- (IBAction)shareClicked:(id)sender {
    [self.delegate didTakePicture:self.previewImage.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender {
    if(self.previewView.isHidden)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        self.previewView.hidden = YES;
        [self.previewImage setImage:nil];
        [self.cancelButton setTitle:@"Cancel"];
        self.shareButton.enabled = NO;
    }
}

- (IBAction)changeClicked:(id)sender {
    self.backCamera = !self.backCamera;
    [self setupCamera];
    
    // animate
    [UIView animateWithDuration:0.1 animations:^{
        self.changeButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.changeButton.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end

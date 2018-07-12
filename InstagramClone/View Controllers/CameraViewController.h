//
//  CameraViewController.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CameraViewControllerDelegate
- (void)didTakePicture:(UIImage*)picture;
@end

@interface CameraViewController : UIViewController
@property (weak, nonatomic) id<CameraViewControllerDelegate> delegate;
@end

//
//  Helper.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// Placeholder image used all around the app
extern UIImage* placeholderImage;

@interface Helper : NSObject
+ (void)setImageFromPFFile:(PFFile*)file forImageView:(UIImageView*)imageView;
+ (void)setImageFromPFFile:(PFFile*)file forButton:(UIButton*)button;
+ (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size;
+ (PFFile*)getPFFileFromImage:(UIImage*)image;
@end

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

/*
    Helper
    Set of global helper variables and methods.
*/
@interface Helper : NSObject
+ (void)setImageFromPFFile:(PFFile*)file forImageView:(UIImageView*)imageView;
+ (void)setImageFromPFFile:(PFFile*)file forButton:(UIButton*)button;
+ (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size;
+ (PFFile*)getPFFileFromImage:(UIImage*)image;
@end

//
//  Helper.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (void)setImageFromPFFile:(PFFile*)file forImageView:(UIImageView*)imageView {
    [file getDataInBackgroundWithBlock:
     ^(NSData* _Nullable data, NSError * _Nullable error)
     {
         if(error == nil)
         {
             [imageView setImage:[UIImage imageWithData:data]];
         }
         else
         {
             NSLog(@"Failed to convert PFFile to UIImage.");
         }
     }
     ];
}

+ (void)setImageFromPFFile:(PFFile*)file forButton:(UIButton*)button {
    [file getDataInBackgroundWithBlock:
     ^(NSData* _Nullable data, NSError * _Nullable error)
     {
         if(error == nil)
         {
             [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
         }
         else
         {
             NSLog(@"Failed to convert PFFile to UIImage.");
         }
     }
     ];
}

// resizeImage: method from https://hackmd.io/s/B1UKigxm7
+ (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size {
    UIImageView* resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (PFFile*)getPFFileFromImage:(UIImage*)image {
    if(image == nil)
    {
        return nil;
    }
    
    NSData* imageData = UIImagePNGRepresentation(image);
    if (imageData == nil)
    {
        return nil;
    }
    
    // if we get here, image is fine
    return [PFFile fileWithName:@"image.png" data:imageData];
}
@end

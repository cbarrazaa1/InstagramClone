//
//  PictureCell.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "PictureCell.h"

@interface PictureCell ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;

@end

@implementation PictureCell
- (void)setPictureWithImage:(UIImage*)image {
    [self.pictureImage setImage:image];
}
@end

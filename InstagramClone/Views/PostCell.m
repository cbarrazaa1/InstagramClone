//
//  PostCell.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "PostCell.h"

@interface PostCell ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;


// Instance Properties //
@property (strong, nonatomic) Post* post;
@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateUI {
    PFFile* image = self.post.image;
    
    // convert PFFile to image
    [image getDataInBackgroundWithBlock:
           ^(NSData* _Nullable data, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   [self.pictureImage setImage:[UIImage imageWithData:data]];
               }
               else
               {
                   NSLog(@"Failed to convert PFFile to UIImage.");
               }
           }
     ];
    
    self.captionLabel.text = self.post.text;
}

- (void)setPost:(Post*)post {
    _post = post;
    [self updateUI];
}
@end

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
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *topUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomUsernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

// Instance Properties //
@property (strong, nonatomic) Post* post;
@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set rounded corners
    self.profileButton.layer.cornerRadius = 16;
    self.profileButton.clipsToBounds = YES;
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
    self.topUsernameLabel.text = self.post.user.username;
    self.bottomUsernameLabel.text = self.post.user.username;
    
    // format data
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d, yyyy";
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
}

- (void)setPost:(Post*)post {
    _post = post;
    [self updateUI];
}

- (IBAction)likeClicked:(id)sender {
    NSLog(@"Like");
}

- (IBAction)replyClicked:(id)sender {
    NSLog(@"Reply");
}

- (IBAction)saveClicked:(id)sender {
    NSLog(@"Save");
}

- (IBAction)profileClicked:(id)sender {
    NSLog(@"Profile");
}

@end

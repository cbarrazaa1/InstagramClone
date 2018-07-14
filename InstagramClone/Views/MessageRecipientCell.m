//
//  MessageRecipientCell.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "MessageRecipientCell.h"

@interface MessageRecipientCell ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIView *messageview;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

// Instance Properties //
@property (strong, nonatomic) UIImage* userImage;
@property (strong, nonatomic) Message* message;
@end

@implementation MessageRecipientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set rounded edges
    self.profileImage.layer.cornerRadius = 17;
    self.profileImage.clipsToBounds = YES;
    self.messageview.layer.cornerRadius = 10;
    self.messageview.layer.borderWidth = 1;
    self.messageview.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)updateUI {
    self.profileImage.image = self.userImage;
    self.messageLabel.text = self.message.text;
    [self.profileImage setImage:self.userImage];
}

- (void)setMessage:(Message*)message withImage:(UIImage*)image {
    _message = message;
    self.userImage = image;
    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

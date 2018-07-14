//
//  MessageSenderCell.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "MessageSenderCell.h"

@interface MessageSenderCell ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

// Instance Properties //
@property (strong, nonatomic) Message* message;
@end

@implementation MessageSenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set rounded edges
    self.messageView.layer.cornerRadius = 10;
    self.messageView.layer.borderWidth = 1;
    self.messageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)updateUI {
    self.messageLabel.text = self.message.text;
}

- (void)setMessage:(Message*)message {
    _message = message;
    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  CommentCell.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "CommentCell.h"
#import "User.h"
#import "Helper.h"

@interface CommentCell ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


// Instance Properties //
@property (strong, nonatomic) Comment* comment;
@property (strong, nonatomic) User* user;
@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // set rounded corners
    self.pictureImage.layer.cornerRadius = 16;
    self.pictureImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   // [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fetchData {
    // fetch the user
    PFQuery* query = [PFQuery queryWithClassName:@"_User"];
    query.limit = 1;
    [query whereKey:@"objectId" equalTo:self.comment.userID];
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   self.user = [[User alloc] initWithPFUser:(PFUser*)objects[0]];
               }
               else
               {
                   NSLog(@"Error loading comment user.");
               }
               
               [self updateUI];
           }
     ];
}

- (void)updateUI {
    [Helper setImageFromPFFile:self.user.profilePicture forImageView:self.pictureImage];
    self.usernameLabel.text = self.user.username;
    self.commentLabel.text = self.comment.text;
    
    // format data
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d, yyyy";
    self.dateLabel.text = [formatter stringFromDate:self.comment.createdAt];
    
    // make them visible
    self.pictureImage.hidden = NO;
    self.usernameLabel.hidden = NO;
    self.commentLabel.hidden = NO;
    self.dateLabel.hidden = NO;
}

- (void)setComment:(Comment*)comment {
    _comment = comment;
    [self fetchData];
}
@end

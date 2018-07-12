//
//  DetailsViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "DetailsViewController.h"
#import "User.h"
#import "Helper.h"

@interface DetailsViewController ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

// Instance Properties //
@property (strong, nonatomic) Post* post;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set rounded corners
    self.profilePicture.layer.cornerRadius = 16;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 0.5;
    self.profilePicture.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)updateUI {
    User* user = [[User alloc] initWithPFUser:self.post.user];
    
    // set info
    [Helper setImageFromPFFile:user.profilePicture forButton:self.profilePicture];
    [Helper setImageFromPFFile:self.post.image forImageView:self.pictureImage];
    self.captionLabel.text = self.post.text;
    self.usernameLabel.text = self.post.user.username;
    
    // set like button
    if(self.post.liked)
    {
        [self.likeButton setImage:[UIImage imageNamed:@"instaheartred"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeButton setImage:[UIImage imageNamed:@"instaheart"] forState:UIControlStateNormal];
    }
    NSString* likesString = (self.post.likeCount == 1) ? @"like" : @"likes";
    self.likeLabel.text = [NSString stringWithFormat:@"%i %@", self.post.likeCount, likesString];
    
    // format data
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d, yyyy";
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
}

- (void)setPost:(Post*)post {
    _post = post;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)likeClicked:(id)sender {
    // animate
    [UIView animateWithDuration:0.1
                     animations:^
     {
         self.likeButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^{
             self.likeButton.transform = CGAffineTransformIdentity;
         }];
     }
     ];
    
    // set network call
    [self.post likeWithUserID:[User currentUser].objectId];
    
    // update UI
    [self updateUI];
}

- (IBAction)replyClicked:(id)sender {
    
}

- (IBAction)saveClicked:(id)sender {
    
}
@end

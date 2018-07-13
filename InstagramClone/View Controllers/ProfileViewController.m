//
//  ProfileViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ProfileViewController.h"
#import "DetailsViewController.h"
#import "Post.h"
#import "PictureCell.h"
#import "Helper.h"
#import "Follower.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

// Instance Properties //
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSMutableArray<Post*>* posts;
@property (nonatomic) BOOL following;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set circle borders
    self.profileImage.layer.cornerRadius = 48;
    self.profileImage.clipsToBounds = YES;
    
    // set buttons border
    self.editProfileButton.layer.cornerRadius = 4;
    self.editProfileButton.layer.borderWidth = 1.0;
    self.editProfileButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageButton.layer.cornerRadius = 4;
    self.messageButton.layer.borderWidth = 1.0;
    self.messageButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // set up collectionview
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat picturesPerLine = 3;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat size = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (picturesPerLine - 1)) / picturesPerLine;
    layout.itemSize = CGSizeMake(size, size);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchPosts];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)updateUI {
    self.navBar.title = self.user.username;
    [Helper setImageFromPFFile:self.user.profilePicture forImageView:self.profileImage];
    self.displayNameLabel.text = self.user.displayName;
    self.bioLabel.text = self.user.bioDesc;
    self.followersLabel.text = [NSString stringWithFormat:@"%i", self.user.followerCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%i", self.user.followingCount];
    
    // change buttons visibility depending on users
    if([self.user.username isEqualToString:[User currentUser].username])
    {
        self.editProfileButton.hidden = NO;
        self.messageButton.hidden = YES;
        self.followButton.hidden = YES;
    }
    else
    {
        self.editProfileButton.hidden = YES;
        self.messageButton.hidden = NO;
        self.followButton.hidden = NO;
        self.followButton.hidden = NO;
        
        // update followbutton accordingly
        if([[User currentUser].following containsObject:self.user.objectId])
        {
            self.following = YES;
            [self.followButton setImage:[UIImage imageNamed:@"user-minus"] forState:UIControlStateNormal];
        }
        else
        {
            self.following = NO;
            [self.followButton setImage:[UIImage imageNamed:@"user-plus"] forState:UIControlStateNormal];
        }
    }
}

- (void)fetchPosts {
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    
    // set up query
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"userID" equalTo:self.user.objectId];
    [query includeKey:@"user"];

    // send request
    [query findObjectsInBackgroundWithBlock:
     ^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if(error == nil)
         {
             self.posts = (NSMutableArray*)objects;
             self.postsLabel.text = [NSString stringWithFormat:@"%lu", self.posts.count];
         }
         else
         {
             NSLog(@"Error fetching objects: %@.", error.localizedDescription);
         }
         
         [self.collectionView reloadData];
         //[self.refreshControl endRefreshing];
     }
     ];
    
    // fetch user data as well
    [self.user fetchFollowers];
    [self.user fetchFollowees];
    [[User currentUser] fetchFollowers];
    [[User currentUser] fetchFollowees];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsSegue"])
    {
        DetailsViewController* viewController = (DetailsViewController*)[segue destinationViewController];
        PictureCell* cell = (PictureCell*)sender;
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
        [viewController setPost:self.posts[indexPath.item]];
    }
}

- (void)setUser:(User*)user {
    if(_user == nil)
    {
        _user = user;
        [self fetchPosts];
    }
}

- (IBAction)editProfileClicked:(id)sender {
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PictureCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
    
    if(post != nil)
    {
        [Helper setImageFromPFFile:post.image forImageView:cell.pictureImage];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (IBAction)followClicked:(id)sender {
    if(self.following)
    {
        self.following = NO;
        self.user.followerCount--;
        [[User currentUser].following removeObject:self.user.objectId];
        [User currentUser].followingCount--;
        PFQuery* query = [PFQuery queryWithClassName:@"Follower"];
        query.limit = 1;
        [query whereKey:@"followerID" equalTo:[User currentUser].objectId];
        [query whereKey:@"followeeID" equalTo:self.user.objectId];
        [query findObjectsInBackgroundWithBlock:
               ^(NSArray * _Nullable objects, NSError * _Nullable error)
               {
                   Follower* follower = objects[0];
                   [follower deleteInBackgroundWithBlock:
                             ^(BOOL succeeded, NSError * _Nullable error)
                             {
                                 // revert local changes if error
                                 if(!succeeded)
                                 {
                                     [[User currentUser].following addObject:self.user.objectId];
                                     [User currentUser].followingCount++;
                                     self.user.followerCount++;
                                     self.following = YES;
                                     [self updateUI];
                                 }
                             }
                    ];
               }
         ];
    }
    else
    {
        self.following = YES;
        self.user.followerCount++;
        [[User currentUser].following addObject:self.user.objectId];
        [User currentUser].followingCount++;
        [Follower createFollower:[User currentUser].objectId followeeID:self.user.objectId
                  completion:^(BOOL succeeded, NSError * _Nullable error)
                  {
                      if(!succeeded)
                      {
                          [[User currentUser].following removeObject:self.user.objectId];
                          [User currentUser].followingCount--;
                          self.user.followingCount--;
                          self.following = NO;
                          [self updateUI];
                      }
                  }
         ];
    }
    
    [self updateUI];
}


@end

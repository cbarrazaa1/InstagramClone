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

// Instance Properties //
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSMutableArray<Post*>* posts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUser:[User currentUser]];
    
    // set circle borders
    self.profileImage.layer.cornerRadius = 48;
    self.profileImage.clipsToBounds = YES;
    
    // set button border
    self.editProfileButton.layer.cornerRadius = 4;
    self.editProfileButton.layer.borderWidth = 1.0;
    self.editProfileButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // set up collectionview
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat picturesPerLine = 3;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat size = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (picturesPerLine - 1)) / picturesPerLine;
    layout.itemSize = CGSizeMake(size, size);
    
    // fetch data
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)updateUI {
    self.navBar.title = self.user.username;
    [Helper setImageFromPFFile:self.user.profilePicture forImageView:self.profileImage];
    self.displayNameLabel.text = self.user.displayName;
    self.bioLabel.text = self.user.bioDesc;
    self.postsLabel.text = [NSString stringWithFormat:@"%i", self.user.postCount];
    self.followersLabel.text = [NSString stringWithFormat:@"%i", self.user.followerCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%i", self.user.followingCount];
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
         }
         else
         {
             NSLog(@"Error fetching objects: %@.", error.localizedDescription);
         }
         
         [self.collectionView reloadData];
         //[self.refreshControl endRefreshing];
     }
     ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailsSegue"])
    {
        DetailsViewController* viewController = (DetailsViewController*)[segue destinationViewController];
        PictureCell* cell = (PictureCell*)sender;
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
        Post* post = self.posts[indexPath.item];
        [viewController setPost:self.posts[indexPath.item]];
    }
}

- (void)setUser:(User*)user {
    _user = user;
    [self updateUI];
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

@end

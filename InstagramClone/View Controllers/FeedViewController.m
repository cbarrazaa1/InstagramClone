//
//  FeedViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "CommentsViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PostCell.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Post*>* posts;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // set up refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tabBarController.delegate = self;
    
    // load posts
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"profileSegue"])
    {
        ProfileViewController* viewController = (ProfileViewController*)[segue destinationViewController];
        PostCell* cell = (PostCell*)[[sender superview] superview];
        [viewController setUser:[[User alloc] initWithPFUser:cell.post.user]];
    }
    else if([segue.identifier isEqualToString:@"commentsSegue"])
    {
        CommentsViewController* viewController = (CommentsViewController*)[segue destinationViewController];
        PostCell* cell = (PostCell*)[[sender superview] superview];
        [viewController setPostID:cell.post.objectId];
    }
}

- (void)fetchPosts {
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    
    // set up query
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    
    // send request
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   // set liked or not
                   for(Post* post in objects)
                   {
                       post.liked = [post.likedBy containsObject:[User currentUser].objectId];
                   }
                   self.posts = (NSMutableArray*)objects;
               }
               else
               {
                   NSLog(@"Error fetching objects: %@.", error.localizedDescription);
               }
               
               [self.tableView reloadData];
               [self.refreshControl endRefreshing];
           }
     ];
}

- (IBAction)logoutClicked:(id)sender {
    // logout
    [PFUser logOutInBackground];
    
    // go back to login screen
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    delegate.window.rootViewController = viewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.row];
    
    if(post != nil)
    {
        [cell setPost:post];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UIViewController* actualController = ((UINavigationController*)viewController).topViewController;
    if([actualController isKindOfClass:[ProfileViewController class]])
    {
        ProfileViewController* controller = (ProfileViewController*)actualController;
        [controller setUser:[User currentUser]];
    }
}

@end

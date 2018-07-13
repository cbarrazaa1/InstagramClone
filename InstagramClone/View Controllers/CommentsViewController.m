//
//  CommentsViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentCell.h"
#import "AppDelegate.h"
#import "User.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UIView *commentView;

// Instance Properties //
@property (strong, nonatomic) NSMutableArray<Comment*>* comments;
@property (strong, nonatomic) NSString* postID;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight:80];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)fetchComments {
    // fetch the comment
    PFQuery* query = [PFQuery queryWithClassName:@"Comment"];
    query.limit = 20;
    [query whereKey:@"postID" equalTo:self.postID];
    [query findObjectsInBackgroundWithBlock:
     ^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         if(error == nil)
         {
             self.comments = (NSMutableArray<Comment*>*)objects;
         }
         else
         {
             NSLog(@"Error loading comment.");
         }
         
         [self.tableView reloadData];
     }
     ];
}

- (void)setPostID:(NSString *)postID {
    _postID = postID;
    // fecth data
    [self fetchComments];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment* comment = self.comments[indexPath.row];
    
    if(comment != nil)
    {
        [cell setComment:comment];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (IBAction)sendCommentClicked:(id)sender {
    NSString* text = self.commentField.text;
    
    // validate text
    if([text length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Share Error" message:@"Please enter text for your post." sender:self];
    }
    
    // send the post data
    Comment* newComment = [Comment new];
    newComment.postID = self.postID;
    newComment.userID = [User currentUser].objectId;
    newComment.text = text;
    
    [Comment createCommentWithPostID:newComment.postID userID:newComment.userID text:newComment.text completion:
             ^(BOOL succeeded, NSError * _Nullable error)
             {
                 [self.comments addObject:newComment];
                 [self.tableView reloadData];
             }
     ];
    
    // clear text
    self.commentField.text = @"";
}

- (IBAction)onTap:(id)sender {
    [self.commentField resignFirstResponder];
}

- (IBAction)editingBegin:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.commentView.frame;
        frame.origin.y -= 166;
        self.commentView.frame = frame;
    }];
}

- (IBAction)editingEnd:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.commentView.frame;
        frame.origin.y += 166;
        self.commentView.frame = frame;
    }];
}


@end

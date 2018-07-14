//
//  MessagesViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "MessagesViewController.h"
#import "Parse/Parse.h"
#import "Message.h"
#import "MessageSenderCell.h"
#import "MessageRecipientCell.h"
#import "User.h"
#import "AppDelegate.h"

@interface MessagesViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIView *messageView;

// Instance Properties //
@property (strong, nonatomic) NSString* senderID;
@property (strong, nonatomic) NSString* recipientID;
@property (strong, nonatomic) UIImage* recipientPicture;
@property (strong, nonatomic) NSMutableArray<Message*>* messages;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight:51];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // timer
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchMessages) userInfo:nil repeats:true];

}

- (void)fetchMessages {
    PFQuery* query = [PFQuery queryWithClassName:@"Message"];
    query.limit = 50;
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
                self.messages = [NSMutableArray new];
               
               if(error == nil)
               {
                   for(Message* message in objects)
                   {
                       if([message.participantsID containsObject:self.senderID] && [message.participantsID containsObject:self.recipientID])
                       {
                           [self.messages addObject:message];
                       }
                   }
               }
               else
               {
                   NSLog(@"Error loading comment.");
               }
               
               [self.tableView reloadData];
           }
     ];
}

- (void)setSenderID:(NSString*)senderID recipientID:(NSString*)recipientID recipientImage:(UIImage*)recipientImage {
    self.senderID = senderID;
    self.recipientID = recipientID;
    self.recipientPicture = recipientImage;
    [self fetchMessages];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message* message = self.messages[indexPath.row];
    NSString* myId = [User currentUser].objectId;
    
    if([message.senderID isEqualToString:[User currentUser].objectId])
    {
        MessageSenderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSenderCell" forIndexPath:indexPath];
  
        if(message != nil)
        {
            [cell setMessage:message];
        }
        
        return cell;
    }
    else
    {
        MessageRecipientCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageRecipientCell" forIndexPath:indexPath];
        
        if(message != nil)
        {
            [cell setMessage:message withImage:self.recipientPicture];
        }
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)sendMessageClicked:(id)sender {
    NSString* text = self.messageField.text;
    
    // validate text
    if([text length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Share Error" message:@"Please enter text for your post." sender:self];
    }
    
    // send the post data
    Message* newMsg = [Message new];
    newMsg.senderID = self.senderID;
    newMsg.recipientID = self.recipientID;
    newMsg.text = text;
    
    [Message createMessageWithSenderID:newMsg.senderID withRecipientID:newMsg.recipientID withText:newMsg.text
             completion:^(BOOL succeeded, NSError * _Nullable error)
             {
                 [self.messages addObject:newMsg];
                 [self.tableView reloadData];
             }
     ];
    
    // clear text
    self.messageField.text = @"";
}

- (IBAction)onTap:(id)sender {
    [self.messageField resignFirstResponder];
}

- (IBAction)editingBegin:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.messageView.frame;
        frame.origin.y -= 166;
        self.messageView.frame = frame;
    }];
}

- (IBAction)editingEnd:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.messageView.frame;
        frame.origin.y += 166;
        self.messageView.frame = frame;
    }];
}
@end

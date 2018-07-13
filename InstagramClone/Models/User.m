//
//  User.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "User.h"
#import "Helper.h"
#import "Follower.h"

@implementation User
@dynamic profilePicture, displayName, bioDesc, following, followerCount, followingCount;

- (instancetype)initWithPFUser:(PFUser*)user {
    return (User*)user;
}

- (void)fetchFollowers {
    PFQuery* query = [PFQuery queryWithClassName:@"Follower"];
    query.limit = 20;
    [query whereKey:@"followeeID" equalTo:self.objectId];
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error) {
               if(error == nil)
               {
                   self.followerCount = (int)objects.count;
               }
               else
               {
                   NSLog(@"Error getting user followers.");
               }
           }
     ];
}

- (void)fetchFollowees {
    PFQuery* query = [PFQuery queryWithClassName:@"Follower"];
    query.limit = 20;
    [query whereKey:@"followerID" equalTo:self.objectId];
    [query findObjectsInBackgroundWithBlock:
           ^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   for(Follower* follower in objects)
                   {
                       [self.following addObject:follower.followeeID];
                   }
                   self.followingCount = (int)objects.count;
               }
               else
               {
                   NSLog(@"Error getting user followees.");
               }
           }
     ];
}

+ (User*)defaultUserWithPFUser:(PFUser*)newUser {
    User* user = [[User alloc] initWithPFUser:newUser];
    user.profilePicture = [Helper getPFFileFromImage:[Helper placeholderImage]];
    user.displayName = newUser.username;
    user.bioDesc = @"This is your bio!";
    user.following = [NSMutableArray new];
    user.followerCount = 0;
    user.followingCount = 0;
    
    return user;
}

+ (User*)currentUser {
    User* user = [[User alloc] initWithPFUser:PFUser.currentUser];
    return user;
}
@end

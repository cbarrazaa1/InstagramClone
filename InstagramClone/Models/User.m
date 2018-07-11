//
//  User.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "User.h"
#import "Helper.h"

@implementation User
@dynamic profilePicture, displayName, bioDesc, postCount, followerCount, followingCount;

- (instancetype)initWithPFUser:(PFUser*)user {
    return (User*)user;
}

+ (User*)defaultUserWithPFUser:(PFUser*)newUser {
    User* user = [[User alloc] initWithPFUser:newUser];
    user.profilePicture = [Helper getPFFileFromImage:placeholderImage];
    user.displayName = newUser.username;
    user.bioDesc = @"This is your bio!";
    user.postCount = 0;
    user.followerCount = 0;
    user.followingCount = 0;
    
    return user;
}

+ (User*)currentUser {
    User* user = [[User alloc] initWithPFUser:PFUser.currentUser];
    return user;
}
@end

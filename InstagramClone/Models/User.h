//
//  User.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser
// Instance Properties //
@property (strong, nonatomic) PFFile* profilePicture;
@property (strong, nonatomic) NSString* displayName;
@property (strong, nonatomic) NSString* bioDesc;
@property (nonatomic) int postCount;
@property (nonatomic) int followerCount;
@property (nonatomic) int followingCount;

// Constructors //
- (instancetype)initWithPFUser:(PFUser*)user;

// Static Methods //
+ (User*)defaultUserWithPFUser:(PFUser*)newUser;
+ (User*)currentUser;
@end

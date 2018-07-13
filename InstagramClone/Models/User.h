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
@property (strong, nonatomic, nullable) PFFile* profilePicture;
@property (strong, nonatomic, nonnull) NSString* displayName;
@property (strong, nonatomic, nullable) NSString* bioDesc;
@property (strong, nonatomic, nullable) NSMutableArray<NSString*>* following;
@property (nonatomic) int followerCount;
@property (nonatomic) int followingCount;

// Constructors //
- (nonnull instancetype)initWithPFUser:(nonnull PFUser*)user;

// Instance Methods //
- (void)fetchFollowers;
- (void)fetchFollowees;

// Static Methods //
+ (nonnull User*)defaultUserWithPFUser:(nonnull PFUser*)newUser;
+ (nonnull User*)currentUser;
@end

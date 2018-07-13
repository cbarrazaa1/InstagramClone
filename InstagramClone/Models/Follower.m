//
//  Follower.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Follower.h"

@implementation Follower
@dynamic followerID, followeeID;

+ (nonnull NSString *)parseClassName {
    return @"Follower";
}

+ (void)createFollower:(NSString*)followerID followeeID:(NSString*)followeeID completion:(nullable PFBooleanResultBlock)completion {
    Follower* newFollower = [Follower new];
    newFollower.followerID = followerID;
    newFollower.followeeID = followeeID;
    
    [newFollower saveInBackgroundWithBlock:completion];
}

@end

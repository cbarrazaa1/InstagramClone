//
//  Follower.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Follower : PFObject <PFSubclassing>
// Instance Properties //
@property (strong, nonatomic, nonnull) NSString* followerID;
@property (strong, nonatomic, nonnull) NSString* followeeID;

// Static Methods //
+ (void)createFollower:(NSString*)followerID followeeID:(NSString*)followeeID completion:(nullable PFBooleanResultBlock)completion;
@end

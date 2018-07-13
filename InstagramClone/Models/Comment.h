//
//  Comment.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Comment : PFObject <PFSubclassing>
// Instance Properties //
@property (strong, nonatomic, nonnull) NSString* postID;
@property (strong, nonatomic, nonnull) NSString* userID;
@property (strong, nonatomic, nullable) NSString* text;

// Static Methods //
+ (Comment*)createCommentWithPostID:(nonnull NSString*)postID userID:(nonnull NSString*)userID text:(nullable NSString*)text completion:(nullable PFBooleanResultBlock)completion;
@end

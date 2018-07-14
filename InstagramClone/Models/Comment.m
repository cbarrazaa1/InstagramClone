//
//  Comment.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@dynamic postID, userID, text;

+ (nonnull NSString*)parseClassName {
    return @"Comment";
}

+ (void)createCommentWithPostID:(NSString*)postID userID:(NSString*)userID text:(NSString*)text completion:(nullable PFBooleanResultBlock)completion {
    Comment* newComment = [Comment new];
    newComment.postID = postID;
    newComment.userID = userID;
    newComment.text = text;
    
    // save in db
    [newComment saveInBackgroundWithBlock:completion];
}
@end

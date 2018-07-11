//
//  Post.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Post.h"
#import "Helper.h"

@implementation Post
@dynamic postID, user, userID, text, image;

+ (nonnull NSString*)parseClassName {
    return @"Post";
}

+ (void)createPostWithImage:(UIImage*)image text:(NSString*)text completion:(nullable PFBooleanResultBlock)completion {
    Post* newPost = [Post new];
    newPost.user = PFUser.currentUser;
    newPost.userID = PFUser.currentUser.objectId;
    newPost.text = text;
    newPost.image = [Helper getPFFileFromImage:image];
    newPost.postID = newPost.objectId;
    
    // save in db
    [newPost saveInBackgroundWithBlock:completion];
}
@end

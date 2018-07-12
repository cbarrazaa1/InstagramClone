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
@dynamic postID, user, userID, text, image, likedBy, likeCount, liked;

- (void)likeWithUserID:(NSString*)userID {
    // we will act accordingly if id exists or not already in the array
    if(![self.likedBy containsObject:userID])
    {
        [self.likedBy addObject:userID];
        self.likeCount++;
        self.liked = YES;
    }
    else
    {
        [self.likedBy removeObject:userID];
        self.likeCount--;
        self.liked = NO;
    }
    
    // without this line, the array won't actually save into Parse
    [self setObject:self.likedBy forKey:@"likedBy"];
    [self saveInBackground];
}

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
    newPost.likedBy = [NSMutableArray new];
    newPost.likeCount = 0;
    newPost.liked = NO;
    
    // save in db
    [newPost saveInBackgroundWithBlock:completion];
}
@end

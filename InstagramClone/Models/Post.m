//
//  Post.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Post.h"

@implementation Post
@dynamic postID, user, text, image;

+ (nonnull NSString*)parseClassName {
    return @"Post";
}

+ (void)createPostWithImage:(UIImage*)image text:(NSString*)text completion:(nullable PFBooleanResultBlock)completion {
    Post* newPost = [Post new];
    newPost.user = PFUser.currentUser;
    newPost.text = text;
    newPost.image = [self getPFFileFromImage:image];
    newPost.postID = newPost.objectId;
    NSLog(@"%@", newPost.objectId);
    
    // save in db
    [newPost saveInBackgroundWithBlock:completion];
}

+ (PFFile*)getPFFileFromImage: (UIImage*)image {
    if(image == nil)
    {
        return nil;
    }
    
    NSData* imageData = UIImagePNGRepresentation(image);
    if (imageData == nil)
    {
        return nil;
    }
    
    // if we get here, image is fine
    return [PFFile fileWithName:@"image.png" data:imageData];
}
@end

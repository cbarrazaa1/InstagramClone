//
//  Post.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>

@interface Post : PFObject<PFSubclassing>
// Instance Properties //
@property (strong, nonatomic) NSString* postID;
@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) PFFile* image;

// Static Methods //
+ (void)createPostWithImage:(UIImage*)image text:(NSString*)text completion:(nullable PFBooleanResultBlock)completion;
@end

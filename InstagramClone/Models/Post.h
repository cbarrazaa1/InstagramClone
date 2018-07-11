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
@property (strong, nonatomic, nonnull) NSString* postID;
@property (strong, nonatomic, nonnull) PFUser* user;
@property (strong, nonatomic, nonnull) NSString* userID;
@property (strong, nonatomic, nullable) NSString* text;
@property (strong, nonatomic, nullable) PFFile* image;

// Static Methods //
+ (void)createPostWithImage:(nullable UIImage*)image text:(nullable NSString*)text completion:(nullable PFBooleanResultBlock)completion;
@end

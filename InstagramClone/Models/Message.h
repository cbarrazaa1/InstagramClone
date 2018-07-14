//
//  Message.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Message : PFObject <PFSubclassing>
// Instance Properties //
@property (strong, nonatomic, nonnull) NSString* senderID;
@property (strong, nonatomic, nonnull) NSString* recipientID;
@property (strong, nonatomic, nonnull) NSString* text;
@property (strong, nonatomic, nonnull) NSMutableArray<NSString*>* participantsID;

// Static Methods //
+ (void)createMessageWithSenderID:(nonnull NSString*)senderID withRecipientID:(nonnull NSString*)recipientID withText:(nonnull NSString*)text completion:(nullable PFBooleanResultBlock)completion;
@end

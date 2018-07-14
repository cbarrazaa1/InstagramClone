//
//  Message.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Message.h"

@implementation Message
@dynamic senderID, recipientID, text, participantsID;

+ (nonnull NSString*)parseClassName {
    return @"Message";
}

+ (void)createMessageWithSenderID:(NSString *)senderID withRecipientID:(NSString *)recipientID withText:(NSString *)text completion:(nullable PFBooleanResultBlock)completion {
    Message* newMsg = [Message new];
    newMsg.senderID = senderID;
    newMsg.recipientID = recipientID;
    newMsg.text = text;
    newMsg.participantsID = [NSMutableArray new];
    [newMsg.participantsID addObject:senderID];
    [newMsg.participantsID addObject:recipientID];
    
    [newMsg setObject:newMsg.participantsID forKey:@"participantsID"];
    [newMsg saveInBackgroundWithBlock:completion];
}
@end

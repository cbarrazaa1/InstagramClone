//
//  MessagesViewController.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController
// Instance Methods //
- (void)setSenderID:(NSString*)senderID recipientID:(NSString*)recipientID recipientImage:(UIImage*)recipientImage;
@end

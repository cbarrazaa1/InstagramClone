//
//  MessageSenderCell.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/13/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageSenderCell : UITableViewCell
// Instance Properties //
- (void)setMessage:(Message*)message;
@end

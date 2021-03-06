//
//  AppDelegate.h
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Shows an alert from any view controller
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message sender:(UIViewController*)sender;
@end


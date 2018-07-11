//
//  LoginViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "NewPostViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface LoginViewController ()
// Outlet Definitions
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)loginClicked:(id)sender {
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    
    // validate textboxes
    if([username length] <= 0 || [password length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Login Error" message:@"Please enter username and password." sender:self];
        return;
    }
    
    // attempt login
    [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser * _Nullable user, NSError * _Nullable error)
            {
                if(error == nil)
                {
                    [self performSegueWithIdentifier:@"loginSegue" sender:self];
                }
                else
                {
                    [AppDelegate showAlertWithTitle:@"Login Error" message:error.localizedDescription sender:self];
                }
            }
     ];
}

- (IBAction)signInClicked:(id)sender {
    PFUser* newUser = [PFUser user];
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    
    // validate textboxes
    if([username length] <= 0 || [password length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Register Error" message:@"Please enter username and password." sender:self];
        return;
    }
    
    // set up user
    newUser.username = username;
    newUser.password = password;
    
    // attempt registration
    [newUser signUpInBackgroundWithBlock:
             ^(BOOL succeeded, NSError * _Nullable error)
             {
                 if(succeeded)
                 {
                     // create the default settings for user
                     User* user = [User defaultUserWithPFUser:newUser];
                     
                     // save the info
                     [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                         if(succeeded)
                         {
                             [self performSegueWithIdentifier:@"loginSegue" sender:self];
                         }
                         else
                         {
                             NSLog(@"Error creating new user data.");
                         }
                     }];
                 }
                 else
                 {
                     [AppDelegate showAlertWithTitle:@"Register Error" message:error.localizedDescription sender:self];
                 }
             }
     ];
}

@end

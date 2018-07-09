//
//  LoginViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface LoginViewController ()
// Outlet Definitions
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // create OK button
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    // add OK button and show
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)loginClicked:(id)sender {
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    
    // validate textboxes
    if([username length] <= 0 || [password length] <= 0)
    {
        [self showAlertWithTitle:@"Login Error" message:@"Please enter username and password."];
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
                    [self showAlertWithTitle:@"Login Error" message:error.localizedDescription];
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
        [self showAlertWithTitle:@"Register Error" message:@"Please enter username and password."];
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
                     [self performSegueWithIdentifier:@"loginSegue" sender:self];
                 }
                 else
                 {
                     [self showAlertWithTitle:@"Register Error" message:error.localizedDescription];
                 }
             }
     ];
}

@end

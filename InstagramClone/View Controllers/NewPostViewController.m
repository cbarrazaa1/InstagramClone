//
//  NewPostViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "NewPostViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "Helper.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraViewControllerDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // show keyboard if not loading
    if(self.loadingView.hidden)
    {
        [self.captionField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* navController = (UINavigationController*)[segue destinationViewController];
    CameraViewController* viewController = (CameraViewController*)navController.topViewController;
    viewController.delegate = self;
}

- (void)beginLoading {
    [self.activityIndicator startAnimating];
    self.loadingView.hidden = NO;
    [self.captionField resignFirstResponder];
    
    // disable buttons
    self.shareButton.enabled = NO;
    self.cancelButton.enabled = NO;
}

- (void)endLoading {
    [self.loadingView setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    // enable buttons
    self.shareButton.enabled = YES;
    self.cancelButton.enabled = YES;
}

- (void)clearData {
    self.captionField.text = @"";
    [self.pictureImage setImage:[Helper placeholderImage]];
}

- (IBAction)imageClick:(id)sender {
    // initialize image picker
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    // ask the user if they want to use camera or photo library
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* alertCamera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action)
                                                {
                                                    // show the controller
                                                    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
                                                }
                                  ];
    
    UIAlertAction* alertGallery = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action)
                                                 {
                                                     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                     
                                                     // show the controller
                                                     [self presentViewController:picker animated:YES completion:nil];
                                                 }
                                   ];
    UIAlertAction* alertCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // add the actions and show
    [alert addAction:alertCamera];
    [alert addAction:alertGallery];
    [alert addAction:alertCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)shareClicked:(id)sender {
    NSString* text = self.captionField.text;
    
    // validate text
    if([text length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Share Error" message:@"Please enter text for your post." sender:self];
    }
    
    // get the image and resize
    UIImage* image = [Helper resizeImage:self.pictureImage.image withSize:CGSizeMake(1024, 768)];
    
    // send the post data
    [self beginLoading];
    [Post createPostWithImage:image text:self.captionField.text
          completion:^(BOOL succeeded, NSError * _Nullable error)
          {
              [self clearData];
              [self endLoading];
              [AppDelegate showAlertWithTitle:@"Success" message:@"Post created successfully." sender:self];
          }
     ];
}

- (IBAction)cancelClicked:(id)sender {
    // hide keyboard
    [self.captionField resignFirstResponder];
    
    // clear data
    [self clearData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* picture = info[UIImagePickerControllerEditedImage];
    
    // set the image
    [self.pictureImage setImage:picture];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTakePicture:(UIImage*)picture {
    [self.pictureImage setImage:picture];
}
@end

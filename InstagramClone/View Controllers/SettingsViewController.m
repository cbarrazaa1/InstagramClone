//
//  SettingsViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/10/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;

// Instance Properties //
@property (strong, nonatomic) User* user;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set round corners
    self.profilePicture.layer.cornerRadius = 48;
    self.profilePicture.clipsToBounds = YES;
    
    // we only use this vc with current user
    self.user = [User currentUser];
    
    // update info
    [self updateUI];
}

- (void)updateUI {
    [self.user.profilePicture getDataInBackgroundWithBlock:
                              ^(NSData * _Nullable data, NSError * _Nullable error)
                              {
                                  if(error == nil)
                                  {
                                      [self.profilePicture setImage:[UIImage imageWithData:data]];
                                  }
                                  else
                                  {
                                      NSLog(@"Error trying to get image data from PFFile.");
                                  }
                              }
     ];
    
    self.nameField.text = self.user.displayName;
    self.bioField.text = self.user.bioDesc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (IBAction)doneClicked:(id)sender {
    // update the user
    [User currentUser].displayName = self.nameField.text;
    [User currentUser].bioDesc = self.bioField.text;
    [User currentUser].profilePicture = [PFFile fileWithData:UIImagePNGRepresentation(self.profilePicture.image)];
    
    // get the image and resize
    [User currentUser].profilePicture = [PFFile fileWithData:UIImagePNGRepresentation([self resizeImage:self.profilePicture.image withSize:CGSizeMake(1024, 768)])];
    
    // update db
    [[User currentUser] saveInBackgroundWithBlock:
                        ^(BOOL succeeded, NSError * _Nullable error)
                        {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
     ];
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)profilePictureClicked:(id)sender {
    // initialize image picker
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    // ask the user if they want to use camera or photo library
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* alertCamera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                      
                                      // show the controller
                                      [self presentViewController:picker animated:YES completion:nil];
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

// resizeImage: method from https://hackmd.io/s/B1UKigxm7
- (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size {
    UIImageView* resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* original = info[UIImagePickerControllerOriginalImage];
    //UIImage* edited = info[UIImagePickerControllerEditedImage];
    
    // set the image
    [self.profilePicture setImage:original];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

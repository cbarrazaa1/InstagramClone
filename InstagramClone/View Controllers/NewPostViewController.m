//
//  NewPostViewController.m
//  InstagramClone
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "NewPostViewController.h"
#import "AppDelegate.h"
#import "Post.h"

// Default image
static UIImage* defaultImage;

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize default image
    if(defaultImage == nil)
    {
        defaultImage = [UIImage imageNamed:@"image_placeholder"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // show keyboard
    [self.captionField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)clearData {
    self.captionField.text = @"";
    [self.pictureImage setImage:defaultImage];
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

- (IBAction)imageClick:(id)sender {
    // initialize image picker
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // show the controller
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)shareClicked:(id)sender {
    NSString* text = self.captionField.text;
    
    // validate text
    if([text length] <= 0)
    {
        [AppDelegate showAlertWithTitle:@"Share Error" message:@"Please enter text for your post." sender:self];
    }
    
    // get the image and resize
    UIImage* image = [self resizeImage:self.pictureImage.image withSize:CGSizeMake(1024, 768)];
    
    // send the post data
    [Post createPostWithImage:image text:self.captionField.text
          completion:^(BOOL succeeded, NSError * _Nullable error)
          {
              [self clearData];
              [AppDelegate showAlertWithTitle:@"Success" message:@"Post created successfully." sender:self];
          }
     ];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* original = info[UIImagePickerControllerOriginalImage];
    //UIImage* edited = info[UIImagePickerControllerEditedImage];
    
    // set the image
    [self.pictureImage setImage:original];
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

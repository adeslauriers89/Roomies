//
//  MyProfileViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "MyProfileViewController.h"
#import <Parse/Parse.h>


@interface MyProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *profileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *profileDetailsTextView;
@property (weak, nonatomic) IBOutlet UISwitch *isLookingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lookingLabel;
@property (nonatomic) BOOL canEditProfile;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canEditProfile = NO;

    
    PFUser *user = [PFUser currentUser];
    
    
    self.profileNameTextField.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"fullName"]];
    
    self.profileDetailsTextView.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"userDetails"]];
    
    PFFile *thumbnail = [user objectForKey:@"userImage"];
    [thumbnail getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *userImage = [UIImage imageWithData:data];
            self.profileImage.image = userImage;
        }
    }];
    

    self.profileDetailsTextView.layer.borderWidth = 1.0;
    self.profileDetailsTextView.layer.borderColor = [UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0].CGColor;
    self.profileDetailsTextView.layer.cornerRadius = 5.0;

 
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.canEditProfile) {
        if ([self.profileDetailsTextView.text isEqualToString:@"Tell us about yourself and what you're looking for.." ]) {
            self.profileDetailsTextView.text = @"";
            return YES;
        } return YES;
    } else {
            return NO;
        }
   
    }


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.canEditProfile) {
        
        return YES;
    } else {
      
        return NO;
    }
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    PFUser *user = [PFUser currentUser];
    
    if ([PFUser currentUser]) {
        user[@"fullName"] = self.profileNameTextField.text;
        user[@"userDetails"] = self.profileDetailsTextView.text;
        
        double compressionRatio = 1;
        NSData *pictureData = UIImagePNGRepresentation(self.profileImage.image);
        while ([pictureData length]>500000) {
            compressionRatio = compressionRatio*0.5;
            pictureData = UIImageJPEGRepresentation(self.profileImage.image, compressionRatio);
        }
        
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:pictureData];
        user[@"userImage"] = imageFile;
        
        
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Object Uploaded");
            }
            else {
                NSString *errorString =[[error userInfo] objectForKey:@"error"];
                NSLog(@"Error: %@", errorString);
            }
        }];
    }
    
}
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    
    self.canEditProfile = YES;
    
}
- (IBAction)isLookingSwitchPressed:(UISwitch *)sender {
    PFUser *user = [PFUser currentUser];
    
    if ([self.isLookingSwitch isOn]) {
        self.lookingLabel.text = @"I'm looking for a room";
        user[@"isLooking"] = @YES;
    } else {
        self.lookingLabel.text = @"Not looking for a room";
        user[@"isLooking"] =@NO;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Saved!! ");
    }];
    
}
- (IBAction)changeImageButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.profileImage.image = info[UIImagePickerControllerOriginalImage];
}


@end

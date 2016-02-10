//
//  MyProfileViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "MyProfileViewController.h"
#import <Parse/Parse.h>
#import "RoomieUser.h"

@interface MyProfileViewController ()
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
    
    
    
//    
//    PFFile *thumbnail = [myObject objectForKey:@"image"];
//    NSData *imageData = [thumbnail getData];
//    UIImage *image = [UIImage imageWithData:imageData];
//    
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"fullName" equalTo:];
//    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        
//    }];
//    
    
    
    
    self.profileDetailsTextView.layer.borderWidth = 1.0;
    self.profileDetailsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
        
        NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"Adam"]);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imgData];
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




@end

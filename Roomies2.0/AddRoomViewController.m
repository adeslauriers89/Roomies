//
//  AddRoomViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "AddRoomViewController.h"
#import <Parse/Parse.h>
#import "Room.h"

@interface AddRoomViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageToUpload;
@property (weak, nonatomic) IBOutlet UITextField *roomTitle;
@property (weak, nonatomic) IBOutlet UITextView *roomDescription;
@property (weak, nonatomic) IBOutlet UITextField *roomPrice;

@end

@implementation AddRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    PFUser *user = [PFUser currentUser];
    Room *newRoom = [Room object];
    newRoom.roomTitle = self.roomTitle.text;
  
    newRoom.roomDetails = self.roomDescription.text;
    newRoom.price = self.roomPrice.text;
    newRoom.roomUser = user;
    
    
    
    double compressionRatio = 1;
    NSData *pictureData = UIImagePNGRepresentation(self.imageToUpload.image);
    while ([pictureData length]>500000) {
        compressionRatio = compressionRatio*0.5;
        pictureData = UIImageJPEGRepresentation(self.imageToUpload.image, compressionRatio);
    }

    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:pictureData];
    newRoom[@"roomImage"] = imageFile;
    
        
    
    
    [newRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            NSLog(@"room uploaded");
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    
}


- (IBAction)addImageButtonPressed:(UIBarButtonItem *)sender {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageToUpload.image = info[UIImagePickerControllerOriginalImage];
}

@end

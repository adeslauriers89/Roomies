//
//  DetailRoomViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "DetailRoomViewController.h"
#import "UIViewController+Login.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface DetailRoomViewController () <PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomPrice;
@property (weak, nonatomic) IBOutlet UITextView *roomDetailTextView;
@property (weak, nonatomic) IBOutlet UILabel *roomDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomCityLabel;


@end

@implementation DetailRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dollarSign = @"$";
    NSString *perMonth = @"/Month";
    
    self.roomPrice.text = [[dollarSign stringByAppendingString:self.room.price] stringByAppendingString:perMonth];
    self.roomDetailTextView.text = self.room.roomDetails;
    self.roomImageView.file = [self.room objectForKey:@"roomImage"];
    
    NSLog(@"%@", self.room.roomImage);
    
    
  
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"showMessageVCFromRoom" sender:self];
    }];
}



- (IBAction)roomMessageButtonPressed:(UIButton *)sender {
    
    if ([PFUser currentUser ]) {
        
        [self performSegueWithIdentifier:@"showMessageVCFromRoom" sender:self];
    } else {
        [self showLoginController];
    }
}

@end

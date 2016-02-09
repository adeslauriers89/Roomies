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

@property (weak, nonatomic) IBOutlet UIScrollView *roomDetailScrollView;
@property (weak, nonatomic) IBOutlet UIStackView *roomDetailStackView;

@end

@implementation DetailRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

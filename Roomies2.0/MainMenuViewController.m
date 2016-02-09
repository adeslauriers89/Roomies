//
//  MainMenuViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "MainMenuViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
@interface MainMenuViewController () <PFLogInViewControllerDelegate>

@end

@implementation MainMenuViewController

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

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:^{
    
    [self performSegueWithIdentifier:@"showProfileSegue" sender:self];
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(nullable NSError *)error{
    
}

- (IBAction)myProfileButtonPressed:(UIButton *)sender {
    
    if ([PFUser currentUser ]) {
        
        [self performSegueWithIdentifier:@"showProfileSegue" sender:self];
    } else {
    PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
    loginController.delegate = self;
    [self presentViewController:loginController animated:YES completion:nil];
    }
}

@end

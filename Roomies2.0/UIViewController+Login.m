//
//  UIViewController+Login.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "UIViewController+Login.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>




@implementation UIViewController(Login)  



-(void)showLoginController{
    
    
    PFLogInViewController *loginController = [[PFLogInViewController alloc] init];
    
    loginController.delegate = (id<PFLogInViewControllerDelegate> )self;
    
    
    loginController.logInView.backgroundColor = [UIColor whiteColor];
    loginController.signUpController.signUpView.backgroundColor = [UIColor whiteColor];
    
    //UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view-room"]];
    
    loginController.logInView.logo = nil;
    loginController.signUpController.signUpView.logo = nil;
    
    [self presentViewController:loginController animated:YES completion:nil];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

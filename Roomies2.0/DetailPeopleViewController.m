//
//  DetailPeopleViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "DetailPeopleViewController.h"
#import "UIViewController+Login.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MessageUI/MessageUI.h>


@interface DetailPeopleViewController () <PFLogInViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *personDetailImage;

@property (weak, nonatomic) IBOutlet UILabel *personDetailName;
@property (weak, nonatomic) IBOutlet UILabel *personDetailAboutLabel;

@end

@implementation DetailPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.personDetailName.text = [self.user objectForKey:@"fullName"];
    self.personDetailAboutLabel.text = [self.user objectForKey:@"userDetails"];
    PFFile *img = [self.user objectForKey:@"userImage"];
    [img getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *userImage = [UIImage imageWithData:data];
            self.personDetailImage.image = userImage;
        }
    }];
    
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"showMessageVCFromPpl" sender:self];
    }];
}

- (IBAction)messageButtonPressed:(UIButton *)sender {
    
    if ([PFUser currentUser ]) {
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [self presentViewController:mc animated:YES completion:NULL];
            NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
            [mc setToRecipients:toRecipents];
        }
    } else {
        [self showLoginController];
    }
}

- (IBAction)roomMessageButtonPressed:(UIButton *)sender {
    
    if ([PFUser currentUser ]) {
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [self presentViewController:mc animated:YES completion:NULL];
            NSArray *toRecipents = [NSArray arrayWithObject:@"adeslauriers89@gmail.com"];
            [mc setToRecipients:toRecipents];
        }
    } else {
        [self showLoginController];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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

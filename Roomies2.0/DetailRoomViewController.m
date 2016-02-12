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
#import <MessageUI/MessageUI.h>

@interface DetailRoomViewController () <PFLogInViewControllerDelegate, MFMailComposeViewControllerDelegate>
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
    
   // NSLog(@"%@", self.room.roomImage);
    
    
  
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"showMessageVCFromRoom" sender:self];
    }];
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

@end

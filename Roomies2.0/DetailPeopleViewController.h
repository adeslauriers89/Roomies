//
//  DetailPeopleViewController.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailPeopleViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

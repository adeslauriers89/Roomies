//
//  Room.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
@class PFUser;

@interface Room : PFObject <PFSubclassing>

@property (nonatomic) NSString *roomDetails;
@property (nonatomic) NSString *price;
@property (nonatomic) UIImage *roomImage;
@property (nonatomic) NSString *roomTitle;
@property PFUser *roomUser;

@end

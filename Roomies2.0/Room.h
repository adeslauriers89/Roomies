//
//  Room.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface Room : PFObject

@property (nonatomic) NSString *roomDetails;
@property (nonatomic) NSString *price;
@property (nonatomic) UIImage *roomImage;

@end

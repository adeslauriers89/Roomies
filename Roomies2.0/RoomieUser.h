//
//  roomieUser.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface RoomieUser : PFObject
//<PFSubclassing> //thiago added  <PFsubclassing>

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userDetails;
@property (nonatomic) UIImage *userImage;
@property (nonatomic) NSDate *dateStartedLooking;
@property (nonatomic, strong) NSMutableArray *roomsArray;
@property (nonatomic) BOOL showMeOnList;



@end

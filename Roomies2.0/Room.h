//
//  Room.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class PFUser;

@interface Room : PFObject <PFSubclassing, MKAnnotation>

@property (nonatomic) NSString *roomDetails;
@property (nonatomic) NSString *price;
@property (nonatomic) UIImage *roomImage;
@property (nonatomic) NSString *roomTitle;
@property (nonatomic) NSString *dateAvailable;
@property (nonatomic) NSString *roomAddress;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@property PFUser *roomUser;

@end

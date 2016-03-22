//
//  Room.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-09.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "Room.h"

@implementation Room

@dynamic roomDetails;
@dynamic price;
@dynamic roomImage;
@dynamic roomTitle;
@dynamic roomUser;
@dynamic dateAvailable;
@dynamic roomAddress;
@dynamic lat;
@dynamic lng;
@dynamic coordinate;
@dynamic title;
@dynamic subtitle;


- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(self.lat.doubleValue, self.lng.doubleValue);
    return temp;
}

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Room";
}

@end

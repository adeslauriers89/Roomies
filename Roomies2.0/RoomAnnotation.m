//
//  roomAnnotation.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-11.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomAnnotation.h"

@implementation RoomAnnotation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle andLocation:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    return self;
}

@end

//
//  roomAnnotation.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-11.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RoomAnnotation : MKAnnotationView

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle andLocation:(CLLocationCoordinate2D)coordinate;

@end

//
//  RoomiesLocationManager.h
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation.CLLocationManager;

NS_ASSUME_NONNULL_BEGIN

@interface RoomiesLocationManager : NSObject

+ (RoomiesLocationManager *)sharedManager;

@property (nonatomic, readonly) CLLocationManager * locationManager;

- (void)addDelegateObserver:(id <CLLocationManagerDelegate>)addObserver;
- (void)removeDelegateObserver:(id <CLLocationManagerDelegate>)removeObserver;

@end

NS_ASSUME_NONNULL_END

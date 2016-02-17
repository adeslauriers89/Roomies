//
//  RoomiesLocationManager.m
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomiesLocationManager.h"
@import CoreLocation.CLLocationManagerDelegate;

@interface RoomiesLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite) CLLocationManager * locationManager;
@property (nonatomic, strong) NSMutableSet * rm_delegateObservers;

@end

@implementation RoomiesLocationManager

+ (RoomiesLocationManager *)sharedManager {
    static RoomiesLocationManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RoomiesLocationManager new];
    });
    return manager;
}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    
    _rm_delegateObservers = [NSMutableSet set];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    };

    return self;
}

- (void)addDelegateObserver:(id<CLLocationManagerDelegate>)addObserver {
    [self.rm_delegateObservers addObject:addObserver];
}

- (void)removeDelegateObserver:(id<CLLocationManagerDelegate>)removeObserver {
    [self.rm_delegateObservers removeObject:removeObserver];
}

#pragma mark - @protocol <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    for (id <CLLocationManagerDelegate> anObserver in self.rm_delegateObservers) {
        if ([anObserver respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
            [anObserver locationManager:manager didChangeAuthorizationStatus:status];
        }
    }
}

@end

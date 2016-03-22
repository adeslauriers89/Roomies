//
//  RoomiesDatabase.h
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomiesDatabase : NSObject

#pragma mark - Initialize

+ (RoomiesDatabase *)defaultDatabase;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Database Connection

- (void)connect;
- (void)disconnect;

@end

NS_ASSUME_NONNULL_END

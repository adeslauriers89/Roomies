//
//  RoomiesDatabase.m
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomiesDatabase.h"
#import "ParseStore.h"

@interface RoomiesDatabase ()
@property (nonatomic, strong) ParseStore * parseStore;
@end

@implementation RoomiesDatabase

#pragma mark - Initialize

+ (RoomiesDatabase *)defaultDatabase {
    static RoomiesDatabase * database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [RoomiesDatabase new];
    });
    return database;
}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    [self initializeDataStores];
    return self;
}

#pragma mark - Database Connection

- (void)connect {
    [self loadDataStores];
}

- (void)disconnect {
    [self unloadDataStores];
}

#pragma mark - PRIVATE LOGIC

- (void)initializeDataStores {
    self.parseStore = [ParseStore new];
}

- (void)loadDataStores {
    [self.parseStore loadStore];
}

- (void)unloadDataStores {
    [self.parseStore unloadStore];
}

@end

//
//  ParseStore.m
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "ParseStore.h"
#import <Parse/Parse.h>

static NSString * const kParseApplicationID = @"IjcTgq7KqvJ98ihU6WWzmadFBpgn1ypK2bDZmiVy";
static NSString * const kParseClientKey = @"P4g1GPpjbBI2otjGBMzC6fP0Xsd7ySvoP8NN2V0j";

@implementation ParseStore

#pragma mark - Initialize

- (instancetype)init {
    if (!(self = [super init])) return nil;
    return self;
}

#pragma mark - @protocol <DatabaseStore>

- (void)loadStore {
    [Parse setApplicationId:kParseApplicationID
                  clientKey:kParseClientKey];
}

/// No need to unload Parse store.
//- (void)unloadStore {
//    
//}

@end

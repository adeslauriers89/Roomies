//
//  DatabaseStore.h
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DatabaseStore <NSObject>

@required
- (void)loadStore;

@optional
- (void)unloadStore;

@end

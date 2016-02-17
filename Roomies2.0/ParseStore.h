//
//  ParseStore.h
//  Roomies2.0
//
//  Created by BozBook on 2016-02-16.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParseStore : NSObject <DatabaseStore>

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

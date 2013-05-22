//
//  CATETerm.h
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATEModule.h"

@interface CATETerm : NSObject {
  NSString *title;
  NSString *start; // this will be a date type
  NSString *end; // this will be a date type
  NSMutableArray *modules;
}

@property (readonly) NSString *title;
@property (readonly) NSString *start;
@property (readonly) NSString *end;
@property (readonly) NSMutableArray *modules;

- (id) init_with_data:(NSData *)xml;
+ (id) term_with_data:(NSData *)xml;

@end

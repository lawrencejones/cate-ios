//
//  CATERecord.h
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATERecordStats.h"

@interface CATERecord : NSObject {
  CATERecordStats *stats;
  NSMutableArray *modules;
}

@property (readonly) CATERecordStats *stats;
@property (readonly) NSMutableArray *modules;

- (id) init_with_data:(NSData *)xml;
+ (id) record_with_data:(NSData *)xml;

@end

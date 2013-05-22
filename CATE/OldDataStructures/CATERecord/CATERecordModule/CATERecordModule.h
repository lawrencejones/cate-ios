//
//  CATERecordModule.h
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"

@interface CATERecordModule : NSObject {
  NSString *name;
  NSString *term;
  NSString *level;
  NSMutableArray *exercises;
}

@property (readonly) NSString *name;
@property (readonly) NSString *term;
@property (readonly) NSString *level;
@property (readonly) NSMutableArray *exercises;

- (id) init_with_data:(SMXMLElement *)xml_elem;
+ (id) record_module_with_data:(SMXMLElement *)xml_elem;

@end

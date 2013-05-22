//
//  CATEModule.h
//  CATE
//
//  Created by Tom Burnell on 22/05/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"

@interface CATEModule : NSObject {
  int moduleID;
  
  NSString *name;
  NSString *code;
  
  NSMutableArray *classes;
  NSMutableArray *exercises;
  
  NSString *term;
  NSString *level;
}

@property (assign) int moduleID;
@property (retain) NSString *name;
@property (retain) NSString *code;
@property (retain) NSMutableArray *classes;
@property (retain) NSMutableArray *exercises;
@property (retain) NSString *term;
@property (retain) NSString *level;


- (void) refreshExerciseLinks;
- (id) init_with_data:(SMXMLElement *)xml_elem;
+ (id) record_module_with_data:(SMXMLElement *)xml_elem;

@end

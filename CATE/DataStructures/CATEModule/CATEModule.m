//
//  CATEModule.m
//  CATE
//
//  Created by Tom Burnell on 22/05/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEModule.h"

@implementation CATEModule

@synthesize moduleID, name, code, classes, exercises, term, level;

- (id) init_with_data:(SMXMLElement *)xml_elem {
  self = [self init];
  
  if (self) {
    // TODO
  }
  
  return self;
}

+ (id) record_module_with_data:(SMXMLElement *)xml_elem {
  CATEModule *module = [[[self alloc] init_with_data:xml_elem] autorelease];
  return module;
}

- (void) refreshExerciseLinks {
  // TODO
}

@end

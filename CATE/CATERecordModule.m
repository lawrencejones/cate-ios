//
//  CATERecordModule.m
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATERecordModule.h"
#import "CATERecordExercise.h"

@implementation CATERecordModule

@synthesize name, term, level, exercises;

- (id) init_with_data:(SMXMLElement *)xml_elem {
  [self init];
  
  if (self) {
    name = [xml_elem valueWithPath:@"name"];
    term = [xml_elem valueWithPath:@"term"];
    level = [xml_elem valueWithPath:@"level"];
    
    NSMutableArray *exercise_array = [[NSMutableArray alloc] init];
    SMXMLElement *exercises_elem = [xml_elem childNamed:@"exercises"];
    for (SMXMLElement *exercise in [exercises_elem childrenNamed:@"exercise"]) {
      [exercise_array addObject:[CATERecordExercise record_exercise_with_data:&*exercise]];
    }
  }
  
  return self;
}

+ (id) record_module_with_data:(SMXMLElement *)xml_elem {
  CATERecordModule *module = [[[self alloc] init_with_data:xml_elem] autorelease];
  return module;
}

@end

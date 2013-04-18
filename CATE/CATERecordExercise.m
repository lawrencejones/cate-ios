//
//  CATERecordExercise.m
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATERecordExercise.h"

@implementation CATERecordExercise

@synthesize type, title, setBy, declaration, extension, submission, grade;

- (id) init_with_data:(SMXMLElement *)xml_elem {
  [self init];
  
  if (self) {
    ident = [[xml_elem valueWithPath:@"id"] intValue];
    type = [xml_elem valueWithPath:@"type"];
    title = [xml_elem valueWithPath:@"title"];
    setBy = [xml_elem valueWithPath:@"set_by"];
    declaration = [xml_elem valueWithPath:@"declaration"];
    extension = [xml_elem valueWithPath:@"extension"];
    submission = [xml_elem valueWithPath:@"submission"];
    grade = [xml_elem valueWithPath:@"grade"];
  }
  
  return self;
}

+ (id) record_exercise_with_data:(SMXMLElement *)xml_elem {
  CATERecordExercise *exercise = [[[CATERecordExercise alloc] init_with_data:xml_elem] autorelease];
  return exercise;
}

@end

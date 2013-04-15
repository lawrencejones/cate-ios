//
//  CATEModule.m
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEModule.h"
#import "CATEExercise.h"
#import "SMXMLDocument.h"

@implementation CATEModule

@synthesize exercises, ident, name, notesLink;

- (id) init_with_data:(SMXMLElement *)xmlElem {
  self = [super init];
  
  if (self) {
    ident = [[xmlElem valueWithPath:@"id"] intValue];
    name = [xmlElem valueWithPath:@"name"];
    notesLink = [xmlElem valueWithPath:@"notesLink"];
    
    SMXMLElement *exercisesElem = [xmlElem childNamed:@"exercises"];
    
    NSMutableArray *exerciseArray = [[NSMutableArray alloc] init];
    
    for (SMXMLElement *exercise in [exercisesElem childrenNamed:@"exercise"]) {
      [exerciseArray addObject:[CATEExercise exercise_with_data:&*exercise module:self]];
    }
    
    exercises = exerciseArray;
  }
  
  return self;
}

+ (id) module_with_data:(SMXMLElement *)xmlElem {
  CATEModule *module = [[[self alloc] init_with_data:xmlElem] autorelease];
  return module;
}

@end

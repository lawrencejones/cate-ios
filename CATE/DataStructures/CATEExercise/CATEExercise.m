//
//  CATEExercise.m
//  CATE
//
//  Created by Tom Burnell on 22/05/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEExercise.h"

@implementation CATEExercise

@synthesize exerciseID, parentModule, name, type, mailto, spec, givens,
            handin, start, end;

- (id) init_with_data:(SMXMLElement*)xmlElem module:(CATEModule *)module {
  self = [super init];
  
  if (self) {
    // TODO
  }
  
  return self;
}

+ (id) exercise_with_data:(SMXMLElement *)xmlElem module:(CATEModule*)module {
  CATEExercise *exercise = [[[self alloc] init_with_data:xmlElem module:module] autorelease];
  return exercise;
}

@end

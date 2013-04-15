//
//  CATEExercise.m
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEExercise.h"
#import "CATEModule.h"

@implementation CATEExercise

@synthesize ident, name, type, parentModule, mailto, spec, givens, handin, start, end;

- (id) init_with_data:(SMXMLElement*)xmlElem module:(CATEModule *)module {
  self = [super init];
  
  if (self) {
    ident = [[xmlElem valueWithPath:@"id"] intValue];
    name = [xmlElem valueWithPath:@"name"];
    type = [xmlElem valueWithPath:@"type"];
    parentModule = module;
    mailto = [xmlElem valueWithPath:@"mailto"];
    spec = [xmlElem valueWithPath:@"spec"];
    givens = [xmlElem valueWithPath:@"givens"];
    handin = [xmlElem valueWithPath:@"handin"];
    start = [xmlElem valueWithPath:@"start"];
    end = [xmlElem valueWithPath:@"end"];
  }
  
  return self;
}

+ (id) exercise_with_data:(SMXMLElement *)xmlElem module:(CATEModule*)module {
  CATEExercise *exercise = [[[self alloc] init_with_data:xmlElem module:module] autorelease];
  return exercise;
}

@end

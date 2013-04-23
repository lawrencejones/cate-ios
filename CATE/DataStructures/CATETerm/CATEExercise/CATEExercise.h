//
//  CATEExercise.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
@class CATEModule;

@interface CATEExercise : NSObject {
  int ident;
  NSString *name;
  NSString *type; // will be an enum { PMT, CW }
  CATEModule *parentModule;
  NSString *mailto;
  NSString *spec;
  NSString *givens;
  NSString *handin;
  NSString *start; // will be a date
  NSString *end; // will be a date
}

@property (readonly) int ident;
@property (readonly) NSString *name;
@property (readonly) NSString *type;
@property (readonly) CATEModule *parentModule;
@property (readonly) NSString *mailto;
@property (readonly) NSString *spec;
@property (readonly) NSString *givens;
@property (readonly) NSString *handin;
@property (readonly) NSString *start;
@property (readonly) NSString *end;

- (id) init_with_data:(SMXMLElement *)xmlElem module:(CATEModule *)module;
+ (id) exercise_with_data:(SMXMLElement *)xmlElem module:(CATEModule *)module;


@end

//
//  CATEExercise.h
//  CATE
//
//  Created by Tom Burnell on 22/05/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "CATEModule.h"

@interface CATEExercise : NSObject {
  int exerciseID;
  CATEModule *parentModule;
  
  NSString *name;
  NSString *type; // will be an enum { PMT, CW }
  NSString *mailto;
  NSString *spec;
  NSString *givens;
  NSString *handin;
  NSString *start; // will be a date
  NSString *end; // will be a date
}

@property (assign) int exerciseID;
@property (retain) CATEModule *parentModule;
@property (retain) NSString *name;
@property (retain) NSString *type;
@property (retain) NSString *mailto;
@property (retain) NSString *spec;
@property (retain) NSString *givens;
@property (retain) NSString *handin;
@property (retain) NSString *start;
@property (retain) NSString *end;

- (id) init_with_data:(SMXMLElement *)xmlElem module:(CATEModule *)module;
+ (id) exercise_with_data:(SMXMLElement *)xmlElem module:(CATEModule *)module;


@end

//
//  CATERecordExercise.h
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "CATERecordModule.h"

@interface CATERecordExercise : NSObject {
  int ident;
  NSString *type;
  NSString *title;
  NSString *setBy;
  NSString *declatation;
  NSString *extension;
  NSString *submission;
  NSString *grade;
}

@property (readonly) NSString *type;
@property (readonly) NSString *title;
@property (readonly) NSString *setBy;
@property (readonly) NSString *declaration;
@property (readonly) NSString *extension;
@property (readonly) NSString *submission;
@property (readonly) NSString *grade;

- (id) init_with_data:(SMXMLElement *)xml_elem;
+ (id) record_exercise_with_data:(SMXMLElement *)xml_elem;

@end

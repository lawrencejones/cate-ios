//
//  CATEModule.h
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CATEExercise.h"
#import "SMXMLDocument.h"

@interface CATEModule : NSObject {
  NSMutableArray *exercises;
  int ident;
  NSString *name;
  NSString *notesLink;
}

@property (readonly) NSMutableArray *exercises;
@property (readonly) int ident;
@property (readonly) NSString *name;
@property (readonly) NSString *notesLink;

- (id) init_with_data:(SMXMLElement *)xmlElem;
+ (id) module_with_data:(SMXMLElement *)xmlElem;

@end

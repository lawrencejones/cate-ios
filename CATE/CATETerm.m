//
//  CATETerm.m
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATETerm.h"
#import "SMXMLDocument.h"

@implementation CATETerm

@synthesize title, start, end, modules;

- (id) init_with_data:(NSData *)xml {
  self = [super init];
  
  if (self) {
    
    NSError *err = NULL;
    SMXMLDocument *document = [SMXMLDocument documentWithData:xml error:&err];
    
    title = [document.root valueWithPath:@"term_title"];
    start = [document.root valueWithPath:@"start"];
    end = [document.root valueWithPath:@"end"];
    
    SMXMLElement *modulesElem = [document.root childNamed:@"modules"];
    
    NSMutableArray *moduleArray = [[NSMutableArray alloc] init];

    for (SMXMLElement *module in [modulesElem childrenNamed:@"module"]) {
      [moduleArray addObject:[CATEModule module_with_data:&*module]];
    }
    
    modules = moduleArray;

  }
  
  return self;
}

+ (id) term_with_data:(NSData *)xml {
  CATETerm *term = [[[self alloc] init_with_data:xml] autorelease];
  return term;
}

@end

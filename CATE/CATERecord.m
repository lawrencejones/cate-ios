//
//  CATERecord.m
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATERecord.h"
#import "SMXMLDocument.h"
#import "CATERecordStats.h"
#import "CATERecordModule.h"

@implementation CATERecord

@synthesize stats, modules;

- (id) init_with_data:(NSData *)xml {
  self = [super init];
  
  if (self) {
    NSError *err = NULL;
    SMXMLDocument *document = [SMXMLDocument documentWithData:xml error:&err];
    
    SMXMLElement *stats_elem = [document.root childNamed:@"stats"];
    CATERecordStats *stats_object = [CATERecordStats record_stats_with_data:stats_elem];
    
    
    NSMutableArray *module_array = [[NSMutableArray alloc] init];
    for (SMXMLElement *module in [document.root childrenNamed:@"module"]) {
      [module_array addObject:[CATERecordModule record_module_with_data:&*module]];
    }
    
    stats = stats_object;
    modules = module_array;
  }
  
  return self;
}

+ (id) record_with_data:(NSData *)xml {
  CATERecord *record = [[[self alloc] init_with_data:xml] autorelease];
  return record;
}

@end

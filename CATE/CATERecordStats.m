//
//  CATERecordStats.m
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATERecordStats.h"

@implementation CATERecordStats

@synthesize lastUpdate, submissionsCompleted, submissionsExtended, submissionsLate;

- (id) init_with_data:(SMXMLElement *)xml_elem {
  [super init];
  
  if (self) {
    lastUpdate = [xml_elem valueWithPath:@"last_update"];
    submissionsCompleted = [xml_elem valueWithPath:@"submissions_completed"];
    submissionsExtended = [xml_elem valueWithPath:@"submissions_extended"];
    submissionsLate = [xml_elem valueWithPath:@"submissions_late"];
  }
  
  return self;
}

+ (id) record_stats_with_data:(SMXMLElement *)xml_elem {
  CATERecordStats *stats = [[[self alloc] init_with_data:xml_elem] autorelease];
  return stats;
}

@end

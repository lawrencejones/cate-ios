//
//  CATERecordStats.h
//  CATE
//
//  Created by Tom Burnell on 15/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"

@interface CATERecordStats : NSObject {
  NSString *lastUpdate;
  NSString *submissionsCompleted;
  NSString *submissionsExtended;
  NSString *submissionsLate;
}

@property (readonly) NSString *lastUpdate;
@property (readonly) NSString *submissionsCompleted;
@property (readonly) NSString *submissionsExtended;
@property (readonly) NSString *submissionsLate;


- (id) init_with_data:(SMXMLElement *)xml_elem;
+ (id) record_stats_with_data:(SMXMLElement *)xml_elem;

@end

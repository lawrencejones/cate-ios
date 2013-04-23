//
//  CATESharedData.m
//  CATE
//
//  Created by Lawrence Jones on 20/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATESharedData.h"

@implementation CATESharedData

@synthesize identity, userAtLogin, passwordAtLogin, cateVersion;

+(CATESharedData*)instance
{
  static dispatch_once_t pred;
  static CATESharedData *sharedInstance = nil;
  dispatch_once(&pred, ^{
    sharedInstance = [[CATESharedData alloc] init];
  });
  return sharedInstance;
}

- (void)dealloc
{
  // implement -dealloc & remove abort() when refactoring for
  // non-singleton use.
  abort();
}

- (void)cache_term:(CATETerm *)term {
  // Saves the given term in the appropriate field
  
  NSString *period
  = [[term.title componentsSeparatedByString: @" "] objectAtIndex:0];
  
  if ([period isEqualToString:@"Autumn"]) {
    self.autumn = term;
    
  } else if ([period isEqualToString:@"Christmas"]) {
    self.christmas = term;
    
  } else if ([period isEqualToString:@"Spring"]) {
    self.spring = term;
    
  } else if ([period isEqualToString:@"Easter"]) {
    self.easter = term;
    
  } else if ([period isEqualToString:@"Summer"]) {
    self.summer = term;
    
  } else if ([period isEqualToString:@"June-July"]) {
    self.june_july = term;
    
  } else if ([period isEqualToString:@"August-September"]) {
    self.august_september = term;
    
  }
}



@end

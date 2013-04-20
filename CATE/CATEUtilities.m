//
//  CATEUtilities.m
//  CATE
//
//  Created by Tom Burnell on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEUtilities.h"
#import "CATEAppDelegate.h"

@implementation CATEUtilities


+ (void) setCateVersion:(NSString *)version {
  [CATESharedData instance].cateVersion = version;
}


+ (void) showAlert:(NSString *)title message:(NSString *)message
     delegate:(NSObject *)delegate cancel_bottom:(NSString *)cancel_button {
  
  UIAlertView *alert
    = [[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:delegate
                       cancelButtonTitle:cancel_button
                       otherButtonTitles:nil];
  [alert show];
}


+ (void) initializeConnection:(NSString *)url delegate:(NSObject*)delegate {
  
  NSMutableURLRequest *request
    = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPMethod:@"GET"];
  
  [[NSURLConnection alloc] initWithRequest:request delegate:delegate
                          startImmediately:YES];
}

@end

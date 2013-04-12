//
//  CATEDataExtractor.m
//  CATE
//
//  Created by Lawrence Jones on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import "CATEDataExtractor.h"

@implementation CATEDataExtractor

+(NSString*)get_main_xml:(UIWebView*)webview {
  return [webview stringByEvaluatingJavaScriptFromString:@"process_main_xml();"];
}

@end

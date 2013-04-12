//
//  CATEDataExtractor.h
//  CATE
//
//  Created by Lawrence Jones on 12/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATEDataExtractor : NSObject
{
}

+(NSString*)get_main_xml:(UIWebView*)webview;

+(NSString*)get_exercises_xml:(UIWebView*)webview;

+(NSString*)get_grades_xml:(UIWebView*)webview;

@end

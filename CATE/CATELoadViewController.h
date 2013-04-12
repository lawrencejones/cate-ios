//
//  CATELoadViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATEAppDelegate.h"

@interface CATELoadViewController : UIViewController
{
  CATEAppDelegate *appDelegate;
  NSString *main_data;
  NSString *ex_data;
  NSString *grade_data;
  NSString *full_html;
  BOOL complete;
  int count;
}

@property (strong, nonatomic) IBOutlet UIWebView *loadingWeb;
@property (retain, nonatomic) NSString *main_data;
@property (retain, nonatomic) NSString *ex_data;
@property (retain, nonatomic) NSString *grade_data;
@property (retain, nonatomic) NSString *full_html;


-(NSString*)getFileContent:(NSString *) res :(NSString *) file_type;


@end

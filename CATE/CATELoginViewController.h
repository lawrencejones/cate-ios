//
//  CATELoginViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CATEAppDelegate.h"

@interface CATELoginViewController : UIViewController
<UITextFieldDelegate, UIWebViewDelegate, NSURLConnectionDataDelegate> {
  CATEAppDelegate *appDelegate;
  UIToolbar *keyboardToolbar;
  UITextField *txtActiveField;
  NSMutableArray *connections;
  BOOL complete;
  int count;
}

@property (retain, nonatomic) IBOutlet UITextField *user;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIWebView *progressBar, *backgroundWeb;

@property (copy, nonatomic) NSString *userString;
@property (copy, nonatomic) NSString *passwordString;
@property (retain, nonatomic) NSString *fullHtml,
                                       *main_data,
                                       *ex_data,
                                       *grade_data,
                                       *full_html;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) UIToolbar *keyboardToolbar;
@property (retain, nonatomic) UITextField *txtActiveField;




- (IBAction)loginAttempt:(id)sender;
- (IBAction)touchUpMyBody:(id)sender;

@end

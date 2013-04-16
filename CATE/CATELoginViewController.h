//
//  CATELoginViewController.h
//  CATE
//
//  Created by Tom Burnell on 11/04/2013.
//  Copyright (c) 2013 Tom Burnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CATELoadViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CATELoginViewController : UIViewController
<UITextFieldDelegate> {
  CATEAppDelegate *appDelegate;
  UIToolbar *keyboardToolbar;
  UITextField *txtActiveField;
}

@property (retain, nonatomic) IBOutlet UITextField *user;
@property (retain, nonatomic) IBOutlet UITextField *password;

@property (copy, nonatomic) NSString *userString;
@property (copy, nonatomic) NSString *passwordString;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) UIToolbar *keyboardToolbar;
@property (retain, nonatomic) UITextField *txtActiveField;




- (IBAction)loginAttempt:(id)sender;
- (IBAction)touchUpMyBody:(id)sender;

@end
